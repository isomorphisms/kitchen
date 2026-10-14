# FastChat device capture candidate

Use candidate `4.grease`; retain the earlier attempts and their failure notes.
Read requirements.md before using the script. This is a host-side ADB procedure,
not a phone-side build or dependency installer. Every path is an explicit
verified absolute input. Existing ADB access, authenticated exact APK bytes,
the maintained Cat Food classifier, platform inspection tools and a working
Grease launcher are prerequisites. No handset channel was available during
preparation, and no device command is being delivered to the user as accepted.

Operations remain separate: inspect reads identity/artifact; install replaces
the existing package and verifies its installed bytes; exercise checks exact
installed bytes, refuses existing FastChat work, starts an isolated deterministic
store, captures per-process logs/memory, stops it, and replays the same store.
The package/signer stay stable and versionCode must not decrease. Normal
conversation data, account settings and system logs are never erased.

The output is a raw CAPTURED receipt with physical_acceptance=NOT_VERIFIED.
Independent ai-ci admission, true visible-frame timing and physical UI behavior
are unfinished. `test.grease` covers fourteen synthetic procedure cases using the
real native Grease launcher and actual Cat Food classifier, including both
observed origin URL spellings and a wrong-owner refusal. These fixtures do
not execute Android, an APK, ICK or a provider account.

The Cat Food `classify-android-target` companion exposes its existing oracle
over captured product/model/primary-ABI values. It neither acquires observations
nor accepts physical evidence. The consumer refuses generic/unknown results.

Native engine SHA-256:
7e31cd05b7a9d8fb2a4a9e003a7f3fcb0159138506d17f0fb28da8cbe22aa85c.
The inherited engine needs its actual native Grease launcher; renaming the
engine to grease is not a qualified entrypoint.
