# Agent instructions: systems

Inherit the [root instructions](../AGENTS.md) and all intervening directory rules.

Keep each fact attached to its machine, operating system/version when known,
execution context and evidence date. Distinguish the physical device from
Termux, adb shell, rish and root privileges. Do not project one host's paths,
commands, architecture or mounts onto another.

Use the [profile index](README.md) and [source notes](../sources/README.md).
Preserve Cat Food provenance and mark unverified or mutable facts explicitly.
Choose bounded read-only probes for unknowns. Example host names or versions
are not observations. Personal conventions belong in [user/](../user/README.md);
interpreter semantics belong in [shells/](../shells/README.md).
