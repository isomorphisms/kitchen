# IB ordinary-file baseline requirements

Target: ordinary, unprivileged MIRO A1 Termux. Host fixtures are not phone evidence.
This is a source-test diagnostic, not product provisioning or E2 acceptance.

1. Accept an explicit existing checkout path. Do not infer a path from the current
   directory, scan HOME, clone, fetch, switch, reset, clean, or install anything.
2. Verify a checkout root and its IB origin before looking up source. A missing
   directory, partial clone, wrong repository, missing commit, missing file,
   wrong blob, syntax failure, and failed test must remain distinct failures.
3. Materialize the exact commit's two pinned blobs in a fresh temporary directory.
   Do not run dirty working-tree files, another branch's lookalike test, or a Git
   replacement object. Verify extracted bytes before executing them.
4. Repeated runs, paths with spaces, and running outside a repository must work.
   Preserve the user's HEAD, index, files, and current directory. Clean only the
   invocation's own temporary directory. Failure must not exit a login shell.
5. Require both syntax checks, actual test execution, zero status, and the exact
   baseline success line. Never promote this result into E2, concurrency,
   crash-durability, APK, or new physical-device acceptance.
6. Unknown tools are a dependency block, not permission to install a toolchain.
7. Keep the failed handoff and the user's successful baseline as dated evidence.
   Local source absence is not proof that a commit never existed anywhere.
8. Before serving a repair test, its producer must publish/materialize the exact
   repair source and test, verify their identities, and test the exact wrapper.
   A local-only commit mentioned in chat is not a runnable downstream prerequisite.

Tests use real disposable Git repositories and fixture pins in a copied task.
They do not modify the runner and do not count as IB implementation acceptance.
