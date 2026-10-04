# Kitchen

Kitchen is where terminal instructions are prepared before they are served.

The repository exists because plausible commands are not good enough for a real
terminal. It keeps target facts, user conventions, shell-language constraints,
fixtures, tests, and preflight rules together so command generation can be
checked against the actual environment instead of a generic Unix mental model.

The working split is:

- `assumptions/` — truth/status classes so observations, preferences and unknowns do not blur together;
- `systems/` — facts and assumptions scoped to machines/environments;
- `user/` — stable human conventions and preferences;
- `shells/` — language/runtime-specific constraints;
- `preflight/` — checks required before a command is presented;
- `probes/` — read-only ways to establish missing target facts;
- `fixtures/` — disposable states used to exercise commands and scripts;
- `tests/` — executable checks and regression cases;
- `incidents/` — escaped mistakes that should become durable regressions;
- `sources/` — provenance and links to upstream facts such as Cat Food.

Start with `AGENTS.md`.

## Source-pinned phone test handoffs

Read [the IB handoff incident](incidents/2026-10-04-ib-unmaterialized-handoff.md)
before serving a checkout-dependent phone test. The
[versioned IB baseline task](tasks/ib-durable-store/README.md) preserves existing
checkouts, verifies source and blob identities, and keeps the passing old baseline
separate from the unavailable E2 repair. Its executable regression covers failed
context discovery, repeated execution, and login-shell preservation; Cat Food
owns verified checkout lookup and the dated phone observation.
