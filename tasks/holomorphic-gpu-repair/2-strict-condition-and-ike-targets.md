# Candidate 2: strict condition and target syntax

The 2026-10-19 admission run rejected the wrong-tool fixture before reaching its
intended diagnostic: the pinned Grease engine forbids command substitution
inside a conditional test under strict errexit. The regression checked the
specific tool-digest diagnosis and therefore failed rather than counting this
unrelated execution error as a successful negative test. Candidate 3 computes
the digest and length before its conditional tests.

Source review also found Make-style target colons in the initial Ikefile.
The pinned Ike a92fe68 parser requires `target depends on`. The actual pinned
parser implementation and retained independent subpixel Ikefile established
that syntax before the first real producer/checker execution. No Ike execution
or mathematical/GPU PASS is claimed for candidate 2.
