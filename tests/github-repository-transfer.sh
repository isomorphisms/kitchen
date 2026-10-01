#!/bin/sh
set -eu

root=$(cd "$(dirname "$0")/.." && pwd)
candidate=$root/tasks/github-repository-transfer/1.sh

tmp=${TMPDIR:-/tmp}/kitchen-gh-transfer-$$
fakebin=$tmp/bin
mkdir -p "$fakebin"
trap 'rm -rf "$tmp"' EXIT HUP INT TERM

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
destination=isomorphisms/sd-card-append-fat

if [ "$1" = auth ]; then
    exit 0
fi

[ "$1" = api ] || exit 97
shift

if [ "$1" = user ]; then
    if [ "$scenario" = wrong-login ]; then
        printf '%s\n' someone-else
    else
        printf '%s\n' isomorphisms
    fi
    exit 0
fi

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

if [ "$method" = POST ]; then
    [ "$endpoint" = "repos/$source/transfer" ] || exit 96
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
    state=$tmp/state-$scenario
    output=$tmp/output-$scenario
    : > "$state"

    set +e
    PATH="$fakebin:$PATH" \
    FAKE_GH_STATE="$state" \
    FAKE_GH_SCENARIO="$scenario" \
        sh "$candidate" \
        fuego-ironworks sd-card-append-fat isomorphisms isomorphisms \
        >"$output" 2>&1
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
            grep 'verified: isomorphisms/sd-card-append-fat' "$output" >/dev/null
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

    printf 'PASS %s\n' "$scenario"
}

run_case normal success
run_case destination-redirect success
run_case destination-exists refusal
run_case source-redirect refusal
run_case wrong-login refusal
