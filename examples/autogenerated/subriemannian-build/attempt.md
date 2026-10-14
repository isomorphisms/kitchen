# Compile and exercise sub-Riemannian geometry

Target: observed Linux x86-64 build host. The user explicitly requests the
existing Idriç compiler/runtime, through Flexible Pipes and Kitchen. This
producer is itself Idriç. It selects Chez explicitly, retains actual compiled
artifacts, and never invokes RefC or a C application compiler.

Type sketch: absolute project/compiler/AICI/build roots → reproducible compiled
geometry, test, figure and acceptance programs; command argument list → captured
output and observed process status; source/artifact identity → TSV receipt.
The pure math remains owned by subriemannian. Kitchen owns preparation and
compilation. AICI owns its separately compiled executable oracle.

Requirements established before implementing Build.idric:

- Reject nonabsolute roots, dirty tracked source, missing compiler/runtime,
  and an existing artifact directory rather than mixing old results into a run.
- Compile the exact named .idric files through the observed compiler and Chez.
- Reject a nonzero compiler/test/generator exit; never consume leftover products.
- Exercise the real compiled mathematical tests and figure generator.
- Compare the regenerated HTML and sample TSV with the checked-in figure.
- Record full source commits and hashes of compiler, runtime and all compiled
  artifacts. No source-text-only result may become runtime acceptance.
- Supply the actual compiled producer digest to AICI through a receipt file;
  Flexible Pipes executes AICI as a separate stage after this producer.

Process launch uses the inherited escaped argument-list interface. Its internal
POSIX process boundary is not an authored shell program or a substitute Grease
implementation. File reads/process waits are deliberately covering, while the
mathematical programs retain total pure functions.

Acceptance: exercise a fresh artifact directory; rerun with that same directory
must reject; run from an unrelated directory; nonzero compiler and digest
mismatch must reject. Exact results are retained in the producer/FP receipts.
