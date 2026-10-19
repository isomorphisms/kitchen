# Version 2 — export can hide substitution failures

A native-Grease probe of the post-build environment setup rejected
`export NAME="$(command)"` under `strict_errexit`: export can report success
while hiding the substituted command's status. This was found before running
the expensive compiler path. Version 2 and its successful wrong-source refusal
remain preserved. Version 3 assigns each digest with a checked `var` declaration,
then passes the already-observed values with the host's explicit `env` command.
The same probe established that this native YSH implementation has no `export`
builtin (its native environment object is `ENV`). The recipe therefore uses
ordinary command-scoped environment arguments, and `env -u` removes the inherited
Ike recipe runner. No shell setting or interpreter changed.
