# Hosted fixture dependency

The first hosted FC-M4 fixture run on 2026-10-14 acquired and verified the real
native Grease runtime and passed the shared transfer checks. Classification
then stopped because the Ubuntu runner had no `rg` command. Local fixture
success had depended on the preparation host's installed ripgrep.

Evidence: https://github.com/isomorphisms/kitchen/actions/runs/38562090112

The workflow now installs the declared fixture source-search dependency before
classification and device-control execution. The missing command was a test
environment defect. It did not exercise the twelve device-control cases and
was not physical-device evidence. The candidate procedure remains version 3;
this repair changes its hosted verification environment, not its behavior.
