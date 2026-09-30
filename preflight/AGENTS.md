# Agent instructions: preflight

Inherit the [root instructions](../AGENTS.md) and all intervening directory rules.

Apply [terminal preflight](terminal.md) to the exact command block that will
be delivered, not an earlier draft. Bind it to the selected host, interpreter,
privilege context, paths and working-directory assumptions.

Check the required source state, intended mutation and concrete postcondition.
A missing prerequisite stops dependent mutations. Keep read-only probes and
state changes visibly separate. Preserve fixture/test evidence and disclose
unverified target gaps. A documentation-only review is not an executed test;
a changed delivered command needs renewed review and applicable tests.
