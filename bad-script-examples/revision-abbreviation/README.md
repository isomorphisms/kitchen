# Revision abbreviation used at the wrong boundary

Evidence date: August 25, 2026.

A generated build recipe reused a shortened revision identifier across two
different source-control boundaries. The abbreviation made sense locally but
was not accepted by the remote operation, so source acquisition failed before
the build.

The recipe had already started expensive environment setup before discovering
this.

Regression: establish the exact immutable source identity before expensive
setup, and do not assume every source-control operation accepts the same
abbreviated identifier.

This is a reconstruction of the failure mechanism, not a verbatim script.
