# Wrapper supplied a second shell at the wrong boundary

Evidence date: August 26, 2026.

A verification wrapper added another shell invocation even though the container
entrypoint already supplied the shell and calling convention. The resulting
argument structure failed with "cannot execute binary file".

Regression: treat entrypoint plus command as one argument contract. Inspect and
test the real entrypoint before adding another shell layer.

This is a reconstruction of the failure mechanism, not a verbatim command.
