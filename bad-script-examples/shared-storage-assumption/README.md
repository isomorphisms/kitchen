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


## 2026-10-06 recurrence

A Spinor APK sideload diagnostic repeated the same class of mistake in a
stronger form: the generated command guessed `/sdcard/Download` from the fact
that an Android app had made a file available.

Regression additions:

- “downloaded” is not evidence for any specific filesystem path;
- `/sdcard` is commonly emulated shared storage and is not evidence of a
  removable SD card;
- scripts must accept/discover the actual path or URI instead of inventing one;
- when several same-model handsets exist, a model name such as `MIRO A1`
  does not identify the physical device on which the script will run.

See
`incidents/2026-10-06-android-device-and-download-path-assumption.md`.
