# Bad script examples

These are intentionally bad examples preserved as regression seeds.

They come from failures in assistant-written terminal instructions and scripts.
Personal names, hostnames, addresses, paths and data have been replaced with
synthetic values. Unless a file explicitly says otherwise, it is a **minimal
reconstruction of the failure class**, not a claim that this exact byte sequence
was the original script.

Do not run these as setup instructions.

Each example should eventually acquire a fixture and test that:

1. reproduces the failure;
2. rejects the bad specimen;
3. accepts a corrected counterpart; and
4. records which Kitchen rule would have prevented it.

Initial examples:

- `invented-home-bin/` — guessed a conventional executable directory instead of using observed state;
- `wrong-execution-host/` — generated a transfer/download recipe for the wrong machine and could transfer a host to itself;
- `python-pasted-as-shell/` — delivered source in a form that could be pasted directly into a shell and interpreted by the wrong language;
- `prerequisite-cascade/` — kept mutating after an unverified install/export prerequisite had already failed;
- `mailbox-mutate-before-prove/` — combined selection, archival and source deletion before the selection and byte-preservation contract had been tested;
- `false-green-wrapper/` — reported success even when the required inner test never completed successfully.

Related tracking work is in Kitchen issues #1–#11.
