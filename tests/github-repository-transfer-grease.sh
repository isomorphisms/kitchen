#!/bin/sh
# Test real Grease, never a sh replacement. Only GitHub and sleep are fixtures.
set -eu
root=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
grease_binary=${GREASE_BINARY:?Set GREASE_BINARY to the verified native Grease/YSH ELF}
case $grease_binary in /*) ;; *) echo 'GREASE_BINARY must be absolute' >&2; exit 2;; esac
[ -x "$grease_binary" ] || exit 2
magic=$(dd if="$grease_binary" bs=4 count=1 2>/dev/null | od -An -tx1 | tr -d ' \n')
[ "$magic" = 7f454c46 ] || { echo 'Expected the real native ELF, not an interpreter shim' >&2; exit 2; }
"$grease_binary" --version
sha256sum "$grease_binary"
# The language witness fails under sh/bash and requires Grease safety defaults.
"$grease_binary" -c 'var n = 6 * 7; if (n !== 42) { exit 8 }; setglobal ENV.GREASE_WITNESS = "native"; echo $[ENV.GREASE_WITNESS]' > /dev/null
if "$grease_binary" -c '[ 1 -eq 1 ]' >/dev/null 2>&1; then
    echo 'Unsafe test: simple_test_builtin is not enabled' >&2; exit 1
fi
if "$grease_binary" -c 'x=$(false) || true' >/dev/null 2>&1; then
    echo 'Unsafe test: strict_errexit is not enabled' >&2; exit 1
fi
scratch=$(mktemp -d)
trap 'rm -rf "$scratch"' EXIT HUP INT TERM
# Deliberately run with whitespace in paths and outside both checkouts.
tmp="$scratch/fixture with spaces"
mkdir -p "$tmp/bin" "$tmp/state"
cp "$root/tests/fixtures/github-transfer/gh" "$tmp/bin/gh"
cat > "$tmp/bin/grease" <<'LAUNCH'
#!/bin/sh
exec "$GREASE_BINARY" "$@"
LAUNCH
printf '#!/bin/sh\nexit 0\n' > "$tmp/bin/sleep"
chmod 700 "$tmp/bin/gh" "$tmp/bin/grease" "$tmp/bin/sleep"
GREASE_BINARY=$grease_binary
PATH="$tmp/bin:$PATH"
KITCHEN_ROOT=$root
export GREASE_BINARY PATH KITCHEN_ROOT
cd "$tmp"
generator=$root/tasks/github-repository-transfer/render-standalone-github-repository-organization-transfer.ysh
if grep -F 'test -r "$candidate"' "$generator" >/dev/null; then
    echo 'Generator still relies on the C67-failing candidate test -r predicate' >&2
    exit 1
fi
grep -F 'head -n 1 "$candidate" > "$candidate_probe"' "$generator" >/dev/null
grep -F 'candidate_header=$(cat "$candidate_probe")' "$generator" >/dev/null
grep -F "test \"\$candidate_header\" = '#!/usr/bin/env grease'" "$generator" >/dev/null
if grease "$generator" 'bad;owner' mapping-class isomorphismes isomorphisms > "$tmp/bad" 2>/dev/null; then
    echo 'Invalid generator argument accepted' >&2; exit 1
fi
[ ! -s "$tmp/bad" ] || { echo 'Invalid arguments emitted partial source' >&2; exit 1; }
grease "$generator" isomorphisms mapping-class isomorphismes isomorphisms > "$tmp/program.ysh"
grease "$generator" isomorphisms mapping-class isomorphismes isomorphisms > "$tmp/repeated.ysh"
cmp "$tmp/program.ysh" "$tmp/repeated.ysh"
grease -n "$tmp/program.ysh" > /dev/null

run_case() {
    scenario=$1; expected_status=$2; expected_posts=$3; expected_text=$4
    state="$tmp/state/$scenario"
    mkdir -p "$state/artifacts"
    status=0
    if [ -n "${TRANSFER_WRAPPER:-}" ]; then
        TRANSFER_TEST_STATE="$state" TRANSFER_TEST_SCENARIO="$scenario" \
          TRANSFER_ARTIFACT_DIR="$state/artifacts" GH_HOST=wrong.invalid GH_TOKEN=fixture GITHUB_TOKEN=fixture \
          grease "$TRANSFER_WRAPPER" isomorphisms mapping-class isomorphismes isomorphisms \
          > "$state/stdout" 2> "$state/stderr" || status=$?
    else
        TRANSFER_TEST_STATE="$state" TRANSFER_TEST_SCENARIO="$scenario" \
          GH_HOST=wrong.invalid GH_TOKEN=fixture GITHUB_TOKEN=fixture \
          grease "$tmp/program.ysh" > "$state/stdout" 2> "$state/stderr" || status=$?
    fi
    count=0
    if [ -f "$state/post.log" ]; then count=$(wc -l < "$state/post.log" | tr -d ' '); fi
    cat "$state/stdout" "$state/stderr" > "$state/output"
    if [ "$status" != "$expected_status" ] || [ "$count" != "$expected_posts" ] || ! grep -F "$expected_text" "$state/output" >/dev/null; then
        cat "$state/output" >&2
        echo "FAIL $scenario: status=$status posts=$count" >&2
        exit 1
    fi
    printf 'PASS %s status=%s posts=%s\n' "$scenario" "$status" "$count"
}

if [ -n "${TRANSFER_WRAPPER:-}" ]; then
    success='Repository transferred and verified'
    already='Repository already transferred'
else
    success='action=transferred'
    already='action=already_transferred'
fi
run_case normal 0 1 "$success"
run_case already 0 0 "$already"
run_case wrong-login 1 0 'authenticated as'
run_case no-admin 1 0 'lacks administrator'
run_case not-member 1 0 'membership'
run_case collision 1 0 'destination already exists'
run_case destination-error 1 0 'cannot determine whether destination exists'
run_case unrelated-redirect 1 0 'redirects to unrelated'
run_case invalid-id 1 0 'ID is missing or invalid'
run_case source-error 1 0 'cannot read source'
run_case rejected 1 1 'HTTP 422 rejected'
run_case pending 1 1 'transfer is unverified'
run_case wrong-id 1 1 'differs from original'
run_case unauthenticated 1 0 'not authenticated'
if [ -n "${TRANSFER_WRAPPER:-}" ]; then
    run_case independent-id 1 1 'identity changed during verification'
    state="$tmp/state/normal"
    if TRANSFER_TEST_STATE="$state" TRANSFER_ARTIFACT_DIR="$state/artifacts" \
       grease "$TRANSFER_WRAPPER" isomorphisms mapping-class isomorphismes isomorphisms > "$tmp/overwrite" 2>&1; then
        echo 'Existing artifacts overwritten' >&2; exit 1
    fi
    grep -F 'refusing to overwrite' "$tmp/overwrite" >/dev/null
    [ "$(wc -l < "$state/post.log" | tr -d ' ')" = 1 ]
    if KITCHEN_ROOT= grease "$TRANSFER_WRAPPER" isomorphisms mapping-class isomorphismes isomorphisms > "$tmp/missing" 2>&1; then
        echo 'Missing Kitchen root accepted' >&2; exit 1
    fi
    grep -F 'KITCHEN_ROOT' "$tmp/missing" >/dev/null
fi

# Exact three-repository request, followed by a rerun against the same identities.
state="$tmp/state/batch"
mkdir -p "$state"
for pass in 1 2; do
    for repository in mapping-class montesinos SymmHub; do
        mkdir -p "$state/$pass-$repository"
        if [ -n "${TRANSFER_WRAPPER:-}" ]; then
            TRANSFER_TEST_STATE="$state" TRANSFER_TEST_SCENARIO=normal \
              TRANSFER_ARTIFACT_DIR="$state/$pass-$repository" GH_TOKEN=fixture GH_HOST=wrong.invalid \
              grease "$TRANSFER_WRAPPER" isomorphisms "$repository" isomorphismes isomorphisms > "$state/$pass-$repository/output" 2>&1
        else
            grease "$generator" isomorphisms "$repository" isomorphismes isomorphisms > "$tmp/next.ysh"
            TRANSFER_TEST_STATE="$state" TRANSFER_TEST_SCENARIO=normal GH_TOKEN=fixture GH_HOST=wrong.invalid \
              grease "$tmp/next.ysh" > "$state/$pass-$repository/output" 2>&1
        fi
        if [ "$pass" = 1 ]; then grep -F "$success" "$state/$pass-$repository/output" >/dev/null;
        else grep -F "$already" "$state/$pass-$repository/output" >/dev/null; fi
    done
done
printf '%s\n' mapping-class montesinos SymmHub > "$tmp/expected-posts"
cmp "$tmp/expected-posts" "$state/post.log"
echo 'PASS three repositories then rerun: exactly three total POST attempts'
echo 'PASS real native Grease; GitHub responses are fixtures; no live transfer'
