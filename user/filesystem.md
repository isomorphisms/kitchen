# Filesystem preferences

These are user/workflow conventions, not claims that a path exists on every
machine.

- Prefer an `opt`-centred layout for checked-out or manually managed software
  when that matches the established machine state.
- Use the machine's established executable directory rather than inventing a
  conventional `~/bin`. On the MIRO A1 phone, the recorded preference is
  `~/opt/bin`.
- Filesystem state should be inspectable. Prefer explicit files, directories,
  symlinks, timestamps, append logs, permissions, and atomic rename over hidden
  state when those mechanisms fit the problem.
- Preserve paths already established in the session. A generic convention never
  outranks directly observed current state.
- Human-facing scripts should not depend on the caller's current directory.


- On Android, a model name does not identify one physical handset when several
  same-model devices exist. Keep physical-instance identity unresolved unless
  it is established in the current context.
- Do not infer a download location from the fact that an app downloaded or
  exposed a file. Use an observed path/URI or perform explicit discovery.
  In particular, do not assume `/sdcard/Download`; `/sdcard` commonly names
  emulated shared storage rather than a removable SD card.
