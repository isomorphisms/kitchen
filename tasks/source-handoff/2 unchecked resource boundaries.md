# Version 2: checked preparation and complete emission

Version 1 remains unchanged as the exact historical adapter that passed the
original 27 host cases. Its manifest-producing `awk` redirection was not checked,
extracted blobs were written directly to their final scratch names, test output
capture had no independently retained child status, and emission streamed
directly to stdout. No observed false acceptance was established from those
gaps; they were untested resource boundaries.

Version 2 stages and checks the contracted-file manifest, proves complete row
coverage, stages each extracted blob before finalizing it, retains the child
status separately from stdout/stderr capture, and stages the complete emitted
unit before replay. A served unit ends with `source-handoff-unit=COMPLETE`.
Partial stdout can still physically escape when its destination fails, but it
cannot carry the completion marker and the producer exits blocked.

The successor preserves version 1's contract schema and command interface so
reviewed consumers do not need a new policy or registry. The tests keep the old
source, checkout, quoting, scope, dirty-state and parent-errexit cases, then add
faults for scratch allocation, manifest writing/omission, extraction, captured
output and final emission. These are disposable Linux host checks only.
