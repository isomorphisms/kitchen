# GitHub repository fork

Kitchen owns the checked semantics and human-facing form for repository-fork scripts.

## Human-facing form

The canonical human output is a **plain-text paste block of direct `gh` commands**.
It is described by `paste-contract.json` and rendered by
`render-paste-block.py`.

Parameters:

- `source_owner`
- `repository`
- `destination_org`

The repository name is preserved. The renderer deliberately omits `--fork-name` and
uses `--clone=false`. It emits no `sh` invocation and no attached script file.

MicroPython is one ordinary invocation:

```text
source_owner=micropython
repository=micropython
destination_org=dilapidated-shed
```

The exact rendered bytes for that case are stored as a test vector in
`paste-contract.json`.

## Internal historical helper

`1.sh` and its generator are retained as implementation evidence from the first
attempt. They are **not** the user-facing interface. The companion failure note records
why: they crossed the wrong shell boundary.

That older helper also captured stronger refusal behavior around canonical identity,
organization membership, collisions, API rejection, and fork-network verification.
Those requirements remain useful for a future richer Grease/YSH implementation, but the
plain-text paste contract does not claim all of those controls.

## Tests

`python3 tests/github-repository-fork-paste.py` verifies every contract vector, unsafe
name refusal, no shell-interpreter invocation, name preservation, no clone, and exact
bytes.

Flexible Pipes is expected to render the same contract form. Its parity test must check
out the exact Kitchen commit and compare every Kitchen vector byte-for-byte rather than
copying expected strings by hand.
