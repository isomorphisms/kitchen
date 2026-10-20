# Second preparation attempt: environment values in Ike recipes

Ike correctly executed each recipe as an independent Grease source file.
The first Ikefile used ambient shell-variable expansion for environment inputs;
strict Grease requires explicit `ENV` access. `Ikefile.1` preserves that failed
candidate. The corrected Ikefile uses expression interpolation for environment
fields. Both errors propagated through Grease, Ike and FP rather than passing.
