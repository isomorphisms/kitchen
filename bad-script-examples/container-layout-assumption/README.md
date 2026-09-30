# Container filesystem layout guessed incorrectly

Evidence date: August 26, 2026.

An ARM build wrapper mounted the source tree under a conventional container
home directory. The build environment actually required a target-specific
absolute layout. The job therefore failed before compilation.

Regression: mount paths are part of the build contract. Verify the path expected
by the image before invoking the build; do not substitute a familiar host or
container layout.

This is a reconstruction of the failure mechanism, not a verbatim wrapper.
