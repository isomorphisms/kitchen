# Kitchen

Kitchen is where terminal instructions are prepared before they are served.

The repository exists because plausible commands are not good enough for a real
terminal. It keeps target facts, user conventions, shell-language constraints,
fixtures, tests, and preflight rules together so command generation can be
checked against the actual environment instead of a generic Unix mental model.

The working split is:

- [`assumptions/`](assumptions/README.md) — truth/status classes so observations, preferences and unknowns do not blur together;
- [`systems/`](systems/README.md) — facts and assumptions scoped to machines/environments;
- [`user/`](user/README.md) — stable human conventions and preferences;
- [`shells/`](shells/README.md) — language/runtime-specific constraints;
- [`preflight/`](preflight/README.md) — checks required before a command is presented;
- [`probes/`](probes/README.md) — read-only ways to establish missing target facts;
- [`fixtures/`](fixtures/README.md) — disposable states used to exercise commands and scripts;
- [`tests/`](tests/README.md) — executable checks and regression cases;
- [`incidents/`](incidents/README.md) — escaped mistakes that should become durable regressions;
- [`sources/`](sources/README.md) — provenance and links to upstream facts such as Cat Food.

Start with [AGENTS.md](AGENTS.md).

## How to use the folders

For a task, choose the relevant machine/execution context from `systems/`,
interpreter constraints from `shells/`, and personal conventions from `user/`.
Use `assumptions/` to distinguish what is known, preferred, required or unknown;
use `sources/` to retain provenance and `probes/` to resolve mutable facts.
Prepare disposable inputs under `fixtures/`, test the intended result under
`tests/`, and apply `preflight/` to the exact command before serving it. Escaped
mistakes belong in `incidents/` with links to their regression work.

A preference for `~/opt/bin` does not prove that directory exists on every host.
Likewise, choosing Bash or Grease/YSH does not identify the operating system or
privileges. These are separate inputs to preparation, not interchangeable
profiles. Add further system and shell profiles from evidence; do not infer an
OS version, host layout or installed interpreter from an illustrative example.

Each folder's README explains what belongs there. Its local AGENTS file adds
scope-specific obligations to the root rules; read the full ancestor chain.
This is the existing organization, not a requirement to reorganize concurrent
work around a new taxonomy.

## Conformance work

[AICI #187](https://github.com/isomorphisms/ai-ci/issues/187) tracks the shared
checker and evidence gate. [Cockswain #34](https://github.com/isomorphisms/cockswain/issues/34)
tracks ongoing supervision using those results. The issues do not establish a
running watcher or a completed test harness. Documentation coverage, behavioral
tests and verification on the real target must be reported separately.
