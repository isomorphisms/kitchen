#!/bin/sh
set -eu

fail() {
    printf '%s\n' "$*" >&2
    exit 2
}

[ "$#" -eq 1 ] || fail "usage: abebooks-lowest-used-isbn.sh ISBN"
isbn=$1
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

# A digit count is not enough to validate an ISBN. ISBN-10 uses weighted
# modulus 11 (X = 10 only in the last place); ISBN-13 alternates weights 1,3
# and uses modulus 10. The syntax above already restricts the character set.
length=${#compact}
position=1
remaining=$compact
sum=0
while [ -n "$remaining" ]; do
    tail=${remaining#?}
    character=${remaining%"$tail"}
    remaining=$tail
    if [ "$length" -eq 10 ]; then
        case "$character" in X|x) value=10 ;; *) value=$character ;; esac
        sum=$((sum + value * (11 - position)))
    else
        if [ $((position % 2)) -eq 0 ]; then weight=3; else weight=1; fi
        sum=$((sum + character * weight))
    fi
    position=$((position + 1))
done
if [ "$length" -eq 10 ]; then
    [ $((sum % 11)) -eq 0 ] || fail "invalid ISBN-10 check digit: $isbn"
    case "$compact" in *x) compact=${compact%x}X ;; esac
else
    [ $((sum % 10)) -eq 0 ] || fail "invalid ISBN-13 check digit: $isbn"
fi

printf '%s\n' "https://www.abebooks.com/servlet/SearchResults?bi=0&bx=off&cond=an%20fine%20nf%20vg%20good%20fair%20poor%20uns&currency=USD&destination=US&ds=20&isbn=$compact&prc=USD&recentlyadded=all&rgn=ww&rollup=on&sortby=17&xdesc=off&xpod=off"
