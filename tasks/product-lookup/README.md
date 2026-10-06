# Amazon product lookup through AZ

Kitchen owns the pasteable/user-facing invocation of the user's local AZ Amazon
backend. Do not replace this path with a generic Amazon URL or an unrelated web
search when AZ is available.

AZ is installed locally at:

```sh
$PREFIX/bin/az
```

and is invoked through Grease:

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

## Ownership

Kitchen owns this exact invocation and its user-pasteable form. Flexible Pipes
must call this file by pinned identity rather than reconstructing the Grease/AZ
command from memory. Product fit/compatibility analysis remains a caller
responsibility; AZ supplies Amazon search/link/price/history behavior.
