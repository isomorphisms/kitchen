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
