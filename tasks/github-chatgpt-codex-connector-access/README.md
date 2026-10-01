# ChatGPT Codex Connector repository access

Use this when ChatGPT/Codex can authenticate to GitHub but cannot see or write a repository, especially after creating a new GitHub organization or moving a repository to another owner.

Verified 2026-10-01.

## Correct entry point

Open:

https://github.com/apps/chatgpt-codex-connector/installations/select_target

Then:

1. Select the account or organization that **owns the repository**.
2. For a new owner with no installation, install **ChatGPT Codex Connector** there.
3. For an owner where it is already installed, configure that installation.
4. Under repository access, choose **All repositories** for owners where ChatGPT/Codex is expected to work generally.
5. Save the installation/configuration.
6. Retry repository discovery or the write that previously failed.

For the `ib-pensieve` organization, select `ib-pensieve` and grant **All repositories**.

## Why this is the recurring fix

GitHub user authorization and GitHub App installation are different things.

A GitHub login can be connected successfully while the ChatGPT Codex Connector is not installed on the repository owner. Likewise, a user may have `push` or `admin` permission to a repository while the Connector installation still lacks access to it.

The installation is scoped to a GitHub account or organization and its selected repositories. Creating a new organization or transferring a repository to another owner can therefore require a new installation/configuration step.

## Wrong first answers to avoid

Do not treat any of these as sufficient:

- reconnecting the GitHub identity in ChatGPT;
- the user's ordinary GitHub `push` or `admin` permission;
- adding the user as a collaborator;
- changing repository team permissions;
- creating a PAT;
- assuming an installation on another account or organization covers this owner.

Do not start from a hard-coded owner-specific installation URL. Use the target selector above so GitHub can route to either installation or configuration for the owner selected.

## Verification

After saving, the installation should be visible from GitHub's installed-app settings:

https://github.com/settings/installations

For an organization, it can also be checked from that organization's settings under installed GitHub Apps.

The real postcondition is not merely that GitHub says the user is connected. The repository should become visible to the Connector and a permitted write should stop failing with `403 Resource not accessible by integration`.

## Upstream

GitHub App:

https://github.com/apps/chatgpt-codex-connector
