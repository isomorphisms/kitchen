#!/bin/sh
set -eu

root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd -P)
abe=$root/tasks/book-lookup/abebooks.py
ia=$root/tasks/book-lookup/internet_archive.py

isbn=$(python3 "$abe" --isbn '978-0-19-920764-0')
[ "$isbn" = 'https://www.abebooks.com/book-search/isbn/9780199207640/used/' ]

search=$(python3 "$abe" --title 'Citizen of the World' --author 'Maria Montessori')
[ "$search" = 'https://www.abebooks.com/servlet/SearchResults?cm_sp=SearchF-_-home-_-Results&ref_=search_f_hp&sortbyp=17&sts=t&an=Maria%20Montessori&tn=Citizen%20of%20the%20World' ]

plan=$(python3 "$ia" --title 'Citizen of the World' --author 'Maria Montessori' --plan-only)
printf '%s\n' "$plan" | grep -F 'https://archive.org/advancedsearch.php?' >/dev/null
printf '%s\n' "$plan" | grep -F 'fav-isomorphismes' >/dev/null
printf '%s\n' "$plan" | grep -F 'Citizen%20of%20the%20World' >/dev/null
printf '%s\n' "$plan" | grep -F 'Maria%20Montessori' >/dev/null

printf '%s\n' 'book lookup regression: ok'
