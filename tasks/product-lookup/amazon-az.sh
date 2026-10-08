#!/bin/sh
set -eu

fail() {
    printf '%s\n' "$*" >&2
    exit 2
}

: "${PREFIX:?PREFIX must identify the Termux prefix containing bin/az}"

az_bin=${AZ_BIN:-"$PREFIX/bin/az"}
grease=${GREASE:-grease}

[ -f "$az_bin" ] || fail "AZ backend not found: $az_bin"

case ${1:-} in
    doctor|search|price|history|link)
        ;;
    "")
        fail "usage: amazon-az.sh {doctor|search|price|history|link} [arguments...]"
        ;;
    *)
        fail "unsupported AZ command: $1"
        ;;
esac

command -v "$grease" >/dev/null 2>&1 || fail "Grease executable not found: $grease"

exec "$grease" "$az_bin" "$@"
