# C67 generator: the fetched candidate was readable but `test -r` rejected it

On 2026-10-09 the user ran the merged ten-repository batch on the MIRO C67. Flexible Pipes fetched the pinned Kitchen generator and candidate, verified both Git blob IDs, and admitted the generator by an actual first-line read. The generator then stopped before emitting the first standalone program:

`missing versioned Grease transfer candidate: .../tasks/github-repository-transfer/6.ysh`

That message came from the generator's redundant `test -r "$candidate"` predicate. The candidate had already been fetched and read by the parent batch. No `PROGRAM` line, preflight, or transfer POST occurred; all ten repositories remained under `isomorphisms`.

The repair removes the access predicate and admits candidate 6 through an actual first-line read into a private probe file. It requires the exact `#!/usr/bin/env grease` header before `sed` copies the candidate body into a standalone program. A regression rejects reintroducing `test -r "$candidate"` and requires the read/header checks.

This preserves the boundary: Kitchen still generates every standalone mutation program; Flexible Pipes materializes and orchestrates them. Native-Grease fixtures remain simulation evidence only. Physical C67 live transfer remains NOT_VERIFIED until the user executes the merged pinned batch and GitHub ownership is independently re-read.
