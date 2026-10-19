# Version 2 host qualification

Execution date: 2026-10-18 UTC. Host: Ubuntu 24.04.3, Linux 6.18.55,
x86_64. This record covers disposable host fixtures only.

Candidate identities before commit:

- engine Git blob: `05d8112855ec9f17b3a62a1b2a5bcf6b73d85a33`;
- source-handoff test Git blob: `5b9f9a5a2fde8f8a6f7a779fcaae2086a91a7aaa`;
- IB consumer test Git blob: `df20d66c0c45a6f5a4937f35a995171b134aed7f`;
- IB handoff contract Git blob: `d9b9b9740918b141680e32564d0b560c2cdcbb1a`;
- source-handoff requirements Git blob: `e4bc9769036a23f871201c0a5caa8e2bc3839a53`.

`sh tests/source-handoff.sh` returned zero with 36 cases. Cases 1–27
preserved the historical source, checkout, quoting, scope, dirty-state,
replacement-object, runtime-failure and parent-errexit controls. Cases 28–36
exercised a complete two-file manifest, parent and checkout preservation,
unavailable scratch, a successful short-manifest mutant, a failing partial
manifest producer, exhausted extraction output, failed stdout capture,
truncated final emission and sufficient constrained capacity. Both successful
preparations ran from an unrelated directory containing whitespace.

`sh tests/ib-durable-store.sh` returned zero with 23 cases. The original 22 keep
the historical IB runner evidence separate. Case 23 derives a disposable
contract from the maintained IB handoff shape, emits it through source-handoff
version 2, executes the exact served bytes, and confirms that HEAD and working
state remain unchanged.

The injected host failures do not establish physical storage behavior, SDF
locking, Android behavior, IB crash durability or any live-data result. No live
checkout was reset, cleaned or modified by the candidate. A complete host-side
emission is identified by its final `source-handoff-unit=COMPLETE` line; a
partial stream remains blocked even if some preceding bytes reached stdout.
