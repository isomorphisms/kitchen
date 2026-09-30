# Systems

Keep facts scoped to the exact system that established them.

A phone fact is not a tablet fact. A Termux fact is not an `adb shell` fact.
An SDF fact is not a local Linux fact. A GitHub runner fact is not a workstation
fact.

Each system note should distinguish:

- observed and dated facts;
- expected but unverified assumptions;
- explicitly unavailable/deferred facilities;
- probes that can refresh mutable facts;
- commands or layouts that must not be projected from another system.

## Current profiles and related context

- [MIRO A1 / Termux](miro-a1-termux.md)
- [SDF](sdf.md)
- [TAB P10 / Termux](tab-p10-termux.md)

These notes describe their own evidence scope, not certified support for every
operation. Add other hosts, operating systems or execution contexts when their
facts are established; do not turn an example version into an observed version.

[Shell constraints](../shells/README.md) cover interpreters such as Grease/YSH
and, when documented, Bash. [User preferences](../user/README.md) cover desired
conventions. Keep those separate from facts about a machine. Consult the local
[agent rules](AGENTS.md) and [provenance](../sources/README.md) when updating a
profile. No directory move is needed to express these relationships.
