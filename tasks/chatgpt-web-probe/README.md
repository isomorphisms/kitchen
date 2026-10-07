# ChatGPT Web Probe scripts

Kitchen owns the scripts for producing and installing the temporary ChatGPT
Web API research probe.

## build.sh

This is the deterministic producer used by Flexible Pipes. It does not invent
target facts. It reads:

- Cat Food: `android/chatgpt-web-probe-targets.tsv` and
  `android/chatgpt-web-probe-build.tsv`;
- android-NDK: the maintained NativeActivity packager;
- ai-ci: the registered test signer and signer verifier;
- ChatGPTExporter `probe`: only the application C source and manifest.

It builds the A1 artifact first and the C67 artifact as its paired target. It
rejects Java/Kotlin/Gradle application code and produces no DEX.

Required environment:

```text
CHATGPT_PROBE_CHECKOUT
CATFOOD_CHECKOUT
ANDROID_NDK_CHECKOUT
AICI_CHECKOUT
ANDROID_NDK_HOME
ANDROID_HOME or ANDROID_SDK_ROOT
```

Optional: `CHATGPT_PROBE_OUTPUT_DIR`, `CHATGPT_PROBE_VERSION_CODE`,
`CHATGPT_PROBE_VERSION_NAME`.

## install.sh

This is the paste/run boundary for Termux + Rish. Pass one already selected APK.
It verifies that the input exists before crossing the shell boundary, stages it
under `/data/local/tmp`, installs, launches the exact NativeActivity component,
and fails unless a WebView DevTools socket appears.

It does not download an artifact or guess whether the phone is A1 or C67.
Artifact selection belongs to the Cat Food/Flexible Pipes handoff.
