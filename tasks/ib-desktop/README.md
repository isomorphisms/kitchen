# IB Linux first-wave recipes

Current source checker: 7.grease. Current generated-program/native checker:
8.grease. FP entrypoint: pipeline.grease. Explicit pinned native ICK producer:
ick-4.grease. Requirements predate implementation; earlier numbered candidates
and their actual failures remain preserved.

Inputs are absolute paths and identities resolved for the exact build target.
Source checking accepts spaces/apostrophes/Unicode. Native generation explicitly
requires an ASCII build root because of Idriç issue 138, while actual program
text/FFI and Unicode-path relocation are qualified separately. Reused snapshots
and Ikefiles are refused before writing records. The native recipe uses qualified
ICK for the C stage and explicitly maintained Idriç/Chez for generation.

Ike runs actual native Grease source-file recipes, bound to their Ikefile digest.
Every producer runs directly with failure propagation; plausible output followed
by exit 7 is refused. Clean and three production semantic mutants, native C
mutation, missing-library failure and clean restoration have executed controls.

The current Linux source/native checks passed. Fresh-host compiler/support
qualification, byte-reproducible compiled Chez output, GUI/network/durable disk
recovery and Android followers remain open. Grease's current diagnostic artifact
uses ASAN_OPTIONS=detect_leaks=0 for the restricted build container; this is not
a complete native Grease producer/release qualification. No provisioning,
download, source build or device operation is hidden in checking recipes.
