# Mostow mathematical build preparation

Target: observed disposable Ubuntu 24.04 x86_64 Linux host, not a phone.
Authority: SUN M-MECHANICAL-01, October 19 2026.

Use the exact Mostow checkout supplied as an absolute path, the direct ICK
compiler and the owner Grease runtime; no syntax normalization or replacement
compiler. The caller pins Ike 93f9eb0aee9094757414df8a7929c89b6a294b0c
and Kitchen 739faa3068983531a04db33b3ecc43573272368e. The runtime's implementation
digest must match the existing Mostow CI pin. The host compiler restored from
the qualified c61e448 artifact has archive SHA256
8ee043088fffadba3704fd567c206c4852b0de69f0b8bb76a131bfb8fa4004a4.

Required postconditions: existing mathematical and scene tests pass; existing
known-bad cusp/scene mutants fail; accepted sheet fixture remains identical;
real EGL/GLES rendering executes and validates semantic changes and exact
scene reopening. New mathematical fixtures and constraint-removal mutations
must be added to the same producer before new work is accepted.

Negative requirements: a missing compiler/runtime/source must stop execution;
test failure must propagate through Grease, Ike and FP; no physical-device
acceptance is inferred. The maintained Grease test-host script's legacy
normalizer test is historical debt and does not normalize compiled source.

Run baseline against a separate clean source worktree so parallel edits cannot
change baseline claims. Run current work independently afterward. Ike receipts
are actual recipe execution evidence, not mathematical certification.
