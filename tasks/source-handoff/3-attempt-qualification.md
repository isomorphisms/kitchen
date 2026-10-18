# K05 attempt-writer host qualification

Execution date: 2026-10-18 UTC. Host: Ubuntu 24.04, Linux 6.18.55,
x86_64. Base dependency: Kitchen PR #65 exact head
`ba7f651e89ae25e831613c8c3fee2f15f73baa54`.

Candidate Git blob identities before commit:

- writer: `5bd0ee85ff5e9e32c64ab430a6dcd46b10df2f5c`;
- requirements: `f354d8fc17377818027a6970ff7985b8c9919c0f`;
- A04 mapping: `517214c4b5499c13e397405da5ac6802ed6b6d18`;
- plan example: `1c0231df420ad19cdda91cf6477ce5ea04b01b33`;
- failed-observations example: `c69e80c5fe2db95b411b4a5f5bfbed0bac0c1e1f`;
- independent controls: `dbe5f1d44b409102ea91ae4a3a54f80c5fe4e106`.

`sh tests/source-handoff-attempts.sh` passed all 16 cases. They cover an
observation existing before effects, a complete run, attempt and stage
non-overwrite, setup failure with dependent `NOT_RUN`, omitted rows, changed
plan and stage evidence, wrong plan/source/actor, interruption, forged success
text with a retained nonzero exit, timeout with separately successful cleanup
and reporting, permitted empty optional output, and distinct attempts over equal
immutable inputs.

The unchanged maintained regressions also passed: 36 source-handoff cases and
23 IB durable-store cases. `sh -n` accepted the writer and its controls. The
conditional parent-survival behavior remains covered by source-handoff case 25.

The failed example was also passed unchanged to A04 PR #286 exact head
`a9595ec901268dca0ebee99f594e0e8797668c39`. A strict C17 host compilation of
its `aici_stage_verdict.c` returned the expected status 1 with first required
failure `setup` and disposition `REJECT_SCOPE`. This compatibility check used
the host compiler; A04's own hosted qualification remains the authority for its
compiler and adapter.

These are disposable host controls. The candidate is not wired into maintained
callers or Android v1 receipts, and does not establish oracle adequacy,
physical-device behavior, runtime eligibility or an A04 aggregate verdict.
