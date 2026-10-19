# Exact requirement/control qualification

`qualify.pi` is the preparation-to-serving boundary for a complete source-handoff
unit. It does not select semantic requirements or decide whether a test is an
adequate oracle. Those decisions remain owned by AICI.

The qualifier consumes six absolute inputs:

- the unchanged `kitchen-a1-preparation-v1` result from the material preparer;
- an approved `aici-requirement-control-selection-v1` file;
- its `aici-executed-control-evidence-v1` results;
- the final source-handoff unit that would be served;
- the exact AICI-owned verifier named and hashed by the selection; and
- the checked Ithon runtime used to invoke that verifier.

The selected preparation must be `source-test READY`. The selection must bind
the same request, target and requirement projection, name the AICI owner and
verifier interface, and hash the final candidate. The candidate must end in
`# source-handoff-unit=COMPLETE`. Kitchen runs the exact hashed verifier from an
unrelated temporary directory and accepts only a report bound to the selection,
evidence, candidate, parameters, target and full selected-control set.

The resulting `kitchen-qualified-preparation-v1` file exposes three immutable
inputs for the existing transfer-handoff work:

```text
handoff_input<TAB>candidate_sha256<TAB>...
handoff_input<TAB>requirement_selection_sha256<TAB>...
handoff_input<TAB>executed_controls_sha256<TAB>...
```

Changing the candidate, preparation, selection, evidence, verifier, or verifier
report changes the qualified bytes. `verify` reruns the owning verifier and
rejects an old output rather than treating a prior PASS string as execution.

Review, syntax, fixture, target and live evidence remain separate. A qualified
file records source/control qualification only. It does not establish a target
runtime, physical device, delivery, mailbox operation, installation or live
effect.

`tests/source-handoff-qualification.pi` supplies a synthetic AICI verifier only
to stress this Kitchen boundary. Its 13 cases cover exact repeat qualification,
tested-A/served-B, omitted negative controls, unexecuted controls, wrong copy and
move roles, stale requirements, wrong scope, always-refusing candidates,
legitimately excluded scope, newly qualified formatting changes, incomplete
served units and changed evidence bytes. The fixture is not a released AICI
verifier and grants no authority.

The released AICI verifier and approved selections remain A01/A02/A03-owned.
Eligible runtime/closure remains pending under Cat Food #131 and BC-P02.
KITCHEN-HANDOFF-01 owns adoption of these three inputs by the canonical transfer
program; this job does not copy its generator or its independent AICI checker.
