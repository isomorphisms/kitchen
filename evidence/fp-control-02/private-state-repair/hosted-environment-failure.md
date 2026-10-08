# Hosted diagnostic environment contamination

The exact Kitchen `59fc9d004ebbf851da1617929de1885b84f07157` hosted diagnostic
failed before entering the checked test. Run:
https://github.com/isomorphisms/kitchen/actions/runs/37821629420 .
Job `113463829600` logs show the Cat Food runtime build completed, then Python 3
imported `runtime/grease/source/vendor/typing.py` and raised
`NameError: name 'basestring' is not defined`.

The workflow's Grease shell exports its Python 2 source/vendor `PYTHONPATH`.
Invoking Python 3 directly propagated that unrelated runtime import path into
Ithon. This was a workflow entrypoint defect, not evidence that the transfer
artifact's independent API checks ran or passed. Artifact upload also failed
because the frontend had not created any diagnostic files.

The workflow now uses the same explicit `env -u PYTHONPATH -u PYTHONHOME`
boundary as the fixture bridges for each Python 3 checked-Ithon invocation.
It creates a narrow diagnostic PENDING manifest before entering the frontend,
so early failure retains a reviewable artifact and does not fabricate PASS.
Only completion of all three required diagnostics replaces that manifest with
PASS. Product generator, recipe and delivered paste bytes are unchanged.
