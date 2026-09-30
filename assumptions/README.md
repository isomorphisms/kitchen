# Assumption classes

Do not flatten different kinds of knowledge into one undifferentiated profile.

Use these classes when preparing commands:

- **observed** — directly established on the named system, preferably with date
  and probe/evidence;
- **preference** — the user's desired convention or style; it does not prove the
  machine currently satisfies it;
- **constraint** — a rule that the prepared command must respect;
- **derived** — follows from named observations/constraints; preserve the
  derivation instead of presenting it as direct observation;
- **unknown** — must be probed or left unresolved, not guessed;
- **deferred** — known problem/setup area the human has explicitly postponed;
  do not reintroduce it as an incidental prerequisite.

System notes should mostly carry observed/unknown/deferred facts. User notes
should mostly carry preferences. Shell notes carry semantic constraints and
verified implementation facts.

When two sources disagree, current direct evidence from the exact target wins
over generic convention. Preserve the disagreement long enough to understand
whether an upstream note is stale.
