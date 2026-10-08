# Pinned interpreter sources

Kitchen keeps exact source references for scripting runtimes whose size or semantics may
need to be changed deliberately rather than accepting an arbitrary host installation.

These are source pins, not phone deployment. Cat Food owns Android delivery and must not
clone these source trees onto a phone merely because Kitchen can inspect/build them.

Current pins:

- MicroPython: `dilapidated-shed/micropython` at
  `a129b2fba1a3348088c94d0462eef16d20874dea`.
  The fork must exist before this branch is merged. The pin is the observed upstream
  `micropython/micropython` master commit from 2026-10-06; GitHub forks preserve it in
  the fork network even if upstream advances before the fork is created.
- Field Mouse: `dilapidated-shed/fieldmouse` at
  `7ebef96b31b013b086bab8abb683741451d08f32`.
  This is the active Idriç runtime line.
- MuJS: `ArtifexSoftware/mujs` at
  `aab59f2c8136b55e8eef7a016d5a15fe8cf69f3f`.
  This is retained as the compact C JavaScript reference/fallback; it is not a claim
  that MuJS is the preferred active runtime.

Do not initialize MicroPython recursively by default. Its upstream repository contains
many hardware-specific submodules. A Kitchen task should initialize only the source
surface its build actually needs.

Before using a pin, verify the gitlink commit exists in the configured remote. A
submodule checkout is evidence about source identity, not evidence that a resulting
binary fits or runs on MIRO A1/C67.
