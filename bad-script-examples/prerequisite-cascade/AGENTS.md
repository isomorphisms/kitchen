# Prerequisite failure

Inherit the [root instructions](../../AGENTS.md) and
[specimen-preservation rules](../AGENTS.md). Read the
[case account](README.md); keep bad evidence unchanged.

Inject install/export prerequisite failures and assert that no dependent
mutation occurs. Include an independently specified successful prerequisite
case. Capture attempted effects as well as exit status; a final successful
command must not hide an earlier failed prerequisite.
