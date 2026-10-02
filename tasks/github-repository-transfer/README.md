# GitHub repository transfer

Target context: Termux or another shell where the GitHub CLI `gh` is already
installed and authenticated.

This task exists because repository transfer has two recurring traps:

1. a successful lookup is not proof that an owner/name is canonical; GitHub
   preserves redirects after repository moves;
2. environment variables such as `GH_TOKEN` or `GITHUB_TOKEN` can silently
   select credentials different from the interactive `gh` login.

## Requirements

A transfer script must:

- establish the exact authenticated GitHub login before mutation;
- verify that the source lookup returns an exact `.full_name` match;
- test a possible destination by comparing returned `.full_name`, not by HTTP
  success alone;
- treat a lookup that redirects somewhere else as a redirect, not as a
  destination collision;
- refuse when the exact canonical destination already exists;
- use GitHub's repository transfer endpoint:
  `POST repos/SOURCE_OWNER/REPOSITORY/transfer` with `new_owner`;
- make one transfer request;
- poll until the destination lookup returns the exact canonical destination;
- fail rather than claim success if that postcondition never appears.

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
old-name destination redirect, real destination collision, redirected source,
and wrong-login refusal.


## Recognition rule

When the user asks for the **"GH API move script"**, **"GitHub API move script"**, or asks to move a repository between GitHub owners/organizations, use this task. Do not invent a file-tree copier or recreate repository contents through the Contents or Git Data APIs.

The intended operation is a **repository ownership transfer**, which preserves the repository as a repository: history, issues, pull requests, releases, stars, and redirects remain under GitHub's transfer semantics.

The canonical API operation is:

```sh
gh api --method POST "repos/$source_owner/$repository/transfer" \
  -f "new_owner=$destination_owner"
```

Prefer the checked wrapper in `1.sh`, which verifies authentication, canonical source/destination names, redirect behavior, and the destination postcondition before claiming success.
