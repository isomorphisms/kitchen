# GitHub repository transfer

Target context: Termux or another shell where the GitHub CLI `gh` is already
installed and authenticated.

This task exists because repository transfer has several recurring traps:

1. a successful lookup is not proof that an owner/name is canonical; GitHub
   preserves redirects after repository moves;
2. environment variables such as `GH_TOKEN` or `GITHUB_TOKEN` can silently
   select credentials different from the interactive `gh` login;
3. a destination organization can exist while the authenticated account is not
   an active member or cannot see that membership through its current `gh`
   authentication;
4. GitHub owner/repository names are case-insensitive, so exact shell string
   comparisons can reject a valid canonical owner merely because of casing;
5. a transfer POST can be rejected before any destination appears, and that
   API error must be shown rather than disappearing behind `set -e`.

## Requirements

The checked helper is for transfers into GitHub organizations. It must:

- establish the exact authenticated GitHub login before mutation;
- verify that the source lookup resolves to the requested owner/repository,
  comparing names case-insensitively while retaining GitHub's canonical casing;
- resolve and print the canonical destination organization login;
- verify that the authenticated user has an active membership in that
  destination organization before mutation;
- test a possible destination by comparing returned `.full_name`, not by HTTP
  success alone;
- treat a lookup that redirects somewhere else as a redirect, not as a
  destination collision;
- refuse when the canonical destination already exists;
- use GitHub's repository transfer endpoint:
  `POST repos/SOURCE_OWNER/REPOSITORY/transfer` with `new_owner`;
- surface GitHub's transfer error if the POST fails;
- make one transfer request;
- poll until the destination lookup returns the canonical destination;
- fail rather than claim success if that postcondition never appears, reporting
  what the old source path resolves to after the polling window.

GitHub requires administrator access to the source repository. For a transfer
into an organization, the authenticated user must also have permission to
create a repository in that organization.

Cat Food does not currently promise that `gh` is installed on every target, so
this script checks for it rather than assuming deployment state.

## Candidate

`1.sh` takes:

```
SOURCE_OWNER REPOSITORY DESTINATION_OWNER EXPECTED_LOGIN
```

For the current Append FAT move:

```sh
sh tasks/github-repository-transfer/1.sh \
  fuego-ironworks sd-card-append-fat isomorphisms isomorphisms
```

Run `sh tests/github-repository-transfer.sh` to exercise the normal case,
canonical-owner casing, old-name destination redirect, real destination
collision, redirected source, wrong-login refusal, inaccessible destination
organization, missing organization membership, and a rejected transfer POST.

## Recognition rule

When the user asks for the **"GH API move script"**, **"GitHub API move script"**,
or asks to move a repository between GitHub owners/organizations, use this task.
Do not invent a file-tree copier or recreate repository contents through the
Contents or Git Data APIs.

The intended operation is a **repository ownership transfer**, which preserves
the repository as a repository: history, issues, pull requests, releases, stars,
and redirects remain under GitHub's transfer semantics.

The canonical API operation is:

```sh
gh api --method POST "repos/$source_owner/$repository/transfer" \
  -f "new_owner=$destination_owner"
```

Prefer the checked wrapper in `1.sh`, which verifies authentication,
source/destination identity, destination organization membership, redirect
behavior, API rejection, and the destination postcondition before claiming
success.
