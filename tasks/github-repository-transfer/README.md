# GitHub repository transfer script generation

Owners: Kitchen #15/#24, AICI #205 and Cat Food #107. The FP registered operation
generates a script and tests its exact bytes against disposable API fixtures. It
does not transfer a live repository. The qualified runtime target is
`linux-x86_64-grease-v1`; availability on Termux or another machine requires its
own runtime qualification.

The maintained descriptive generator is
`generate-transfer-github-repository-script.sh`. Its six data arguments are
source owner, repository, destination owner, expected authenticated login,
positive numeric repository ID and the qualified context above. It derives
both `transfer-REPOSITORY-from-SOURCE-to-DESTINATION.sh` and
`transfer-REPOSITORY-from-SOURCE-to-DESTINATION.paste.grease` in the chosen scratch
directory and refuses to overwrite an existing file. There is no output-path
override. The optional leading `--paste` selects only the compact presentation.

The generated complete Grease artifact contains all task parameters and candidate 10's
body. It has no dependency on a Kitchen checkout, numbered helper, hidden cwd,
parent variable or live token supplied by the generator. It requires a qualified
Grease interpreter and an authenticated `gh` installation when a human later
chooses to use it. That separate live action is outside FP2's operation.

The compact presentation visibly invokes the descriptive ownership-transfer
program with named parameters. It acquires only the immutable Kitchen program at
`322b4ff634ee745748b209f19e63c472d01e0ae9` and checks SHA-256
`cf85b1dc4caea07749d5070bbc143d669e687820598c36a0050fddccb2612dc6`
before execution, including cached bytes. Its durable program and pending ledger
live under the user's home `.local/state/kitchen/github-transfers`, so changing
the working directory cannot cause a blind resend. Changing homes changes that
durable input state. Curl and coreutils are explicit additional prerequisites.

The compact unit protects the parent session after child failure and emits an
explicit unverified outcome. `KITCHEN_TRANSFER_CHILD_EXIT` records the actual
inner program status; wrapper completion alone is not transfer success. Both the
inner verified markers and independent API observations are required for a
verified transfer. Generation sends no transfer request and cannot grant later
live-execution authorization. See `compact-handoff-requirements.md`.
Its outer conditional is supported by Grease and Bash terminal parents; all
acquisition and transfer implementation runs through the explicit qualified
Grease command. A caller does not need to switch its parent shell first.

The body checks the expected login, canonical numeric repository identity,
canonical source name, administrator capability and unchanged visibility. It
distinguishes personal destinations from organizations; membership is checked
only for an organization. A destination collision is rejected. Every attempted
transfer POST is followed by a numeric-identity observation even when the POST
fails. An accepted request with no verified move fails explicitly. A rerun first
reconciles numeric identity and does not resend a transfer already observed at
the destination.

A durable intent ledger is written beside the artifact before POST. If a rerun
still observes the source, it blocks without resending; an observed move must
retain the original visibility. Destination absence requires CLI exit 1 and an
included HTTP 404 response. Authentication exit 4 and HTTP 403 block. The checked
interface test exercises the installed GitHub CLI against disposable HTTP
responses with no live credentials.

`tests/qualify-transfer-artifact.pi` runs actual generation twice, compares the
bytes, then executes that artifact in unrelated fresh homes and directories with
spaces and quotes. `tests/transfer-parent.grease` proves the parent shell survives
successful and failing children. Disposable API observations are checked by
AICI's maintained `validators/kitchen-transfer-script.pi`. The local diagnostic
is explicitly narrower than FP's hosted worker-isolation acceptance.

The local diagnostic accepts an optional final input-file argument with the same
six data fields. It uses the maintained generator and tests the resulting exact
parameterized bytes. Omitting that file retains the synthetic sample control.
Its receipt records inputs and generator/candidate/launcher hashes; the launcher
hash alone is not complete runtime qualification. This diagnostic never executes
a real transfer, promotes an operation, or establishes phone compatibility.

Pass `paste` after the optional input file to exercise the exact compact bytes
inside fresh Grease sessions, or `paste bash` for fresh Bash parents. Those modes
require the checked launcher at the
qualified `/opt/catfood/bin/grease` path, checks parent cwd/home/token state,
retain each child's independent API event range, and reject partial/unavailable
acquisition, changed source/cache bytes, missing curl and a symbolic state path.
The fixture acquisition record is diagnostic only; it does not grant acceptance.
The API corpus retains the thirteen original scenarios and adds wrong login,
source, repository, destination and inactive organization membership: eighteen
scenarios per presentation and parent context.
The maintained CI runs both presentations without path filters. Its scope is
human-handoff fixture behavior, separate from FP's root supervisor acceptance.

Candidates 1–9 and their failure notes are retained. Candidate 1 and the
`generate-transfer-github-repository-script-legacy-1.sh` producer are historical
POSIX debt, not a qualification for transfer orchestration. The temporary-source-
test POSIX exception remains confined to `tasks/source-handoff/1.sh`.

The recognition rule for “GH API move script” still selects this descriptive
producer. Never replace repository ownership transfer with a file-tree copier or
Contents API recreation; never serve a numbered candidate as the normal handoff.
