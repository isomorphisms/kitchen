# Attempt 9 — repeat native consumer qualification

November 15, 2026. Owner: SUN IB-X64-01.

The old native qualification ran a real maintained Idriç/Chez program through
the ICK C boundary and its negative controls, but the separately observed
compiled Chez hashes differed between fresh outputs. A successful runtime test
must not hide that byte-reproducibility failure.

Attempt 9 wraps the immutable 8.grease recipe. It gives that recipe two fresh
output roots and the same explicit source, compiler, runtime, Grease, Ike and
ICK inputs. It verifies source/material stability and compares four original
output components directly. Both builds' full native tests remain required;
comparison does not replace semantic execution. This is IB-specific orchestration,
not a new generic acceptance policy.

No input or output is normalized. Any mismatch is retained with component hashes
and diagnostic output and causes exit 4. Missing/empty material and reused roots
fail before a reproducibility PASS. Bootstrap compiler reproducibility and the
unfinished desktop/Android/physical evidence remain separate.

Implementation status: source written after 9-requirements.md. On November 15,
the actual native Grease executable from
[Oils run 43520333267](https://github.com/dilapidated-shed/oils/actions/runs/43520333267),
SHA-256 `5991182c9540a8bba58c12bf15965db033b6bcbb59b30f85a8c44000b697382c`,
parsed and exercised the refusal boundary. This is a partial C++-free runtime;
these results do not qualify its entire producer or release.

| Executed case | Exit | Observation |
| --- | --- | --- |
| Native Grease parse-only (`-n`) | 0 | Complete recipe parsed |
| Missing arguments | 2 | Required seven-path diagnostic |
| Relative IB path | 2 | Absolute-path diagnostic; output remained absent |
| Existing output directory | 2 | Existing-root diagnostic; marker bytes preserved |
| Broken output symlink | 2 | Linked-root diagnostic; symlink and missing target preserved |

The existing-directory marker SHA-256 remained
`a0faf8eed8760ddb219724f9b0490ed709ec39d2526e0bf1c3625f73aa47b942`
before and after refusal. The tested recipe SHA-256 was
`ddce71ff7b9fc40d1cc0c1febb6e960010ad50dac3d7b9c8c434b0f7336ba0d7`.
These refusal cases intentionally stop before compiler or ICK access; they are
not a successful native build or component-comparison result.

Actual two-build qualification and component-comparison controls remain
NOT_RUN until the verified compiler and qualified ICK material are supplied.
Do not use a different shell to manufacture a passing result. The historical
compiled-Chez mismatch is not yet attributed to a proven compiler mechanism.
