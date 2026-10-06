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
`transfer-REPOSITORY-from-SOURCE-to-DESTINATION.sh` in the chosen scratch directory
and refuses to overwrite an existing file. There is no output-path override.

The generated Grease artifact contains all task parameters and candidate 7's
body. It has no dependency on a Kitchen checkout, numbered helper, hidden cwd,
parent variable or live token supplied by the generator. It requires a qualified
Grease interpreter and an authenticated `gh` installation when a human later
chooses to use it. That separate live action is outside FP2's operation.

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

Candidates 1–6 and their failure notes are retained. Candidate 1 and the
`generate-transfer-github-repository-script-legacy-1.sh` producer are historical
POSIX debt, not a qualification for transfer orchestration. The temporary-source-
test POSIX exception remains confined to `tasks/source-handoff/1.sh`.

The recognition rule for “GH API move script” still selects this descriptive
producer. Never replace repository ownership transfer with a file-tree copier or
Contents API recreation; never serve a numbered candidate as the normal handoff.
