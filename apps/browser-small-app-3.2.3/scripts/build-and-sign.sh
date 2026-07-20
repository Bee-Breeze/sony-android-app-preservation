#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 4 ]]; then
  printf 'Usage: KEYSTORE_PASSWORD=... KEY_PASSWORD=... %s ORIGINAL.apk OUTPUT.apk KEYSTORE ALIAS\n' "$0" >&2
  exit 2
fi

: "${KEYSTORE_PASSWORD:?Set KEYSTORE_PASSWORD}"
: "${KEY_PASSWORD:?Set KEY_PASSWORD}"

original="$1"
output="$2"
keystore="$3"
alias_name="$4"
script_dir="$(cd "$(dirname "$0")" && pwd)"
app_dir="$(cd "$script_dir/.." && pwd)"
if [[ -n "${APKTOOL_JAR:-}" ]]; then
  apktool_cmd=(java -jar "$APKTOOL_JAR")
else
  apktool_cmd=("${APKTOOL:-apktool}")
fi
sdk_root="${ANDROID_SDK_ROOT:-${ANDROID_HOME:-$HOME/Library/Android/sdk}}"
build_tools_version="${ANDROID_BUILD_TOOLS_VERSION:-35.0.0}"
android_platform="${ANDROID_PLATFORM_VERSION:-35}"
android_jar="${ANDROID_JAR:-$sdk_root/platforms/android-$android_platform/android.jar}"
build_tools="${ANDROID_BUILD_TOOLS:-$sdk_root/build-tools/$build_tools_version}"
d8_bin="${D8:-$build_tools/d8}"
zipalign_bin="${ZIPALIGN:-$build_tools/zipalign}"
apksigner_bin="${APKSIGNER:-$build_tools/apksigner}"

for command_path in java javac jar "$d8_bin" "$zipalign_bin" "$apksigner_bin" patch; do
  command -v "$command_path" >/dev/null || {
    printf 'Required command not found: %s\n' "$command_path" >&2
    exit 1
  }
done

apktool_version="$("${apktool_cmd[@]}" --version)"
if [[ "$apktool_version" != "3.0.2" ]]; then
  printf 'Apktool 3.0.2 is required for the verified two-pass resource layout; found %s.\n' \
    "$apktool_version" >&2
  exit 1
fi

[[ -r "$android_jar" ]] || {
  printf 'Android platform jar is not readable: %s\n' "$android_jar" >&2
  exit 1
}

"$script_dir/verify-input.sh" "$original"

work_dir="$(mktemp -d "${TMPDIR:-/tmp}/browser-small-app-patch.XXXXXX")"
trap 'rm -rf "$work_dir"' EXIT

"${apktool_cmd[@]}" d -f "$original" -o "$work_dir/normalized-source"
"${apktool_cmd[@]}" b "$work_dir/normalized-source" \
  -o "$work_dir/normalized.apk"
"${apktool_cmd[@]}" d -f "$work_dir/normalized.apk" \
  -o "$work_dir/decoded"
patch -d "$work_dir/decoded" -p1 < "$app_dir/patches/AndroidManifest.patch"

mkdir -p "$work_dir/classes" "$work_dir/dex"
javac -source 8 -target 8 -classpath "$android_jar" \
  -d "$work_dir/classes" "$app_dir/patches/FullBrowserActivity.java"
jar cf "$work_dir/full-browser-activity.jar" -C "$work_dir/classes" .
"$d8_bin" --min-api 16 --lib "$android_jar" \
  --output "$work_dir/dex" "$work_dir/full-browser-activity.jar"
cp "$work_dir/dex/classes.dex" "$work_dir/decoded/classes2.dex"

"${apktool_cmd[@]}" b "$work_dir/decoded" -o "$work_dir/unsigned.apk"
"$zipalign_bin" -f -p 4 "$work_dir/unsigned.apk" "$work_dir/aligned.apk"
"$apksigner_bin" sign \
  --ks "$keystore" \
  --ks-key-alias "$alias_name" \
  --ks-pass env:KEYSTORE_PASSWORD \
  --key-pass env:KEY_PASSWORD \
  --out "$output" \
  "$work_dir/aligned.apk"
"$apksigner_bin" verify --verbose --print-certs "$output"

printf 'Built: %s\nSHA-256: ' "$output"
shasum -a 256 "$output" | awk '{print $1}'
