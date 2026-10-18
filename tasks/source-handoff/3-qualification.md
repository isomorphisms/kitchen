# BC-K01-S02 source qualification

Execution date: 2026-10-18 UTC. Host: disposable Linux x86_64 workspace.

This candidate is stacked on isomorphisms/kitchen PR #66, “Bind Kitchen
preparation to exact material context,” head
`62fb3c0305be60350a98cbd27ee580d4cc842a31`. That PR is stacked on
isomorphisms/kitchen PR #65, “Make source-test handoffs fail closed on resource
exhaustion,” head `ba7f651e89ae25e831613c8c3fee2f15f73baa54`.

Candidate identities before commit:

- qualifier Git blob: `01fefba5929fee69b6e8b3f626b89dd431f3e06e`;
- qualifier SHA-256:
  `460dbaac66fe7237da5c2c0f9e74ace2e72ae6f8c4f30bf3cdc2357695e70c73`;
- regression Git blob: `4fa5b6147b8373e74f3e02f3bf863e38e588b0c1`;
- synthetic verifier fixture Git blob:
  `296788acc6b8c2cf6e53d4581f2cb2a3c2264973`;
- synthetic verifier fixture SHA-256:
  `3921b44f212da0a10e991c4be505048e4cf7e53c24b10f066d14d317b24bf918`;
- checked Ithon revision:
  `d6e83969f82512e920fb17b44326cb54f31d015c`.

Checks on exact candidate bytes:

- checked-Ithon requirement/control qualification: 13/13 cases passed;
- checked-Ithon material-bound preparation: 15/15 controls passed;
- source-handoff regression: 36/36 cases passed;
- IB source-handoff consumer regression: 23/23 cases passed;
- `git diff --check`: passed.

The 13 new cases cover exact repeat qualification, tested-A/served-B, omitted
negative controls, unexecuted controls, wrong copy/move roles, stale requirement
projection, wrong scope, an always-refusing candidate despite embedded PASS text,
legitimately excluded scope, formatting changes with fresh matching
qualification, incomplete served bytes and changed evidence.

These are source and disposable-host fixture results. The verifier in the test
tree is explicitly synthetic; it proves the Kitchen invocation/binding boundary,
not production AICI authority or semantic adequacy. No Grease runtime, Android
device, SDF mailbox, transfer mutation, delivery or live effect ran. A released
AICI verifier/selection, eligible Cat Food closure and KITCHEN-HANDOFF-01 adoption
remain separate downstream inputs.
