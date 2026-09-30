# Missing input counted as successful coverage

Evidence date: August 24, 2026.

A generated checker reported complete coverage even though one class of source
material had not actually been read.

Regression: unavailable, unchecked, checked-absent, and checked-present must be
different result states. Missing evidence cannot become a PASS merely because
the checker reached the end.

This is a reconstruction of the failure mechanism, not a verbatim script.
