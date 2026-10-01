# Pipeline early-exit failure

Inherit the [root instructions](../../AGENTS.md) and
[specimen-preservation rules](../AGENTS.md). Read the
[case account](README.md); keep bad evidence unchanged.

Use a bounded producer large enough to expose the early-consumer-exit case;
a tiny output that fits the pipe can miss the failure. Record the actual shell
and pipeline statuses. Test both present and absent matches, plus an unrelated
producer failure, so the correction cannot simply discard every failure.
