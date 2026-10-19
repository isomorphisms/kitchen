# Flower SUN #124/#125 — Cat Food-aware APK handoff (version 3)

Previous attempts 1.sh and 2.sh remain historical evidence. Version 1 reported 0 matches because Flower was never published through Cat Food and the APK had no verified local path. Version 2 addressed the Cat Food storage path but checked for a selected file too early: Termux:API's document activity can finish writing asynchronously. Version 3 waits for a complete exact-SHA copy.

## Source of truth

- Cat Food draft PR #141 records the missing Flower Android publication, rather than inventing a package URL or an APK path. Cat Food's runtime workspace is ${CATFOOD_ROOT:-$HOME/opt}; its published-package cache uses downloads/$package-$sha256 only after an authenticated package fetch. Neither catfood where (Git checkouts only) nor this cache can observe a private ChatGPT attachment without real materialization.
- A1 (ARMv7) test APK: SHA-256 7256bb53f40392ca35ef5ccf83cf040a633f70c6a97c27cdf303ea3969085a7d. Flower source 25fa730858901665b686c578a09e514ead16400c.
- C67 (ARM64) test APK: SHA-256 14ac3dcc7547075b961436471b249a4354d7603f68c6404c5add2c0898a69bab. Flower source ce697a31edb67e4bbd2843dde824f1779ad05414.
- Both are signed test candidates using the same existing public development certificate. They are NOT published through Cat Food and are NOT tested on physical devices.

## Kitchen version 3

3.sh first inspects Cat Food's existing local downloads, then actual readable Android Downloads, then (if needed and available) opens the Android Documents picker through termux-storage-get. It asks the user to select the already-saved APK and verifies its exact digest before retaining a clearly labeled manual test copy under Cat Food's downloads/manual folder. This is explicit local test intake, not a published package row. Termux:API may return before the file picker completes its content-URI copy; v3 stays in the foreground and waits for the full matching digest with a bounded limit.

An explicit FLOWER_APK_PATH overrides discovery; missing files, conflicting device/ABI, wrong hashes, ambiguous matching copies, absent Termux:API, or canceled picks stop before installer intent. A successful termux-open requests a system package-install UI; it NEVER claims that installation or the GPU/touch application actually succeeded. Physical and package identity receipts remain with Cat Food/FP #125.

Reviewed Kitchen version 3 test run: https://github.com/isomorphisms/kitchen/actions/runs/39080832618. It covers the Cat Food cache, multiple existing Downloads roots, a picker returning before its copy finishes, wrong selections, A1/C67 model/ABI, duplicate hashes, unresolved paths, and declined installer intent. These are host fixtures, not device acceptance.

## One pasteable Termux invocation

After the test APK attachment has been saved into Android Files or is accessible in a document picker, run this command on the target handset; it never assumes the current working directory:

    sh -c 'set -eu; t=$(mktemp "${TMPDIR:-$HOME}/flower-intake.XXXXXXXX"); trap '"'"'rm -f -- "$t"'"'"' EXIT HUP INT TERM; curl -fsSL "https://raw.githubusercontent.com/isomorphisms/kitchen/8666aef8987ac46ce8c7500c2d78a43b245b9650/tasks/flower-subpixel-apk/3.sh" -o "$t"; printf "%s  %s\n" 82a11961c95f845adac80483e6470bed14ea0961570b6cfdaf310d0b66743d7f "$t" | sha256sum -c -; sh "$t"'

The command is applicable only to this exact pinned reviewed script; future changes require new digest/commit. If termux-storage-get is unavailable (Termux:API package and companion app not present), the script records an explicit blocker rather than guessing a filesystem location. In that case, opening the saved APK directly from Android Files is a supported manual test-install route, but does not produce Cat Food's independent device receipt.

No merge, release, Cat Food publication, physical A1/C67 acceptance or registered FP dispatch is claimed.
