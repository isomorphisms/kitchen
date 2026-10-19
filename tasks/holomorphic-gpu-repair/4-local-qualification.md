# Candidate 4: local execution evidence

On 2026-10-19 at 17:31 UTC, the actual named Flexible Pipes pipeline executed
candidate 4 through the verified native Grease engine and pinned Ike binary.
Source/material/tool preflight passed. The retained reference ran 11 tests and
passed. Independent checked-Ithon qualification ran 31 cases, rejected 10
evaluator mutants and five provenance mutants, checked missing output and its
synthetic numerical-log parser, and passed. These are host reference/checker
results, not producer or GPU acceptance.

The real producer stage stopped with `missing-exact-ICK-host-compiler`. Its Ike
receipt records FAIL. Runtime-source-binding C, E1 native sampler, generated
compiler, APK, emulator, A1, C67, TAB_P10 and sustained performance remain NOT_RUN.
No generic compiler, synthetic producer output or alternate renderer was used.

The final admission run refused relative context, unknown phase, missing input,
wrong executable identity and changed material for their intended diagnoses.
A direct repeat of preflight refused the existing output directory with exit 2.
An earlier admission run also caught source revisions moving while other work
was being committed; those stale snapshots were never admitted.

Local application commit 47b0a0b99a55165cde9bcc2d82b8450f6647ed34 has source tree
d5a301e01714b9ca7272c04cbd25a81ec34d0315. Local AICI commit
219eae6b847b24839649e2662386eb5653d4b088 has source tree
5f1547828d2f4eb8c072771db9f94ffbfc43b8da. The pipeline source SHA-256 was
23b3b09efa12f01d5fec27f9eaa8f2a91ad607461bba96f86c321077cba9d240.
Its FP checkout parent was c240c4c8b3b3ccc3c90bc63446578377a20ac671; the new
pipeline files were digest-bound working-tree inputs, not a published FP commit.

Grease entrypoint SHA-256:
37088097c36a2f82cf45aaea9392e4a4cf16155fecb9da87d08a9c7fb4d92e4a.
Its multicall engine SHA-256:
7e31cd05b7a9d8fb2a4a9e003a7f3fcb0159138506d17f0fb28da8cbe22aa85c.
Ike binary SHA-256:
ecf8b281b4c233aefb61a4720566f24e9d7407108dd3ee5354310475ede7827d.
The traced host required ASAN_OPTIONS=detect_leaks=0; no Grease leak-safety
qualification is claimed.
