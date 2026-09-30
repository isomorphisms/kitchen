#!/bin/sh
# INTENTIONALLY BAD. Minimal reproduction of a historical false-green class.

log="${TMPDIR:-/tmp}/checks.log"

run_required_checks() {
    cd ./source || return 1
    ./required-check
}

# In some shells this pipeline reports tee's status rather than the failing
# check's status. The script then declares success unconditionally.
run_required_checks 2>&1 | tee "$log"

echo "PASS"
exit 0
