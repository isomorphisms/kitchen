# Grease / YSH preparation notes

Grease/YSH must not be treated as generic POSIX `sh`.

Before serving code:

- check the syntax against the actual Grease/YSH surface being used;
- preserve the user's spelling conventions rather than reverting to familiar
  shell abbreviations;
- do not assume Bash-only syntax, startup files, option names, arrays, quoting,
  or command-substitution behavior;
- when an inherited YSH/Oils implementation detail matters, name it as an
  implementation boundary rather than silently changing the user-facing shell
  back to YSH;
- test quoting, whitespace, missing paths, existing destinations, and reruns.

If the exact Grease/YSH feature is uncertain, verify it or produce a probe/test
rather than substituting a POSIX-shell approximation.
