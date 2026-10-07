#!/bin/sh
set -eu

fail() {
    printf '%s\n' "$*" >&2
    exit 2
}

isbn=${1:-}
[ -n "$isbn" ] || fail "usage: abebooks-lowest-used-isbn.sh ISBN"

case "$isbn" in
    *[!0-9Xx-]*)
        fail "ISBN must contain only digits, X, or hyphens: $isbn"
        ;;
esac

compact=$(printf '%s' "$isbn" | tr -d '-')

case "$compact" in
    [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9Xx])
        ;;
    [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9])
        ;;
    *)
        fail "ISBN must be 10 or 13 characters after removing hyphens: $isbn"
        ;;
esac

printf '%s\n' "https://www.abebooks.com/servlet/SearchResults?bi=0&bx=off&cond=an%20fine%20nf%20vg%20good%20fair%20poor%20uns&currency=USD&destination=US&ds=20&isbn=$compact&prc=USD&recentlyadded=all&rgn=ww&rollup=on&sortby=17&xdesc=off&xpod=off"
