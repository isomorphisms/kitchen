# Kitchen

Kitchen prepares terminal instructions before they are served.

Plausible commands are not good enough for a real terminal. Kitchen keeps target facts, user conventions, shell constraints, fixtures, tests, and preflight rules together so generated commands can be checked against the actual environment.

## Repository layout

- `assumptions/` — observations, preferences, and unknowns kept distinct
- `systems/` — facts and assumptions scoped to machines and environments
- `user/` — stable human conventions and preferences
- `shells/` — language- and runtime-specific constraints
- `preflight/` — checks required before a command is presented
- `probes/` — read-only ways to establish missing target facts
- `fixtures/` — disposable states used to exercise commands and scripts
- `tests/` — executable checks and regression cases
- `incidents/` — escaped mistakes turned into durable regressions
- `sources/` — provenance and links to upstream facts such as Cat Food

Start with [`AGENTS.md`](AGENTS.md).

## Common task: transfer a GitHub repository

See [the Grease-first canonical procedure](tasks/github-repository-transfer/HOW-TO-MOVE-A-GITHUB-REPOSITORY-TO-ANOTHER-ORGANIZATION.md).

The checked generator emits one complete standalone Grease program. Flexible Pipes runs it and verifies repository identity before the result is presented.

## Source-pinned phone test handoffs

Read [the IB handoff incident](incidents/2026-10-04-ib-unmaterialized-handoff.md) before serving a checkout-dependent phone test.

The [versioned IB baseline task](tasks/ib-durable-store/README.md) preserves existing checkouts, verifies source and blob identities, and keeps the passing old baseline separate from the unavailable E2 repair. Its regression covers failed context discovery, repeated execution, and login-shell preservation. Cat Food owns verified checkout lookup and the dated phone observation.

New source-test handoffs use the shared [producer gate](tasks/source-handoff/README.md). It verifies fresh source materialization before emitting a digest-bound command. Consumer execution remains read-only and acceptance stays scope-specific.
