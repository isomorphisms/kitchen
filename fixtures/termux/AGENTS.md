# Agent instructions: fixtures/termux

Inherit the [root instructions](../../AGENTS.md) and all intervening directory rules.

Follow [fixture rules](../AGENTS.md), the root instructions and this folder's
[README](README.md). Separate device-specific layout, Termux app permissions,
and shell behavior. Neither an Android label nor one phone fixture establishes
adb/rish/root access or behavior on every Android device.

Label synthetic states and historical observations. Include missing-path,
permission and changed-mount variants where relevant. Do not touch a connected
device to construct a fixture. New nested fixtures need their own useful README
and local guidance unless an explicitly reviewed payload exclusion applies.
