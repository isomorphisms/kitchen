# Static artifact checks reported as target-device acceptance

Evidence period: July–August 2026.

Several generated Android workflows produced reassuring parser, signature,
hash, packaging or builder-environment checks. The target device later rejected
or failed to run artifacts that had passed those checks.

The failure was not that the earlier checks were useless. It was that the
reported conclusion was stronger than the evidence.

Regression: keep these evidence states separate: package parses, signature
structure verifies, expected contents are present, target device installs it,
and target device reaches the requested runtime postcondition.

This entry groups several related historical failures; it is not a verbatim
single script.
