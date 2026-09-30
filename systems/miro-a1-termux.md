# MIRO A1 — Termux

Source: Cat Food device notes, especially `isomorphisms/catfood/AGENTS.md`.
Treat observations as mutable and recheck when they materially affect a command.

## Known conventions and observations

- Preferred executable location in the phone's private Termux storage:
  `~/opt/bin`.
- Do not invent `~/bin` merely because it is conventional elsewhere.
- Android shared Downloads is `~/storage/downloads`; that name does not mean
  external SD.
- A removable card has previously appeared as `~/storage/external-1`, but its
  presence, mount and execution properties must be reverified before use.
- Shizuku exported terminal files were observed at
  `~/storage/shared/Shizuku`, with the convenience link
  `~/opt/Shizuku -> ../storage/shared/Shizuku/`.
- Shared Android storage is not automatically executable. In particular, a DEX
  that must be loaded by `app_process` may need to be copied into private
  Termux storage and made non-writable.

## Context boundaries

Do not confuse:

- ordinary Termux UID and permissions;
- `adb shell`;
- Shizuku/rish;
- root.

A command proven in one context is not proven in the others.

## Useful read-only refresh probes

Prefer direct evidence such as `readlink -f`, `test -e`, `command -v`,
`id`, mount/space inspection, and an execution probe where execution capability
is the actual question.
