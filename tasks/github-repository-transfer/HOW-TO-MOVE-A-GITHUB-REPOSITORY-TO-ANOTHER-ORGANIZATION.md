# How to move a user's GitHub repository to a different organization

**Search phrases:** move user's GitHub repository; transfer GitHub repository to another organization; transfer repo ownership; GitHub API move script; `gh api repos/OWNER/REPO/transfer`.

The primary implementation is **Grease**, not Python or Bash. Kitchen owns the transfer policy, destination checks, generated complete runnable program, and negative fixtures. Flexible Pipes owns the deterministic call to Kitchen, execution, independent verification, and truthful human response.

## Generate and run the entire standalone program

From a verified Kitchen checkout:

```console
grease tasks/github-repository-transfer/render-standalone-github-repository-organization-transfer.ysh \
  isomorphisms switch isomorphismes isomorphisms \
  > move-github-repository-switch-from-isomorphisms-to-isomorphismes.ysh
grease move-github-repository-switch-from-isomorphisms-to-isomorphismes.ysh
```

The four required values are source owner, repository name, destination organization, and expected authenticated GitHub login. The producer binds them into the generated program, which runs without a Kitchen checkout.

For normal automation, prefer [Flexible Pipes](https://github.com/isomorphisms/flexible-pipes/blob/main/docs/how-to-move-the-users-github-repository-to-a-different-organization.md). It calls this generator itself rather than asking the user to hand-assemble a command.

The program preserves GitHub's numeric repository ID; checks authentication, canonical source, administrator permissions, destination organization/membership, collisions, API errors, and final canonical identity. If the old URL already redirects to the destination with the same repository ID, it returns `action=already_transferred` **without another POST**. A transfer POST is requested at most once. A successful HTTP return without identity verification is **not** success.

The older `1.sh` and `generate-transfer-github-repository-script.sh` remain versioned, historical POSIX evidence; do not serve them instead of the Grease path.

## Acceptance rules learned on the physical MIRO C67

The first accepted live batch is retained in
[`C67-LIVE-ACCEPTANCE-2026-10-09.md`](C67-LIVE-ACCEPTANCE-2026-10-09.md).
The operation moved ten repositories to `isomorphismes`; GitHub was then read
independently and every canonical destination retained its original numeric ID.

Use these rules for future generated commands:

1. Run transfer fixtures through a digest-bound native Grease binary. A test
   command named `grease` that invokes `sh` is not Grease acceptance.
2. Fetch and identify source bytes before mutation. For a downloaded script,
   use a bounded actual read plus exact blob/header identity. On the C67,
   redundant Grease `test -r` checks falsely rejected files that `head` read.
3. Materialize, parse, and hash every standalone Kitchen program before the
   first POST in a batch.
4. Preserve API exit status and response bytes separately. Real `gh api` can
   return nonzero while writing a REST error body to stdout.
5. Do not interpret a 404 JSON body as a repository name, and do not collapse
   an unknown API error into “destination absent.”
6. Keep visible delivery, target execution, POST acceptance, per-repository
   identity verification, and aggregate verification as separate claims.
7. A zero exit status or accepted POST is not completion. The accepted
   postcondition is the canonical destination plus the original immutable ID.
8. Use a client surface the user can actually receive. The accepted Android
   handoff used ordinary plain text after fenced code rendered as unavailable.

## Executable evidence

`sh tests/github-repository-transfer-grease.sh` acquires no interpreter itself;
the caller supplies `GREASE_BINARY` pointing to a verified native Grease ELF.
The suite rejects an interpreter shim, witnesses Grease-only syntax and safety
defaults, generates standalone programs, and tests positive, refusal, rerun,
REST-error, and one-POST behavior with fake GitHub responses. Those fixtures
qualify the program behavior under Grease but do not claim a live network
mutation. The physical C67 result and independently verified GitHub state are
recorded separately in the live-acceptance note.
