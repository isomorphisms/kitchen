# H1: producer-to-human source handoff

This extends the existing pre-Grease source diagnostic boundary. The interpreter
is explicitly POSIX sh, including its IB consumer; this is not Grease execution.
It supports only reviewed, temporary-file-only POSIX test tasks. Other mutation
classes and runtimes must remain blocked until an appropriate adapter is reviewed.

Before emitting a command, establish a reviewed contract's digest, repository,
exact source, exact file blobs, entrypoint, execution context, requested scope,
excluded claims, mutation class, rerun policy, and exact success marker. Reject
unknown fields, duplicate fields, unsafe paths, and missing/ambiguous identities.
Do not accept arbitrary shell snippets. Emit only a child-shell invocation,
guarded against the caller's errexit, with safely quoted absolute paths.

Separate producer refresh from consumer execution. Explicit producer refresh
fetches the full commit from the contract repository into a fresh private Git
object store, without borrowing local objects or changing the human checkout.
Failure means unavailable through that transport, not globally nonexistent.
Before emission compare the fresh remote source with the selected checkout and
verify and parse every required file. Consumer execution repeats local checks
without network access; an emission receipt is not execution acceptance.

Reject scope substitution independently of source availability: the IB baseline
contract may never satisfy E2. Contract review remains semantic: a source test
that merely prints a marker cannot establish implementation correctness. The
gate proves the reviewed selection ran, not that its oracle is adequate.

Git reads must ignore inherited GIT_* variables, global/system config and
replacement objects, and inspect the checkout's literal local origin without URL
rewrites or includes. Verify the checkout root, including linked worktrees.
Never reset, switch, clean, clone into an existing directory, register, provision,
or mutate source/user files. Keep Cat Food as the sole checkout inventory.

Test the generated command twice from outside Git, positive and failure paths,
including parent errexit survival. Verify dirty bytes, untracked files, HEAD and
pre-existing partial directories survive. Mutants must fail before emission for
wrong repository, unavailable source, other-branch-only test, blob mismatch,
syntax failure and wrong scope. Zero status without marker and marker with
nonzero status must fail after execution. Also exercise env config injection,
replacement objects, stale checkouts, permitted refresh and runtime failure.

No phone execution, E2 implementation acceptance, or follower acceptance can be
inferred from these host fixtures.
