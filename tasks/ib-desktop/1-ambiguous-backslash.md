# Attempt 1 — explicit text escapes

The real native Grease parser refused the record-separator path check with
OILS-ERR-20: ambiguous backslash. In expression mode this runtime requires an
explicit Unicode or raw string prefix. No implementation ran. Attempt 2 uses
u'\\n', u'\\r' and u'\\t' for those three character checks; the shell and
compiler are unchanged. The failed source remains preserved as 1.grease.
