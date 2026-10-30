#!/bin/sh
set -eu

fail() {
    printf 'kitchen amazon-az: %s\n' "$*" >&2
    exit 2
}

case ${1:-} in
    doctor|search|price|history|link) ;;
    "") fail "usage: amazon-az.sh {doctor|search|price|history|link} [arguments...]" ;;
    *) fail "unsupported AZ command: $1" ;;
esac

# Explicit selection takes precedence. Cat Food stable commands are the
# normal workbench and packaged-runtime path; Termux PREFIX is a fallback.
catfood_bin=${CATFOOD_BIN:-}
if [ -z "$catfood_bin" ] && [ -n "${CATFOOD_ROOT:-}" ]; then
    catfood_bin=$CATFOOD_ROOT/bin
fi

if [ -n "${AZ_BIN:-}" ]; then
    az_bin=$AZ_BIN
elif [ -n "$catfood_bin" ] && [ -f "$catfood_bin/az" ]; then
    az_bin=$catfood_bin/az
elif [ -n "${PREFIX:-}" ] && [ -f "$PREFIX/bin/az" ]; then
    az_bin=$PREFIX/bin/az
else
    fail "AZ missing: set AZ_BIN to a pinned executable, or provide Cat Food / Termux installed command"
fi

case "$az_bin" in
    /*) ;;
    *) fail "AZ_BIN must be an absolute installed path: $az_bin" ;;
esac
[ -f "$az_bin" ] && [ -r "$az_bin" ] ||
    fail "AZ backend not readable: $az_bin"
command -v git >/dev/null 2>&1 || fail "git is required for AZ blob verification"

# Workbench Cat Food wrapper is admitted only against its checked-out,
# canonical source with no edited bytes. A mere matching path is not proof.
verified_source=
if [ -n "${CATFOOD_ROOT:-}" ] &&
   [ "$az_bin" = "$CATFOOD_ROOT/bin/az" ]; then
    checkout=$CATFOOD_ROOT/az
    source=$checkout/bin/az
    [ -f "$source" ] || fail "Cat Food AZ source checkout missing: $source"
    grep -Fq '# catfood az wrapper' "$az_bin" ||
        fail "Cat Food stable AZ command is not a Cat Food wrapper"
    origin=$(git -C "$checkout" remote get-url origin 2>/dev/null || true)
    case "$origin" in
        https://github.com/Ashtray-Archer/az|https://github.com/Ashtray-Archer/az.git|git@github.com:Ashtray-Archer/az.git|ssh://git@github.com/Ashtray-Archer/az.git) ;;
        *) fail "wrong AZ origin: $origin" ;;
    esac
    head_blob=$(git -C "$checkout" rev-parse HEAD:bin/az 2>/dev/null || true)
    work_blob=$(git hash-object -- "$source")
    [ -n "$head_blob" ] && [ "$head_blob" = "$work_blob" ] ||
        fail "Cat Food AZ source bytes differ from committed HEAD"
    verified_source=$head_blob
fi

# Installed Termux binaries and explicitly supplied paths have no trusted
# checkout behind them. They require a source-bound Git blob from the caller.
# An optional pin also constrains the Cat Food checkout.
expected=${AZ_EXPECTED_BLOB:-}
if [ -z "$verified_source" ] && [ -z "$expected" ]; then
    fail "unverified AZ executable: supply AZ_EXPECTED_BLOB or a verified Cat Food checkout"
fi
actual=$verified_source
if [ -z "$actual" ]; then
    actual=$(git hash-object -- "$az_bin")
fi
case "$expected" in
    "" ) ;;
    *[!a-f0-9]* ) fail "invalid AZ_EXPECTED_BLOB: expected Git object ID" ;;
esac
if [ -n "$expected" ] && [ "$expected" != "$actual" ]; then
    fail "AZ executable blob mismatch: expected $expected, got $actual"
fi

grease=${GREASE:-${GREASE_BINARY:-}}
if [ -z "$grease" ] && [ -n "$catfood_bin" ] &&
   [ -x "$catfood_bin/grease" ]; then
    grease=$catfood_bin/grease
fi
if [ -z "$grease" ]; then grease=grease; fi
case "$grease" in
    /*) ;;
    *) grease=$(command -v "$grease" 2>/dev/null || true) ;;
esac
[ -n "$grease" ] && [ -x "$grease" ] ||
    fail "Grease executable not found or not executable"

printf 'kitchen amazon-az: verified az_blob=%s az_bin=%s grease=%s\n' \
    "$actual" "$az_bin" "$grease" >&2

# Cat Food's stable executable is already a reviewed Grease-launch wrapper.
# Launch it as a command, not as Grease source (which would double-interpret
# the wrapper). For directly installed AZ scripts, Grease owns interpretation.
if [ -n "$verified_source" ]; then
    [ -x "$az_bin" ] || fail "Cat Food AZ command is not executable"
    exec "$az_bin" "$@"
fi
exec "$grease" "$az_bin" "$@"
