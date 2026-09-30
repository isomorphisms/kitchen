# Successful retrieval mistaken for a tracking reference

Evidence date: August 31, 2026.

A generated bootstrap sequence successfully retrieved a named branch and then
assumed the local tracking reference needed by the next step now existed. In
the shallow, single-branch checkout involved, that assumption was false. The
branch switch failed and the intended bootstrap never ran.

Regression: distinguish "objects were retrieved" from "the exact local
reference required by the next operation exists". Verify the latter directly.

This is a reconstruction of the failure mechanism, not a verbatim script.
