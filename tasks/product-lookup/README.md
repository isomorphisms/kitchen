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
phone installation is the built backend at:

```sh
$PREFIX/bin/az
```

and it is invoked through Grease:

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

It accepts only the known AZ commands `doctor`, `search`, `price`,
`history`, and `link`, then forwards the arguments unchanged through Grease
to the exact local AZ backend.

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
