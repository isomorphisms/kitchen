# SDF SPEC-LIST refile

This task prepares the live filing operation for the SDF mailbox. Domain code,
fixtures and cross-language conformance belong in `isomorphisms/mbox`; Kitchen
owns the operational promotion gate.

## Fixed intent

Source:

`/var/mail/isomorphisms`

Archive:

`~/Mail/spec-list`

Final effect:

Move selected source occurrences into the archive while preserving every
unselected occurrence and any safely observed append-only new source tail.

The match policy is ASCII-case-insensitive `SPEC-LIST` in exactly these ordinary
RFC header fields:

- `From`
- `Sender`
- `Reply-To`
- `To`
- `Cc`
- `Subject`

Body text and other fields, including `List-*` and `Delivered-To`, do not
select a message.

Occurrence identity matters. Equal bytes and reused `Message-ID` values do not
collapse two source occurrences into one.

## Preferred implementation

Idriç/Edriç is the preferred executor.

The D branch is an independent implementation and performance cross-check. It
must not become the live fallback merely because it has more systems code if its
transaction semantics do not pass the same recovery corpus.

## Promotion stages

### 1. Selection

Required:

- shared fixture checksums pass;
- framing fixture runtime check passes;
- exact 14-message SPEC-LIST fixture passes by expected identities;
- body-only and wrong-header negatives pass.

This stage authorizes no writes.

### 2. Read-only real-file scan

Required:

- bounded-memory binary input;
- same streaming framer and selection policy as the shared fixtures;
- deterministic selected occurrence ranges/count;
- source file remains unchanged.

This stage authorizes no writes.

### 3. Copy transaction on disposable fixtures

Required:

- byte-identical selected occurrence copy;
- multiplicity preservation;
- durable archive append;
- durable journal or equivalent recovery evidence;
- prepared, mid-archive and archive-fsynced restart fixtures pass;
- preexisting equal archive bytes never stand in for a source occurrence.

### 4. Source rewrite on disposable fixtures

Required:

- unselected source bytes preserved;
- recorded selected ranges removed only after durable archive evidence;
- append-only new source tail preserved;
- changed original source prefix causes refusal;
- rerun/recovery does not duplicate transaction occurrences.

### 5. SDF preflight

Run `probes/sdf-mailbox-refile.sh` and record:

- actual host/kernel;
- account groups;
- `/var/mail` and source ownership/modes;
- free space;
- actual local-delivery lock policy;
- ability implied by permissions to create/replace the source safely.

Do not infer the delivery lock from generic Unix practice.

### 6. Live move

Only the exact executable and wrapper that passed stages 1–5 may be installed in
the established SDF executable directory `~/opt/bin`.

The first live invocation must print a read-only plan before mutation and refuse
on source/archive aliasing, an unresolved prior transaction, unsupported lock
policy, insufficient permissions, or insufficient workspace.

## Current status

Stages 1 and 2 are green in Idriç:

- the exact six-header selection policy passes the 14-message shared fixture;
- body-only and wrong-header negatives pass;
- the full mbox framing + selection composition passes;
- the bounded-memory binary file scanner compiles and reads the shared mailbox
  through real file I/O, reporting exactly nine selected occurrences.

Destructive copy, journal/recovery and source replacement are not yet promoted.
The live SDF move remains blocked on those transaction tests and the read-only
SDF locking/permission preflight.

## Disposable hardening reference, 2026-10-06

`requirements.md` states the operational handoff contract. `1.py` is the exact
numbered wrapper; `test_handoff.py` executes it from unrelated directories,
checks byte results, error propagation and reruns. `gate.py qualify` runs the
wrapper suite, mbox's full reference suite including large resource fixtures,
and actual edited-executor mutants before issuing a content/argument-bound TSV
receipt. `verify` refuses any changed wrapper, parser, selector, fixture, tested
path, source/destination role or mode. It emits a sealed argv record, not another
shell wrapper. An outer untested wrapper is outside the receipt.

The mbox Python reference is a narrow fallback corpus consumer: the maintained
Idriç compiler/runtime was unavailable in this job, and Idriç's filesystem
transaction effects remain unimplemented. Reference passes do not count as Idriç
or D passes. The wrapper permits only read-only live plans and explicitly marked
disposable transactions. Cat Food now provides `probes/sdf_mailbox.py` for actual
NetBSD host evidence; this job did not execute it on SDF.

Read-only scan candidate: locally qualified Python bytes, pending actual SDF
Python/path/readability checks. Live move/archive: BLOCKED by target delivery
locks, target execution and standard-bearer transaction implementation. The
historical stage-1/2 Idriç results above are not new execution evidence.
