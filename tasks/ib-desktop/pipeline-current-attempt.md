# Current native pipeline environment handoff

November 15, 2026. FP's existing controller permits a parameter placeholder only
as a complete argument. The first current registration's `GREASE={{grease}}`
argument was refused before execution with `parameter placeholders must occupy
a whole argv element`. That is an observed registration error, not a native
consumer failure.

The wrapper retains the existing Kitchen ownership of environment setup. It
receives explicit paths and material identities, sets Grease/Ike/Kitchen values
without shell interpolation in FP, and calls the already exercised recipe 12.
No controller implementation, interpreter, compiler or acceptance condition is
replaced. Missing arguments and nonabsolute runtime paths must refuse before
executing the native recipe. The complete successful path requires a fresh FP
run; source presence and parsing alone do not establish its result.
