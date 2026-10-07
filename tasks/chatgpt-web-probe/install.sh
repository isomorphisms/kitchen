#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

fail() {
    printf 'chatgpt-web-probe install: %s\n' "$*" >&2
    exit 1
}

[[ $# -eq 1 ]] || {
    printf 'usage: %s APK\n' "$0" >&2
    exit 2
}
apk=$1
[[ -f "$apk" && -s "$apk" ]] || fail "APK is missing or empty: $apk"
command -v rish >/dev/null 2>&1 || fail "rish is not on PATH"
command -v sha256sum >/dev/null 2>&1 || fail "sha256sum is not on PATH"

digest=$(sha256sum "$apk" | awk '{print $1}')
printf 'apk_sha256=%s\n' "$digest"

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
