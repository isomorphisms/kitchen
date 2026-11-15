# Version 2 host syntax and refusal checks

Requirements before implementation: preserve the five-argument interface and
all existing build/installed-test commands; parse on the declared actual Grease
host runtime; reject missing arguments, a mismatched source head, and a producer
whose version invocation fails. No test may manufacture compiler, installed
program or live-provider acceptance.

Observed target: disposable Linux x86-64 host, 2026-10-19. The runtime and
launcher identities are recorded in the version-1 failure note.

| Actual check | Result |
| --- | --- |
| Grease parses version 1 | status 2, expression syntax refusal |
| Grease parses version 2 | status 0 |
| Version 2 with no arguments | usage, status 2 |
| Actual clean CLI source f548fbfeb73a2d98364b64180d2bb9af4fc01618, deliberately wrong requested head | status 1 before the producer invocation |
| Same actual source/head, explicit `/bin/false` negative producer | status 1 from its version invocation; Grease errexit prevents preflight success |

The failing producer is a negative control, not a substituted compiler. No
positive build or installed-command result is claimed from these tests. Those
consumer stages must execute the actual pinned Idriç compiler and produced
program, followed by independent AICI and separately captured provider output.
