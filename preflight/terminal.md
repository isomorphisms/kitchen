# Terminal command preflight

Run this reasoning before presenting a mutating command.

## Context

- exact machine/device known;
- exact execution context known: Termux, adb, rish/Shizuku, root, SDF, runner;
- intended shell/language known;
- current-directory assumptions eliminated.

## Paths and state

- every input/source path established;
- every destination either established or intentionally created;
- existing file/symlink/directory cases considered;
- storage/mount identity established when it matters;
- execution permission/capability established when it matters.

## Behavior

- successful path exercised against a fixture when practical;
- rerun/idempotence behavior known;
- failure stops near the first broken assumption;
- destructive effects isolated and explicit;
- quoting and whitespace cases tested when data can contain them.

## Verification

Pair each mutation with a direct postcondition check. Examples include
`readlink`, `stat`, a content comparison, `command -v`, `id`, package
queries, or process-specific evidence.

Only after these checks should the command be served as runnable instructions.
