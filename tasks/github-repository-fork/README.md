# GitHub repository fork

Target context: Termux or another shell with GitHub CLI `gh` installed and
authenticated.

This task creates a GitHub fork under a destination organization while preserving the
repository name. It exists to avoid ambiguous browser/manual state and to verify that
the destination is actually in the expected fork network.

## Requirements

The checked helper must:

- establish the exact authenticated GitHub login before mutation;
- verify the source lookup resolves to the requested canonical owner/repository;
- resolve the destination organization and verify active membership;
- treat an existing destination as success only when it is already a fork whose
  source network is the requested source;
- refuse an unrelated repository collision at the destination name;
- issue exactly one `POST repos/SOURCE/REPOSITORY/forks` with the destination
  organization and unchanged repository name;
- request a full fork rather than a default-branch-only fork;
- surface GitHub's API error if the fork request is rejected;
- poll until the destination exists and verifies both its canonical name and source
  fork network;
- fail rather than claim success when the verified destination never appears.

## Human-facing generation

The numbered candidate `1.sh` is Kitchen evidence, not the normal interface.
Generate a standalone, parameter-bound script:

```sh
sh tasks/github-repository-fork/generate-fork-github-repository-script.sh \
  SOURCE_OWNER REPOSITORY DESTINATION_ORGANIZATION EXPECTED_LOGIN
```

For MicroPython:

```sh
sh tasks/github-repository-fork/generate-fork-github-repository-script.sh \
  micropython micropython dilapidated-shed isomorphisms
```

This produces:

```text
fork-micropython-from-micropython-into-dilapidated-shed.sh
```

Run `sh tests/github-repository-fork.sh` for generator, normal fork,
already-correct idempotence, unrelated collision, redirected source, wrong login,
organization/membership failures, API rejection, and wrong-network regressions.
