# Producer-to-human source handoff, version 1

Read requirements.md first. The shared gate replaces IB-specific selection logic
for new handoffs; old numbered runners remain historical. Its bounded interface
supports reviewed temporary-file-only POSIX source tests before Grease exists.
It is not a general command evaluator, execution sandbox, installer, or proof
that a test's oracle measures the requested feature.

The producer supplies `emit`, an absolute contract path, its reviewed Git blob,
an explicitly chosen verified checkout, and the independently requested scope.
The gate fetches the exact source from the contract repository into fresh scratch,
verifies local origin/root and required committed files, extracts and syntax-checks
them, then emits a receipt followed by a single conditional child-shell command.
It emits no command on failure. No local objects can satisfy the fresh-fetch check.

Obtain the engine and contract from a verified immutable Kitchen revision; derive
their blob identities from that revision. Do not compute a digest from arbitrary
job prose and call it reviewed. The host audit receipt records the release pins.
The interface parameters are data, never shell code. Unknown manifest fields are
rejected, including `command`. Required files must be regular Git blobs, not
symlinks or gitlinks. This adapter syntax-checks all listed files as POSIX source.

The emitted command binds the engine and contract bytes and repeats local source,
origin, file and syntax checks. `run` never fetches. It executes extracted committed
bytes in scratch, requires exit zero AND the exact marker, and reports scope and
excluded claims separately. The outer conditional intentionally keeps the human
session alive even under errexit; therefore its shell exit alone is not acceptance.
Read `acceptance=PASS`, the exact scope and `handoff-command=PASS` together.

The receipt records the observed host and UID, which are observations, not device
authentication. An emitted command is valid only for the selected target checkout
and absolute runner/contract paths. Never copy a container path to the phone.
For a remote human target whose state cannot be verified, stop at lookup/probe;
do not serve a runnable target test based on host fixture results.

Repository identity is the literal local origin normalized for GitHub SSH/HTTPS
and case, plus an independent fetch from the contract's repository. Inherited
Git variables and system/global Git configuration cannot redirect it. Only network
proxy variables are carried into the isolated transport. Private repositories
requiring excluded credential helpers remain blocked until a reviewed acquisition
path is available. No credential installation is hidden inside preparation.

Checkout discovery remains Cat Food's responsibility. Empty inventory means no
verified declared candidate. Multiple candidates require explicit selection.
An unavailable local commit is a different result from a failed producer fetch.
A producer may explicitly refresh a verified checkout separately, but this gate
does not silently fetch it. A transport failure never proves global nonexistence.

Reusable job rules:

1. Require a producer receipt with retrievable repository/source and reviewed
   contract/runner identities before making a dependent job executable.
2. Select an explicit target and checkout from Cat Food or direct verification;
   establish exact committed file identities before selecting tests.
3. Pass the independently requested acceptance scope to the gate. A passing
   baseline cannot satisfy a repair, packaging cannot satisfy behavior, and host
   evidence cannot satisfy a phone or another follower.
4. Serve only the generated command after its positive and rejecting mutants
   run twice from outside Git. Preserve its conditional child boundary.
5. Record execution, historical human reports, implementation acceptance and
   follower acceptance separately. A missing receipt stays missing.

Regression: `tests/source-handoff.sh` uses real disposable Git publishers and
checkouts, without a fake Git program. All identities vary per run. The deliberate
success-printing fixture tests wrapper selection only, never IB semantics. The
separate audit also executes IB's real pinned baseline twice.
