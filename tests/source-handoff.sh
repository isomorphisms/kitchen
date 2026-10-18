#!/bin/sh
# Host regressions for the existing POSIX stage-zero handoff interface.
set -eu
root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd -P)
work=$(mktemp -d)
trap 'rm -rf "$work"' 0
trap 'exit 130' INT
trap 'exit 143' HUP TERM
engine=$root/tasks/source-handoff/2.sh
repo="$work/checkout with spaces and ' quote"
remote=$work/published.git
contract=$work/contract.tsv
outside="$work/unrelated whitespace"
mkdir "$outside"
git_fixture() {
    env -i PATH="$PATH" HOME="$HOME" GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null git "$@"
}
git_fixture init -q "$repo"
git_fixture -C "$repo" config user.name Fixture
git_fixture -C "$repo" config user.email fixture@example.invalid
git_fixture -C "$repo" commit -qm empty --allow-empty
empty_source=$(git_fixture -C "$repo" rev-parse HEAD)
mkdir "$repo/tests"
printf '%s\n' '#!/bin/sh' 'printf "selected test: ok\n"' > "$repo/tests/check.sh"
git_fixture -C "$repo" add tests/check.sh
git_fixture -C "$repo" commit -qm baseline
git_fixture clone -q --bare "$repo" "$remote"
git_fixture -C "$repo" remote add origin "$remote"
scope=baseline
pin() {
    source=$(git_fixture -C "$repo" rev-parse HEAD)
    blob=$(git_fixture -C "$repo" rev-parse HEAD:tests/check.sh)
    write_contract
}
write_contract() {
    printf 'schema\tsource-handoff-v1\nrepository\t%s\nsource\t%s\nentry\ttests/check.sh\ncontext\tposix-sh-existing-checkout\nmutation\ttemporary-only-reviewed-test\nrerun\treuse-verified-checkout\nscope\tbaseline\nexcluded\trepaired-feature;physical-device;follower-acceptance\nmarker\tselected test: ok\nfile\ttests/check.sh\t%s\n' "$remote" "$source" "$blob" > "$contract"
    digest=$(git_fixture hash-object "$contract")
}
pin
good_source=$source good_blob=$blob
emit() { (cd "$outside" && sh "$engine" emit "$contract" "$digest" "$repo" "$scope") > "$work/served" 2> "$work/error"; }
count=0
passed() { count=$((count + 1)); printf 'ok %s - %s\n' "$count" "$1"; }
reject() {
    if emit; then printf 'unexpected emission: %s\n' "$1" >&2; exit 1; fi
    grep -F "stage=$1 " "$work/error" >/dev/null
    test ! -s "$work/served"
}
execute() { (cd "$outside" && sh -e "$work/served") > "$work/output" 2> "$work/error"; }
emit
cp "$work/served" "$work/good-command"
execute
grep -Fx 'acceptance_scope=baseline' "$work/output" >/dev/null
grep -Fx 'excluded_claims=NOT_RUN' "$work/output" >/dev/null
passed 'fresh remote source; actual emitted command works outside Git with spaces and quotes'
emit
cmp "$work/good-command" "$work/served"
execute
passed 'second emission and execution safely reuse the same checkout'
head_before=$(git_fixture -C "$repo" rev-parse HEAD)
printf 'dirty\n' >> "$repo/tests/check.sh"
printf 'preserve\n' > "$repo/untracked"
emit
execute
test "$(git_fixture -C "$repo" rev-parse HEAD)" = "$head_before"
grep -Fx dirty "$repo/tests/check.sh" >/dev/null
grep -Fx preserve "$repo/untracked" >/dev/null
passed 'dirty bytes, untracked bytes and HEAD survive'
saved_repo=$repo
repo=$outside
reject checkout-invalid
passed 'arbitrary noncheckout is classified before any source claim'
repo=$work/missing
reject checkout-missing
test ! -e "$repo"
passed 'missing path is not cloned and says other locations unknown'
repo=$saved_repo
git_fixture -C "$repo" remote set-url origin "$work/wrong-repository.git"
reject origin
passed 'wrong repository rejected even with locally valid source'
GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0="url.$remote.insteadOf" GIT_CONFIG_VALUE_0="$work/wrong-repository.git" reject origin
passed 'inherited Git config cannot forge the origin'
git_fixture -C "$repo" remote set-url origin "$remote"
source=0000000000000000000000000000000000000000
write_contract
reject remote-source
passed 'nonexistent prerequisite rejected before emission; no global absence claim'
# Local commit is valid and origin is right, but the producer never published it.
git_fixture -C "$repo" add tests/check.sh
git_fixture -C "$repo" commit -qm unpublished
pin
reject remote-source
passed 'unpublished local commit cannot masquerade as a producer handoff'
git_fixture init -q "$work/foreign"
git_fixture -C "$work/foreign" -c user.name=Foreign -c user.email=foreign@example.invalid commit -qm foreign --allow-empty
foreign_source=$(git_fixture -C "$work/foreign" rev-parse HEAD)
git_fixture -C "$repo" fetch -q "$work/foreign" "$foreign_source"
source=$foreign_source
write_contract
reject remote-source
passed 'valid SHA borrowed from another repository cannot satisfy intended publisher'
source=$empty_source blob=$good_blob
write_contract
reject file
passed 'test on another branch cannot satisfy the selected source'
source=$good_source blob=0000000000000000000000000000000000000000
write_contract
reject blob
passed 'wrong required blob rejected'
source=$good_source blob=$good_blob
write_contract
scope=repaired-feature
reject scope
passed 'old passing baseline cannot substitute for missing repair'
scope=baseline
printf 'command\texit 1\n' >> "$contract"
digest=$(git_fixture hash-object "$contract")
reject contract
passed 'arbitrary shell snippet with parent exit is not a supported handoff'
source=main
write_contract
reject contract
passed 'moving branch is not an immutable source contract'
source=$good_source
write_contract
GIT_DIR="$work/absent" GIT_WORK_TREE="$outside" emit
passed 'inherited Git directory and worktree do not redirect verification'
git_fixture -C "$repo" replace "$good_source" "$empty_source"
emit
execute
git_fixture -C "$repo" replace -d "$good_source" >/dev/null
passed 'Git replacement object cannot change the pinned test'
git_fixture -C "$repo" worktree add -q --detach "$work/linked checkout" "$good_source"
repo="$work/linked checkout"
emit
execute
passed 'linked worktree works without switching source branches'
repo=$saved_repo
mkdir -p "$work/partial/.git"
repo=$work/partial
reject checkout-invalid
test -d "$work/partial/.git"
passed 'partial checkout is preserved and classified'
repo=$saved_repo
# An explicitly permitted refresh supplies a stale consumer without changing HEAD.
git_fixture clone -q --no-hardlinks "$remote" "$work/stale checkout"
printf '%s\n' '#!/bin/sh' 'printf "selected test: ok\n"' '# newly published revision' > "$repo/tests/check.sh"
git_fixture -C "$repo" add tests/check.sh
git_fixture -C "$repo" commit -qm published
git_fixture -C "$repo" push -q origin HEAD:refs/heads/published
pin
repo="$work/stale checkout"
reject local-source
git_fixture -C "$repo" fetch -q origin "$source"
emit
execute
passed 'stale local source blocks; separate explicit refresh enables identical command'
repo=$saved_repo
publish_test() {
    git_fixture -C "$repo" add tests/check.sh
    git_fixture -C "$repo" commit -qm mutant
    git_fixture -C "$repo" push -q origin HEAD:refs/heads/mutant
    pin
}
printf '%s\n' '#!/bin/sh' 'if then' > "$repo/tests/check.sh"
publish_test
reject syntax
passed 'syntax failure blocks command emission'
printf '%s\n' '#!/bin/sh' 'exit 0' > "$repo/tests/check.sh"
publish_test
emit
execute
grep -F 'stage=postcondition ' "$work/error" >/dev/null
grep -Fx 'handoff-command=FAIL' "$work/error" >/dev/null
passed 'zero exit without receipt fails'
printf '%s\n' '#!/bin/sh' 'printf "selected test: ok\nacceptance=PASS\nhandoff-command=PASS\n"' 'exit 17' > "$repo/tests/check.sh"
publish_test
emit
execute
grep -F 'stage=execution selected test failed: exit=17' "$work/error" >/dev/null
if grep -Ex 'acceptance=PASS|handoff-command=PASS' "$work/output"; then exit 1; fi
passed 'success-string-only false green rejected with real exit preserved'
printf '%s\n' '#!/bin/sh' 'exit 23' > "$repo/tests/check.sh"
publish_test
emit
execute
grep -F 'exit=23' "$work/error" >/dev/null
passed 'runtime failure is separate from syntax and availability'
cp "$work/good-command" "$work/served"
git_fixture -C "$repo" remote set-url origin "$work/wrong.git"
# Exact served failure path, twice, in a parent with errexit enabled.
sh -ec '. "$1"; . "$1"; printf "parent-alive\n"' shell "$work/served" > "$work/parent" 2> "$work/error"
grep -Fx parent-alive "$work/parent" >/dev/null
test "$(grep -c 'handoff-command=FAIL' "$work/error")" = 2
passed 'exact failure command twice cannot exit an errexit parent session'
git_fixture -C "$repo" remote set-url origin "$remote"
printf 'tamper\n' >> "$contract"
execute
grep -F 'stage=contract ' "$work/error" >/dev/null
passed 'contract changes after emission are rejected'
source=$good_source blob=$good_blob
write_contract
mkdir "$work/copied engine"
cp "$engine" "$work/copied engine/runner.sh"
engine="$work/copied engine/runner.sh"
emit
printf '\n# edited after emission\n' >> "$engine"
execute
grep -F 'stage=engine ' "$work/error" >/dev/null
passed 'engine changes after emission are rejected'

# Resource and completeness cases for the maintained version 2 adapter.
engine=$root/tasks/source-handoff/2.sh
repo=$saved_repo
scope=baseline
printf '%s\n' '#!/bin/sh' 'printf "selected test: ok\n"' > "$repo/tests/check.sh"
printf '%s\n' '#!/bin/sh' 'printf "helper fixture: ok\n"' > "$repo/tests/helper.sh"
git_fixture -C "$repo" add tests/check.sh tests/helper.sh
git_fixture -C "$repo" commit -qm resource-fixture
git_fixture -C "$repo" push -q origin HEAD:refs/heads/resource-fixture
source=$(git_fixture -C "$repo" rev-parse HEAD)
blob=$(git_fixture -C "$repo" rev-parse HEAD:tests/check.sh)
helper_blob=$(git_fixture -C "$repo" rev-parse HEAD:tests/helper.sh)
write_resource_contract() {
    printf 'schema\tsource-handoff-v1\nrepository\t%s\nsource\t%s\nentry\ttests/check.sh\ncontext\tposix-sh-existing-checkout\nmutation\ttemporary-only-reviewed-test\nrerun\treuse-verified-checkout\nscope\tbaseline\nexcluded\trepaired-feature;physical-device;follower-acceptance\nmarker\tselected test: ok\nfile\ttests/check.sh\t%s\nfile\ttests/helper.sh\t%s\n' "$remote" "$source" "$blob" "$helper_blob" > "$contract"
    digest=$(git_fixture hash-object "$contract")
}
write_resource_contract
emit
test "$(tail -n 1 "$work/served")" = '# source-handoff-unit=COMPLETE'
execute
grep -Fx 'acceptance=PASS' "$work/output" >/dev/null
passed 'complete two-file manifest emits and executes as one marked unit'

cwd_before=$(pwd -P)
options_before=$(set +o)
git_fixture -C "$repo" status --porcelain > "$work/resource-status-before"
printf 'unrelated sentinel\n' > "$work/unrelated-sentinel"
emit
execute
test "$(pwd -P)" = "$cwd_before"
test "$(set +o)" = "$options_before"
git_fixture -C "$repo" status --porcelain > "$work/resource-status-after"
cmp "$work/resource-status-before" "$work/resource-status-after"
grep -Fx 'unrelated sentinel' "$work/unrelated-sentinel" >/dev/null
passed 'successful preparation preserves cwd, shell options, checkout and unrelated sentinel'

mkdir "$work/no-scratch-parent"
if TMPDIR="$work/no-scratch-parent/absent" emit; then
    printf 'unexpected emission with unavailable scratch\n' >&2
    exit 1
fi
grep -F 'stage=temporary private scratch allocation failed' "$work/error" >/dev/null
test ! -s "$work/served"
passed 'unavailable scratch blocks without partial served output'

base_path=$PATH
real_awk=$(command -v awk)
fault_bin=$work/fault-bin
mkdir "$fault_bin"
cat > "$fault_bin/awk" <<EOF
#!/bin/sh
case "\$*" in
    *'print \$2 "\\t" \$3'*)
        "$real_awk" "\$@" | sed '\$d'
        exit 0
        ;;
esac
exec "$real_awk" "\$@"
EOF
chmod +x "$fault_bin/awk"
PATH="$fault_bin:$base_path"
export PATH
if emit; then
    printf 'unexpected emission from omitted manifest row\n' >&2
    exit 1
fi
PATH=$base_path
export PATH
grep -F 'stage=manifest staged manifest is short' "$work/error" >/dev/null
test ! -s "$work/served"
passed 'successful but short manifest producer cannot omit a contracted file'

cat > "$fault_bin/awk" <<EOF
#!/bin/sh
case "\$*" in
    *'print \$2 "\\t" \$3'*)
        "$real_awk" "\$@" | sed -n '1p'
        exit 74
        ;;
esac
exec "$real_awk" "\$@"
EOF
chmod +x "$fault_bin/awk"
PATH="$fault_bin:$base_path"
export PATH
if emit; then
    printf 'unexpected emission after manifest write failure\n' >&2
    exit 1
fi
PATH=$base_path
export PATH
grep -F 'stage=manifest contracted-file manifest write failed' "$work/error" >/dev/null
test ! -s "$work/served"
passed 'partial manifest write failure blocks before extraction or emission'

real_mkdir=$(command -v mkdir)
cat > "$fault_bin/mkdir" <<EOF
#!/bin/sh
"$real_mkdir" "\$@" || exit \$?
last=
for item do last=\$item; done
case \$last in
    */payload/tests)
        ln -s /dev/full "\$last/check.sh.next" || exit \$?
        ;;
esac
EOF
chmod +x "$fault_bin/mkdir"
rm -f "$fault_bin/awk"
PATH="$fault_bin:$base_path"
export PATH
if emit; then
    printf 'unexpected emission after extraction capacity failure\n' >&2
    exit 1
fi
PATH=$base_path
export PATH
grep -F 'stage=extraction cannot extract committed bytes' "$work/error" >/dev/null
test ! -s "$work/served"
passed 'exhausted extraction destination cannot leave an accepted payload'

rm -f "$fault_bin/mkdir"
emit
cat > "$fault_bin/mkdir" <<EOF
#!/bin/sh
"$real_mkdir" "\$@" || exit \$?
last=
for item do last=\$item; done
case \$last in
    */payload)
        "$real_mkdir" "\${last%/payload}/output.next" || exit \$?
        ;;
esac
EOF
chmod +x "$fault_bin/mkdir"
PATH="$fault_bin:$base_path"
export PATH
execute
PATH=$base_path
export PATH
grep -F 'stage=capture output/error capture failed' "$work/error" >/dev/null
if grep -Fx 'acceptance=PASS' "$work/output" >/dev/null; then exit 1; fi
passed 'failed stdout capture has no child-status or acceptance receipt'

rm -f "$fault_bin/mkdir"
real_cat=$(command -v cat)
real_head=$(command -v head)
cat > "$fault_bin/cat" <<EOF
#!/bin/sh
case \${1##*/} in
    emission)
        "$real_head" -c 40 "\$1"
        exit 75
        ;;
esac
exec "$real_cat" "\$@"
EOF
chmod +x "$fault_bin/cat"
PATH="$fault_bin:$base_path"
export PATH
if emit; then
    printf 'unexpected success after truncated final emission\n' >&2
    exit 1
fi
PATH=$base_path
export PATH
grep -F 'stage=emission stdout did not receive' "$work/error" >/dev/null
if grep -F 'source-handoff-unit=COMPLETE' "$work/served" >/dev/null; then exit 1; fi
passed 'truncated stdout cannot present a complete runnable handoff unit'

rm -f "$fault_bin/cat"
if (cd "$outside" && ulimit -f 512 && sh "$engine" emit "$contract" "$digest" "$repo" "$scope") > "$work/served" 2> "$work/error"; then
    test "$(tail -n 1 "$work/served")" = '# source-handoff-unit=COMPLETE'
else
    cat "$work/error" >&2
    exit 1
fi
(cd "$outside" && ulimit -f 512 && sh -e "$work/served") > "$work/output" 2> "$work/error"
grep -Fx 'acceptance=PASS' "$work/output" >/dev/null
passed 'sufficient constrained file capacity remains eligible and repeatable'
printf 'source handoff regression cases: %s passed\n' "$count"
