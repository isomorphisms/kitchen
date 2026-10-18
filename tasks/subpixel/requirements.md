# Subpixel host qualification

Target: disposable x86_64 Linux GitHub-hosted Ubuntu, running pinned native Grease.
This is the Kitchen execution recipe for Flexible Pipes' `subpixel-acceptance`.

1. Resolve every input from one explicit, canonical FP checkout. Require clean,
   exact producer, ai-ci, ICK, GCC-reference and Ike revisions before any build.
   FP checks this recipe and the Grease binary against its material digests before
   executing it. No caller-selected script, compiler or command is accepted.
2. Begin with fresh evidence and build directories; never adopt previous outputs.
3. Build ICK using its declared host stage-zero compiler/Make exception. Compile
   Ike and all consumer/oracle C through ICK. The host driver only links objects.
4. Execute the producer's actual `preview` target through Ike, then ai-ci's
   independently authored rational oracle and four real source mutants through
   its separate `accept` target. Require the exact ai-ci receipt checker.
5. Reject forged final and selected-target receipts. Keep failure logs and
   return nonzero; later FP stages must not execute after a failure.
6. Seal hashes only after both executions and receipt negatives pass. The result
   qualifies this pinned HOST baseline. It does not implement whole-curve work,
   authorize merge, establish trusted production admission, or qualify Android.

The registered materials live at `_subpixel/{producer,aici,ick,ike,kitchen}`
inside the explicit FP checkout; runtime is the native `_subpixel/ysh` binary
used by the maintained Grease handoff action. Version 2 is current. This layout is
owned scratch for this operation, not a user-wide checkout registry. Paths with
spaces are refused because the independently pinned ai-ci recipe uses flag lists.

Tests: absent/malformed FP parameters and corrupt material digests must fail
before a marker executable runs; wrong source revision must fail before evidence
creation. A fresh hosted run must exercise the positive build/oracle path.
