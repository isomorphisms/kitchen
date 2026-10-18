# Version 3 — distinguish source dirtiness from generated output

Reviewing the pinned checkouts established that rough.framebuffer has no root
gitignore, ai-ci does not ignore `subpixel/build`, and ICK ignores only `build`.
Version 3's repeated untracked-file check would therefore reject its own genuine
outputs after bootstrap/preview. This was found from exact source files before
the expensive compiler stage, not observed as a numerical failure.

Version 4 keeps the input-dirtiness rejection and excludes only the particular
operation-owned output directories in each repository. All those directories,
including materialized ICK `source`, must be absent at initial preflight. No
existing outputs are deleted or adopted. All tracked-input changes still fail.
