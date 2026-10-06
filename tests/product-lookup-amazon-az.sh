#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
helper="$repo_root/tasks/product-lookup/amazon-az.sh"

tmp=${TMPDIR:-/tmp}/kitchen-az-test.$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp/prefix/bin" "$tmp/bin"

cat >"$tmp/prefix/bin/az" <<'EOF'
#!/bin/sh
exit 0
EOF

cat >"$tmp/bin/grease" <<'EOF'
#!/bin/sh
printf 'argc=%s\n' "$#"
for arg in "$@"; do
    printf '<%s>\n' "$arg"
done
EOF
chmod +x "$tmp/prefix/bin/az" "$tmp/bin/grease"

out=$(
    PREFIX="$tmp/prefix" \
    PATH="$tmp/bin:$PATH" \
    sh "$helper" search "MIRO A1 LCD digitizer screen assembly"
)

expected=$(cat <<EOF
argc=3
<$tmp/prefix/bin/az>
<search>
<MIRO A1 LCD digitizer screen assembly>
EOF
)

[ "$out" = "$expected" ] || {
    printf 'unexpected forwarding:\n%s\n' "$out" >&2
    exit 1
}

if PREFIX="$tmp/prefix" PATH="$tmp/bin:$PATH" sh "$helper" bogus >/dev/null 2>&1; then
    printf 'unsupported AZ command unexpectedly succeeded\n' >&2
    exit 1
fi

printf 'amazon-az forwarding: ok\n'
