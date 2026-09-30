# Builder environment hid a missing target dependency

Evidence date: August 26, 2026.

A package passed smoke testing in the build environment and then failed on the
phone because the builder already contained a shared library that the target
runtime did not have.

Regression: execution in the builder proves only that the builder can run the
artifact. Target dynamic dependencies and target execution need separate
evidence.

This is a reconstruction of the failure mechanism. The historical target error
identified a missing shared library at program startup.
