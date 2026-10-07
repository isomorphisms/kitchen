# Version 2 host guard failed under Grease strict_errexit

The initial version 2 off-device recipe compiled both ABI candidates before a
host guard was added. After that guard, committed version 2 failed before output
creation on all three requested host/A1/C67 invocations. Grease reported:
`Command subs not allowed here because status wouldn't be checked (strict_errexit)`.

Earlier cross-built bytes are preserved as historical candidates; they are not
counted as committed version 2 build success. Version 3 uses checked observation
assignments and rejects uncommitted build/task/launcher source. Requirements for
version 3 precede its candidate. No alternate shell was used to make this pass.
