# Signed Mathieu APK preparation

Target: Linux x86_64 build host. No device builds, installation, publication or physical acceptance.

Inputs: clean exact-head Mathieu source, separately qualified Debug/Release libraries for armeabi-v7a, arm64-v8a and x86_64, pinned android-NDK packager checkout, Android SDK platform/build-tools, NDK strip tool, pinned Ike, Grease, and an absent evidence directory. Metadata and permanent development signing bytes belong to the application. Never generate or choose a key.

Refuse wrong source head, dirty source, wrong packager revision, missing SDK/tools/keys, unsafe or relative paths, stale native source markers, or an existing output directory. Perform read-only checks before creating output. Preserve input libraries; strip staged copies and record before/after sizes and digests. Package via the maintained NativeActivity packager under Ike's Grease recipe runner, keeping Debug/Release and all ABIs distinct. The finished APK must match the application package/version/label/ABI and pinned certificate. Failure must not publish a candidate as accepted.

Positive qualification must produce six signer-verified APKs from one exact application head. Negative qualification must reject a wrong source pin, existing output, missing SDK, and a missing signer. Independent AI-CI must inspect the actual finished APKs, reject a wrong signer and an unregistered package/lane, and keep Android/emulator/physical evidence separate from packaging.
