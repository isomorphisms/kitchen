# BC-K01-S01 source qualification

Execution date: 2026-10-18 UTC. Host: disposable Linux x86_64 workspace.

This candidate is stacked on Kitchen PR #65 head
`ba7f651e89ae25e831613c8c3fee2f15f73baa54`. Its accepted external
interfaces are:

- AICI requirement projection candidate:
  `cdf6f09dda2828e4d463dab202d66175397dbbd4`;
- Cat Food obligation decision candidate:
  `7f4a3707a63812af1039ad80aea8ad7e86983670`;
- Cat Food profile/request candidate:
  `54bf33c139a67f7db5b9139a349b324c2bc7a3ee`;
- source-handoff version-2 Git blob:
  `05d8112855ec9f17b3a62a1b2a5bcf6b73d85a33`;
- source-handoff version-2 SHA-256:
  `cc79e130ddd4a79e0a1d5b2c7be37e8daf68e7aee5452c5616f538aa137833d9`;
- checked Ithon:
  `d6e83969f82512e920fb17b44326cb54f31d015c`.

Candidate identities for S02:

- preparation adapter Git blob:
  `9f08ff276ea3c570664c67a2b32bd22622dc47b8`;
- preparation adapter SHA-256:
  `3aefbb59a8a49ad72532472033c6611fef2c4931daf951d7d0d5f7c5ceab83fc`;
- regression Git blob:
  `6c9d0b5b38ea229822c0b7587e902acfd06c7fbf`;
- repaired A1 mirror Git blob:
  `1291b3f795f3079b9f751f8b09c0fa135a9f542b`;
- repaired A1 mirror SHA-256:
  `3e364eb6bef4ae87e0b867724fa9211b458738b3a6e81414962a0c147596e031`;
- exact copied AICI projection Git blob:
  `4d81a6ee1f0aacad0f6855f2e8315ac58fa80c1e`;
- exact copied AICI projection SHA-256:
  `a0981c2268ed3ffd4d56d30a429cb1254803dcefb6326e088878355327f8cbe8`.

Checks:

- checked-Ithon regression: 15/15 controls passed from an unrelated path
  containing whitespace;
- source-handoff regression: 36/36 cases passed;
- IB source-handoff consumer regression: 23/23 cases passed;
- `git diff --check`: passed.

The 15 controls cover exact-host and alternate verified paths, wrong host,
preference-only invented path, missing export, stopped service, deterministic
repeat preparation, repeated read-only freshness, completed mutation replay,
corrupt mirror, changed profile, stale correction, and changed material.

These results exercise source and disposable host fixtures. They do not prove
physical A1 identity, Shizuku authority/service behavior, Android diagnostic
capture, installation, managed mutation, or device acceptance.
