# Review of candidate 2

Candidate 2 replaces the executable property adapter with Cat Food's explicit
read-only `classify-android-target` interface. It passed the ordinary capture
and hostile control-flow fixtures on Linux x86-64.

Review then found a distinct preservation problem: unconditional force-stop
before the test could interrupt an ordinary active FastChat request, despite
the isolated acceptance store. Candidate 3 refuses exercise while any FastChat
process already runs. It only terminates the process that it launched into the
named deterministic acceptance store. A hostile running-process fixture is
required before serving candidate 3.
