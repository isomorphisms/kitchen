# GitHub organization pin preflight

Kitchen owns the repository-identity checks and exact human-facing explanation for a request to pin repositories on an organization profile. This is a **read-only preflight**, not a pin mutation.

Target execution: a GitHub Actions runner with authenticated `gh`, normally dispatched through the registered Flexible Pipes pipeline `github-organization-pin-preflight`. No Termux checkout or generic shell invocation is required of the user.

GitHub currently exposes `pinnedItems` for reading, but no supported REST or GraphQL mutation for editing organization profile pins. GitHub documents the organization owner's web-interface procedure. Never substitute an undocumented endpoint, assert success because `gh` exited zero, or move a repository between organizations as an implicit side effect of pinning.

Inputs are one destination organization and a comma-separated ordered list of 1–6 full repository names. Reject unsafe names, duplicates, missing/inaccessible repositories, redirected identities, and any repository whose canonical owner differs from the destination organization. Preserve the numeric IDs returned by GitHub. A matching preflight returns `PENDING_UI`, not `PINNED`; it gives the supported browser steps. A mismatch returns `BLOCKED` with nonzero exit status. No path should issue POST, PATCH, PUT, or DELETE.

This contract intentionally blocks `isomorphismes/wegert,functorial-games/spinor`: the second repository is currently owned by `functorial-games`. Moving it to `isomorphismes` would reverse its ownership and requires a separate user-directed transfer operation; it must never be inferred from the pin request.

Run `python3 tests/github-organization-pin-preflight.py` to exercise positive, cross-owner, redirected, duplicate, malformed-input, API failure, and authentication failure fixtures. Flexible Pipes must consume this Kitchen implementation at a checked immutable revision rather than reimplement its decisions.
