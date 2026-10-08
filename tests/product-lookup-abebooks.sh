#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
candidate="$repo_root/tasks/product-lookup/abebooks-lowest-used-isbn.sh"

fail() {
    printf 'FAIL: %s\n' "$*" >&2
    exit 1
}

expected='https://www.abebooks.com/servlet/SearchResults?bi=0&bx=off&cond=an%20fine%20nf%20vg%20good%20fair%20poor%20uns&currency=USD&destination=US&ds=20&isbn=9780312625436&prc=USD&recentlyadded=all&rgn=ww&rollup=on&sortby=17&xdesc=off&xpod=off'

[ -f "$candidate" ] || fail "candidate missing: $candidate"

actual=$(sh "$candidate" 9780312625436)
[ "$actual" = "$expected" ] || fail "unexpected ISBN-13 URL: $actual"

hyphenated=$(sh "$candidate" 978-0-312-62543-6)
[ "$hyphenated" = "$expected" ] || fail "hyphen normalization changed URL"

isbn10=$(sh "$candidate" 031262543X)
case "$isbn10" in
    *'isbn=031262543X'*'sortby=17'*) ;;
    *) fail "ISBN-10 URL missing normalized ISBN or lowest-total sort: $isbn10" ;;
esac

if sh "$candidate" >/dev/null 2>&1; then
    fail "missing ISBN was accepted"
fi

# A well-shaped ISBN with a bad check digit must fail rather than become a URL.
if sh "$candidate" 9780312625437 >/dev/null 2>&1; then
    fail "invalid ISBN-13 check digit was accepted"
fi
if sh "$candidate" 0312625430 >/dev/null 2>&1; then
    fail "invalid ISBN-10 check digit was accepted"
fi

isbn10_lower=$(sh "$candidate" 031262543x)
[ "$isbn10_lower" = "$isbn10" ] || fail "lowercase ISBN-10 X did not canonicalize"

if sh "$candidate" 9780312625436 ignored-extra-argument >/dev/null 2>&1; then
    fail "extra positional arguments were accepted"
fi

if sh "$candidate" '9780312625436;touch /tmp/nope' >/dev/null 2>&1; then
    fail "shell metacharacters were accepted"
fi

if sh "$candidate" 12345 >/dev/null 2>&1; then
    fail "wrong-length ISBN was accepted"
fi

printf 'product-lookup AbeBooks tests: ok\n'
