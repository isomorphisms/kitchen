# Agent instructions

Kitchen is the preparation area for human-facing terminal commands and scripts.

Before serving runnable commands for a real machine, prepare them here against the
best available knowledge of the target system and the user's conventions.

## Mandatory flow

Kitchen is not a place to improvise a runnable script and then invent tests for
it afterward. The evidence should grow from the intended behavior.

1. **Identify the target context.** Name the exact machine and execution context:
   Termux, `adb shell`, Shizuku/rish, root, SDF, GitHub runner, or another host.
2. **State the requirements before implementing.** Write down what the command or
   script must do, what it must not do, what inputs and state it expects, and
   what observable postconditions would count as success. Requirements should be
   concrete enough that a test can disagree with the implementation.
3. **Load known facts.** Read the applicable files under `systems/`, `user/`,
   and `shells/`. Treat dated observations as observations, not eternal truths.
4. **Resolve unknowns with read-only probes.** Never replace an unknown path,
   permission, shell feature, package, mount, executable, input format, or other
   environmental fact with a generic Unix guess.
5. **Write tests from the requirements.** Before trusting the implementation,
   turn each important requirement into one or more tests. Include negative
   requirements: things the script must refuse, preserve, or leave unchanged.
6. **Build fixtures for those tests.** Reproduce the relevant
   filesystem/input/process state under `fixtures/` when practical. Fixtures are
   evidence, not decoration: each should have a reason to exist and an expected
   outcome.
7. **Review the fixtures before running the candidate.** Ask whether the fixtures
   actually exercise the stated requirement and the failure that motivated the
   work. A test that passes on an irrelevant or too-friendly fixture proves
   little. Fix weak fixtures before treating their results as evidence.
8. **Implement a versioned candidate.** Keep materially distinct attempts rather
   than erasing the path by which the script was produced. A task may look like:

       scripts/parse-a-mailbox/in-mbox-format/
           1.py
           2.py
           3.py

   Use the natural source suffix for the language rather than assuming Python.
9. **Run the tests on the fixtures.** Exercise the successful case and relevant
   failure, rerun, quoting, path, permission, malformed-input, partial-state, and
   interruption cases that apply. Record enough about the run that a later agent
   can tell what was actually tested.
10. **Attack the candidate.** After the ordinary tests, deliberately think about
    how the script could be wrong even while those tests pass. Add aggressive
    fixtures for those possibilities and rerun. Important discoveries should
    become permanent regression cases rather than one-off thoughts.
11. **Preflight the exact command.** Check sources, destinations,
    current-directory independence, shell syntax, privilege boundary,
    destructive effects, and whether repeated execution is safe when it is
    supposed to be.
12. **Serve the smallest mutation.** Prefer one state change followed by a
    verification over a large blind block.
13. **Verify the postcondition.** A zero exit status is not sufficient evidence
    when the intended state can be checked directly.
14. **Preserve what was learned.** Do not clean up a failed or misleading attempt
    so thoroughly that the failure becomes invisible. Keep the script version,
    the fixture that exposed it, the test, and a short account of the failure.

If a required assumption cannot be established, serve a read-only probe instead
of a guessed mutation.

## Version and failure record

The numbered script versions are part of Kitchen's evidence. Once a numbered
version has been tested, served, or otherwise become evidence, do not silently
rewrite its history. Make the next numbered version for a materially changed
attempt.

When a numbered version exposes a bug, bad assumption, misleading success, or
other useful failure, add a companion Markdown note beginning with the same
version number and a short human-readable description. For example:

    scripts/parse-a-mailbox/in-mbox-format/
        1.py
        1 confused arguments with vectors.md
        2.py

The exact suffix is less important than the stable link to version `1` and a
description useful to a human scanning the directory.

A failure note should record, when known:

- the requirements that version was intended to satisfy;
- when the attempt and observations were made;
- the target system and relevant assumptions;
- what was tried;
- which tests and fixtures were used;
- what went right;
- what went wrong;
- how the failure was observed;
- whether the problem was in the implementation, requirement, test, fixture, or
  an assumption about the environment;
- what changed in the next attempt; and
- any new regression fixture or test created from the failure.

Do not record only failures. A version that succeeded for a non-obvious reason,
or that revealed a useful constraint, can have the same kind of note.

This history is deliberately machine-inspectable. Future tools should be able
to walk requirements, tests, fixtures, numbered attempts, and failure notes;
look for recurring failure patterns; and propose improvements to Kitchen's own
procedure. Prefer regular local structure and explicit evidence over prose that
exists only in a chat.

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

## GitHub Connector repository access

When ChatGPT/Codex can authenticate to GitHub but a repository is invisible or
writes fail, especially after a new organization is created or a repository is
transferred, use the canonical procedure in
`tasks/github-chatgpt-codex-connector-access/README.md`.

Do not infer GitHub App access from the user's ordinary repository `push` or
`admin` permissions, and do not treat reconnecting the GitHub identity as a
substitute for installing/configuring the ChatGPT Codex Connector on the actual
repository owner.

## Canonical movie assembly

For mathematical visualization movies built from generated stills, use
`tasks/movie-from-stills/build.sh` as the canonical assembly command.

The producing repository owns mathematical state evolution, camera/control
trajectories, and still rendering. It should write a numbered still sequence
beginning at frame zero. Kitchen owns the ordinary FFmpeg assembly step.

Do not introduce a project-local movie-encoding library, Python `movie.py`
wrapper, raw-RGB streaming protocol, or hand-built MP4 encoder merely to turn
those stills into a movie. Keeping the numbered PNG/PNM/PPM files alongside the
movie is acceptable when the producing repository wants them as artifacts.

If the canonical command needs another codec, container, audio rule, or timing
feature, change and test the Kitchen task rather than creating a divergent
project-local encoder.
