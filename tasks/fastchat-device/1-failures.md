# Candidate preparation failures

2026-10-14, Linux x86-64 build host. Requirements preceded the implementation.
The actual hash-bound native Grease interpreter was used. No physical channel
or Android build tools were available on this host.

Preparation exposed three Grease syntax assumptions in the synthetic fixture
driver: `export` must be `setglobal ENV`, `elif` must continue the same brace
statement, and the inherited runtime does not provide a `range` function.
The device recipe also exposed invalid double-quoted regex escapes; extraction
uses an ordinary awk field separator instead. These failures occurred before
the candidate was served or published. Failed outputs remain in the local run
directories and are not physical evidence.

Cat Food's complete POSIX `android/target.sh` cannot be sourced by Grease because
it contains a POSIX subshell. The candidate invokes the existing Cat Food
entrypoint through its declared interpreter and supplies a Grease getprop
adapter; it does not copy or rewrite the identity oracle. A later rejecting
fixture exposed that the adapter was not executable in this context. Cat Food
correctly permits planning overrides without properties, so that interface
cannot accept a device capture. Candidate 2 calls the new explicit-property
Cat Food classifier with the captured bytes instead; the existing identity
oracle stays canonical and unknown classification is refused by Kitchen.

The pinned engine rejects invocation under a `grease` symlink basename. The
already established native `bin/grease` launcher invokes the same verified
engine through its implementation entrypoint. A consumer must supply that real
launcher, not invent another alias. Native engine SHA-256 remains
7e31cd05b7a9d8fb2a4a9e003a7f3fcb0159138506d17f0fb28da8cbe22aa85c.
