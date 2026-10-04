# October 4 IB handoff: source contract before command

Incident facts 1–9 come from the user's supplied account and the preserved
October 4 incident, not a newly observed phone run. H1 independently refreshed
the named GitHub heads, fetched IB branches, inspected committed blobs, executed
the baseline on the host and attacked the actual Kitchen/Cat Food entrypoints.

| Layer | Failure and earliest preventable point | Owner / existing mechanism / repair |
| --- | --- | --- |
| Job specification | E2-A made a chat-only repair SHA an executable prerequisite. Reject when the producer cannot materialize it, before assigning the dependent test. | Job producer; Kitchen's preparation rules lacked an executable emission gate. Require producer fetch and reviewed contract. |
| Producer provenance | A remembered commit name stood in for published source. Reject before handing the downstream job its prerequisite. | Producer publishes source/artifact; fresh isolated fetch now rejects unpublished local and foreign commits. |
| Artifact/source materialization | No successful retrieval established the repair. An old available baseline could not repair that absence. | Producer owns retrieval; consumer must remain blocked for E2. |
| Checkout discovery | Narrow path search became global absence. Reject that conclusion when the search scope is known. | Cat Food already owns bounded inventory; empty results now explicitly mean no verified declared candidate. |
| Execution context | Git outside a repository was classified as a missing commit. Reject before invoking a source-object query. | Kitchen verifies explicit root and literal origin before checking source. |
| Shell safety | Pasted top-level exit terminated the parent. Reject at command preparation. | Kitchen version 2's subshell protects ordinary sourcing; new emitted conditional child also protects an errexit parent. |
| Repeatability | Existing ib-e2-check caused a second clone to fail. Classify/reuse before clone or any recovery action. | Cat Food owns locations; gate never clones into consumer paths or deletes partial state. |
| Test selection | Remembered pathname was assumed available at the requested source. Reject before emitting a test command. | Implementation owns tests; Kitchen binds regular committed files and blobs, including paths absent on selected branch. |
| Acceptance semantics | Old passing test risked being called E2 acceptance. Reject at independent scope comparison, before source execution. | IB defines implementation acceptance; Kitchen cannot upgrade it. Baseline contract explicitly excludes E2. |
| Evidence propagation | Host fixtures, phone-reported history and new phone acceptance could blur. Reject at receipt construction. | Each receipt carries its evidence class, source and target; no new physical evidence produced. |
| Follower/target reconciliation | Cat Food source had no exact leader/job records. Reject promotion at reconcile, even when dedicated tests are green. | Existing ai-ci/Cat Food check correctly failed; declare real pending jobs, then record only actual matching acceptance. |

The systemic defect was enforcement placement. Kitchen already required context,
requirements, negative fixtures and postconditions; Cat Food already provided a
verified registry. The assistant bypassed preparation, and the first repair
mainly guarded execution after service. The reusable producer gate now stops
unsupported or unmaterialized handoffs before service. Instructions alone cannot
prevent an agent from bypassing the gate; job authors must use the executable
interface, and unsupported mutation/runtime adapters remain blocked.

## Findings against the initial repair

Kitchen's 22 original cases all passed. They test a useful consumer wrapper, but
the local fixture sets an IB origin string without proving that IB published its
commit. GIT_CONFIG_COUNT was also still active. The new publisher fixtures fetch
real disposable remotes; a locally valid unpublished or foreign commit is refused.
The scope input is independent of the baseline contract. Test output is prefixed
so a failing child cannot forge gate receipt fields.

Cat Food's 9 original cases all passed. Adding a GIT_DIR mutant to that unchanged
entrypoint produced `mutant escaped: inherited GIT_DIR authenticated the wrong
checkout`. The repaired entrypoint rejects it, environment-config forgery and a
partial checkout borrowing another repository. Linked worktrees remain usable.
Its old dedicated help test missed the broader entrypoint test's required
repository line; restoring that line repairs the actual help contract.

Both dedicated workflows used a moving checkout action despite the shared exact
action rule. They now pin the already-used reviewed checkout action identity.
Cat Food's x86 follower action now includes its handoff regression.

## Discovery states

| Observation | Permitted conclusion |
| --- | --- |
| One path search missed | Not found by that search; elsewhere unknown |
| Empty Cat Food result | No verified declared candidate; elsewhere unknown |
| Path absent | Supplied path missing; source unknown |
| Directory/partial .git invalid | Not a readable checkout root; preserve contents |
| Wrong/multiple origins | Repository identity rejected |
| Source missing locally | Unavailable in that checkout; no consumer fetch performed |
| Producer transport failure | Could not materialize through stated transport; global existence unknown |
| Successful intended-remote refresh but no object | Object unavailable through that observed remote state; no global claim |
| File absent at source | Test unavailable at that source, not test failure |
| Syntax/runtime/postcondition failure | Preserve the specific stage; no acceptance |
| Test exit zero and marker present | Only the contract's reviewed scope passed |
| Requested feature excluded | Feature remains NOT_RUN even if baseline passed |

## Migration inventory

This is a bounded inspection, not an account-wide job census. The job rows below
refer to prompts supplied with H1; their live downstream completion was not audited.

| Existing consumer | Required migration |
| --- | --- |
| Kitchen IB baseline version 2 | Preserve as history; use source-handoff plus handoff.tsv for new service. |
| Cat Food help ib | Pin shared gate and contract; preserve old phone report independently. |
| Moon E2-A | Block absent 5184f62…; require producer source/artifact receipt before execution. Never relabel baseline. |
| Moon E2-B | Materialize all three exact inputs and verify ancestry/files; unnamed E1/E4 heads are not runnable prerequisites. |
| Earth E3 | Local WIP hash needs a materializable location or an explicitly reconstructed new source receipt. Keep E1/E2 dependencies blocked until verified. |
| Earth E4 | Require actual E2/E3/E1 receipts; a retained-control narrative is not execution evidence. |
| Earth A2 / A3-E | Existing receipt prerequisite is the right direction; use an executable producer check instead of delegating availability discovery to the dependent job. |
| Kitchen preflight/terminal.md | Previously applied only to mutation; source tests now require the gate too. |
| Kitchen Lua install / repository-transfer / movie / SDF refile tasks | Do not pass through this temporary-only test adapter. Each needs its own reviewed mutation/runtime contract before future service. This audit did not requalify those adapters. |
| Cat Food README bootstrap paste blocks | Fixed clone destinations and implicit cd assumptions need a separately reviewed restart-safe provisioning adapter. Not served or executed as human instructions by H1. |

## Executed rejecting mutants

`tests/source-handoff.sh` contains 27 cases and saves distinct diagnostics for
unavailable source, unpublished source, foreign SHA, other-source-only test,
wrong origin/blob, moving ref, shell-snippet field, changed runner/contract,
syntax failure, runtime failure and false green. Its positive controls cover
fresh fetch, explicit consumer refresh, linked worktree, spaces/quotes, dirty
work preservation and exact-command rerun. The failure command runs twice in an
errexit parent, which prints parent-alive afterward. Historical 22-case Kitchen
and expanded 14-case Cat Food results are separate wrapper evidence.

The original raw `sh tests/...` has no supported producer contract and is not an
emittable command. The baseline contract requested as E2 fails `stage=scope`.
A repair contract naming an unavailable commit fails `stage=remote-source`.
The verified baseline remains intentionally runnable as ordinary-file-baseline.

No general wrapper can prove an arbitrary test's oracle or mutation declaration
truthful. Those are implementation-review obligations. New target/runtime or
mutation classes cannot be made accepted by changing a scope string.
