#!/bin/sh
# Kitchen SUN #124/#125: ordinary Termux package installer intent, not receipt
# of installed/running app. Version 1; digest-bound, no adb/rish/pm fallback.
set -eu
umask 077
a1_sha=7256bb53f40392ca35ef5ccf83cf040a633f70c6a97c27cdf303ea3969085a7d
c67_sha=14ac3dcc7547075b961436471b249a4354d7603f68c6404c5add2c0898a69bab
a1_source=25fa730858901665b686c578a09e514ead16400c
c67_source=ce697a31edb67e4bbd2843dde824f1779ad05414
subpixel_source=efff5fbe71d8722d713282c478dbdb52fa280f9b
blocked() { printf 'FLOWER_APK_BLOCKED: %s\n' "$*" >&2; exit 2; }

[ "${PREFIX:-}" = /data/data/com.termux/files/usr ] ||
    blocked 'ordinary Termux environment not established; not adb, rish, or root'
case $HOME in /*) ;; *) blocked 'absolute Termux HOME missing' ;; esac
for required in sha256sum find sort mktemp termux-open date awk; do
    command -v "$required" >/dev/null 2>&1 ||
        blocked "required command missing: $required"
done
if command -v getprop >/dev/null 2>&1; then prop=getprop
elif [ -x /system/bin/getprop ]; then prop=/system/bin/getprop
else blocked 'Android properties unavailable'; fi
model=$("$prop" ro.product.model) || blocked 'device model unavailable'
abi=$("$prop" ro.product.cpu.abi) || blocked 'device ABI unavailable'
device=$("$prop" ro.product.device) || blocked 'device product unavailable'
case "$model:$abi" in
    'MIRO A1:armeabi-v7a'|'Miro A1:armeabi-v7a')
        [ "$device" != Miro_C67 ] || blocked 'A1 model conflicts with C67 product'
        lane=A1; expected=$a1_sha; source=$a1_source ;;
    'Miro C67:arm64-v8a'|'MIRO C67:arm64-v8a')
        case $device in Miro_C67|'') ;; *) blocked 'C67 product conflict' ;; esac
        lane=C67; expected=$c67_sha; source=$c67_source ;;
    *) blocked "unsupported observed device / primary ABI: $model / $abi" ;;
esac

# Candidate locations are discovered in existing readable folders.
# A content URI or unmounted file cannot be silently converted to a path.
candidates=$(mktemp "${TMPDIR:-$HOME}/flower-candidates.XXXXXXXX") ||
    blocked 'unable to allocate candidate list'
trap 'rm -f -- "$candidates"' EXIT HUP INT TERM
if [ -n "${FLOWER_APK_PATH:-}" ]; then
    path=$FLOWER_APK_PATH
    case $path in /*) ;; *) path=$(pwd -P)/$path ;; esac
    printf '%s\n' "$path" > "$candidates"
else
    found_root=
    for root in "$HOME/storage/downloads" "$HOME/storage/shared/Download" \
                /storage/emulated/0/Download /sdcard/Download; do
        if [ -d "$root" ] && [ -r "$root" ]; then found_root=$root; break; fi
    done
    [ -n "$found_root" ] ||
        blocked 'no readable download directory; supply explicit FLOWER_APK_PATH'
    find "$found_root" -maxdepth 3 -type f \( \
        -name 'app-debug.apk' -o \
        -name 'flower-subpixel-a1-candidate.apk' -o \
        -name 'flower-subpixel-c67-candidate.apk' \) \
        -print 2>/dev/null | sort -u > "$candidates" ||
        blocked 'file discovery failed'
fi

count=0
selected=
while IFS= read -r path || [ -n "$path" ]; do
    [ -f "$path" ] && [ -r "$path" ] || continue
    case $path in *.apk) ;; *) continue ;; esac
    observed=$(sha256sum -- "$path" | awk '{print $1}') ||
        blocked 'cannot hash candidate'
    if [ "$observed" = "$expected" ]; then
        count=$((count+1))
        selected=$path
    fi
done < "$candidates"
[ "$count" -eq 1 ] || {
    printf 'FLOWER_APK_UNRESOLVED: %s exact-hash matches; nothing opened\n' "$count" >&2
    printf 'If necessary, set FLOWER_APK_PATH to an observed .apk file.\n' >&2
    exit 2
}
printf 'FLOWER_APK_VERIFIED: class=%s observed_model=%s abi=%s\n' "$lane" "$model" "$abi"
printf 'SHA256=%s\nSOURCE=%s\nSUBPIXEL=%s\nARTIFACT=%s\n' \
    "$expected" "$source" "$subpixel_source" "$selected"
printf 'REQUEST: Android package-installer UI only; user confirmation required.\n'
outcome=INSTALLER_INTENT_FAILED
if termux-open --view --content-type application/vnd.android.package-archive "$selected"; then
    outcome=INSTALLER_INTENT_REQUESTED
fi
# A terminal intent is not installation, launch, runtime, or physical acceptance.
receipt_dir="$HOME/.local/state/kitchen/flower-subpixel-apk"
mkdir -p "$receipt_dir" || blocked 'cannot make local receipt directory'
receipt="$receipt_dir/intent-$(date +%Y%m%dT%H%M%S)-$$.tsv"
{
    printf 'scope\tSUN-124-125-Flower-APK-handoff\n'
    printf 'model\t%s\nabi\t%s\ndevice_product\t%s\n' "$model" "$abi" "$device"
    printf 'lane\t%s\nsource_commit\t%s\nsubpixel_commit\t%s\n' \
        "$lane" "$source" "$subpixel_source"
    printf 'apk_sha256\t%s\napk_path\t%s\n' "$expected" "$selected"
    printf 'installer_intent\t%s\ninstallation_result\tNOT_VERIFIED\n' "$outcome"
    printf 'launch_result\tNOT_VERIFIED\nruntime_result\tNOT_VERIFIED\n'
    printf 'physical_device_result\tNOT_VERIFIED\n'
    printf 'physical_instance\tNOT_ESTABLISHED\n'
} > "$receipt" || blocked 'cannot write local intent receipt'
printf 'FLOWER_APK_HANDOFF=%s receipt=%s\n' "$outcome" "$receipt"
[ "$outcome" = INSTALLER_INTENT_REQUESTED ] ||
    blocked 'Android package-installer intent failed; nothing installed by this script'
