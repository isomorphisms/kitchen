# Candidate 6: preserve build-source Git identity

Candidate 5 copied exact Idriç and backend source trees with `git archive`.
Idriç's unchanged `_/Makefile` discovers Git with unscoped `git status`,
`git describe` and `git rev-parse --short=9 HEAD`. Inside a source archive
nested under Flexible Pipes, those commands discover the outer repository.
The source bytes are pinned, but the built compiler's version tag can identify
the wrong repository.

The counterexample used exact Idriç source
`2734ac5a86610eddfab73b1644d72b4ac85a65ee`, archived inside a local Flexible Pipes
worktree at `69d3b6c9ea086075395c60545fff84e92349a0cb`. Running only the owner's
`make --just-print src/IdrisPaths.idr` produced this generated-version command:

```
echo 'export idrisVersion : ((Nat,Nat,Nat), String); idrisVersion = ((0,8,0), "69d3b6c9e")' >> src/IdrisPaths.idr
```

This is an actual Git-discovery/version-generation counterexample; it is not
compiler execution. The current candidate-5 hosted run's compiler version must
be inspected separately when its receipts become available.

Candidate 6 creates detached Git worktrees at the exact source-table commits.
It checks the Idriç identity from both the worktree root and `_/`, checks the
backend identity before copying the maintained application module, and records
the checked identities in `build-source-worktrees.tsv`. The owner's launcher,
Chez acquisition and bootstrap paths accept Git worktree `.git` files: they do
not require a `.git` directory. No version override is supplied.

The actual newly built compiler must emit exactly
`Idris 2, version 0.8.0-2734ac5a8`, before compiler-API installation and afterward.
The generated compiler and backend payload digests remain required. The source
input checkouts remain clean; build changes are confined to the detached run
worktrees. Candidate 5 and its matching Ikefile are retained unchanged.

`test-source-identity.grease` reproduces the archive counterexample and executes
the same owner Makefile dry-run inside a real detached worktree nested in a
different Git repository. It also checks a real detached backend worktree and
the original source identities and cleanliness. This test establishes source
discovery behavior only; native compiler, generation, APK and GPU execution
remain separate stages.
