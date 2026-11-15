# Candidate 1: incomplete indirect tool identity

On 2026-10-19, syntax and missing/relative/unknown-input rejection were exercised
through the pinned native Grease runtime on the disposable Linux x86_64 host.
Those negative cases behaved as intended; no positive producer/GPU run occurred.

Review found that binding only the Ithon launcher bytes did not bind its source
implementation and host Python selection. Candidate 2 binds the exact Ithon
and Ike source revisions and host Python executable, explicitly selects the
host Ithon boundary, and permits the published multicall `ysh` binary to serve
as both the Grease entrypoint and engine without a new wrapper. Candidate 1 is
retained as preparation history and is not the pipeline entrypoint.
