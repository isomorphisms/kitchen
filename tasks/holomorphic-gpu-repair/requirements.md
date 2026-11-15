# Holomorphic GPU repair preparation

Target: the current disposable Linux x86_64 host. This task does not execute on
Android devices and does not deliver an APK. Cat Food owns eventual delivery.
Origin: https://github.com/isomorphisms/flexible-pipes/issues/227.

Requirements recorded before implementation on 2026-10-19:

1. Execute the existing retained mathematical reference and independent AICI
   checker qualification through Flexible Pipes → Kitchen/Grease → Ike.
2. Bind each source root to an exact Git commit, the Kitchen candidate/Ikefile
   to SHA-256, and each executable to its SHA-256. Refuse relative roots,
   ambiguous/duplicate source or tool roles, stale output and changed materials.
3. Grease is the recipe interpreter. Ike must record external-source-file mode;
   its default POSIX `system()` recipe path is forbidden for this task.
4. A zero exit code with missing numerical output is a failure. AICI selftest
   qualifies the checker only. It cannot count as producer-field or GPU PASS.
5. Run the retained reference and independent checker before an unavailable
   compiler prevents later stages. Never substitute GCC/Clang for missing ICK,
   a handwritten fragment for missing checked generation, or a fixture readback
   for actual producer/emulator/device output.
6. Compile the native E1 sampler with ICK only; identify its binary64 host result
   separately from actual generated GLSL execution. Preserve the live z/3 field.
7. Leave compiler, APK, emulator, A1, C67, TAB_P10 and sustained performance as
   NOT_RUN unless each corresponding real stage completes and independently
   accepts its actual output. Missing stages must stop with a concrete blocker.
8. A rerun uses a new context/output directory. Preflight refuses an existing
   output directory rather than reusing a stale successful receipt.
9. Inputs are a per-run handoff, not a checkout registry. The caller resolves
   absolute source/tool paths from observed facts or Cat Food before preparing it.

The three handoff files are `sources.tsv` (role, absolute checkout, commit),
`tools.tsv` (role, absolute executable, SHA-256), and `materials.sha256`
(sha256sum format with absolute files). They must include the recipe, Ikefile,
source/tool handoff files, and tested input sources. A fresh `output/` is owned
by this run. No input file is evaluated as shell code.
