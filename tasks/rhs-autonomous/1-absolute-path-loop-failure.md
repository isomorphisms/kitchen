# Version 1 rejected valid absolute paths

The real native hosted path failed before AI-CI execution in RHS run 38570599667, artifact 11897906676. The admitted stage supplied four absolute paths, but Grease interpreted the bracketed `for ... in` words as shell words rather than evaluating a list expression. The earlier relative-path rejection did not expose that defect.

Version 2 checks each named path explicitly. Its separate fixture test must execute a successful absolute-path call through the actual owner Grease runtime, prove checker preflight precedes checker execution, and reject relative paths and missing dependencies. Fixture sequencing evidence is not compiler or RHS acceptance.
