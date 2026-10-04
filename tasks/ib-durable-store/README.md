# IB ordinary-file baseline, not E2 acceptance

Read `requirements.md`, the incident at
`../../incidents/2026-10-04-ib-unmaterialized-handoff.md`, and Cat Food's
`docs/help/ib.md` before serving a command. `baseline.lock` pins the source and
two blobs that the user actually tested. Version `2.sh` is historical evidence.
New handoffs use `handoff.tsv` with the shared `../source-handoff/1.sh` gate.
Read its requirements and README before emission; request the exact scope
`ordinary-file-baseline`. Any E2 scope must be refused.

Invoke the versioned script with one explicit, reverified IB checkout path using
`sh`. It locates its lock beside itself; the caller's working directory is
irrelevant. Prefer paths supplied by Cat Food's verified `where ib` inventory;
an explicitly known acceptance checkout is also valid. Multiple registered paths
require an explicit choice, not the first line of a search.

For the observed October 4 phone session, the IB checkout was
`/data/data/com.termux/files/home/ib-e2-check`. That is not a default for other
machines. Kitchen's own location and version must also be established before
issuing a fully runnable command; never invent `~/kitchen` or assume installation.

The script reads existing Git objects, extracts and verifies the committed
implementation/test in temporary storage, then runs the two syntax checks and
regression. It does not clone, fetch, switch branches, change tracked/untracked
work, register a path, install anything, or need Grease, Shizuku, root, or ADB.
POSIX sh is intentional for this pre-Grease source diagnostic and the existing
POSIX-compatible IB fixture; it is not a language migration.

Success must include the exact baseline line and both status fields:

    durable ordinary-file store tests: ok
    baseline=PASS
    e2=NOT_RUN

`BLOCKED stage=...` identifies the failed prerequisite or execution stage. A
source block is local evidence, not proof of global nonexistence. The wrapper
never tests or certifies the E2 repair. That repair must first arrive as a
verified, materializable producer handoff. Do not replace its missing commit
with this baseline or infer concurrency safety from the old test.

## Regression evidence

Run `sh tests/ib-durable-store.sh` from a materialized Kitchen checkout. The
suite executes the unchanged version-2 runner against real disposable Git
repositories, replacing only fixture pins in a copied task. Its fixture store is
not the IB implementation. It tests 22 path, source, byte-identity, failure,
working-tree preservation, replacement-object, and shell-survival cases.

Version 1 is retained because it was tested; version 2 adds `mv` to dependency
preflight. See `1 missing mv preflight.md`. A malformed missing-file fixture was
also caught while extending the suite: its implementation pin pointed at an
older blob, so it correctly failed at the blob stage before reaching the intended
missing-file stage. The corrected fixture pins its actual implementation.

The dedicated workflow checks the exact PR head without a path filter. Local
host fixture success is not new physical-phone evidence. Cat Food preserves the
original user's baseline observation separately; neither repository may convert
it into acceptance of this new wrapper or E2.
