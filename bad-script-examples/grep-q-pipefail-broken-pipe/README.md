# grep -q plus pipefail creates a false failure

Evidence date: September 12, 2026.

## Observed failure

Two JNI builders used a symbol check equivalent to:

    llvm-readelf -Ws output | grep -q required_symbol

under `set -Eeuo pipefail`.

On sufficiently large symbol output, `grep -q` found the match and exited
early. The producer then saw a closed pipe and returned status 74. Because
`pipefail` propagated that status, the build failed even though the symbol was
present and linking had succeeded.

## Bad specimen

    set -Eeuo pipefail
    llvm-readelf -Ws libexample.so | grep -Fq required_symbol

## Regression

Use enough producer output to trigger early consumer exit. Capture the complete
producer output first, then test it separately, or handle early-close semantics
explicitly.
