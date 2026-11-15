# Attempt 11 — authenticated receipt path relocation

November 15, 2026. The actual producer's own-runtime receipt contains absolute
`/home/runner/work/ick/ick/` paths. Attempt 11 preserves the original authenticated
receipt and writes an exact two-row path mapping beneath the declared acquired
material root. Other names, duplicate rows, malformed hashes and traversal are
refused. Original compiler/runtime receipt hashes are independently bound.

Native Grease parsing passed. The actual digest-bound Ike invocation was run
against source `34a463354975cdc8dfce4d96edb8d0aa17300968`, archive SHA-256
`8b74fe6725efd8972cb11493f3cb1ae3b8e9005059c010a6e5b7fc4f70f9600e`,
compiler receipt SHA-256
`ce416f1890e8cb400d9f1186cb3a501e6c405f179856bcfa0606f331c6e872a8`,
and runtime receipt SHA-256
`5ec8d5f6ff01d9cb0e60466fd5ebb2044f7a74239069ab6a883bfe8a785123e5`.
The real archive, compiler and relocated own-runtime checks succeeded.

Execution then stopped before compilation: the disposable Debian 13.6 consumer
has working glibc 2.41 but no `dpkg-query` entries for `libc6` or `libc6-dev`.
The old assumption that package-manager metadata was present was false. Ike
preserved the recipe's actual exit 1. The original logs/output remain at
`qualification/native-current-first` with adjacent stdout/stderr in this session.
This is an observed recipe preflight failure, not a C/FFI failure or PASS.

Attempt 12 records absent package-manager metadata separately and requires the
actual resolved compiler/runtime library file hashes before and after execution.
It keeps the compiler, source, oracle and negative controls unchanged.
