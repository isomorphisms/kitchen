# Kitchen

Kitchen is where terminal instructions are prepared before they are served.

The repository exists because plausible commands are not good enough for a real
terminal. It keeps target facts, user conventions, shell-language constraints,
fixtures, tests, and preflight rules together so command generation can be
checked against the actual environment instead of a generic Unix mental model.

The working split is:

- `systems/` — facts and assumptions scoped to machines/environments;
- `user/` — stable human conventions and preferences;
- `shells/` — language/runtime-specific constraints;
- `preflight/` — checks required before a command is presented;
- `fixtures/` — disposable states used to exercise commands and scripts;
- `tests/` — executable checks and regression cases;
- `sources/` — provenance and links to upstream facts such as Cat Food.

Start with `AGENTS.md`.
