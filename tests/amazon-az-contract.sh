#!/bin/sh
# Contract fixtures for the POSIX wrapper, not a Grease runtime qualification.
set -eu
root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
wrapper=$root/tasks/product-lookup/amazon-az.sh

mkdir -p "$tmp/bin" "$tmp/installed path"
cat > "$tmp/bin/grease" <<'EOF'
#!/bin/sh
exec /bin/sh "$@"
EOF
chmod +x "$tmp/bin/grease"

cat > "$tmp/installed path/az" <<'EOF'
#!/bin/sh
printf '%s\n' "$@"
EOF
chmod +x "$tmp/installed path/az"
pin=$(git hash-object "$tmp/installed path/az")

# Explicit binary does not depend on PREFIX. Arguments remain separate.
output=$(env -u PREFIX AZ_BIN="$tmp/installed path/az" AZ_EXPECTED_BLOB="$pin" \
    GREASE="$tmp/bin/grease" /bin/sh "$wrapper" search 'door seal' 'two words')
expected=$(printf 'search\ndoor seal\ntwo words')
[ "$output" = "$expected" ] || {
    echo "explicit AZ_BIN lost arguments/whitespace" >&2; exit 1;
}
if env -u PREFIX AZ_BIN="$tmp/installed path/az" \
    GREASE="$tmp/bin/grease" /bin/sh "$wrapper" link B000CCFXYY >/dev/null 2>&1; then
    echo "unverified explicit AZ_BIN accepted" >&2; exit 1
fi
if AZ_BIN="$tmp/installed path/az" AZ_EXPECTED_BLOB=ffffffffffffffffffffffffffffffffffffffff \
    GREASE="$tmp/bin/grease" /bin/sh "$wrapper" doctor >/dev/null 2>&1; then
    echo "swapped AZ executable accepted" >&2; exit 1
fi
if AZ_BIN="$tmp/missing/az" AZ_EXPECTED_BLOB="$pin" \
    GREASE="$tmp/bin/grease" /bin/sh "$wrapper" doctor >/dev/null 2>&1; then
    echo "missing AZ executable accepted" >&2; exit 1
fi
if AZ_BIN="$tmp/installed path/az" AZ_EXPECTED_BLOB="$pin" \
    GREASE="$tmp/missing/grease" /bin/sh "$wrapper" doctor >/dev/null 2>&1; then
    echo "missing Grease accepted" >&2; exit 1
fi

# A real Termux PREFIX may be used only if the installed file matches a pin.
mkdir -p "$tmp/termux/bin"
cp "$tmp/installed path/az" "$tmp/termux/bin/az"
output=$(env -u AZ_BIN PREFIX="$tmp/termux" AZ_EXPECTED_BLOB="$pin" \
    GREASE="$tmp/bin/grease" /bin/sh "$wrapper" link B000PEZ1L4)
[ "$output" = "$(printf 'link\nB000PEZ1L4')" ] || {
    echo "Termux PREFIX fallback failed" >&2; exit 1;
}

# Cat Food's stable command is accepted only when its source has the expected
# origin, HEAD bytes, and an unmodified wrapper.
mkdir -p "$tmp/food/bin" "$tmp/food/az/bin"
cp "$tmp/bin/grease" "$tmp/food/bin/grease"
cp "$tmp/installed path/az" "$tmp/food/az/bin/az"
cat > "$tmp/food/bin/az" <<'EOF'
#!/bin/sh
# catfood az wrapper
exec "$CATFOOD_ROOT/bin/grease" "$CATFOOD_ROOT/az/bin/az" "$@"
EOF
chmod +x "$tmp/food/bin/az"
git -C "$tmp/food/az" init -q
git -C "$tmp/food/az" config user.name Fixture
git -C "$tmp/food/az" config user.email fixture@example.invalid
git -C "$tmp/food/az" remote add origin https://github.com/Ashtray-Archer/az.git
git -C "$tmp/food/az" add bin/az
git -C "$tmp/food/az" commit -qm fixture
output=$(env -u AZ_BIN -u PREFIX -u AZ_EXPECTED_BLOB \
    CATFOOD_ROOT="$tmp/food" /bin/sh "$wrapper" link B000CCFXYY)
[ "$output" = "$(printf 'link\nB000CCFXYY')" ] || {
    echo "Cat Food stable bin resolution failed" >&2; exit 1;
}
git -C "$tmp/food/az" remote set-url origin https://github.com/untrusted/az.git
if env -u AZ_BIN -u PREFIX -u AZ_EXPECTED_BLOB CATFOOD_ROOT="$tmp/food" \
    /bin/sh "$wrapper" doctor >/dev/null 2>&1; then
    echo "wrong AZ source origin accepted" >&2; exit 1
fi
git -C "$tmp/food/az" remote set-url origin https://github.com/Ashtray-Archer/az.git
printf '\n# changed\n' >> "$tmp/food/az/bin/az"
if env -u AZ_BIN -u PREFIX -u AZ_EXPECTED_BLOB CATFOOD_ROOT="$tmp/food" \
    /bin/sh "$wrapper" doctor >/dev/null 2>&1; then
    echo "dirty Cat Food source accepted" >&2; exit 1
fi
printf 'Kitchen Amazon AZ fixture contract: PASS (fake Grease only)\n'
