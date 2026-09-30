# Shared-storage availability assumed instead of checked

Evidence date: December 16, 2025.

A generated mobile-shell automation attempted to place an output file in shared
user storage and immediately hand it to another app. The first step failed
because the required storage access was not established, and the follow-on step
failed as a consequence.

Regression: distinguish missing storage binding, insufficient access, missing
source file, successful placement, and successful handoff. A failed placement
must stop the later action.

The exact historical script is not fully recovered; this preserves the observed
failure mechanism.
