# Build succeeded but artifact lookup searched the wrong tree

Evidence date: August 25, 2026.

A CI helper looked for the Android package near the repository root even though
the build produced it deeper under the application build-output tree. The build
could therefore succeed while the packaging/handoff step reported no artifact.

Regression: artifact location comes from the build contract, not from a generic
repository-root guess. Include a root-level decoy and the real nested artifact
in the fixture.

This is a reconstruction of the failure mechanism, not a verbatim helper.
