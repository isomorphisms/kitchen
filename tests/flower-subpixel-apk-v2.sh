#!/bin/sh
# Disposable host fixtures for Kitchen Flower APK v2. No Android app installed.
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
script="$root/tasks/flower-subpixel-apk/2.sh"
sh -n "$script"
temp=$(mktemp -d)
trap 'rm -rf -- "$temp"' EXIT HUP INT TERM
mkdir -p "$temp/home" "$temp/fixtures with spaces" "$temp/bin"
printf 'owned test APK content; not a signed Android APK\n' > "$temp/fixtures with spaces/app-debug.apk"
fixture="$temp/fixtures with spaces/app-debug.apk"
digest=$(sha256sum "$fixture" | awk '{print $1}')
sed -e "s/7256bb53f40392ca35ef5ccf83cf040a633f70c6a97c27cdf303ea3969085a7d/$digest/" \
    -e "s/14ac3dcc7547075b961436471b249a4354d7603f68c6404c5add2c0898a69bab/$digest/" \
    "$script" > "$temp/fixture-runner.sh"
sh -n "$temp/fixture-runner.sh"

cat > "$temp/bin/getprop" <<'GETPROP'
#!/bin/sh
case $1 in
  ro.product.model) printf '%s\n' "$TEST_MODEL" ;;
  ro.product.cpu.abi) printf '%s\n' "$TEST_ABI" ;;
  ro.product.device) printf '%s\n' "$TEST_PRODUCT" ;;
  *) exit 2 ;;
esac
GETPROP
cat > "$temp/bin/termux-open" <<'OPEN'
#!/bin/sh
printf '%s\n' "$*" >> "$OPEN_LOG"
exit "${MOCK_OPEN_RC:-0}"
OPEN
chmod +x "$temp/bin/getprop" "$temp/bin/termux-open"
log="$temp/open.log"; out="$temp/stdout"; err="$temp/stderr"
: > "$log"

# Termux identity is synthetic only; cannot qualify a real device.
target_model='MIRO A1'
target_abi=armeabi-v7a
target_product=''
given_path="$fixture"
open_rc=0
run() {
    TEST_MODEL="$target_model" TEST_ABI="$target_abi" TEST_PRODUCT="$target_product" \
    MOCK_OPEN_RC="$open_rc" OPEN_LOG="$log" HOME="$temp/home" \
    PREFIX=/data/data/com.termux/files/usr \
    FLOWER_APK_PATH="$given_path" \
    PATH="$temp/bin:$PATH" \
    sh "$temp/fixture-runner.sh" > "$out" 2> "$err"
}
fail_without_intent() {
    : > "$log"
    if run; then echo "FALSE PASS: $1" >&2; exit 1; fi
    test ! -s "$log" || { echo "FALSE installer intent: $1" >&2; exit 1; }
}
assert_pass() {
    : > "$log"
    run
    test "$(wc -l < "$log")" -eq 1 ||
        { echo "installer not requested exactly once" >&2; exit 1; }
    grep -Fq 'installation_result' \
      "$(find "$temp/home/.local/state/kitchen/flower-subpixel-apk" -type f | sort | tail -1)" ||
        { echo "intent receipt missing" >&2; exit 1; }
    grep -Fq 'INSTALLER_INTENT_REQUESTED' "$out"
    if grep -Fq 'installation_result	PASS' "$out"; then
        echo 'installer request falsely equated with install' >&2
        exit 1
    fi
}
(cd / && assert_pass)
grep -Fq 'ACQUISITION=explicit-path' "$out"
target_model='Miro C67'; target_abi=arm64-v8a; target_product=Miro_C67
assert_pass
grep -Fq 'FLOWER_APK_VERIFIED: C67' "$out"
target_abi=armeabi-v7a
fail_without_intent 'C67 wrong ABI'
target_abi=arm64-v8a; target_product=unexpected
fail_without_intent 'C67 conflicting product'
target_model=unknown; target_product=''
fail_without_intent 'unknown model'
target_model='MIRO A1';target_abi=armeabi-v7a
given_path="$temp/fixtures with spaces/broken.apk"
printf 'not correct\n' > "$given_path"
fail_without_intent 'wrong sha'
given_path=
fail_without_intent 'missing file and no file picker'
grep -Fq 'not a published Cat Food package' "$err"

# Real Cat Food import/cache path is preferred over guessed shared downloads.
mkdir -p "$temp/home/opt/downloads"
cp "$fixture" "$temp/home/opt/downloads/flower-test-$digest"
assert_pass
grep -Fq 'ACQUISITION=catfood-local' "$out"

rm -f -- "$temp/home/opt/downloads/flower-test-$digest"
mkdir -p "$temp/home/storage/downloads/Folder Name"
cp "$fixture" "$temp/home/storage/downloads/Folder Name/app-debug.apk"
assert_pass
grep -Fq 'ACQUISITION=observed-download' "$out"
mkdir -p "$temp/home/storage/downloads/Another"
cp "$fixture" "$temp/home/storage/downloads/Another/app-debug.apk"
fail_without_intent 'ambiguous downloads'
grep -Fq 'multiple exact APK files' "$err"
rm -rf -- "$temp/home/storage"
# Empty observed Downloads alias must not hide the populated second alias.
mkdir -p "$temp/home/storage/downloads"
mkdir -p "$temp/home/storage/shared/Download/Real observed"
cp "$fixture" "$temp/home/storage/shared/Download/Real observed/app-debug.apk"
assert_pass
grep -Fq 'ACQUISITION=observed-download' "$out"
rm -rf -- "$temp/home/storage"

# Browser private-content URI may only be transferred via Android's chooser
# when the Termux:API add-on is actually provided. No guessed filename.
cat > "$temp/bin/termux-storage-get" <<'PICK'
#!/bin/sh
printf 'picker-selected\n' >> "$PICK_LOG"
cp -- "$PICK_SOURCE" "$1"
PICK
chmod +x "$temp/bin/termux-storage-get"
export PICK_SOURCE="$fixture" PICK_LOG="$temp/picker.log"
: > "$PICK_LOG"
assert_pass
grep -Fq 'ACQUISITION=android-documents-picker' "$out"
test "$(wc -l < "$PICK_LOG")" -eq 1
test -f "$temp/home/opt/downloads/manual/flower-A1-$digest.apk"
test "$(sha256sum "$temp/home/opt/downloads/manual/flower-A1-$digest.apk" | awk '{print $1}')" = "$digest"
# Second call must reuse exact Cat Food-local bytes, no repeated chooser.
assert_pass
grep -Fq 'ACQUISITION=catfood-local' "$out"
test "$(wc -l < "$PICK_LOG")" -eq 1

rm -f -- "$temp/home/opt/downloads/manual/flower-A1-$digest.apk"
PICK_SOURCE="$temp/fixtures with spaces/broken.apk"
export PICK_SOURCE
fail_without_intent 'picker wrong SHA'
grep -Fq 'picked APK SHA mismatch' "$err"

# User declined/closed installer: still no installation/physical PASS.
given_path="$fixture"
open_rc=9
: > "$log"
if run; then echo 'false installer-intent success' >&2; exit 1; fi
grep -Fq 'INSTALLER_INTENT_FAILED' "$out"
test "$(wc -l < "$log")" -eq 1

# Even with a matching fake APK, a normal Linux host cannot claim Termux.
if HOME="$temp/home" PREFIX=/usr PATH="$temp/bin:$PATH" \
   TEST_MODEL='MIRO A1' TEST_ABI=armeabi-v7a TEST_PRODUCT='' \
   FLOWER_APK_PATH="$fixture" OPEN_LOG="$log" \
    sh "$temp/fixture-runner.sh" > "$out" 2> "$err"; then
    echo 'false host-acceptance as Termux' >&2
    exit 1
fi
grep -Fq 'ordinary Termux not confirmed' "$err"
echo 'PASS: Flower v2 Cat Food cache, observed Downloads, SAF picker, hash, ABI and intent boundaries'
