# Invented home bin directory

## Failure

The generated instructions chose `~/bin` because it looked conventional,
rather than because that path had been observed or requested.

This can create a second layout, miss the files the user actually has, and make
later commands disagree with the established filesystem state.

The specimen is deliberately synthetic. The original incident involved
target-specific paths which are not needed to preserve the bug.

## Bad assumption

`$HOME/bin` exists or should exist merely because it is a familiar Unix
convention.

## Regression

A fixture should contain an established executable directory elsewhere and no
`~/bin`. The bad specimen must fail review before it creates a competing
directory.

Related: Kitchen issue #2 and
`incidents/2026-09-rish-path-assumption.md`.
