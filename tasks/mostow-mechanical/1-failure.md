# First preparation attempt: Grease object interpolation

Attempt 1 stopped before any recipe at `test -x "$ENV.MOSTOW_HOST_COMPILER"`.
Grease interprets `$ENV` as an object, not a scalar interpolation followed by
field lookup. Version 2 binds each environment field to a scalar local before
word interpolation. No build/test result is inferred from attempt 1.
