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

The Idriç six-header selection policy and shared SPEC-LIST fixture are green.
The bounded-memory file scanner is being promoted through CI. Destructive copy,
journal/recovery and source replacement are not yet promoted.
