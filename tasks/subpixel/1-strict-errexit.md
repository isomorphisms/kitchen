# Version 1 — source-check command substitution refused

Native Grease executed version 1 against a genuinely wrong producer revision.
It rejected command substitution inside a `test ... || ...` condition because
that context could hide the substituted command's exit status (`strict_errexit`).
The test required a specific source-mismatch refusal and correctly failed when
this unrelated runtime error occurred. Nothing was built and no evidence was
created. Version 1 remains intact. Version 2 assigns the observed revision in a
checked `var` declaration before comparing it, preserving Grease's strict rule.

The materialized native binary also has a multicall basename requirement:
copying it as `grease` yields `Invalid applet`. Execute the digest-verified
`ysh` binary used by the existing Grease handoff action under that real name;
do not relabel a different shell or weaken its interpreter checks.
