# Delivered native ICK consumer — requirements before attempt 10

Owner: SUN IB-X64-01, https://github.com/isomorphisms/ib/issues/139.
Attempt 8 remains immutable. It consumed an older stage with borrowed host
runtime manifests and prebuilt glyph probes. The current delivered native
compiler instead owns its target libgcc/libatomic and supplies producer receipts
beside its stage. Do not manufacture the old stage layout or reuse old passes.

1. Accept eleven explicit arguments: mode (`run` or `native`), absolute IB and
   independent AI-CI checkouts, original compiler-bundle root, new output root,
   acquired material root, caller-owned expected ICK source commit and archive
   SHA-256, the absolute independent assignment-arrow C probe, and caller-owned
   SHA-256 identities for the compiler and own-runtime receipt files.
2. The material root contains the producer-relative `build/native-polar/` tree:
   `stage/`, `native-stage.tar.gz`, `native-stage.sha256`, `source.txt`,
   `compiler.sha256`, `ick-runtime.sha256`, and
   `scalar-runtime-packages.tsv`. Match the exact expected source and tar digest,
   match the caller's independently held receipt-file hashes, then check unchanged
   compiler and own-runtime receipts in that root. Rewriting a receipt cannot
   self-certify changed extracted compiler/runtime bytes.
   Source/archive expectations must come from independently resolved producer
   workflow and download evidence, not from values copied out by this recipe.
3. Pin the independent AI-CI glyph source to commit
   `903b2cb27ea572c9c6cb2ffa9f39e0fbf06ec9f8`, Git blob
   `4dc4d0ff50fcb691768aef7034016143ee956764`, SHA-256
   `019c7b6074b012f41c98af3afb92c1ef179b8fbfca03bf3089c20352a9caf470`.
   Compile and execute it at O0/O2 with the delivered native compiler. Compile
   its maintained wrong-division mutation and require actual exit 2. Reject
   division in preprocessing and require the intended compiler diagnostic and
   absent output object. Do not substitute an Android compiler or generic C.
4. Keep the package unchanged. Write consumer qualification binaries, source
   snapshots and all receipts under the new output only. Record actual current
   host/OS/libc/compiler dependencies separately from producer Ubuntu evidence.
5. Execute the real native IB C boundary and unchanged independent 46-case
   generated Idriç/Chez oracle, Android-target refusal, byte-count library mutant,
   missing-library refusal, restoration, and Unicode-path relocation from
   attempt 8. Preserve producer exits and source hashes.
6. `run` mode must invoke the same native work through the existing digest-bound
   Ike source-file protocol and explicit native Grease path. Neither mode may
   provision, download or build a compiler/runtime. Its fresh output root holds
   the Ikefile and a separately fresh `consumer/` child for native results.
7. Refuse a reused output before writes. A missing or mismatched source, archive,
   compiler, runtime, probe or dependency must fail rather than downgrade.
8. Report native generated-program/FFI execution independently from compiled
   byte reproducibility, desktop GUI/network/disk recovery, Android and physical
   evidence. A single passing build never establishes repeat-build equality.

Validation: native Grease parsing and refusal controls first; then actual
delivered-material positive qualification and known-bad division/native-library
controls. The actual native artifact is still being built at writing time;
neither source presence nor a runtime version string is execution acceptance.
