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

## Known-good interactive Shizuku/rish prompt

In the September 30 / October 1 MIRO A1 session, the following command was
served **inside the interactive `rish` shell** and the user subsequently
showed the cyan `A1:/ # MIRO A1 — Termux

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

 prompt:

```sh
PS1="$(printf '\033[1;36m')A1$(printf '\033[0m'):"'${PWD}'" \\$ "
```

Preserve this literal command when the request is simply to recover the
known-working Shizuku prompt. The single-quoted `${PWD}` is intentional: it
keeps the parameter reference in `PS1` so the displayed path changes after
`cd`, rather than freezing the directory that was current when the assignment
ran.

Evidence boundary:

- cyan was preferred over the earlier magenta experiment;
- the observed interactive result was `A1:/ # MIRO A1 — Termux

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

;
- this is an interactive-shell prompt assignment, not a command to prepend to
  `rish -c`;
- prompt color is only a visual context marker and is not evidence of UID,
  Shizuku authorization, or root.

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
