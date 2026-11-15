# Runtime identity without a package database — before attempt 12

Preserve attempt 11 and its actual exit-1 preflight failure. A package-manager
database is metadata; its absence does not prove that an observed ELF runtime
is missing. Do not label it PASS or silently invent package identities.

Keep attempt 11's exact authenticated material checks, strict path mapping,
Ike protocol, independent glyph checks, 46-case native execution, mutants and
restoration unchanged. Record the package query's real exit and diagnostic.
When package metadata is unavailable, mark only that metadata UNAVAILABLE.

Require actual `ldd` dependency resolution for the delivered compiler and cc1,
reject unresolved libraries, and hash every named absolute resolved runtime
file. Keep producer package receipts separate. Recheck those actual consuming
runtime file hashes after all compilation/execution, alongside the authenticated
archive/receipt/compiler/own-runtime/source/probe/recipe checks. A missing runtime
or changed runtime remains a required failure.
