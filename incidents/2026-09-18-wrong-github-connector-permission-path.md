# 2026-09-18 — wrong GitHub Connector permission path

## Failure

For repositories owned by a new or different GitHub organization, ChatGPT/Codex repository writes failed even though the GitHub identity was connected and the user had repository permissions.

Earlier troubleshooting repeatedly blurred three different things:

1. GitHub user authorization;
2. installation of the **ChatGPT Codex Connector** GitHub App on the repository owner;
3. repository access granted to that installation.

The recurring bad first answer was to send the user through a generic or owner-specific installation path without first selecting the actual repository owner, or to suggest reconnecting GitHub as though identity authorization were the missing permission.

## Correct procedure

Start at:

https://github.com/apps/chatgpt-codex-connector/installations/select_target

Select the repository owner. Then install or configure the Connector there and grant the required repository access. For the user's working organizations, **All repositories** is the preferred setting so repositories created later do not silently fall outside the installation.

## Regression rule

When a repository is invisible or writes fail with `403 Resource not accessible by integration`:

- do not infer Connector access from the user's `push` or `admin` repository metadata;
- do not treat a successful ChatGPT GitHub login as proof that the GitHub App is installed on the repository owner;
- check the GitHub App installation target and repository selection first;
- use the target selector rather than guessing an installation URL.

The canonical current procedure is:

`tasks/github-chatgpt-codex-connector-access/README.md`
