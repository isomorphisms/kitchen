# Version 5 collection failure

The exact registered host run 39610843230 built the pinned ICK compiler, built
Ike using ICK, and passed the actual producer native tests and preview. Its
producer stage then failed while collecting evidence: GNU find's batched
`-exec ... {} +` requires `{}` immediately before `+`. Version 5 incorrectly
put cp's destination after `{}`. This is a collection failure, not a native
rendering failure, and the FP run correctly failed without sealing acceptance.

Version 6 uses `cp -t DESTINATION {} +`, tested against real fixture files
through the verified native Grease runtime. The old version and its failed
receipt remain evidence. The run also motivates testing actual collection,
rather than treating a successful parse as execution of the collection path.

Evidence: https://github.com/isomorphisms/flexible-pipes/actions/runs/39610843230
artifact 12351737396, ZIP SHA256
6107e4b1d415e27878737b24370c01ac7523ca7dac5b94ad851db4e059eb7ea2.
