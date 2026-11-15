# ICK producer wrapper attempt 1

The initial thirty-minute producer invocation reached tree-ssa compilation and
was terminated by timeout (exit 124), with no out-of-memory kill. The resume
wrapper then failed before building: this native Grease dialect admits `in`
for dictionaries, not lists. FP run
ib-linux-native-ick-20261014T120347.994512Z records exit 3 and that diagnostic.

ick-2.grease uses an exact one-digit worker-bound check through grep. It invokes
the same pinned AI-CI Makefile, ICK/GCC sources, native Grease and Ike, resuming
the preserved build directory. The failed wrapper remains in ick.grease.
