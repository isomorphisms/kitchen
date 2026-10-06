# Candidate 4 used a removed status register

Local artifact diagnostic `qualification/candidate4-local-b` on 2026-10-06
generated identical bytes, authenticated and verified numeric identity, source
capability and a personal destination. The destination lookup correctly returned
NOT_FOUND, but `_status` was undefined in pinned Grease source 6d29702a. The
independent validator rejected both executions with zero mutations.

Candidate 5 reads `_error.code`, the verified register produced by `try`. A
read-only Grease probe also established `.lower()` for string comparison; `->`
selects mutating methods and is inappropriate here. The diagnostic's preceding
attempt `candidate4-local-a` instead exposed inherited Python-2 vendor imports
in the test harness. That harness now clears those variables for Ithon children.
Neither attempt qualifies worker isolation or deployed execution.
