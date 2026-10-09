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

The program preserves GitHub's numeric repository ID; checks authentication, canonical source, administrator permissions, destination organization/membership, collisions, API errors, and final canonical identity. If the source URL already redirects to the destination with the same repository ID, it returns `action=already_transferred` **without another POST**. A transfer POST is requested at most once. A successful HTTP return without identity verification is **not** success.

The older `1.sh` and `generate-transfer-github-repository-script.sh` remain versioned, historical POSIX evidence; do not serve them instead of the Grease path.

Offline compatibility fixtures: `sh tests/github-repository-transfer-grease.sh`. The fixture interpreter does not certify execution under the actual Grease binary.
