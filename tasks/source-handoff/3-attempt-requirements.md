# K05 candidate: immutable required-stage attempts

This is the candidate writer for the existing pre-Grease POSIX source-handoff
boundary. It does not make POSIX the implementation language for later Grease
procedures. Version 2 remains the maintained source-handoff engine until K05-S03
wires a reviewed caller.

Before any selected operation runs, `begin` must durably create a new attempt
whose positive decimal identity cannot replace an earlier attempt. The attempt
binds an independently supplied required-stage plan, exact source, contract,
control and runtime identities. Plans and raw observation rows use A04's exact
columns; Kitchen does not compute a second aggregate verdict.

Each stage observation is immutable and names its plan actor. The writer retains
raw exit, signal, command, source, producer/log identities, native code and
detail without diagnosing cause. Timeout/interruption and later cleanup or
reporting remain separate rows. A stage can be observed only once per attempt.
Retries use another attempt identity, so later success cannot erase an earlier
failure.

`finalize` emits observations in plan order only when every selected stage has a
record. Otherwise it retains the partial rows and exact missing stage names,
writes an INCOMPLETE finalization receipt, and returns nonzero. Callers must
record descendants as `NOT_RUN`; the writer must not invent evidence for them.
Incomplete observations are input for A04's missing-receipt handling, not PASS.

The writer must reject changed plans, records with the wrong source or actor,
duplicate stage records, reused attempt identities, unknown states and malformed
typed hashes. A harmless optional stage may record empty output with a digest;
empty output alone is neither success nor failure.

This host writer does not establish oracle adequacy, Android authority,
application behavior, deployed Flexible Pipes acceptance or physical-device
execution. K05-S03 owns maintained caller/workflow adoption. The Android writer
requires a new numbered owner version rather than rewriting
`kitchen-android-procedure-receipt-v1`.
