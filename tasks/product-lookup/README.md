# Product lookup

Kitchen owns user-facing product lookup entry points. Keep provider-specific
authority in one place rather than reconstructing lookup commands in chat.

## Amazon through AZ

Kitchen owns the pasteable/user-facing invocation of the user's local AZ Amazon
backend. Do not replace this path with a generic Amazon URL or an unrelated web
search when AZ is available.

The canonical AZ source repository is:

```text
Ashtray-Archer/az
```

Do not fall back to the former `isomorphisms/az` location. The maintained
runtime may be the Cat Food stable command under `$CATFOOD_ROOT/bin/az`
(workbench) or `~/opt/bin/az` (packaged runtime), or the Termux-installed
source under `$PREFIX/bin/az`.

When `AZ_BIN` is set, it takes precedence and **does not require**
`PREFIX`. A direct installed AZ source requires the exact reviewed Git
blob in `AZ_EXPECTED_BLOB`; a Cat Food stable workbench command is admitted
only when its canonical AZ checkout, HEAD and working bytes agree (and the
optional `AZ_EXPECTED_BLOB` agrees). The Cat Food stable wrapper is executed
directly, since it already invokes Grease. A directly installed AZ script is
interpreted by Grease. Neither an arbitrary file named `az` nor an unverified
Termux executable is sufficient.

For a direct Termux installation, the syntax is:

```sh
grease "$PREFIX/bin/az" doctor
grease "$PREFIX/bin/az" search "MIRO A1 LCD digitizer screen assembly"
grease "$PREFIX/bin/az" price B0ABC123
grease "$PREFIX/bin/az" history B0ABC123
grease "$PREFIX/bin/az" link B0ABC123
```

The maintained Kitchen entry point is:

```sh
sh tasks/product-lookup/amazon-az.sh search "MIRO A1 LCD digitizer screen assembly"
```

It accepts only `doctor`, `search`, `price`, `history`, and `link`,
passes each argument unchanged, refuses absent Grease or unverified executable
identity, and preserves the AZ exit status and standard streams. The search TSV
contains **unverified** ASIN candidates; a tagged link is not product-fit,
price or stock evidence. See AZ's `AZ_SEARCH_STATUS_FILE` and the named
Flexible Pipes `amazon-product-lookup` for product-fit gating and receipts.

Offline wrapper/location fixture tests: `sh tests/amazon-az-contract.sh`.
Those tests use a fake Grease interpreter to check Kitchen dispatch, **not**
to certify the real AZ/Grease runtime. The provider and cross-repository
integration require separate exact-source execution.

## AbeBooks lowest used result by ISBN

Target context: a POSIX shell with standard `tr`. This helper is deliberately
read-only and network-free; it constructs the canonical AbeBooks search URL for
a browser or web consumer rather than scraping AbeBooks itself.

Requirements:

- Accept one ISBN-10 or ISBN-13, with optional hyphens.
- Reject other characters or the wrong compact length.
- Remove hyphens before placing the ISBN in the query.
- Restrict the query to observed used-book condition values.
- Set United States destination and USD pricing.
- Preserve AbeBooks `sortby=17`, which orders results by lowest total price.
- Print exactly one URL and perform no network request, browser launch, file
  mutation, or purchase action.

Invocation:

```sh
sh tasks/product-lookup/abebooks-lowest-used-isbn.sh 9780312625436
```

The first available result on the resulting AbeBooks page is the intended
lowest-total-price used offer for that ISBN under those destination/currency
settings. AbeBooks can change listings between lookup and checkout, so the
displayed result remains the final authority.

## Ownership

Kitchen owns these exact user-facing invocations. Flexible Pipes should call
them by pinned identity rather than reconstructing AZ/Grease or AbeBooks query
semantics from memory. Product fit/compatibility analysis remains a caller
responsibility.
