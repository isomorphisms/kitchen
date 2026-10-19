# IB desktop foundation checking recipe

Owner: SUN IB-X64-00/01/08, IB issues 138/139/146.
Target observed here: disposable Ubuntu 24.04 Linux x86-64 build container.

Inputs are explicit absolute IB, AI-CI and pinned compiler-bundle roots and an
output directory. Cat Food supplies the compiler and native Grease identities.
Ike must run its source-file recipe protocol with the actual Grease entrypoint.
No source acquisition, package installation, source bootstrap or device operation
is hidden in this checking recipe.

## Observable requirements, before candidate implementation

1. Snapshot actual shared IB modules and the independent AI-CI oracle into an
   isolated source directory. Preserve canonical source bytes and keep the oracle
   owned by AI-CI. Record their SHA-256s and source revisions.
2. Check source with the declared compiler; execute the compiler evaluator in a
   separately identified stage. Producer failure must stop before reading results.
3. Expect True only for the clean 38-case oracle, with each named result retained.
4. Mutate actual production source in separate snapshots: disposable ordinary tab,
   one-unit non-BMP UTF-16 width, and bypassed source-revision binding. Each must
   typecheck and evaluate False with the intended named cases false.
5. Rechecking the clean snapshot must restore True. Original worktrees must be
   byte-identical afterward.
6. ACI owns expected corpus and named pass/fail conditions. Do not accept a
   success constant, build existence, stale TTC, or a failed producer.
7. Working directory is arbitrary. Arguments with whitespace must stay intact;
   relative paths and record separators must be refused.
8. Type/evaluator, native executable, graphical, network and Android physical
   results are distinct. Checking does not manufacture desktop parity.
9. A native stage is conditional on the qualified compiler/native dependency
   tuple; a missing native prerequisite must produce a blocked result.

The numbered 1.grease candidate is maintained Grease source. The recipe run
produces an inspectable Ikefile and an Ike receipt bound to that file's hash.

## Native executable extension, before attempt 3

Use a qualified ICK stage root, not a generic system compiler. Verify its target
and existing positive qualification binaries, record the compiler, startup/runtime
hashes, and compile the actual stateless IB C boundary. Reject the same source
when __ANDROID__ is defined. Snapshot the actual Idriç platform module and AI-CI
native oracle, then generate a Chez executable with the maintained Idriç bundle.
Retain the generated source/program, C library, ABI inspection and dependency
results. Run all 38 shared cases plus the eight independent native cases.

Mutate the actual C byte-count return in a separate library; the same generated
program must exit nonzero with native-empty-bytes=False. Withhold its copied
library and require execution to fail. Restore the original library and require
the original 46 cases to pass again. Inputs must remain unchanged. Report this
as Linux generated-program/native-FFI execution, not an ELF-only application,
graphical desktop, network, durable disk restoration or Android acceptance.

The selected compiler's non-ASCII build-path failure is explicitly refused
before effects; unrestricted build roots are blocked by Idriç issue 138. The
compiled program must separately relocate/launch under a Unicode/apostrophe
path. Every imported IB module is hashed, not only directly edited modules.
