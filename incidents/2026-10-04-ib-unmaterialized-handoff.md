# October 4: IB test served before source and context were verified

The assistant served `sh tests/test_durable_object_store.grease` for an E2 repair
without establishing that the user's checkout contained the repair. The quoted
commit `5184f62fb9183f300cde615fa06ca0cfa561040c` could not be resolved by the
GitHub read or in the subsequently fetched phone checkout. It may have been a
local-only or otherwise unavailable commit; no recovered repair is established.

Further escaped errors compounded the source problem: Git was run outside a
repository; that failure was mislabeled as an unavailable commit; a narrow HOME
search was promoted into a claim that no checkout existed; pasted top-level
`exit 1` logged the human out; and a second clone attempt stopped merely because
`~/ib-e2-check` already existed. The existing checkout should have been verified
and reused. No conclusion about all storage follows from a failed narrow search.

The eventual user-pasted result was:

    HEAD: f1f22778fb66f7219c13ba864c13b03be10cfea8
    durable ordinary-file store tests: ok

The preceding command checked implementation blob
`bdabc03428d7e7d9b7f098b3dc61321798d9dc74` and test blob
`b7147483cea50e095193e7e59609091efe2a3aa4` and ran both syntax checks. This is the
older ordinary-file baseline, not repaired no-replace publication. Its success
must not release the E2-A prerequisite or imply concurrent-writer, bounded-reader,
source-growth, low-space, owner-cleanup, APK, or crash-durability acceptance.

Cat Food owns the dated machine/path observation in
`docs/observations/miro-a1-ib-baseline-2026-10-04.tsv`; registration on the phone
was not performed by this follow-up. Kitchen owns `tasks/ib-durable-store/` and
its 22-case executable regression. Cat Food's actual `where`/`register`/`help`
entrypoint has a separate 9-case regression. No new phone provisioning is needed
to establish the reported baseline, and no installed update is claimed.

Before a future repair handoff, the producer must verify remotely retrievable
source or a usable exact artifact, both implementation and test identities, and
the exact wrapper. Downstream work must block rather than silently use older
source. Distinguish wrong directory, missing checkout, unavailable source,
missing file, syntax error, failed execution, and passed baseline. Use explicit
verified paths, preserve existing work, keep exit inside a child/subshell, and
exercise the command twice from outside the checkout before serving it.
