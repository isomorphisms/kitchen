# Version 2: useful consumer checks, incomplete producer boundary

H1 reproduced all 22 original host cases. They exercise a real version-2 runner,
but do not establish that a producer can fetch the promised source. The fixture
creates a local commit and supplies an IB origin string; that string alone does
not prove IB published the commit. The runner also leaves GIT_CONFIG_COUNT and
GIT_CONFIG_PARAMETERS active. Its subshell protects ordinary sourcing but the
served command needs an explicit conditional to survive a caller using errexit.

Keep version 2 and its fixtures as historical evidence. New source handoffs use
the shared source-handoff task and a reviewed contract rather than another
IB-only runner. The shared task separates producer refresh from read-only
consumer execution and binds the requested scope independently of test success.
