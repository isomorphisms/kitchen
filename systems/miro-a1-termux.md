# MIRO A1 — Termux

Source: Cat Food's `android/devices/miro-a1.md`, its dated observation files,
and `AGENTS.md`. Durable facts and current capabilities have different scopes.

Preferred executable location: private Termux `~/opt/bin`. Shizuku exports
were observed at `~/storage/shared/Shizuku`, with
`~/opt/Shizuku -> ../storage/shared/Shizuku/`. A DEX loaded by `app_process`
may need private storage and non-writable permissions. Neither valid files
nor a cyan prompt establish authorization or a running Shizuku service.

Shared Downloads means `~/storage/downloads`. Cat Food records the A1 card
root as `/storage/4A21-0000`; `~/storage/external-1` is the app-private
directory on that card, not its whole root. Refresh mounts before storage work.

## Interactive Shizuku/rish prompt

The literal assignment retained from the September 30 / October 1 record is:

```sh
PS1="$(printf '\033[1;36m')A1$(printf '\033[0m'):"'${PWD}'" \\$ "
```

The previous file repeated the profile opening twice inside its claimed
rendered prompt. That text is corruption, not a supported exact prompt
observation. Preserve the assignment; do not reconstruct the rendered result.
The single-quoted `${PWD}` keeps its expansion interactive. Cyan is a visual
marker, not evidence of shell UID or root. Do not prepend this assignment to
noninteractive `rish -c` tasks.

## Execution contexts

Termux process, rish launcher/DEX, Shizuku authorization/service, ADB host
server, connected Android ADB device, shell UID 2000 and root UID 0 remain
separate states. `adb devices` does not prove it started Shizuku.

Use `tasks/android-diagnostic/capture.pi` after AICI preparation and Cat Food
profile selection. Its authority and operation probes refresh only relevant
mutable facts. Missing instance, firmware, installed bytes or telemetry stay
visible; historical GPU/compositor evidence does not accept Crystal.
