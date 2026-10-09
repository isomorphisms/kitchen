# Candidate 4: quoted case pattern was not valid YSH

Hosted native-Grease CI run 38002560892 rejected candidate 4 during parse, before any fixture POST:

`Invalid quoted word part in YSH (OILS-ERR-17)`

The invalid source was the shell-style `case` pattern used to recognize the literal JSON fragment `"status":"404"`. This was caught before user delivery and before mutation.

Candidate 5 preserves candidate 4 and uses `grep -F` under Grease `try/_error` to recognize the exact `"status":"404"` fragment. A non-404 API body still fails closed.

The fixture continues to reproduce the user's real Termux observation: `gh api` emits a 404 REST JSON body on stdout and exits nonzero.
