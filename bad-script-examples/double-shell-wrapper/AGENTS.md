# Entrypoint argument boundaries

Inherit the [root instructions](../../AGENTS.md) and
[specimen-preservation rules](../AGENTS.md). Read the
[case account](README.md); keep bad evidence unchanged.

Record the entrypoint's argument contract and the argument vector it actually
receives. Test the extra-shell failure and the correct invocation, including
spaces and quoting. Do not add another interpreter layer unless that contract
requires one; checking only a printed command string is insufficient.
