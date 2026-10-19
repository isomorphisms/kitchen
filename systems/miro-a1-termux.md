# MIRO A1 — Termux

Source: Cat Food's `android/devices/miro-a1.md`, its source-bound Android
profile interface, dated observations, and `AGENTS.md`. Durable model facts,
physical-instance observations, application context, and session capabilities
have different scopes.

Preferred executable location: private Termux `~/opt/bin`. Shizuku exports
were observed at `~/storage/shared/Shizuku`, with
`~/opt/Shizuku -> ../storage/shared/Shizuku/`. A DEX loaded by `app_process`
may need private storage and non-writable permissions. Neither valid files nor
a cyan prompt establishes authorization or a running Shizuku service.

Shared Downloads means `~/storage/downloads`. Cat Food records the historical
A1 card root as `/storage/4A21-0000`; `~/storage/external-1` is the app-private
directory on that card, not its whole root. Recheck current mounts before a
storage-dependent action.

## Interactive Shizuku/rish prompt

The literal assignment retained from the September 30 / October 1 record is:

```sh
PS1="$(printf '\033[1;36m')A1$(printf '\033[0m'):"'${PWD}'" \\$ "
```

The previous file repeated the profile opening inside its claimed rendered
prompt. That text is corruption, not a supported exact prompt observation.
Preserve the assignment; do not reconstruct the rendered result. The
single-quoted `${PWD}` keeps its expansion interactive. Cyan is a visual marker,
not evidence of shell UID or root. Do not prepend this assignment to
noninteractive `rish -c` tasks.

## Execution contexts

Termux process, exported rish launcher/DEX, Shizuku authorization and service,
ADB host server, connected Android ADB device, shell UID 2000, and root UID 0
remain separate states. `adb devices` does not prove it started Shizuku.

Use `tasks/android-diagnostic/prepare.pi` with the exact Cat Food profile
request, profile projection, AICI requirement projection, and a task-local
material input before selecting a diagnostic action. The preparation keeps a
source-only check eligible when a missing export or service blocks only the
Shizuku-dependent action. Its host fixtures are not physical-device acceptance.
