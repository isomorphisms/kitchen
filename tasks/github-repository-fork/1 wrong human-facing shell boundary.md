# Version 1 used the wrong human-facing shell boundary

The first checked fork helper was implemented as a POSIX-shell program and its generator
produced another shell program. That is retained as implementation evidence, but it is no
longer the human-facing form.

The user-facing contract is now `paste-contract.json` plus
`render-paste-block.py`: a deterministic plain-text block of direct `gh` commands,
with no `sh` invocation and no attached-script requirement.

The older helper still documents stronger refusal cases (canonical source, organization
membership, collisions, and fork-network verification). Those remain useful regression
requirements for any future richer Grease/YSH implementation; they are not silently
claimed by the simpler paste-block contract.
