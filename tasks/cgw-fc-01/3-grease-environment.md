# Version 3: use the actual Grease environment interface

The first qualified attempt, FP run 39082823061 at FP source
`498ca0f08d362fda0d516776ddfe4d39747d9161`, completed its pinned Grease and
ICK producers and compiled actual Ike. The Kitchen stage then failed before
Ike execution: Grease rejected `export` at version 1 line 39 and explicitly
required `setglobal ENV.FOO = ...`. The raw stage stderr SHA-256 is
`552fb00927e84e2dc9d4eef29bcd9045da29e3414c7d3c0b6ae085faa48bb8cb`;
the downloaded original receipt ZIP matches the platform digest
`1a74bdd8798ddcab149fdcf3c3bf57753e7fbe3185dfc805c491651582e4d890`.
Version 2 had not executed: its source preflight stopped earlier in the
unchanged Grease producer. Its inherited `export` form was still wrong.

Version 3 keeps both earlier candidates. It sets `ENV` fields explicitly,
reads those fields in Ike recipes, and uses the external `env` interface for
Ike's per-invocation receipt/runner settings. No Bash replacement is used.

Local syntax and environment tests used the actual native runtime from the
already recorded source-manifest diagnostics artifact 11727693085. The ZIP
digest is `20c526c8bae5dc32a7b3d01a39eca5bdb7ee4c63fe540f34a07af7ba8b0d0039`;
the extracted binary is exactly
`7e31cd05b7a9d8fb2a4a9e003a7f3fcb0159138506d17f0fb28da8cbe22aa85c` and
reports implementation source `5651cf97a1b5042f24f14112a7ade9a1518eb0bc`.
Actual Grease parsed the driver and all extracted Ike recipe lines. The
environment fixture executed real child Grease processes and proved ENV
inheritance, temporary child bindings and stop-on-failed-precondition behavior.

These are local Grease syntax/fixture results. They are not current producer
qualification, ICK execution, an Ike receipt or platform delivery. The registered
workflow must still build the unchanged source-pinned producer; it must not
download this historical artifact as a fallback. Producer cpp-spec failures
remain FAIL and their diagnostic files must be retained.
