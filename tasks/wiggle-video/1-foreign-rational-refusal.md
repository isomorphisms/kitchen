# Candidate 1: foreign rational operators are not checked

2026-10-21, disposable Ubuntu x86-64. Ithon source
74ab6d6044b07b76a910978437a34a6b5ac6acda rejects the complete candidate before
execution: `comparison is not statically defined for Fraction and Fraction`
at the control-range assertion. Nothing rendered. The checker is behaving
honestly about a missing foreign operator interface. Candidate 2 uses explicit,
typed rational operation boundaries; it does not bypass mandatory checking.
