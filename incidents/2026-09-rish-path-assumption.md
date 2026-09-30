# rish path assumption on Termux

## Failure

A command sequence was served using `~/bin/rish` and
`~/bin/rish_shizuku.dex` even though that path had not been established on the
target and the surrounding session contained contrary filesystem evidence.

The resulting `chmod` operations failed because the files were not there.

## Wrong assumption

A conventional-looking home `bin` directory was substituted for observed
device state.

The relevant device notes instead place Shizuku's exported files under
`~/storage/shared/Shizuku` with a convenience link at `~/opt/Shizuku`, while
the phone's preferred private executable area is `~/opt/bin`.

## Preparation that should have caught it

Before serving any mutation:

1. load the MIRO A1 Termux system note;
2. establish the actual rish source path;
3. establish the intended private destination;
4. fixture the cases “source exists”, “destination missing”, “destination
   already exists”, and “rerun”;
5. test the copy/link/permission transition in disposable state;
6. pair the real mutation with direct path and permission verification.

## Regression requirement

No terminal recipe may invent `~/bin`, `~/opt/bin`, or another executable
directory from convention alone. The target-specific path must be observed,
recorded, or explicitly created as part of the tested operation.
