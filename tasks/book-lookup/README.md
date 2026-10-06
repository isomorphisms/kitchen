# Book lookup

Kitchen owns the provider-specific lookup scripts used for book research.

The point is to preserve the user's actual book links instead of silently
substituting a generic shopping/search path.

## AbeBooks

`abebooks.py` emits direct AbeBooks URLs in the forms already present in the
user's link collection:

- ISBN lookup: `https://www.abebooks.com/book-search/isbn/ISBN/used/`
- title/author lookup:
  `https://www.abebooks.com/servlet/SearchResults?...&sortbyp=17&sts=t...`

Examples:

```sh
python3 tasks/book-lookup/abebooks.py --isbn 9780199207640
python3 tasks/book-lookup/abebooks.py \
  --title 'Citizen of the World' \
  --author 'Maria Montessori'
```

The script builds the direct URL only. It does not replace the user's link with
an affiliate redirect or another bookseller.

## Internet Archive

`internet_archive.py` queries Internet Archive's advanced search endpoint and
returns canonical item links as `https://archive.org/details/IDENTIFIER`.

The user's favorites collection `fav-isomorphismes` is searched first, then
the general texts collection; duplicate identifiers are removed. This keeps
known/saved Archive material visible without limiting the search to favorites.

Examples:

```sh
python3 tasks/book-lookup/internet_archive.py \
  --title 'Citizen of the World' \
  --author 'Maria Montessori'

python3 tasks/book-lookup/internet_archive.py \
  --title 'Citizen of the World' \
  --author 'Maria Montessori' \
  --plan-only
```

`--plan-only` performs no network request and prints the exact Archive query
URLs. The normal mode records both query URLs and returned canonical detail
links in JSON.

## Ownership

Kitchen owns these scripts and their provider URL semantics. Flexible Pipes must
invoke these exact Kitchen files; it must not copy the AbeBooks or Archive URL
construction into its own implementation.
