#!/bin/sh
set -eu

root=$(cd "$(dirname "$0")/.." && pwd)
generator=$root/tasks/github-repository-transfer/generate-transfer-github-repository-script-legacy-1.sh

tmp=${TMPDIR:-/tmp}/kitchen-gh-transfer-$$
fakebin=$tmp/bin
mkdir -p "$fakebin"
trap 'rm -rf "$tmp"' EXIT HUP INT TERM

candidate=$tmp/transfer-sd-card-append-fat-from-fuego-ironworks-to-isomorphisms.sh

(
    cd "$tmp"
    sh "$generator" \
        fuego-ironworks sd-card-append-fat isomorphisms isomorphisms
)

[ -x "$candidate" ] || {
    printf 'FAIL generator: expected executable %s\n' "$candidate" >&2
    exit 1
}

grep -F 'source_owner=fuego-ironworks' "$candidate" >/dev/null
grep -F 'repository=sd-card-append-fat' "$candidate" >/dev/null
grep -F 'destination_owner=isomorphisms' "$candidate" >/dev/null
grep -F 'expected_login=isomorphisms' "$candidate" >/dev/null

if grep -F 'usage: 1.sh' "$candidate" >/dev/null; then
    printf 'FAIL generator: generated script exposes numbered candidate name\n' >&2
    exit 1
fi

if (
    cd "$tmp"
    sh "$generator" 'bad;owner' sd-card-append-fat isomorphisms isomorphisms \
        >"$tmp/invalid-generator.out" 2>&1
); then
    printf 'FAIL generator: unsafe owner was accepted\n' >&2
    exit 1
fi

cat > "$fakebin/sleep" <<'EOF'
#!/bin/sh
exit 0
EOF
chmod +x "$fakebin/sleep"

cat > "$fakebin/gh" <<'EOF'
#!/bin/sh
set -eu

state=${FAKE_GH_STATE:?}
scenario=${FAKE_GH_SCENARIO:?}
source=fuego-ironworks/sd-card-append-fat

if [ "$scenario" = destination-owner-case ]; then
    destination_owner=Isomorphisms
else
    destination_owner=isomorphisms
fi

destination=$destination_owner/sd-card-append-fat

if [ "$1" = auth ]; then
    exit 0
fi

[ "$1" = api ] || exit 97
shift

method=GET
endpoint=

while [ "$#" -gt 0 ]; do
    case $1 in
        --method)
            method=$2
            shift 2
            ;;
        -f|--jq)
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
    orgs/isomorphisms)
        [ "$scenario" != destination-org-missing ] || exit 1
        printf '%s\n' "$destination_owner"
        exit 0
        ;;
    user/memberships/orgs/isomorphisms|user/memberships/orgs/Isomorphisms)
        [ "$scenario" != destination-membership-missing ] || exit 1
        printf '%s\n' active:admin
        exit 0
        ;;
esac

if [ "$method" = POST ]; then
    [ "$endpoint" = "repos/$source/transfer" ] || exit 96

    if [ "$scenario" = transfer-rejected ]; then
        printf '%s\n' 'gh: Validation Failed (HTTP 422)' >&2
        exit 1
    fi

    printf '%s\n' transferred > "$state"
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
        if [ "$scenario" = destination-exists ]; then
            printf '%s\n' "$destination"
        elif [ -s "$state" ]; then
            printf '%s\n' "$destination"
        elif [ "$scenario" = destination-redirect ]; then
            printf '%s\n' "$source"
        else
            exit 1
        fi
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
    : > "$state"

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
            [ -s "$state" ] || {
                printf 'FAIL %s: transfer POST was not observed\n' "$scenario" >&2
                exit 1
            }
            ;;
        refusal)
            [ "$status" -ne 0 ] || {
                cat "$output" >&2
                printf 'FAIL %s: expected refusal\n' "$scenario" >&2
                exit 1
            }
            [ ! -s "$state" ] || {
                printf 'FAIL %s: transfer POST occurred despite refusal\n' "$scenario" >&2
                exit 1
            }
            ;;
        *)
            printf 'bad expected result: %s\n' "$expected" >&2
            exit 2
            ;;
    esac

    if [ -n "$pattern" ]; then
        grep -F "$pattern" "$output" >/dev/null || {
            cat "$output" >&2
            printf 'FAIL %s: expected output containing: %s\n' "$scenario" "$pattern" >&2
            exit 1
        }
    fi

    printf 'PASS %s\n' "$scenario"
}

run_case normal success 'verified: isomorphisms/sd-card-append-fat'
run_case destination-owner-case success 'verified: Isomorphisms/sd-card-append-fat'
run_case destination-redirect success 'verified: isomorphisms/sd-card-append-fat'
run_case destination-exists refusal 'destination already exists'
run_case source-redirect refusal 'instead of being the canonical source'
run_case wrong-login refusal 'gh is authenticated as someone-else'
run_case destination-org-missing refusal 'destination organization isomorphisms is not accessible'
run_case destination-membership-missing refusal 'is not an active member of isomorphisms'
run_case transfer-rejected refusal 'GitHub rejected transfer'
