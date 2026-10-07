# Build adapter version 3

Version 2's added off-device host guard failed in the real verified Grease
runtime: strict_errexit rejects command substitution inside the boolean test
chain because its status would not be checked. Preserve version 2. Resolve
host observations in standalone checked assignments before comparing them.
Reject uncommitted build-adapter, launcher and capture source before creating
output. Preserve the verified r27c tool digests and existing host/A1/C67 recipes.
Record exact source tree, bytes and prebuilt outputs; no S4 authority is implied.
