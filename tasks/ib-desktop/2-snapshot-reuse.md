# Attempt 2 follow-up — refuse reused snapshot directories

The successful first run used fresh output roots. Inspection afterward found
that cp -R into an existing snapshot directory can leave the previous top-level
IB source and place the new copy below IB/IB. A repeated run must not check those
stale bytes while hashing new producer inputs.

Attempt 4 preserves attempt 2 and adds refusal before any receipt/output write
when a snapshot, TTC directory or Ikefile already exists. The native extension
also requires fresh source/TTC/library directories. A reused-output fixture must
stop before invoking the compiler; the ordinary fresh-root run must still pass.
