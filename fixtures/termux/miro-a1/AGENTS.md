# Agent instructions: fixtures/termux/miro-a1

Inherit the [root instructions](../../../AGENTS.md) and all intervening directory rules.

Follow [Termux fixture rules](../AGENTS.md) and the full ancestor chain.
Use [paths.tsv](paths.tsv) as scoped reference data, not as shell input or a
list of paths to create on a real phone. Preserve its distinction between
preference, observation, mutable state and forbidden assumption.

Construct any executable filesystem fixture under a verified disposable root.
Test absent sources and the wrong ~/bin assumption without silently creating
the missing prerequisites. A stored path observation must be refreshed before
relying on it for a live operation. Report table validation, disposable tests
and actual MIRO A1 acceptance separately; the table alone proves none of the
latter two.
