#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

fail() {
    printf 'chatgpt-web-probe install: %s\n' "$*" >&2
    exit 1
}

bundle=${1:-.}
[[ -d "$bundle" ]] || fail "bundle directory is missing: $bundle"
bundle=$(CDPATH= cd -- "$bundle" && pwd -P)

manifest="$bundle/artifacts.tsv"
target_logic="$bundle/catfood-target.sh"
[[ -f "$manifest" ]] || fail "artifacts.tsv is missing from bundle"
[[ -f "$target_logic" ]] || fail "pinned Cat Food target logic is missing from bundle"

command -v rish >/dev/null 2>&1 || fail "rish is not on PATH"
command -v sha256sum >/dev/null 2>&1 || fail "sha256sum is not on PATH"

# shellcheck source=/dev/null
. "$target_logic"

product=$(rish -c 'getprop ro.product.device' | tr -d '\r')
model=$(rish -c 'getprop ro.product.model' | tr -d '\r')
abi=$(rish -c 'getprop ro.product.cpu.abi' | tr -d '\r')
target=$(catfood_android_profile "$product" "$model" "$abi") ||
    fail "Cat Food could not identify this device"

case "$target" in phone|c67) ;; *)
    fail "probe bundle is for A1/C67, observed target: $target"
esac

row=$(awk -F '\t' -v target="$target" 'NR > 1 && $1 == target {print}' "$manifest")
[[ -n "$row" && "$row" != *$'\n'* ]] ||
    fail "bundle does not contain exactly one artifact for $target"

IFS=$'\t' read -r selected_target device expected_abi apk_path expected_sha receipt_path <<< "$row"
[[ "$selected_target" == "$target" ]] || fail "selected target changed"
[[ "$expected_abi" == "$abi" ]] || fail "artifact ABI $expected_abi does not match observed $abi"

if [[ "$apk_path" = /* ]]; then
    apk_name=${apk_path##*/}
else
    apk_name=${apk_path##*/}
fi
apk="$bundle/apk/$apk_name"
[[ -f "$apk" && -s "$apk" ]] || fail "selected APK is missing or empty: $apk"

digest=$(sha256sum "$apk" | awk '{print $1}')
[[ "$digest" == "$expected_sha" ]] ||
    fail "APK digest changed: expected $expected_sha got $digest"

printf 'target=%s\ndevice=%s\nabi=%s\napk=%s\napk_sha256=%s\n'     "$target" "$device" "$abi" "$apk_name" "$digest"

cat "$apk" | rish -c '
set -eu
tmp=/data/local/tmp/chatgpt-web-probe.apk
trap "rm -f \"$tmp\"" EXIT HUP INT TERM
cat > "$tmp"
[ -s "$tmp" ] || { echo "staged APK is empty" >&2; exit 1; }
pm install -r "$tmp"
'

rish -c '
set -eu
am force-stop org.isomorphisms.chatgptprobe
am start -W -n org.isomorphisms.chatgptprobe/android.app.NativeActivity
sleep 2
echo "=== process ==="
pidof org.isomorphisms.chatgptprobe || true
echo "=== WebView DevTools socket ==="
grep -Ei "webview.*devtools_remote" /proc/net/unix || true
'

socket=$(rish -c 'grep -Ei "webview.*devtools_remote" /proc/net/unix' || true)
[[ -n "$socket" ]] || fail "probe launched but no WebView DevTools socket appeared"

printf '%s\n' 'CHATGPT_WEB_PROBE_INSTALL PASS'
