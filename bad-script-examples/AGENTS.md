# Bad-script preservation rules

Inherit the [root instructions](../AGENTS.md). Read the [case index](README.md)
and each case's local README and AGENTS. These are regression seeds, not approved
commands and not proof that a regression test has been implemented.

Preserve bad specimen bytes and existing provenance. Do not repair, format or
execute a specimen merely because a directory scan found it. Put a corrected
counterpart and its independent expected behavior alongside the regression
work, keeping the failing evidence distinguishable. Preserve the difference
between recovered source and a reconstruction; do not invent missing history.

Keep identifying data synthetic and review new additions for private details.
Use disposable fixtures and bounded execution with no live mail, network
configuration, credentials or user directories. Record which bad behavior is
rejected and which valid counterpart is accepted. A successful reproduction
of a failure is not approval to deploy the bad script.

A documentation scan must read these files as data, not source or import them.
A new case needs its own README, specific AGENTS guidance and an index link.
Do not blanket-exclude this maintained subtree to make coverage green. A future
byte-sensitive payload exclusion must name its exact scope and rationale;
keep guidance in the containing directory rather than altering payload bytes.

Conformance implementation remains in [AICI #187](https://github.com/isomorphisms/ai-ci/issues/187)
and [Cockswain #34](https://github.com/isomorphisms/cockswain/issues/34).
