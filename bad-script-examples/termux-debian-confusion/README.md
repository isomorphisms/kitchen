# Termux treated as an ordinary Linux distribution

Evidence date: August 26, 2026.

A generated provisioning flow chose package, privilege and installation
conventions for a conventional Linux distribution even though the target was
ordinary Termux. It blurred four distinct contexts: Termux, a rootless Linux
environment inside Termux, Android shell, and root.

Regression: environment identity is an input to script generation. A command
sequence validated in one of these contexts must not be silently reused in
another.

This is a reconstruction of the failure mechanism, not a verbatim script.
