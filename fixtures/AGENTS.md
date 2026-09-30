# Agent instructions: fixtures

Inherit the [root instructions](../AGENTS.md) and all intervening directory rules.

Use disposable, synthetic or appropriately redacted inputs as explained in the
[README](README.md). Describe each fixture's intended state, provenance,
expected outcomes and limitations. Keep fixture facts separate from current
machine observations. Link regression fixtures to their incident or contract.

Keep destructive tests inside a verified disposable boundary. Do not use the
user's live mail, home directory, keys or removable storage as test material.
Retain known-bad cases and independent correct counterparts; do not rewrite a
fixture to match a faulty implementation. Any byte-sensitive payload exclusion
from the directory-documentation rule needs explicit scope and review.
