# Candidate 3: recipe environment access

On 2026-10-19, admission refusals passed under the actual Grease engine. The real
FP pipeline admitted the exact material set and reached Ike. The pinned parser
accepted the corrected target grammar, wrote an external runner receipt and
executed the Grease recipe. That recipe failed because Grease reads inherited
environment through `ENV`; it does not import arbitrary environment entries as
shell variables. No mathematical test ran in this attempt.

Candidate 4's Ikefile reads `ENV.HOLO_GREASE`, `ENV.HOLO_KITCHEN_RECIPE` and
`ENV.HOLO_CONTEXT`. The hosted Grease workflow uses the same explicit environment
access. The complete local pipeline then passed retained mathematical reference
and independent checker qualification before its genuine missing-ICK blocker.
