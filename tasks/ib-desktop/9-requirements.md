# Repeat native consumer builds — requirements before attempt 9

Owner: SUN IB-X64-01, https://github.com/isomorphisms/ib/issues/139.
Target: an explicitly selected Linux x86-64 build host. Provisioning remains
outside this recipe. Compiler, Grease, Ike, ICK and host-runtime qualification
must already exist; no fallback toolchain or download is permitted here.

The earlier 8.grease recipe establishes one generated-program/native-ABI run.
Its passing result does not establish reproducible compiled Chez bytes.
November 15 continuation must compare two actual fresh consumer builds and
retain the differing outputs if they differ.

Required behavior:

1. Accept seven explicit absolute paths: IB checkout, independent AI-CI checkout,
   compiler bundle, nonexistent output root, qualified ICK stage, Grease, Ike.
   Refuse record separators and any preexisting output, including a broken link.
   The native compiler's existing ASCII build-root restriction remains in force.
2. Run the immutable 8.grease `run` mode twice with separate fresh output roots.
   Each build must execute through its existing digest-bound Ike protocol, all
   46 oracle cases, native mutation, missing-library refusal and clean recovery.
   Any producer failure stops the recipe and leaves its original output intact.
3. Record input source revisions and the actual recipe/runtime/compiler hashes.
   Verify the bundle's existing `payload.sha256` and ICK host-runtime manifest
   before and after the pair. Hash source trees before the pair and verify them
   afterward. Source identities must not drift between builds.
4. Require nonempty launcher, generated Scheme, compiled Chez program and native
   shared library in both outputs. Compare their bytes without rewriting,
   stripping, timestamp changes, archive rebuilding or other normalization.
5. Produce a component TSV containing both SHA-256 values and PASS/FAIL, retaining
   all comparison diagnostics. Any difference exits 4 after reporting every
   component; all four must match before a reproducibility PASS can be written.
6. Neither same-byte inputs nor same semantic output may conceal different
   compiled bytes. A compiled-program-only mutation must fail even when the
   launcher/Scheme/library still match. A missing/empty component also fails.
7. Keep generated-program execution and consumer byte reproducibility separate
   from compiler bootstrap reproducibility, desktop GUI/network/recovery,
   Android runtime and physical-device evidence.

Validation plan: run through the verified native Grease entrypoint with the
actual provisioned dependencies. A known nondeterministic compiler is an
expected FAIL control, not grounds to weaken comparison. Also exercise refusal
of an existing output root and inspect that it is unchanged.
