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
