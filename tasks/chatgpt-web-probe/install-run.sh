#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

fail() {
    printf 'chatgpt-web-probe install-run: %s\n' "$*" >&2
    exit 1
}

[[ $# -eq 1 && "$1" =~ ^[0-9]+$ ]] || {
    printf 'usage: %s FLEXIBLE_PIPES_RUN_ID\n' "$0" >&2
    exit 2
}
run_id=$1

for command in gh mktemp rm bash; do
    command -v "$command" >/dev/null 2>&1 || fail "missing command: $command"
done

work=$(mktemp -d "${TMPDIR:-$HOME/.cache}/chatgpt-web-probe.XXXXXX") ||
    fail "cannot create temporary directory"
trap 'rm -rf "$work"' EXIT HUP INT TERM
bundle="$work/bundle"
mkdir -p "$bundle"

gh run download "$run_id"     -R isomorphisms/flexible-pipes     -n chatgpt-web-probe-paired     -D "$bundle"

for file in install.sh artifacts.tsv catfood-target.sh; do
    [[ -f "$bundle/$file" ]] || fail "downloaded bundle is missing $file"
done
[[ -d "$bundle/apk" ]] || fail "downloaded bundle is missing apk/"

bash "$bundle/install.sh" "$bundle"
