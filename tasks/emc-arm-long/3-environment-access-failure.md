# Grease environment access stopped version 3 before compilation

The first actual FP qualification attempt reached Kitchen but failed while
expanding its heredoc: `Undefined variable PATH`. Grease exposes inherited
environment through `ENV`, not automatically as shell variables. No parser
compile/test ran in this attempt. The FP receipt correctly records failure.

Version 4 explicitly obtains `ENV.PATH` before constructing the Ike recipes.
Retain this as a regression against mistaking syntax-only checks for execution.
