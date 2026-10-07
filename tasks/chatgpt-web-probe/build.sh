#!/usr/bin/env bash
set -Eeuo pipefail

fail() {
    printf 'chatgpt-web-probe build: %s\n' "$*" >&2
    exit 1
}

for name in CHATGPT_PROBE_CHECKOUT CATFOOD_CHECKOUT ANDROID_NDK_CHECKOUT AICI_CHECKOUT ANDROID_NDK_HOME; do
    [[ -n ${!name:-} ]] || fail "required environment value is unset: $name"
done

for checkout in "$CHATGPT_PROBE_CHECKOUT" "$CATFOOD_CHECKOUT" "$ANDROID_NDK_CHECKOUT" "$AICI_CHECKOUT"; do
    [[ -d "$checkout/.git" ]] || fail "not a Git checkout: $checkout"
done

android_home=${ANDROID_HOME:-${ANDROID_SDK_ROOT:-}}
[[ -n "$android_home" ]] || fail "ANDROID_HOME/ANDROID_SDK_ROOT is required"

source_file="$CHATGPT_PROBE_CHECKOUT/probe/native_activity.c"
manifest="$CHATGPT_PROBE_CHECKOUT/probe/AndroidManifest.xml"
targets="$CATFOOD_CHECKOUT/android/chatgpt-web-probe-targets.tsv"
build_contract="$CATFOOD_CHECKOUT/android/chatgpt-web-probe-build.tsv"
packager="$ANDROID_NDK_CHECKOUT/apk/build-nativeactivity-apk.sh"
key="$AICI_CHECKOUT/android-signing/test-keys/chatgpt-probe-test.p12"
identities="$AICI_CHECKOUT/android-signing/identities.tsv"
signing_source="$AICI_CHECKOUT/src/aici_android_signing.c"
out=${CHATGPT_PROBE_OUTPUT_DIR:-"$PWD/chatgpt-web-probe-out"}

for file in "$source_file" "$manifest" "$targets" "$build_contract" "$packager" "$key" "$identities" "$signing_source"; do
    [[ -f "$file" ]] || fail "required file is missing: $file"
done

sh "$CATFOOD_CHECKOUT/android/check.sh" check >/dev/null ||
    fail "Cat Food Android policy check failed"

if find "$CHATGPT_PROBE_CHECKOUT/probe" -type f \( -name '*.java' -o -name '*.kt' -o -name 'build.gradle' -o -name 'build.gradle.kts' \) -print -quit | grep . >/dev/null; then
    fail "probe contains a Java/Kotlin/Gradle application path"
fi

IFS=$'\t' read -r h_package h_min h_target h_library h_activity h_no_dex < "$build_contract"
IFS=$'\t' read -r package_id min_sdk target_sdk native_library activity no_dex < <(sed -n '2p' "$build_contract")
[[ "$h_package:$h_min:$h_target:$h_library:$h_activity:$h_no_dex" ==    "package_id:min_sdk:target_sdk:native_library:activity:no_dex" ]] ||
    fail "unexpected Cat Food build-contract header"
[[ "$activity" == "android.app.NativeActivity" && "$no_dex" == "true" ]] ||
    fail "probe contract must require NativeActivity with no DEX"

signer=$(
    awk -F '\t' -v package="$package_id" '
        $1 == package && $2 == "test" {print $3}
    ' "$identities"
)
[[ "$signer" =~ ^[0-9a-f]{64}$ ]] ||
    fail "ai-ci has no unique test signer for $package_id"

case "$(uname -s)-$(uname -m)" in
    Linux-x86_64) ndk_host=linux-x86_64 ;;
    Linux-aarch64|Linux-arm64) ndk_host=linux-aarch64 ;;
    *) fail "unsupported NDK build host: $(uname -s)-$(uname -m)" ;;
esac

clang_root="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/$ndk_host/bin"
[[ -d "$clang_root" ]] || fail "NDK LLVM toolchain is missing: $clang_root"

build_tools=$(
    find "$android_home/build-tools" -mindepth 1 -maxdepth 1 -type d |
        sort -V | tail -n 1
)
[[ -n "$build_tools" ]] || fail "Android build-tools are missing"

rm -rf "$out"
mkdir -p "$out/lib" "$out/apk"

source_commit=$(git -C "$CHATGPT_PROBE_CHECKOUT" rev-parse HEAD)
packager_commit=$(git -C "$ANDROID_NDK_CHECKOUT" rev-parse HEAD)
catfood_commit=$(git -C "$CATFOOD_CHECKOUT" rev-parse HEAD)
aici_commit=$(git -C "$AICI_CHECKOUT" rev-parse HEAD)

verifier="$out/aici-android-signing"
cc -std=c17 -Wall -Wextra -Werror -pedantic -O2 "$signing_source" -o "$verifier"

printf 'target\tdevice\tabi\tapk\tapk_sha256\tpackager_receipt\n' > "$out/artifacts.tsv"

tail -n +2 "$targets" |
while IFS=$'\t' read -r device abi ndk_target api priority profile physical_acceptance; do
    [[ -n "$device" ]] || continue
    compiler="$clang_root/${ndk_target}${api}-clang"
    [[ -x "$compiler" ]] || fail "target compiler is missing: $compiler"

    case "$device" in
        MIRO_A1) target=phone; suffix=a1 ;;
        MIRO_C67) target=c67; suffix=c67 ;;
        *) fail "unsupported Cat Food probe device: $device" ;;
    esac

    mkdir -p "$out/lib/$suffix"
    library="$out/lib/$suffix/lib${native_library}.so"
    "$compiler"         -std=c17 -Wall -Wextra -Werror -pedantic -O2         -fPIC -shared         -Wl,-soname,"lib${native_library}.so"         -Wl,--no-undefined -Wl,-z,relro,-z,now         "$source_file" -llog -landroid         -o "$library"

    llvm_readelf="$clang_root/llvm-readelf"
    "$llvm_readelf" -h "$library" > "$out/lib/${suffix}.elf.txt"
    grep -Eq 'Type:[[:space:]]+DYN' "$out/lib/${suffix}.elf.txt" ||
        fail "$device library is not a shared object"

    apk="$out/apk/chatgpt-web-probe-${suffix}.apk"
    export ANDROID_PACKAGE_ID="$package_id"
    export ANDROID_VERSION_CODE="${CHATGPT_PROBE_VERSION_CODE:-1}"
    export ANDROID_VERSION_NAME="${CHATGPT_PROBE_VERSION_NAME:-0.1.0}"
    export ANDROID_MIN_SDK="$min_sdk"
    export ANDROID_TARGET_SDK="$target_sdk"
    export ANDROID_KEYSTORE="$key"
    export ANDROID_KEYSTORE_TYPE=PKCS12
    export ANDROID_KEY_ALIAS=chatgpt-probe-test
    export ANDROID_STORE_PASSWORD=chatgpt-probe-test
    export ANDROID_KEY_PASSWORD=chatgpt-probe-test
    export ANDROID_EXPECTED_CERT_SHA256="$signer"
    export ANDROID_SOURCE_COMMIT="$source_commit"
    export ANDROID_REQUIRE_NO_DEX=1

    bash "$packager" "$manifest" "$library" "$abi" "$apk"         > "$out/apk/${suffix}.packager.txt"

    AICI_APK="$apk" AICI_SIGNING_LANE=test         "$verifier" verify "$identities" "$package_id" test "$signer"         > "$out/apk/${suffix}.signing.txt"

    apk_sha=$(sha256sum "$apk" | awk '{print $1}')
    receipt="${apk%.apk}.receipt.tsv"
    [[ -f "$receipt" ]] || fail "packager receipt missing for $target"

    printf '%s\t%s\t%s\t%s\t%s\t%s\n'         "$target" "$device" "$abi" "$apk" "$apk_sha" "$receipt"         >> "$out/artifacts.tsv"
done

{
    printf 'source_commit\t%s\n' "$source_commit"
    printf 'catfood_commit\t%s\n' "$catfood_commit"
    printf 'android_ndk_commit\t%s\n' "$packager_commit"
    printf 'aici_commit\t%s\n' "$aici_commit"
    printf 'package_id\t%s\n' "$package_id"
    printf 'signer_cert_sha256\t%s\n' "$signer"
} > "$out/provenance.tsv"

[[ "$(($(wc -l < "$out/artifacts.tsv") - 1))" -eq 2 ]] ||
    fail "paired A1/C67 producer did not emit exactly two artifacts"

printf '%s\n' 'CHATGPT_WEB_PROBE_BUILD PASS'
printf 'artifacts=%s\n' "$out/artifacts.tsv"
