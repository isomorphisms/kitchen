# Attempt 4 — native Grease word quoting

Fresh/reused-output refusal worked, but a real apostrophe path exposed an
incorrect POSIX-style quote splice in the Ikefile recipe. Native Grease refused
the quoted word (OILS-ERR-17) before checking source. The failed FP run is retained.

Attempts 5 (source) and 6 (native) use actual Grease Unicode literals u'...'
with explicit backslash and apostrophe escapes. Their execution must pass with
spaces, apostrophes and Unicode in output paths. The earlier sources remain
preserved. The independently qualified ICK producer wrapper ick-4.grease uses
the same source-file encoding.
