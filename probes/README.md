# Read-only probes

Probes establish facts needed to prepare a command without changing the target.

Examples of questions a probe may answer:

- what shell/runtime is executing this;
- what UID and privilege boundary applies;
- whether a path exists and what a symlink resolves to;
- whether a command is installed;
- what storage/mount a path belongs to;
- whether a location can execute the relevant artifact type;
- what Git repository/origin a checkout actually has.

Keep probes narrow. Do not smuggle setup, installation, chmod, file creation, or
other mutations into something presented as observation.

If a probe's output will be pasted back by the human, make the requested evidence
easy to identify and avoid unrelated diagnostic noise.
