#!/bin/sh
# Disposable contract tests with fake getprop and termux-open, never a phone.
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
script="$root/tasks/flower-subpixel-apk/1.sh"
sh -n "$script"
work=$(mktemp -d)
trap 'rm -rf -- "$work"' EXIT HUP INT TERM
mkdir -p "$work/bin" "$work/home" "$work/fixtures with spaces"
printf 'deterministic disposable APK fixture, not real app\n' > \
    "$work/fixtures with spaces/app-debug.apk"
digest=$(sha256sum "$work/fixtures with spaces/app-debug.apk" | awk '{print $1}')
# Test copy pins disposable digest; never modifies the release candidate.
sed -e "s/7256bb53f40392ca35ef5ccf83cf040a633f70c6a97c27cdf303ea3969085a7d/$digest/" \
    -e "s/14ac3dcc7547075b961436471b249a4354d7603f68c6404c5add2c0898a69bab/$digest/" \
    "$script" > "$work/fixture-runner.sh"
sh -n "$work/fixture-runner.sh"
cat > "$work/bin/getprop" <<'PROP'
#!/bin/sh
case "$1" in
    ro.product.model) printf '%s\n' "$TEST_MODEL" ;;
    ro.product.cpu.abi) printf '%s\n' "$TEST_ABI" ;;
    ro.product.device) printf '%s\n' "$TEST_DEVICE" ;;
    *) exit 2 ;;
esac
PROP
cat > "$work/bin/termux-open" <<'OPEN'
#!/bin/sh
printf '%s\n' "$*" >> "$HANDOFF_LOG"
exit "${TEST_OPEN_RC:-0}"
OPEN
chmod +x "$work/bin/getprop" "$work/bin/termux-open"
log="$work/requests"
out="$work/output"
err="$work/errors"
: > "$log"
run() {
    TEST_MODEL="$test_model" TEST_ABI="$test_abi" TEST_DEVICE="$test_device" \
    TEST_OPEN_RC="$test_open_rc" HANDOFF_LOG="$log" \
    HOME="$work/home" PREFIX=/data/data/com.termux/files/usr \
    FLOWER_APK_PATH="$test_path" PATH="$work/bin:$PATH" \
        sh "$work/fixture-runner.sh" > "$out" 2> "$err"
}
must_fail() {
    if run; then echo "FALSE PASS ($1)" >&2; exit 1; fi
    if [ -s "$log" ]; then
        echo "FALSE INTENT on refused case ($1)" >&2
        cat "$log" >&2
        exit 1
    fi
}

test_model='MIRO A1'; test_abi=armeabi-v7a; test_device=''; test_open_rc=0
test_path="$work/fixtures with spaces/app-debug.apk"
(cd / && run)
grep -Fq 'FLOWER_APK_HANDOFF=INSTALLER_INTENT_REQUESTED' "$out"
grep -Fq 'FLOWER_APK_VERIFIED: class=A1' "$out"
grep -Fq "$test_path" "$log"
receipt=$(find "$work/home/.local/state/kitchen/flower-subpixel-apk" -name '*.tsv' -type f | head -1)
test -n "$receipt"
grep -Fq 'installation_result' "$receipt"
grep -Fq 'physical_device_result' "$receipt"
grep -Fq 'NOT_VERIFIED' "$receipt"
test "$(sha256sum "$test_path" | awk '{print $1}')" = "$digest"

: > "$log"
test_model='Miro C67'; test_abi=arm64-v8a; test_device='Miro_C67'
run
grep -Fq 'FLOWER_APK_VERIFIED: class=C67' "$out"
test "$(wc -l < "$log")" -eq 1

: > "$log"
test_abi=armeabi-v7a
must_fail 'C67 wrong primary ABI'
test_abi=arm64-v8a; test_device='unexpected'
must_fail 'C67 conflicting Android product'
test_model='Unknown'; test_device=''; must_fail 'unknown model'

test_model='MIRO A1'; test_abi=armeabi-v7a; test_device=''
: > "$log"
test_path="$work/fixtures with spaces/wrong.apk"
printf 'corrupt unrelated file\n' > "$test_path"
must_fail 'wrong SHA never opens package manager'

: > "$log"
test_path=
must_fail 'no observed storage location'
grep -Fq 'FLOWER_APK_BLOCKED' "$err"
mkdir -p "$work/home/storage/downloads/a fixture"
cp "$work/fixtures with spaces/app-debug.apk" \
    "$work/home/storage/downloads/a fixture/app-debug.apk"
run
test "$(wc -l < "$log")" -eq 1

: > "$log"
mkdir -p "$work/home/storage/downloads/another fixture"
cp "$work/fixtures with spaces/app-debug.apk" \
    "$work/home/storage/downloads/another fixture/app-debug.apk"
must_fail 'ambiguous two matching hashes'
grep -Fq 'FLOWER_APK_UNRESOLVED: 2 exact-hash matches' "$err"

: > "$log"
test_path="$work/fixtures with spaces/app-debug.apk"
test_open_rc=9
if run; then echo 'FALSE PASS: package UI refusal accepted' >&2; exit 1; fi
grep -Fq 'INSTALLER_INTENT_FAILED' "$out"
test "$(wc -l < "$log")" -eq 1

if HOME="$work/home" PREFIX=/usr/bin PATH="$work/bin:$PATH" \
   FLOWER_APK_PATH="$test_path" TEST_MODEL='MIRO A1' \
   TEST_ABI=armeabi-v7a TEST_DEVICE='' HANDOFF_LOG="$log" \
    sh "$work/fixture-runner.sh" > "$out" 2> "$err"; then
    echo 'host context accepted as Termux' >&2
    exit 1
fi
grep -Fq 'ordinary Termux environment not established' "$err"
echo 'PASS Flower APK handoff: digest, model/ABI, path, ambiguity, intent, host refusal'
