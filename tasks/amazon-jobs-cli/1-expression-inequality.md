# Version 1 did not parse on the recorded Grease host runtime

BACKLOG-REPAIR-02, 2026-10-19: the actual Linux x86-64 Grease entrypoint
rejected `int($#) != 5` before any producer command. The retained native
runtime is artifact 12192502970, archive SHA-256
295329ec3bb419d90364fcb5937eafe4306b03f68b7aaa63089dadde8082ffb5,
payload SHA-256
7e31cd05b7a9d8fb2a4a9e003a7f3fcb0159138506d17f0fb28da8cbe22aa85c.
Its declared portable Grease launcher has SHA-256
37088097c36a2f82cf45aaea9392e4a4cf16155fecb9da87d08a9c7fb4d92e4a.

The syntax error names `Id.Expr_Bang`. Version 2 uses the supported strict
inequality operation for the integer argument count and preserves all producer
commands and source checks. Version 1 remains byte-identical as failed history.
Version 2 parses, and missing arguments return usage/status 2. Actual compiler,
installed-command and provider execution remain distinct downstream gates.

An initial host-runtime staging attempt also showed why the launcher matters:
a symlink naming the native payload `grease` returned `Invalid applet grease`.
The verified declared launcher, with its verified companion host payload,
is required. No stock shell was substituted for the Grease task.
