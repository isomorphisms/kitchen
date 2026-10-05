#!/bin/sh
set -eu
root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd -P)
work=$(mktemp -d)
trap 'rm -rf "$work"' 0
trap 'exit 130' INT
trap 'exit 143' HUP TERM
mkdir -p "$work/task" "$work/outside" "$work/repository with spaces"
cp "$root/tasks/ib-durable-store/2.sh" "$work/task/1.sh"
runner=$work/task/1.sh
repo=$work/repository\ with\ spaces
export HOME="$work/home" GIT_CONFIG_NOSYSTEM=1
mkdir -p "$HOME"
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE GIT_COMMON_DIR GIT_OBJECT_DIRECTORY GIT_ALTERNATE_OBJECT_DIRECTORIES

git init -q "$repo"
git -C "$repo" config user.name Fixture
git -C "$repo" config user.email fixture@example.invalid
git -C "$repo" remote add origin https://github.com/isomorphisms/ib.git
mkdir -p "$repo/lib" "$repo/tests"
printf '%s\n' '# fixture implementation, not IB' > "$repo/lib/durable_object_store.grease"
cat > "$repo/tests/test_durable_object_store.grease" <<'TEST'
#!/bin/sh
printf '%s\n' 'durable ordinary-file store tests: ok'
TEST
pin() {
    git -C "$repo" add .
    git -C "$repo" commit -qm fixture
    source=$(git -C "$repo" rev-parse HEAD)
    implementation=$(git -C "$repo" rev-parse HEAD:lib/durable_object_store.grease)
    test_blob=$(git -C "$repo" rev-parse HEAD:tests/test_durable_object_store.grease)
    printf 'source\t%s\nimplementation\t%s\ntest\t%s\n' "$source" "$implementation" "$test_blob" > "$work/task/baseline.lock"
}
pin
cp "$work/task/baseline.lock" "$work/good.lock"
count=0
passed() { count=$((count + 1)); printf 'ok %s - %s\n' "$count" "$1"; }
run() {
    (cd "$work/outside" && sh "$runner" "$@") > "$work/output" 2> "$work/error"
}
reject() {
    expected=$1
    shift
    if run "$@"; then printf 'unexpected success: %s\n' "$expected" >&2; exit 1; fi
    grep -F "stage=$expected" "$work/error" >/dev/null
    if grep -F 'baseline=PASS' "$work/output" >/dev/null; then exit 1; fi
}
run "$repo"
grep -Fx 'baseline=PASS' "$work/output" >/dev/null
grep -Fx 'e2=NOT_RUN' "$work/output" >/dev/null
passed 'explicit path with spaces from outside Git'
run "$repo"
passed 'second run reuses existing checkout'
head_before=$(git -C "$repo" rev-parse HEAD)
printf 'local work\n' >> "$repo/lib/durable_object_store.grease"
printf 'preserve me\n' > "$repo/untracked"
git -C "$repo" status --porcelain > "$work/status-before"
run "$repo"
test "$(git -C "$repo" rev-parse HEAD)" = "$head_before"
git -C "$repo" status --porcelain > "$work/status-after"
cmp "$work/status-before" "$work/status-after"
grep -Fx 'local work' "$repo/lib/durable_object_store.grease" >/dev/null
test -f "$repo/untracked"
passed 'committed blobs used; dirty work and HEAD preserved'
reject arguments
passed 'missing argument fails before Git'
reject checkout "$work/missing"
passed 'missing directory is not a missing commit'
mkdir "$work/partial"
reject checkout "$work/partial"
passed 'partial checkout remains untouched'
reject checkout "$repo/tests"
passed 'nested directory cannot borrow its parent checkout identity'
git -C "$repo" remote set-url origin https://github.com/someone-else/ib.git
reject origin "$repo"
passed 'wrong origin rejected'
git -C "$repo" remote set-url origin git@github.com:isomorphisms/IB.git
run "$repo"
passed 'IB SSH origin accepted'
git -C "$repo" remote set-url origin https://github.com/isomorphisms/ib.git
sed 's/^source.*/source\t0000000000000000000000000000000000000000/' "$work/good.lock" > "$work/task/baseline.lock"
reject source "$repo"
passed 'unavailable exact source blocks before execution'
cp "$work/good.lock" "$work/task/baseline.lock"
sed 's/^test.*/test\t0000000000000000000000000000000000000000/' "$work/good.lock" > "$work/task/baseline.lock"
reject blob "$repo"
passed 'wrong test blob blocks before execution'
printf 'source\tmain\n' > "$work/task/baseline.lock"
reject lock "$repo"
passed 'moving or incomplete pins rejected'
cp "$work/good.lock" "$work/task/baseline.lock"
# An earlier pinned commit remains usable without switching the user's new HEAD.
printf 'new branch work\n' > "$repo/new-work"
git -C "$repo" add new-work
git -C "$repo" commit -qm new-head
head_before=$(git -C "$repo" rev-parse HEAD)
run "$repo"
test "$(git -C "$repo" rev-parse HEAD)" = "$head_before"
passed 'different current HEAD does not force a branch switch'
printf '%s\n' '#!/bin/sh' 'printf "%s\n" "durable ordinary-file store tests: ok"' 'exit 17' > "$repo/tests/test_durable_object_store.grease"
pin
reject execution "$repo"
grep -F 'status=17' "$work/error" >/dev/null
passed 'false-green output cannot hide test failure'
printf '%s\n' '#!/bin/sh' 'exit 0' > "$repo/tests/test_durable_object_store.grease"
pin
reject postcondition "$repo"
passed 'zero exit alone is not a baseline receipt'
printf '%s\n' '#!/bin/sh' 'if then' > "$repo/tests/test_durable_object_store.grease"
pin
reject syntax "$repo"
passed 'syntax failure is separate from runtime failure'
# Replacing a pinned Git object must not redirect the source claim.
bad_head=$(git -C "$repo" rev-parse HEAD)
good_source=$(awk -F '\t' '$1 == "source" { print $2 }' "$work/good.lock")
git -C "$repo" replace "$good_source" "$bad_head"
cp "$work/good.lock" "$work/task/baseline.lock"
run "$repo"
passed 'Git replacement cannot substitute the pinned source'
git -C "$repo" replace -d "$good_source" >/dev/null
GIT_DIR="$work/not-a-git-directory" run "$repo"
passed 'inherited Git directory cannot redirect source checks'
git -C "$repo" rm -q tests/test_durable_object_store.grease
git -C "$repo" commit -qm missing-test
missing_source=$(git -C "$repo" rev-parse HEAD)
missing_implementation=$(git -C "$repo" rev-parse HEAD:lib/durable_object_store.grease)
awk -F '\t' -v source="$missing_source" -v implementation="$missing_implementation" 'BEGIN { OFS="\t" } $1 == "source" { $2=source } $1 == "implementation" { $2=implementation } { print }' "$work/good.lock" > "$work/task/baseline.lock"
reject file "$repo"
passed 'missing test at pinned source is not a runtime failure'
cp "$work/good.lock" "$work/task/baseline.lock"
git -C "$repo" worktree add -q --detach "$work/linked checkout" "$good_source"
run "$work/linked checkout"
passed 'linked worktree with a .git file is accepted'
printf '%s\n' 'gitdir: /nonexistent/fixture' > "$work/partial/.git"
reject checkout "$work/partial"
passed 'interrupted Git checkout is not treated as an absent commit'
# The entire served body is a subshell; even accidental sourcing cannot log out.
sh -c '. "$1"; printf "parent-alive\n"' shell "$runner" > "$work/parent" 2>/dev/null
grep -Fx parent-alive "$work/parent" >/dev/null
passed 'failure leaves parent shell alive'
printf 'ib handoff regression cases: %s passed\n' "$count"
