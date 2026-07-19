#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 6 ]]; then
  printf 'Usage: KEYSTORE_PASSWORD=... KEY_PASSWORD=... %s ORIGINAL.apk FRAMEWORK_RES.apk UXPRES_FRAMEWORK.apk OUTPUT.apk KEYSTORE ALIAS\n' "$0" >&2
  exit 2
fi

: "${KEYSTORE_PASSWORD:?Set KEYSTORE_PASSWORD}"
: "${KEY_PASSWORD:?Set KEY_PASSWORD}"

original="$1"
framework_res="$2"
uxpres_framework="$3"
output="$4"
keystore="$5"
alias_name="$6"
script_dir="$(cd "$(dirname "$0")" && pwd)"
app_dir="$(cd "$script_dir/.." && pwd)"
apktool_bin="${APKTOOL:-apktool}"
zipalign_bin="${ZIPALIGN:-zipalign}"
apksigner_bin="${APKSIGNER:-apksigner}"

for command_path in java "$apktool_bin" "$zipalign_bin" "$apksigner_bin" patch; do
  command -v "$command_path" >/dev/null || {
    printf 'Required command not found: %s\n' "$command_path" >&2
    exit 1
  }
done

java -version >/dev/null 2>&1 || {
  printf 'Java is present but not runnable. Set JAVA_HOME to a working JDK 17+ path.\n' >&2
  exit 1
}

"$script_dir/verify-input.sh" "$original"
[[ -r "$uxpres_framework" ]] || {
  printf 'Sony UX framework APK is not readable: %s\n' "$uxpres_framework" >&2
  exit 1
}
[[ -r "$framework_res" ]] || {
  printf 'Sony framework-res APK is not readable: %s\n' "$framework_res" >&2
  exit 1
}

work_dir="$(mktemp -d "${TMPDIR:-/tmp}/calendar-20-patch.XXXXXX")"
trap 'rm -rf "$work_dir"' EXIT
framework_dir="$work_dir/framework"
mkdir -p "$framework_dir"

"$apktool_bin" if -p "$framework_dir" "$framework_res"
"$apktool_bin" if -p "$framework_dir" "$uxpres_framework"
"$apktool_bin" d -f -p "$framework_dir" "$original" -o "$work_dir/decoded"
patch -d "$work_dir/decoded" -p1 \
  < "$app_dir/patches/calendar-20.0.A.4.22-portable-v3.patch"
"$apktool_bin" b -p "$framework_dir" "$work_dir/decoded" -o "$work_dir/unsigned.apk"
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
