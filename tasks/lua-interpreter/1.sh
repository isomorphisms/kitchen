#!/bin/sh
set -eu

fail() {
    printf '%s\n' "$*" >&2
    exit 1
}

[ "$#" -eq 1 ] || fail 'usage: 1.sh ABSOLUTE_PREFIX'
prefix=$1
case $prefix in
    /*) ;;
    *) fail 'ABSOLUTE_PREFIX must be an absolute path' ;;
esac

version=5.5.1
archive=lua-$version.tar.gz
url=https://www.lua.org/ftp/$archive
expected_sha256=1c4b4068d67061f2a2231ad2b5422e77acea1487ea9890f6320af614f4373dce

for required in make cc tar cp chmod mv mkdir ln readlink rm awk basename; do
    command -v "$required" >/dev/null 2>&1 || fail "$required is required"
done

hash_file() {
    file=$1
    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum "$file" | awk '{print $1}'
    elif command -v sha256 >/dev/null 2>&1; then
        sha256 -q "$file"
    elif command -v shasum >/dev/null 2>&1; then
        shasum -a 256 "$file" | awk '{print $1}'
    else
        fail 'sha256sum, sha256, or shasum is required'
    fi
}

bin=$prefix/bin
lua_alias=$bin/lua
luac_alias=$bin/luac
lua_target=lua-$version
luac_target=luac-$version

check_alias() {
    alias_path=$1
    expected_target=$2
    if [ -L "$alias_path" ]; then
        current_target=$(readlink "$alias_path")
        [ "$current_target" = "$expected_target" ] ||
            fail "refusing to replace existing symlink: $alias_path -> $current_target"
    elif [ -e "$alias_path" ]; then
        fail "refusing to replace existing path: $alias_path"
    fi
}

check_alias "$lua_alias" "$lua_target"
check_alias "$luac_alias" "$luac_target"

lua_versioned=$bin/$lua_target
luac_versioned=$bin/$luac_target

if [ -e "$lua_versioned" ] || [ -L "$lua_versioned" ] || [ -e "$luac_versioned" ] || [ -L "$luac_versioned" ]; then
    [ -f "$lua_versioned" ] && [ -x "$lua_versioned" ] ||
        fail "partial or invalid existing Lua install: $lua_versioned"
    [ -f "$luac_versioned" ] && [ -x "$luac_versioned" ] ||
        fail "partial or invalid existing Lua install: $luac_versioned"
    case $("$lua_versioned" -v 2>&1) in
        'Lua 5.5.1'*) ;;
        *) fail "existing $lua_versioned is not Lua 5.5.1" ;;
    esac
    case $("$luac_versioned" -v 2>&1) in
        'Lua 5.5.1'*) ;;
        *) fail "existing $luac_versioned is not Lua 5.5.1" ;;
    esac
    [ -L "$lua_alias" ] || ln -s "$lua_target" "$lua_alias"
    [ -L "$luac_alias" ] || ln -s "$luac_target" "$luac_alias"
    "$lua_alias" -e 'assert(_VERSION == "Lua 5.5")'
    printf '%s\n' "$lua_alias"
    exit 0
fi

work=${TMPDIR:-/tmp}/kitchen-lua-$version-$$
trap 'rm -rf "$work"' EXIT HUP INT TERM
mkdir -p "$work"

if [ -n "${KITCHEN_LUA_ARCHIVE:-}" ]; then
    [ -f "$KITCHEN_LUA_ARCHIVE" ] || fail "archive does not exist: $KITCHEN_LUA_ARCHIVE"
    source_archive=$KITCHEN_LUA_ARCHIVE
else
    command -v curl >/dev/null 2>&1 || fail 'curl is required when KITCHEN_LUA_ARCHIVE is not set'
    source_archive=$work/$archive
    curl --fail --location --proto '=https' --tlsv1.2 --output "$source_archive" "$url"
fi

actual_sha256=$(hash_file "$source_archive")
[ "$actual_sha256" = "$expected_sha256" ] ||
    fail "SHA-256 mismatch for $source_archive: expected $expected_sha256, got $actual_sha256"

tar -xzf "$source_archive" -C "$work"
source_dir=$work/lua-$version
[ -d "$source_dir/src" ] || fail "archive did not contain expected directory: lua-$version/src"

make -C "$source_dir" CC=cc all

built_lua=$source_dir/src/lua
built_luac=$source_dir/src/luac
[ -x "$built_lua" ] || fail 'build did not produce an executable lua interpreter'
[ -x "$built_luac" ] || fail 'build did not produce an executable luac compiler'
"$built_lua" -e 'assert(_VERSION == "Lua 5.5")'

mkdir -p "$bin"

install_one() {
    source_path=$1
    destination=$2
    temporary=$bin/.install-$(basename "$destination")-$$
    cp "$source_path" "$temporary"
    chmod 755 "$temporary"
    mv "$temporary" "$destination"
}

install_one "$built_lua" "$lua_versioned"
install_one "$built_luac" "$luac_versioned"

[ -L "$lua_alias" ] || ln -s "$lua_target" "$lua_alias"
[ -L "$luac_alias" ] || ln -s "$luac_target" "$luac_alias"

"$lua_alias" -e 'assert(_VERSION == "Lua 5.5")'
printf '%s\n' "$lua_alias"
