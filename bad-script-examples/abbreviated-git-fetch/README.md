# Abbreviated commit passed to git fetch

Evidence date: August 25, 2026.

## Observed failure

A Termux build recipe used an abbreviated commit ID such as `45b39d5` directly
as the argument to `git fetch origin`. Git treated it as a remote ref name and
rejected it.

The recipe also started comparatively expensive environment setup before proving
that the requested source revision could be fetched.

## Regression

Resolve or fetch an immutable revision using a valid source/refspec, then verify
the source tree before toolchain installation or compilation. A short object
name that exists locally must not be assumed fetchable from a remote by the same
spelling.
