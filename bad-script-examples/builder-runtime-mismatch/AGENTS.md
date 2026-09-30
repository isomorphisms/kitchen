# Builder versus target runtime

Inherit the [root instructions](../../AGENTS.md) and
[specimen-preservation rules](../AGENTS.md). Read the
[case account](README.md); keep bad evidence unchanged.

Keep builder success separate from target-runtime evidence. A regression
needs a fixture without the dependency that the builder happened to supply,
and an independently specified supported counterpart. Record target ABI and
runtime assumptions; a builder smoke test must not stand in for target launch.
