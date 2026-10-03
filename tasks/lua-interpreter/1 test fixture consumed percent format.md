# 1 — test fixture consumed the percent format

Observed: 2026-10-02 on the GitHub `ubuntu-latest` runner for Kitchen PR #21.

Candidate `1.sh` successfully downloaded the pinned Lua 5.5.1 archive, verified
it, built Lua, installed it, evaluated `6 * 7`, and passed the idempotent rerun.
The workflow then failed in the test intended to prove that an unrelated existing
`PREFIX/bin/lua` was preserved.

The candidate had already refused the conflicting path as required. The failure
was in the fixture itself: the outer shell `printf` used to write the sentinel
script contained `%s` in its own format string. That outer `printf` consumed the
specifier before the sentinel script was written, leaving a script that printed
only a newline. The preservation assertion therefore blamed the installer for a
change it had not made.

The regression fixture now writes `%%s` in the outer format so the generated
script contains the intended `%s`. Keep this case because it demonstrates that a
fixture can create a false failure while the mutation under test is correct.
