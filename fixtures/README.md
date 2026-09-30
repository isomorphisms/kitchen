# Fixtures

Fixtures model the state a command expects to encounter before it is run.

Prefer small disposable directory trees and input files that can express:

- expected files and directories;
- missing paths;
- pre-existing destinations;
- symlinks and broken symlinks;
- spaces, tabs, Unicode and shell metacharacters in names/data;
- read-only or permission-denied cases where practical;
- rerunning after a successful first invocation;
- distinct execution contexts when a local surrogate can model them.

Fixtures are evidence aids, not the source of system semantics.
