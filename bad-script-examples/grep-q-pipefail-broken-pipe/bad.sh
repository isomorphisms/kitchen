#!/bin/bash
# INTENTIONALLY BAD. Minimal reproduction of a September 12, 2026 failure.

set -Eeuo pipefail

readelf="${READELF:-llvm-readelf}"
output="${1:-libexample.so}"

"$readelf" -Ws "$output" | grep -Fq 'required_symbol'

echo "symbol present"
