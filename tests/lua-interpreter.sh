#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
installer=$root/tasks/lua-interpreter/install.sh

tmp=${TMPDIR:-/tmp}/kitchen-lua-test-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

prefix=$tmp/prefix
sh "$installer" "$prefix" >/dev/null

[ -x "$prefix/bin/lua-5.5.1" ] || { printf 'missing versioned lua\n' >&2; exit 1; }
[ -x "$prefix/bin/luac-5.5.1" ] || { printf 'missing versioned luac\n' >&2; exit 1; }
[ -L "$prefix/bin/lua" ] || { printf 'missing lua symlink\n' >&2; exit 1; }
[ -L "$prefix/bin/luac" ] || { printf 'missing luac symlink\n' >&2; exit 1; }
[ "$(readlink "$prefix/bin/lua")" = lua-5.5.1 ] || { printf 'wrong lua symlink target\n' >&2; exit 1; }
[ "$(readlink "$prefix/bin/luac")" = luac-5.5.1 ] || { printf 'wrong luac symlink target\n' >&2; exit 1; }

answer=$("$prefix/bin/lua" -e 'io.write(6 * 7)')
[ "$answer" = 42 ] || { printf 'lua evaluation failed: %s\n' "$answer" >&2; exit 1; }
case $("$prefix/bin/lua" -v 2>&1) in
    'Lua 5.5.1'*) ;;
    *) printf 'unexpected Lua version\n' >&2; exit 1 ;;
esac
printf 'PASS real Lua evaluation\n'

sh "$installer" "$prefix" >/dev/null
[ "$("$prefix/bin/lua" -e 'io.write(21 * 2)')" = 42 ] || {
    printf 'rerun damaged interpreter\n' >&2
    exit 1
}
printf 'PASS idempotent reinstall\n'

protected=$tmp/protected
mkdir -p "$protected/bin"
printf '#!/bin/sh\nprintf "%s\\n" sentinel\n' > "$protected/bin/lua"
chmod 755 "$protected/bin/lua"
set +e
sh "$installer" "$protected" >"$tmp/protected.out" 2>&1
status=$?
set -e
[ "$status" -ne 0 ] || { printf 'expected existing lua refusal\n' >&2; exit 1; }
[ "$("$protected/bin/lua")" = sentinel ] || { printf 'existing lua was changed\n' >&2; exit 1; }
[ ! -e "$protected/bin/lua-5.5.1" ] || { printf 'build/install started before alias refusal\n' >&2; exit 1; }
printf 'PASS existing lua refusal\n'

printf 'not the Lua archive\n' > "$tmp/corrupt.tar.gz"
bad=$tmp/bad-prefix
set +e
KITCHEN_LUA_ARCHIVE=$tmp/corrupt.tar.gz sh "$installer" "$bad" >"$tmp/corrupt.out" 2>&1
status=$?
set -e
[ "$status" -ne 0 ] || { printf 'expected corrupt archive refusal\n' >&2; exit 1; }
[ ! -e "$bad/bin/lua-5.5.1" ] || { printf 'corrupt archive installed lua\n' >&2; exit 1; }
grep -F 'SHA-256 mismatch' "$tmp/corrupt.out" >/dev/null || {
    printf 'corrupt archive did not fail at digest check\n' >&2
    cat "$tmp/corrupt.out" >&2
    exit 1
}
printf 'PASS corrupt archive refusal\n'

set +e
sh "$installer" relative/prefix >"$tmp/relative.out" 2>&1
status=$?
set -e
[ "$status" -ne 0 ] || { printf 'expected relative prefix refusal\n' >&2; exit 1; }
printf 'PASS relative prefix refusal\n'
