# Attempt 10 — current delivered native ICK

November 15, 2026. Owner: SUN IB-X64-01. Requirements are in
`10-requirements.md`; attempts 8 and 9 remain unchanged.

The actual current native producer builds and delivers its own libgcc/libatomic.
It does not contain attempt 8's older borrowed-runtime manifests or prebuilt
glyph executables. This candidate consumes its original archive and producer
receipts, bound to caller-owned source/archive/receipt hashes, then compiles and
executes the maintained independent AI-CI glyph probe on the actual consuming
host. It does not manufacture the old stage layout or treat a producer's Ubuntu
receipt as a Debian result.

The independent probe is the exact source from AI-CI
`903b2cb27ea572c9c6cb2ffa9f39e0fbf06ec9f8`, blob
`4dc4d0ff50fcb691768aef7034016143ee956764`, SHA-256
`019c7b6074b012f41c98af3afb92c1ef179b8fbfca03bf3089c20352a9caf470`.
The wrong-division control must compile and actually exit 2. A preprocessor
division control must fail the intended compiler diagnostic without an object.
The subsequent 46-case native program, library mutation/loss/recovery and
Unicode relocation checks retain attempt 8's semantic path.

Observed preliminary validation under the exact partial C++-free native Grease
runtime SHA-256
`5991182c9540a8bba58c12bf15965db033b6bcbb59b30f85a8c44000b697382c`:

- Native parse: exit 0.
- Missing arguments: exit 2 with the required-arguments diagnostic.
- Relative path: exit 2 before writes.
- Existing output root: exit 2; marker hash
  `b6a84bd0a26bd1078f0a2bf187cb85c5a6c95f08dd26f7f77965a2583eea83a9`
  unchanged.
- Broken output symlink: exit 2; link retained, target not created.

The Grease positional form `${10}` was directly verified; `$10` is rejected by
this runtime. The candidate uses the verified form for its two final explicit
receipt-identity arguments. It also captures a failed command's actual status
through the verified `var rejected_status = $?` form.

Full delivered-compiler/native execution is NOT_RUN at this checkpoint, pending
the actual producer package and independently held archive/receipt identities.
No compiled-byte reproducibility, GUI/network/disk recovery, Android runtime or
physical acceptance follows from preliminary validation. No fallback was used.
