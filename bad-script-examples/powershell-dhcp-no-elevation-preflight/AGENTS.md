# Privilege preflight

Inherit the [root instructions](../../AGENTS.md) and
[specimen-preservation rules](../AGENTS.md). Read the
[case account](README.md); keep bad evidence unchanged.

Use mocked network operations and an explicit privilege-state fixture. Verify
that missing required rights prevent every network mutation; include an allowed
mocked counterpart. Do not request elevation or change an actual adapter to
reproduce this historical failure. Test postconditions, not only the warning.
