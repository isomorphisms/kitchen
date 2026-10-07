# Version 1 fixture history and unfinished integration

Requirements and the invariant-keyed hostile corpus were written before the
candidate. The selected checked-Ithon line rejects unknown method-result types;
explicit intermediate types fixed those errors. Its `--check` CLI does not
exist: actual checked module execution, including refusal from argument parsing,
was used. No unchecked Python execution is counted as Ithon evidence.

The initial runtime manifest fixture generated `ithon-Lib-...`, while the parser
requires lowercase role identifiers. The parser correctly rejected it. The full
initial ledger contains FAIL, not fabricated successes. Lowercasing fixture role
names repaired the fixture. Tests run during a wrapper revision became stale;
only the subsequent complete run against frozen bytes qualifies the candidate.

The fixture admission/executor/validator are deliberately not Cat Food production
code. Host wrong-device, ABI, freshness, signer and downgrade cases prove that
Kitchen obeys owner refusals before executor calls; they do not qualify Cat Food
policy semantics. URI tests prove location data is passed intact rather than
interpreted by Kitchen. S2/S3/S4 adapters must replace this fixture protocol in a
new version. No production-enabling flag exists in version 1.

An admission/validator returning zero without a typed postcondition is refused.
An executor changing an immutable input and a validator rewriting the prior owner
receipt are refused after their exact bytes are independently rehashed. The
cleared environment prevents ambient Ithon, Python module and Cat Food target
selectors from choosing a runtime or device. This is exact-byte selection and
stage/postcondition evidence, not a sandbox or proof of arbitrary adapter honesty.
