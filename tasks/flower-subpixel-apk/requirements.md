# Flower SUN #124 / #125 — exact APK to Android package installer

This Kitchen task prepares a single current-device Termux command. It is
not a substitute for Cat Food artifact publication, FP registered dispatch,
AI-CI release authorization, or physical-device acceptance.

## Requirements (before implementation)

1. Work in ordinary Termux, not `adb shell`, root, Shizuku/rish, or an
   assumed current checkout. Observe the current device model and primary
   ABI with `getprop`. Support the A1 `armeabi-v7a` first and the C67
   `arm64-v8a` companion. Any unknown/conflicting identity must stop before
   an install intent is sent. A device model alone is not a physical-instance ID.
2. Require an artifact with the exact *already verified* immutable APK
   SHA-256 for the selected ABI. Distinguish package bytes from the ZIP
   holding GitHub Actions artifacts. No invented download path, no silent
   downloads from private GitHub Actions URLs, no automatic compiler/build,
   no APK signature key creation, no unlinking other apps or deleting user
   downloads. Source and signer hashes remain in the retained producer
   evidence; SHA-256 binds this exact APK to those results.
3. Resolve an explicit `FLOWER_APK_PATH` if supplied, or discover only
   actual readable APK candidates under observed existing shared-download
   access paths in the current Termux environment. Never assume any path
   exists. Ambiguity (more than one matching artifact) and no match both
   stop without launch/installation attempt.
4. Request only the regular Android package-installer VIEW intent through
   installed `termux-open`. Do not substitute privileged `pm install`,
   `adb`, `rish`, a browser cache guess, `termux-storage-get` without a
   connector, or a claim that the package installer accepted the APK.
   User confirmation and Android's update/signature rules remain authoritative.
5. Preserve original artifact unchanged. Write only a local, explicitly
   labeled intent receipt in private Termux state, containing observed model,
   ABI, APK path/digest, source pin, and `physical_result=NOT_VERIFIED`.
   Success of `termux-open` means only that an intent was requested.
6. Refuse unrecognized terminal context, ABI mismatch, unverified APK,
   missing required commands, or an unresolved local path. Work from
   arbitrary current working directories, handle ordinary spaces in paths,
   avoid shell injection, and never print a false install/runtime PASS.
7. Script remains a versioned Kitchen candidate. Test normal, malformed,
   ambiguous, rerun, wrong-device, wrong-digest, and environment cases in
   disposable fixture state. Host fixtures are never physical-device evidence.
8. Cat Food owns device identity, package registry, and current v2 receipt
   gate. The existing Cat Food manifest contains **no Flower APK package**.
   Do not add a fictitious package row with an expired/private CI artifact
   URL; a future publication follower must satisfy its immutable URL/hash
   contract first.

See Cat Food's android/device-instance-and-artifact-location.md and Kitchen's
incidents/2026-10-06-android-device-and-download-path-assumption.md.
