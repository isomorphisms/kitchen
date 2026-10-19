# Candidate 3 confused origin spelling with repository identity

The third hosted run on 2026-10-14 passed classification and then refused the
first capture preflight at the Cat Food origin check. GitHub's checkout action
records `https://github.com/isomorphisms/catfood`; candidate 3 required the same
repository URL with `.git`. Local fixtures used the latter spelling and did not
expose this representation error.

Evidence: https://github.com/isomorphisms/kitchen/actions/runs/38562632824

Candidate 4 permits the two exact observed HTTPS URLs for the required owner
and repository. It still rejects every other origin before device operations.
The fixture suite adds an isolated local clone with the no-suffix spelling and
a different-owner negative case. It does not change the real control checkout's
origin. Candidate 3 is retained unchanged as failure evidence.
