# Python source pasted at a shell prompt

## Failure

The program itself can be valid Python and still be a bad terminal handoff.

A source listing was presented in a context where the human could paste it
directly at a shell prompt. The shell then interpreted Python statements as
shell commands.

The specimen is intentionally mundane: the bug is the **delivery unit and
interpreter boundary**, not an exotic Python error.

## Regression

Test the exact block that would be shown to the human.

A source listing is acceptable when clearly delivered as source. A runnable
installation block must create the file completely, use the intended
interpreter, preserve its bytes, and not accidentally execute a mutation.

Related: Kitchen issue #4.
