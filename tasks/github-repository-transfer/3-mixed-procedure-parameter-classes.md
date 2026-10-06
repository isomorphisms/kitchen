# Candidate 3 mixed procedure parameter classes

Hosted qualification 37410978324 on 2026-10-06 reached the independent personal
fixture and failed immediately: `read-repo` declared its output reference as a
word parameter, while its caller supplied an expression argument. `same-repo`
likewise declared expression inputs in the word parameter section. The generated
artifact failed explicitly and the independent validator rejected it; no
accepted output or live mutation resulted.

Candidate 4 separates word arguments from expression arguments with Grease's
semicolon syntax. These exact procedure interfaces are now probed in the actual
pinned runtime before running the operation. Candidate 3 remains unchanged.
https://github.com/isomorphisms/flexible-pipes/actions/runs/37410978324
