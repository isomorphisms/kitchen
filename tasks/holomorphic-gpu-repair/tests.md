# Tests and fixture review

Record requirements before authoring `1.grease`. Test the exact verified Grease
entrypoint from a directory outside Kitchen.

| Case | Required result |
| --- | --- |
| Relative context | Reject before output creation |
| Missing handoff | Reject before output creation |
| Unknown phase | Reject before output creation |
| Wrong executable digest | Reject before executing it |
| Changed material | Reject before executing producer/checker |
| Existing output | Reject stale-state reuse |
| Actual retained reference | Nonempty unittest results through an Ike receipt |
| Actual AICI checker | Nonempty corpus + independently rejecting semantic mutants |
| Absent ICK executable | Nonzero producer stage; native/GPU classifications remain NOT_RUN |
| Zero exit and missing output | Explicit output postconditions reject success |

The negative input cases exercise admission, not mathematical correctness. The
retained reference and AICI mutant tests exercise their own stated scopes. An
absent compiler is not a successful semantic mutation test. Do not use a mock
compiler or synthetic GPU readback as a positive implementation fixture.
