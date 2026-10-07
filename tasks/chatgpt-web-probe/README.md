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

The Flexible Pipes bundle includes this installer, `artifacts.tsv`, and the exact pinned Cat Food target selector. The script observes product/model/ABI through Rish, lets Cat Food select `phone` or `c67`, verifies the selected APK digest, installs it, launches the NativeActivity, and requires a WebView DevTools socket.


## install-run.sh

This is the normal human entry point after a successful Flexible Pipes run:

```sh
bash tasks/chatgpt-web-probe/install-run.sh RUN_ID
```

It downloads only the named `chatgpt-web-probe-paired` artifact from
`isomorphisms/flexible-pipes`, requires the expected bundle files, and then
hands the bundle to `install.sh`. The selected APK still comes from Cat Food's
observed device identity, not from the caller.
