#!/bin/sh
# Offline fixture regression for Kitchen's Grease-first transfer program.
# POSIX-compatible command subset is exercised with sh; production uses Grease.
set -eu
root=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
generator=$root/tasks/github-repository-transfer/render-standalone-github-repository-organization-transfer.ysh
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir "$tmp/bin"

sh "$generator" isomorphisms switch isomorphismes isomorphisms > "$tmp/move.ysh"
sh "$generator" isomorphisms switch isomorphismes isomorphisms > "$tmp/repeated.ysh"
cmp "$tmp/move.ysh" "$tmp/repeated.ysh"
sh -n "$tmp/move.ysh"
if sh "$generator" 'bad;owner' switch isomorphismes isomorphisms > "$tmp/bad" 2>/dev/null; then
    echo 'FAIL: malicious component was accepted' >&2; exit 1
fi
[ ! -s "$tmp/bad" ] || { echo 'FAIL: generator leaked partial script' >&2; exit 1; }

cat > "$tmp/bin/sleep" <<'SLEEP'
#!/bin/sh
exit 0
SLEEP
cat > "$tmp/bin/gh" <<'GH'
#!/bin/sh
set -eu
state=${TRANSFER_FIXTURE_STATE:?}
scenario=${TRANSFER_FIXTURE_SCENARIO:-normal}
case $1 in
    auth) exit 0 ;;
    api) shift ;;
    *) exit 99 ;;
esac
method=GET
path=
jqvalue=
while [ "$#" -gt 0 ]; do
    case $1 in
        --method) method=$2; shift 2 ;;
        -f) shift 2 ;;
        --jq) jqvalue=$2; shift 2 ;;
        --silent) shift ;;
        *) [ -n "$path" ] || path=$1; shift ;;
    esac
done
source=isomorphisms/switch
destination=isomorphismes/switch
case $path in
    user)
        [ "$scenario" = wrong-login ] && echo other || echo isomorphisms ;;
    orgs/isomorphismes)
        echo isomorphismes ;;
    user/memberships/orgs/isomorphismes)
        [ "$scenario" = not-member ] && echo pending || echo active ;;
    "repos/$source"|"repos/$source/transfer")
        if [ "$method" = POST ]; then
            [ "$scenario" != rejected ] || { echo 'HTTP 422 rejected' >&2; exit 1; }
            echo POST >> "$state"
        elif [ "$scenario" = unrelated-redirect ]; then
            [ "$jqvalue" = '.id' ] && echo 123 || echo unrelated/switch
        elif [ "$scenario" = already ]; then
            [ "$jqvalue" = '.id' ] && echo 123 || echo "$destination"
        elif [ "$jqvalue" = '.full_name' ]; then
            echo "$source"
        elif [ "$jqvalue" = '.id' ]; then
            echo 123
        elif [ "$jqvalue" = '.permissions.admin' ]; then
            [ "$scenario" = no-admin ] && echo false || echo true
        else
            exit 98
        fi ;;
    "repos/$destination")
        if [ "$scenario" = collision ]; then
            [ "$jqvalue" = '.id' ] && echo 456 || echo "$destination"
        elif [ "$scenario" = already ] || { [ -s "$state" ] && [ "$scenario" != pending ]; }; then
            [ "$jqvalue" = '.id' ] && echo 123 || echo "$destination"
        else
            exit 1
        fi ;;
    *) exit 97 ;;
esac
GH
chmod 700 "$tmp/bin/gh" "$tmp/bin/sleep"

run_case() {
    scenario=$1
    expected=$2
    message=$3
    : > "$tmp/posted"
    if PATH="$tmp/bin:$PATH" TRANSFER_FIXTURE_STATE="$tmp/posted" TRANSFER_FIXTURE_SCENARIO="$scenario" \
       sh "$tmp/move.ysh" > "$tmp/output" 2>&1; then
        actual=success
    else
        actual=refused
    fi
    [ "$actual" = "$expected" ] || {
        cat "$tmp/output" >&2
        echo "FAIL $scenario: expected $expected, got $actual" >&2
        exit 1
    }
    grep -F "$message" "$tmp/output" >/dev/null || {
        cat "$tmp/output" >&2
        echo "FAIL $scenario: expected message $message" >&2
        exit 1
    }
    if [ "$scenario" = normal ] || [ "$scenario" = pending ]; then
        [ "$(wc -l < "$tmp/posted")" -eq 1 ]
    else
        [ ! -s "$tmp/posted" ]
    fi
    echo "PASS $scenario"
}

run_case normal success action=transferred
run_case already success action=already_transferred
run_case unrelated-redirect refused 'redirects to unrelated'
run_case collision refused 'destination already exists'
run_case wrong-login refused 'authenticated as'
run_case no-admin refused 'lacks administrator access'
run_case not-member refused 'membership in'
run_case rejected refused 'GitHub rejected transfer'
run_case pending refused 'transfer is unverified'
