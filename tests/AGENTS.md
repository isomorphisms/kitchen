# Agent instructions: tests

Inherit the [root instructions](../AGENTS.md) and all intervening directory rules.

Follow the [README](README.md). Specify expected results independently of the
candidate implementation. Pair known-bad specimens with valid counterparts;
testing only rejection or deriving the oracle from the generated script is not
sufficient. Cover relevant failure, rerun, quoting, path, context and permission
cases, and verify the requested postcondition rather than exit status alone.

Run destructive cases only in verified disposable fixtures. Record the exact
candidate, interpreter, fixtures, test command and actual outcomes. Keep
structural checks, simulated behavior and real-target acceptance separate.
A missing dependency, zero tests, skipped required case or unexecuted plan is
not a pass. Preserve failing evidence; do not weaken a test merely to obtain
green output.
