# Agent instructions

Kitchen is the preparation area for human-facing terminal commands and scripts.

Before serving runnable commands for a real machine, prepare them here against the
best available knowledge of the target system and the user's conventions.

## Mandatory flow

1. **Identify the target context.** Name the exact machine and execution context:
   Termux, `adb shell`, Shizuku/rish, root, SDF, GitHub runner, or another host.
2. **Load known facts.** Read the applicable files under `systems/`, `user/`,
   and `shells/`. Treat dated observations as observations, not eternal truths.
3. **Resolve unknowns with read-only probes.** Never replace an unknown path,
   permission, shell feature, package, mount, or executable with a generic Unix
   guess.
4. **Build or select fixtures.** Reproduce the relevant filesystem/input/process
   state under `fixtures/` when practical.
5. **Test before serving.** Exercise the successful case and relevant failure,
   rerun, quoting, path, and permission cases under `tests/`.
6. **Preflight the exact command.** Check sources, destinations, current-directory
   independence, shell syntax, privilege boundary, and destructive effects.
7. **Serve the smallest mutation.** Prefer one state change followed by a
   verification over a large blind block.
8. **Verify the postcondition.** A zero exit status is not sufficient evidence
   when the intended state can be checked directly.

If a required assumption cannot be established, serve a read-only probe instead
of a guessed mutation.

## Source-of-truth boundaries

- Cat Food is the source for durable device identity, Android delivery, and
  observed device/storage facts. Kitchen may mirror those facts with provenance
  so they are available while preparing commands, but must not silently promote
  a dated observation into a universal fact.
- AICI owns reusable evidence/acceptance guardrails and failure-mode enforcement.
- Kitchen owns preparation: translating those facts and guardrails into tested,
  target-specific commands before they are shown to the human.

## Conventions

- Do not assume generic Unix filesystem layout.
- Do not assume POSIX `sh` semantics when the selected shell is Grease/YSH.
- Do not assume `$PWD`; human-facing scripts must locate what they need or use
  explicit verified paths.
- Keep system facts separate from user preferences. A preference is not proof of
  machine state, and machine state is not permission to override a preference.

## Directory guidance

Read the [root README](README.md), this file, and every applicable ancestor and
local `AGENTS.md` before working in a directory. Read that directory's README for
its purpose and boundaries. Record the resolved guidance and selected system,
shell and user profiles with the preparation evidence. Do not assume an agent
runner automatically loads every local file.

Each maintained directory, including nested directories, needs two useful files:
`README.md` explains its purpose, contents and navigation to people and agents;
`AGENTS.md` adds obligations specific to that scope. Local instructions inherit
the root safety flow and must not silently weaken it. Surface a conflict rather
than choosing whichever rule permits an unsafe operation.

Add these files when adding a directory, and update its parent's navigation and
the root overview when the organization changes. Keep local guidance short and
specific; do not copy the whole root rulebook into every folder. Preserve the
existing layout unless a separate task authorizes reorganization. Do not inject
Markdown into byte-sensitive fixture payloads, generated output or upstream
mirrors merely to satisfy a count: an exclusion needs explicit scope, rationale
and review in the containing guidance. No implicit blanket exclusions apply.

## Conformance and evidence

Before proposing changes, enumerate the affected directory scopes, check their
guidance and local links, and explain any unresolved gaps. Keep mechanical
checks (missing files or broken links), semantic review, executed tests and
real-target acceptance separate. A README, AGENTS file, issue or claimed PASS
is not executable enforcement and does not prove commands are safe.

Prepared-command evidence must identify the exact command/script revision,
applicable policy and profile revisions, relevant observations with provenance,
fixtures, independent expected outcomes, commands actually tested, actual
results and remaining target limitations. A material change to the candidate
or context invalidates earlier acceptance. An unavailable required test or
unknown required fact is not a pass. Never execute a destructive test against
the user's live data.

Implementation is tracked in [AICI #187](https://github.com/isomorphisms/ai-ci/issues/187)
and [Cockswain #34](https://github.com/isomorphisms/cockswain/issues/34).
These references record future conformance scripts and supervision, not an
enabled watcher. AICI owns the shared evidence contract; Cockswain consumes it
for follow-up. Do not implement conflicting copies of the same acceptance rule.

## Concurrent work

Check the current tree and relevant active work before editing. Prefer a small,
additive patch or a separate review branch. Re-read any changed file before
reconciling another thread's work; do not overwrite it from an older snapshot,
force-push, or turn a guidance task into a directory migration. Report exactly
what was checked and what remains unimplemented.
