# Version 1 qualification boundary

Version 1 is a Python wrapper around the exact mbox reference executor. It adds
no mailbox mechanism. Its parser reconstructs explicit source/destination/mode
arguments, binds live planning to the incoming spool, propagates child failure,
and exposes only a marked disposable mutation entrypoint.

`test_handoff.py` runs those exact bytes twice from unrelated directories and
asserts the independent expected archive and keeper bytes, not only exit status.
The gate tests reproduce version A tested/version B displayed, changed selector,
changed fixture/library, changed path, copy becoming move, swapped roles and an
untested wrapper. Every bad counterpart is rejected; the original counterpart
passes again after restoration. `qualify` invokes the committed suites itself
and refuses drift during the tests before producing a receipt.

There was no SDF execution or delivery in this job. No live move command is
produced. Python 3.9 is the declared minimum; local receipts state the actual
executed version, and GitHub matrix execution is a separate evidence boundary.
Retained evidence is under `evidence/sdf-filing/`.
