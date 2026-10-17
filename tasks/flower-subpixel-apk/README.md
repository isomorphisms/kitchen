# Flower SUN #124/#125 — Cat Food-aware APK handoff

Previous attempt 1.sh is historical evidence. On MIRO A1, it successfully verified its own source but reported FLOWER_APK_UNRESOLVED: 0 because it assumed a readable Android Downloads file, not an actual Cat Food-managed package or Android Documents content URI.

## Source of truth

- Cat Food draft PR #141 records the missing Flower Android publication, rather than inventing a package URL or an APK path. Cat Food's runtime workspace is ${CATFOOD_ROOT:-$HOME/opt}; its published-package cache uses downloads/$package-$sha256 only after an authenticated package fetch. Neither catfood where (Git checkouts only) nor this cache can observe a private ChatGPT attachment without real materialization.
- A1 (ARMv7) test APK: SHA-256 7256bb53f40392ca35ef5ccf83cf040a633f70c6a97c27cdf303ea3969085a7d. Flower source 25fa730858901665b686c578a09e514ead16400c.
- C67 (ARM64) test APK: SHA-256 14ac3dcc7547075b961436471b249a4354d7603f68c6404c5add2c0898a69bab. Flower source ce697a31edb67e4bbd2843dde824f1779ad05414.
- Both are signed test candidates using the same existing public development certificate. They are NOT published through Cat Food and are NOT tested on physical devices.

## Kitchen version 2

2.sh first inspects Cat Food's existing local downloads, then actual readable Android Downloads, then (if needed and available) opens the Android Documents picker through termux-storage-get. It asks the user to select the already-saved APK and verifies its exact digest before retaining a clearly labeled manual test copy under Cat Food's downloads/manual folder. This is an explicit local intake, not an added package row or durable publication.

An explicit FLOWER_APK_PATH overrides discovery; missing files, conflicting device/ABI, wrong hashes, ambiguous matching copies, absent Termux:API, or canceled picks stop before installer intent. A successful termux-open requests a system package-install UI; it NEVER claims that installation or the GPU/touch application actually succeeded. Physical and package identity receipts remain with Cat Food/FP #125.

Reviewed Kitchen version 2 test run: https://github.com/isomorphisms/kitchen/actions/runs/39080388658. It covers the Cat Food cache, multiple currently accessible Downloads roots, Android picker positive and wrong-selection cases, A1/C67 identity, duplicate hashes, missing device context, and declined installer intent.

## One pasteable Termux invocation

After the test APK attachment has been saved into Android Files or is accessible in a document picker, run this command on the target handset; it never assumes the current working directory:

    sh -c 'set -eu; t=$(mktemp "${TMPDIR:-$HOME}/flower-intake.XXXXXXXX"); trap '"'"'rm -f -- "$t"'"'"' EXIT HUP INT TERM; curl -fsSL "https://raw.githubusercontent.com/isomorphisms/kitchen/d8e46a6fe622f17de6a225002311e379d0ea707a/tasks/flower-subpixel-apk/2.sh" -o "$t"; printf "%s  %s\n" af1a581ed5bd2b94545080f1d4ff9e9817018a7f6ad84389f95dcbf5d98d15ed "$t" | sha256sum -c -; sh "$t"'

The command is applicable only to this exact pinned reviewed script; future changes require new digest/commit. If termux-storage-get is unavailable (Termux:API package and companion app not present), the script records an explicit blocker rather than guessing a filesystem location. In that case, opening the saved APK directly from Android Files is a supported manual test-install route, but does not produce Cat Food's independent device receipt.

No merge, release, Cat Food publication, physical A1/C67 acceptance or registered FP dispatch is claimed.
