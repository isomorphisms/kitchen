# Candidate 5 lacked pending-rerun and ENV coverage

Candidate 5 passed ten API scenarios and hosted FP adapters, but those fixtures
supplied no credential override and reconciled an accepted move before the second
execution. They did not prove safety while acceptance remained pending.

On 2026-10-06, aggressive probes showed that `unset GH_TOKEN` does not erase
`ENV.GH_TOKEN` in pinned Grease. Candidate 6 explicitly clears three override
entries, and the fixture rejects any inherited override. Injected values are
disposable strings, never live credentials.

Candidate 6 records task-bound ATTEMPTED intent under `transfer-state` beside the
standalone artifact, before POST. A fresh-home rerun reconciles numeric identity
and original visibility. If ownership remains unverified, it fails without
resending. The new accepted-still-pending fixture requires both calls to fail
with exactly one attempted mutation. The ledger is private worker state, not
acceptance evidence. Root-owned API observations remain authoritative.

The local eleven-fixture diagnostic passed before scratch files disappeared.
Its raw local evidence was lost; qualification must be repeated on the published
candidate and backed by retained hosted evidence. No deployed claim follows.
