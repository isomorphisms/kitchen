# Tests

Tests exist to catch command-generation failures before the human becomes the
test harness.

For each prepared script or nontrivial command sequence, prefer tests for:

1. the intended successful transition;
2. a known-bad precondition;
3. rerun/idempotence behavior;
4. path and quoting edge cases;
5. preservation of unrelated files/state;
6. the postcondition actually claimed to the human.

When a terminal mistake reaches the human, add a regression fixture/test when it
can be represented here.
