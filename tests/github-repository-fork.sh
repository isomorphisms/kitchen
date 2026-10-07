#!/bin/sh
set -eu

root=$(cd "$(dirname "$0")/.." && pwd)
generator=$root/tasks/github-repository-fork/generate-fork-github-repository-script.sh

tmp=${TMPDIR:-/tmp}/kitchen-gh-fork-$$
fakebin=$tmp/bin
mkdir -p "$fakebin"
trap 'rm -rf "$tmp"' EXIT HUP INT TERM

candidate=$tmp/fork-micropython-from-micropython-into-dilapidated-shed.sh

(
    cd "$tmp"
    sh "$generator" micropython micropython dilapidated-shed isomorphisms
)

[ -x "$candidate" ] || {
    printf 'FAIL generator: expected executable %s\n' "$candidate" >&2
    exit 1
}

grep -F 'source_owner=micropython' "$candidate" >/dev/null
grep -F 'repository=micropython' "$candidate" >/dev/null
grep -F 'destination_owner=dilapidated-shed' "$candidate" >/dev/null
grep -F 'expected_login=isomorphisms' "$candidate" >/dev/null

if grep -F 'usage: 1.sh' "$candidate" >/dev/null; then
    printf 'FAIL generator: generated script exposes numbered candidate name\n' >&2
    exit 1
fi

if (
    cd "$tmp"
    sh "$generator" 'bad;owner' micropython dilapidated-shed isomorphisms \
        >"$tmp/invalid-generator.out" 2>&1
); then
    printf 'FAIL generator: unsafe owner was accepted\n' >&2
    exit 1
fi

cat >"$fakebin/sleep" <<'EOF'
#!/bin/sh
exit 0
EOF
chmod +x "$fakebin/sleep"

cat >"$fakebin/gh" <<'EOF'
#!/bin/sh
set -eu

state=${FAKE_GH_STATE:?}
scenario=${FAKE_GH_SCENARIO:?}
source=micropython/micropython
destination=dilapidated-shed/micropython

if [ "$1" = auth ]; then
    exit 0
fi

[ "$1" = api ] || exit 97
shift

method=GET
endpoint=
jq_expr=

while [ "$#" -gt 0 ]; do
    case $1 in
        --method)
            method=$2
            shift 2
            ;;
        --jq)
            jq_expr=$2
            shift 2
            ;;
        -f|-F)
            shift 2
            ;;
        --silent)
            shift
            ;;
        *)
            if [ -z "$endpoint" ]; then
                endpoint=$1
            fi
            shift
            ;;
    esac
done

if [ "$endpoint" = user ]; then
    if [ "$scenario" = wrong-login ]; then
        printf '%s\n' someone-else
    else
        printf '%s\n' isomorphisms
    fi
    exit 0
fi

case $endpoint in
    orgs/dilapidated-shed)
        [ "$scenario" != destination-org-missing ] || exit 1
        printf '%s\n' dilapidated-shed
        exit 0
        ;;
    user/memberships/orgs/dilapidated-shed)
        [ "$scenario" != destination-membership-missing ] || exit 1
        printf '%s\n' active:admin
        exit 0
        ;;
esac

if [ "$method" = POST ]; then
    [ "$endpoint" = "repos/$source/forks" ] || exit 96
    if [ "$scenario" = fork-rejected ]; then
        printf '%s\n' 'gh: Validation Failed (HTTP 422)' >&2
        exit 1
    fi
    printf '%s\n' forked >"$state"
    exit 0
fi

case $endpoint in
    "repos/$source")
        if [ "$scenario" = source-redirect ]; then
            printf '%s\n' someone/current
        else
            printf '%s\n' "$source"
        fi
        ;;
    "repos/$destination")
        exists=0
        fork=true
        fork_source=$source
        [ -s "$state" ] && exists=1
        [ "$scenario" = already-correct ] && exists=1
        if [ "$scenario" = destination-collision ]; then
            exists=1
            fork=false
            fork_source=
        fi
        if [ "$scenario" = wrong-network ]; then
            exists=1
            fork=true
            fork_source=someone/else
        fi
        [ "$exists" -eq 1 ] || exit 1
        case $jq_expr in
            .full_name) printf '%s\n' "$destination" ;;
            .fork) printf '%s\n' "$fork" ;;
            *source.full_name*) printf '%s\n' "$fork_source" ;;
            *) exit 95 ;;
        esac
        ;;
    *)
        exit 95
        ;;
esac
EOF
chmod +x "$fakebin/gh"

run_case() {
    scenario=$1
    expected=$2
    pattern=${3:-}
    state=$tmp/state-$scenario
    output=$tmp/output-$scenario
    : >"$state"

    set +e
    PATH="$fakebin:$PATH" \
    FAKE_GH_STATE="$state" \
    FAKE_GH_SCENARIO="$scenario" \
        sh "$candidate" >"$output" 2>&1
    status=$?
    set -e

    case $expected in
        success)
            [ "$status" -eq 0 ] || {
                cat "$output" >&2
                printf 'FAIL %s: expected success, got %s\n' "$scenario" "$status" >&2
                exit 1
            }
            ;;
        refusal)
            [ "$status" -ne 0 ] || {
                cat "$output" >&2
                printf 'FAIL %s: expected refusal\n' "$scenario" >&2
                exit 1
            }
            ;;
        *) exit 2 ;;
    esac

    if [ -n "$pattern" ]; then
        grep -F "$pattern" "$output" >/dev/null || {
            cat "$output" >&2
            printf 'FAIL %s: expected output containing: %s\n' "$scenario" "$pattern" >&2
            exit 1
        }
    fi

    if [ "$scenario" = normal ]; then
        [ -s "$state" ] || {
            printf 'FAIL normal: fork POST was not observed\n' >&2
            exit 1
        }
    fi

    if [ "$expected" = refusal ]; then
        [ ! -s "$state" ] || {
            printf 'FAIL %s: fork POST occurred despite refusal\n' "$scenario" >&2
            exit 1
        }
    fi

    printf 'PASS %s\n' "$scenario"
}

run_case normal success 'verified: dilapidated-shed/micropython is a fork of micropython/micropython'
run_case already-correct success 'already verified: dilapidated-shed/micropython is a fork of micropython/micropython'
run_case destination-collision refusal 'destination already exists but is not the requested fork'
run_case source-redirect refusal 'instead of being the canonical source'
run_case wrong-login refusal 'gh is authenticated as someone-else'
run_case destination-org-missing refusal 'destination organization dilapidated-shed is not accessible'
run_case destination-membership-missing refusal 'is not an active member of dilapidated-shed'
run_case fork-rejected refusal 'GitHub rejected fork'
run_case wrong-network refusal 'destination already exists but is not the requested fork'
