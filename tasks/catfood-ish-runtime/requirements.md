# Ish physical runtime acceptance

Context: ordinary private Termux on MIRO A1, MIRO C67 or TAB_P10. No ADB,
Shizuku, root, SD-card access, compiler or source fleet. A1 may use its retained
`~/opt` convention. C67 and TAB_P10 must supply the actual installed workspace;
the procedure does not invent one. Cat Food remains the device identity owner.

Requirements established before candidate implementation:

1. Invoke the real Grease entrypoint. Resolve Cat Food helpers relative to the
   candidate's own file. Accept exactly target and absolute installed workspace.
2. Validate known physical identity, ABI, current instance and the v2 installation
   receipt before executing a packaged runtime. Refuse host/synthetic overrides,
   wrong model, contradictory properties, another instance and unknown devices.
3. Bind all six private payloads to their packaged SHA-256 record, reject
   undeclared paths and aliases, and ensure the delivered executable resolves to
   the installed package. Never infer an A1 run from C67 compatibility.
4. Execute bundled Chez and the compiled Ish program. Check literal UTF-8 text,
   environment and binary stdin inheritance, requested process status, no PATH
   search, missing executable, invalid UTF-8, NUL and empty-source rejection.
5. Preserve separate per-device, per-run logs. Refusal or partial execution must
   leave the installation receipt unchanged and produce no passing physical
   receipt. A passing receipt may be written only after every semantic check.
6. Keep producer build, emulator and publication fields unchanged. Update only
   launch, runtime and physical evidence in a new receipt. Validate it with Cat
   Food before atomic publication. Hash logs in a retained SHA256SUMS file.
7. Color section/action/PASS/FAIL output when supported; receipt fields plain.
   Reruns must create separate evidence, independent of the caller's directory.

Tests derived from requirements: Grease parse; host refusal; synthetic-override
refusal; wrong model; contradictory identity; missing/wrong-instance receipt;
modified payload; partial semantic failure; positive orchestration twice from
outside the repository. Positive fixtures are synthetic and must never be
submitted as physical device evidence. Real ARM archives are inspected and
installed on the host without being executed; physical execution is pending.

Canonical implementation belongs in `isomorphisms/catfood`,
`android/acceptance/ish-installed.grease`. Kitchen retains this preparation
contract and its test result, not a competing device registry or runtime copy.
