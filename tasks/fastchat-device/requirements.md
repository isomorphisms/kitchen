# FC-M4 device capture

Execution host: a verified host with existing ADB access to one explicitly named
MIRO A1 or MIRO C67 instance. No setup, pairing, acquisition or build occurs.
Candidate `3.grease` follows the retained `1.grease` and `2.grease` attempts.
Kitchen owns the procedure. Cat Food owns device classification. ai-ci owns
independent admission; this candidate emits captures, never physical PASS.

Inputs: operation (`inspect`, `install`, `exercise`), absolute ADB/Cat Food/APK/
aapt2/apksigner/Grease paths, ADB serial, target (`phone` or `c67`), expected APK
SHA-256, exact source commit, fresh absolute output directory, and unique
`fc-m4-` store name for exercise. All tools/artifact/source identities are recorded.

Requirements established before implementation:

1. Check the selected serial, observed model/product/primary ABI and emulator
   property before effects. Use Cat Food's existing target oracle; unknown or
   conflicting facts must refuse. A1 and C67 never share a receipt.
2. Validate APK bytes, package, ABI, version and stable public test signer before
   install or execution. No compiler, acquisition or on-device build.
3. `inspect` remains read-only. `install` uses replacement installation only and
   checks installed bytes. Never uninstall, downgrade, clear data or clear logs.
4. `exercise` requires the exact APK already installed. Use the application's
   named deterministic acceptance store and :long fixture, preserving ordinary
   conversation data and account settings. Refuse exercise when FastChat already
   runs, so ordinary work is not interrupted. Stop only the test process that
   the procedure subsequently launched.
5. Capture current-process FastChat logs and memory observations, then stop and
   relaunch the same store without submitting a second request. Check the old
   process is gone and the new process exists. Do not infer durable replay from
   a launch command or another process's historical logs.
6. Preserve raw outputs, commands/exits, selected device and source/artifact/tool
   digests. Retain captures before any refusal. Output `CAPTURED` and
   `physical_acceptance=NOT_VERIFIED` until independent admission occurs.
7. Missing metrics or partial text remain missing. No timing/RSS threshold is
   invented. IME, touch, selection and visible frames remain human acceptance.

Fixtures must reject wrong model/ABI, emulator, wrong artifact/signature, failed
replacement installation, source-log mismatch and process replay failure. A
passing fixture proves procedure control flow only. No script is served to a
handset before the exact producer artifact and independent gate are qualified.
