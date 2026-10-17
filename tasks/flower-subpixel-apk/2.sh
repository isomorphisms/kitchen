#!/bin/sh
# Version 2 — Cat Food-aware intake and ordinary Termux installer intent.
# V1 tried conventional Downloads but overlooked Cat Food managed files and
# the Android Documents URI boundary. No private file location is invented.
set -eu
umask 077

a1_sha=7256bb53f40392ca35ef5ccf83cf040a633f70c6a97c27cdf303ea3969085a7d
c67_sha=14ac3dcc7547075b961436471b249a4354d7603f68c6404c5add2c0898a69bab
a1_source=25fa730858901665b686c578a09e514ead16400c
c67_source=ce697a31edb67e4bbd2843dde824f1779ad05414
subpixel_source=efff5fbe71d8722d713282c478dbdb52fa280f9b

blocked() { printf 'FLOWER_APK_BLOCKED: %s\n' "$*" >&2; exit 2; }
[ "${PREFIX:-}" = /data/data/com.termux/files/usr ] ||
    blocked 'ordinary Termux not confirmed (not adb, Shizuku/rish, or root)'
case $HOME in /*) ;; *) blocked 'absolute Termux HOME missing' ;; esac
for required in getprop sha256sum find sort mktemp awk termux-open date; do
    command -v "$required" >/dev/null 2>&1 ||
        blocked "required Termux command missing: $required"
done
model=$(getprop ro.product.model) || blocked 'device model unavailable'
abi=$(getprop ro.product.cpu.abi) || blocked 'device primary ABI unavailable'
device=$(getprop ro.product.device) || blocked 'device product unavailable'
case "$model:$abi" in
  'MIRO A1:armeabi-v7a'|'Miro A1:armeabi-v7a')
    [ "$device" != Miro_C67 ] || blocked 'conflicting A1/C67 model and product'
    lane=A1; expected=$a1_sha; source=$a1_source ;;
  'Miro C67:arm64-v8a'|'MIRO C67:arm64-v8a')
    case $device in Miro_C67|'') ;; *) blocked 'conflicting C67 product identity' ;; esac
    lane=C67; expected=$c67_sha; source=$c67_source ;;
  *) blocked "unknown or conflicting model/primary ABI: $model / $abi" ;;
esac

# Cat Food's Android install.sh owns this runtime workspace convention;
# neither this directory nor its contents is assumed to exist already.
catfood_root=${CATFOOD_ROOT:-$HOME/opt}
case $catfood_root in /*) ;; *) blocked 'Cat Food root must be absolute' ;; esac
candidates=$(mktemp "${TMPDIR:-$HOME}/flower-candidates.XXXXXXXX") ||
    blocked 'cannot allocate candidate list'
trap 'rm -f -- "$candidates"' EXIT HUP INT TERM

find_in() {
    directory=$1
    [ -d "$directory" ] && [ -r "$directory" ] || return 0
    find "$directory" -maxdepth 3 -type f \( \
        -iname '*.apk' -o -iname '*flower*' -o -name "*$expected*" \
        \) -print 2>/dev/null | sort -u >> "$candidates" ||
        blocked "cannot inspect existing directory: $directory"
}
choose_matching() {
    count=0
    selected=
    while IFS= read -r path || [ -n "$path" ]; do
        [ -f "$path" ] && [ -r "$path" ] || continue
        digest=$(sha256sum -- "$path" | awk '{print $1}') ||
            blocked 'cannot hash a candidate file'
        if [ "$digest" = "$expected" ]; then
            count=$((count+1))
            selected=$path
        fi
    done < "$candidates"
}

acquisition=
if [ -n "${FLOWER_APK_PATH:-}" ]; then
    path=$FLOWER_APK_PATH
    case $path in /*) ;; *) path=$(pwd -P)/$path ;; esac
    printf '%s\n' "$path" > "$candidates"
    choose_matching
    [ "$count" -eq 1 ] ||
        blocked 'explicit APK path missing, unreadable, or wrong SHA-256'
    acquisition=explicit-path
else
    # First canonical Cat Food-managed and manually imported files, not a
    # guessed shared Downloads location. Flower is not yet a published package.
    find_in "$catfood_root/downloads"
    choose_matching
    if [ "$count" -eq 1 ]; then
        acquisition=catfood-local
    elif [ "$count" -gt 1 ]; then
        blocked 'multiple exact APKs in Cat Food storage; supply FLOWER_APK_PATH'
    else
        : > "$candidates"
        for directory in "$HOME/storage/downloads" \
                         "$HOME/storage/shared/Download" \
                         /storage/emulated/0/Download /sdcard/Download; do
            [ -d "$directory" ] && [ -r "$directory" ] || continue
            find_in "$directory"
            break
        done
        choose_matching
        if [ "$count" -eq 1 ]; then
            acquisition=observed-download
        elif [ "$count" -gt 1 ]; then
            blocked 'multiple exact APK files; supply FLOWER_APK_PATH'
        else
            # The ChatGPT app may expose a content URI, not a Unix path.
            # Termux:API can materialize user-selected Documents bytes into
            # private storage. Never infer the path from an attachment title.
            command -v termux-storage-get >/dev/null 2>&1 ||
                blocked 'Flower is not a published Cat Food package, no local APK found, and the optional Termux:API file picker is unavailable. Select/save the APK in Android Files, or provide FLOWER_APK_PATH.'
            mkdir -p "$catfood_root/downloads/manual" ||
                blocked 'cannot prepare private manual-intake directory'
            pickdir=$(mktemp -d "$catfood_root/downloads/manual/.flower-pick.XXXXXXXX") ||
                blocked 'cannot allocate safe file-picker output'
            pickfile="$pickdir/selected.apk"
            printf 'FLOWER_APK_PICKER: choose the already downloaded %s APK in Android Files.\n' "$lane"
            if ! termux-storage-get "$pickfile"; then
                rmdir "$pickdir" 2>/dev/null || :
                blocked 'Android file picker failed or Termux:API is not connected'
            fi
            if [ ! -f "$pickfile" ] || [ ! -r "$pickfile" ]; then
                rmdir "$pickdir" 2>/dev/null || :
                blocked 'Android file picker did not materialize a readable local APK'
            fi
            observed=$(sha256sum "$pickfile" | awk '{print $1}') ||
                blocked 'cannot hash picked Android document'
            if [ "$observed" != "$expected" ]; then
                # Keep user-supplied content separate; never mistake a wrong
                # selection for the signed APK or delete another user file.
                blocked "picked APK SHA mismatch; selection retained at $pickfile, nothing installed"
            fi
            canonical="$catfood_root/downloads/manual/flower-$lane-$expected.apk"
            if [ -e "$canonical" ] || [ -L "$canonical" ]; then
                current=$(sha256sum "$canonical" | awk '{print $1}') ||
                    blocked 'existing Cat Food manual file cannot be verified'
                [ "$current" = "$expected" ] ||
                    blocked 'manual-intake destination exists with mismatched bytes'
                selected=$canonical
                rm -f -- "$pickfile"
            else
                mv -- "$pickfile" "$canonical" ||
                    blocked 'could not retain picked, verified APK in Cat Food area'
                selected=$canonical
            fi
            rmdir "$pickdir" 2>/dev/null || :
            acquisition=android-documents-picker
        fi
    fi
fi

[ -f "$selected" ] && [ -r "$selected" ] ||
    blocked 'selected file lost before use'
[ "$(sha256sum "$selected" | awk '{print $1}')" = "$expected" ] ||
    blocked 'selected APK changed between discovery and installation request'
printf 'FLOWER_APK_VERIFIED: %s / %s / %s\n' "$lane" "$model" "$abi"
printf 'CATFOOD_STATUS=Flower-test-APK-local-only; not-yet-published-package\n'
printf 'ACQUISITION=%s\nSOURCE=%s\nSUBPIXEL=%s\nSHA256=%s\nAPK=%s\n' \
    "$acquisition" "$source" "$subpixel_source" "$expected" "$selected"

outcome=INSTALLER_INTENT_FAILED
if termux-open --view --content-type application/vnd.android.package-archive "$selected"; then
    outcome=INSTALLER_INTENT_REQUESTED
fi
receipt_dir="$HOME/.local/state/kitchen/flower-subpixel-apk"
mkdir -p "$receipt_dir" || blocked 'cannot prepare intent receipt'
receipt="$receipt_dir/intent-$(date +%Y%m%dT%H%M%S)-$$.tsv"
{
    printf 'scope\tSUN-124-125-Flower-test-APK-intent\n'
    printf 'model\t%s\nabi\t%s\nproduct\t%s\n' "$model" "$abi" "$device"
    printf 'lane\t%s\napk_source_commit\t%s\nsubpixel_source_commit\t%s\n' \
        "$lane" "$source" "$subpixel_source"
    printf 'apk_sha256\t%s\nfile\t%s\nacquisition\t%s\n' \
        "$expected" "$selected" "$acquisition"
    printf 'installer_intent\t%s\n' "$outcome"
    printf 'installation_result\tNOT_VERIFIED\nlaunch_result\tNOT_VERIFIED\n'
    printf 'runtime_result\tNOT_VERIFIED\nphysical_device_result\tNOT_VERIFIED\n'
    printf 'physical_instance\tNOT_ESTABLISHED\n'
} > "$receipt" || blocked 'cannot write intent-only receipt'
printf 'FLOWER_APK_HANDOFF=%s receipt=%s\n' "$outcome" "$receipt"
[ "$outcome" = INSTALLER_INTENT_REQUESTED ] ||
    blocked 'package installer was not opened; installation is NOT_VERIFIED'
