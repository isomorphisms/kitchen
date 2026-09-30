# AICI provenance

AICI is the upstream source for reusable evidence, acceptance, and recurrent
agent-failure guardrails.

Kitchen applies those rules before human-facing terminal commands are served.
It should not fork general acceptance policy when that policy belongs in AICI.

Current integration tracker:
https://github.com/isomorphisms/ai-ci/issues/186

Boundary:

- AICI defines reusable evidence/acceptance rules and failure-mode enforcement.
- Cat Food records durable device/delivery facts.
- Kitchen combines the applicable facts and rules into target-specific probes,
  fixtures, tests, preflight checks, and prepared commands.
