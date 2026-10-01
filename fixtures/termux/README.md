# Termux fixtures

This folder groups disposable reference states for Termux-specific preparation.
Keep each device and execution context distinct; do not infer adb, rish or root
behavior from an ordinary Termux case.

The current child is [MIRO A1](miro-a1/README.md), containing a path reference
table. A reference table is not an executed filesystem test or current device
inspection. [System notes](../../systems/README.md) record target context;
[tests](../../tests/README.md) hold behavioral checks. Follow the
[parent fixture guidance](../README.md) and [local agent rules](AGENTS.md).
