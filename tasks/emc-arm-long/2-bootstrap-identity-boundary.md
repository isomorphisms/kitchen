# Record the canonical-owner bootstrap correction

Version 2 passed the real Grease syntax check. Before running compilation,
the original canonical compiler bootstrap failed in inherited RefC support.
Version 3 requires the exact build-only support Makefile overlay prepared in
the canonical compiler owner and records its hash, source revision and explicit
nonpristine-bootstrap status. Other compiler diffs and dirty consumer sources
are refused. The hosted pristine-source compiler run stays separate.
