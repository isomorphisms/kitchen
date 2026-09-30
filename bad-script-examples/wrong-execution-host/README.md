# Wrong execution host

## Failure

A generated handoff failed to distinguish:

- the machine currently running the commands;
- the machine holding the artifact;
- the transfer source;
- the destination; and
- which machine had the required tools and credentials.

The resulting recipe assumed a tool such as `gh` existed locally and could
even instruct a destination machine to transfer to or log into itself.

## Regression

Model at least two hosts plus an “already at destination” case. Tool
availability and credentials belong to a specific host. A recipe that collapses
source and destination without an explicit reason must be rejected.

Related: Kitchen issue #3.
