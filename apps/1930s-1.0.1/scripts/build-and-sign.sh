#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 5 ]]; then
  printf 'Usage: KEYSTORE_PASSWORD=... KEY_PASSWORD=... %s 1930S.apk STYLE.apk OUTDIR KEYSTORE ALIAS\n' "$0" >&2
  exit 2
fi

: "${KEYSTORE_PASSWORD:?Set KEYSTORE_PASSWORD}"
: "${KEY_PASSWORD:?Set KEY_PASSWORD}"

addon="$1"
host="$2"
out="$3"
keystore="$4"
alias_name="$5"
script_dir="$(cd "$(dirname "$0")" && pwd)"
app_dir="$(cd "$script_dir/.." && pwd)"
apktool_bin="${APKTOOL:-apktool}"
zipalign_bin="${ZIPALIGN:-zipalign}"
apksigner_bin="${APKSIGNER:-apksigner}"

for command_path in python3 "$apktool_bin" "$zipalign_bin" "$apksigner_bin" unzip zip shasum; do
  command -v "$command_path" >/dev/null || {
    printf 'Required command not found: %s\n' "$command_path" >&2
    exit 1
  }
done

expected_addon="a8831dd72c66bf48e26e09509d975c8a11f3bfbcfb16825943c88ac3aa291e26"
expected_host="0f844f1cbc37154370642fab3398b74a2804003dd2825953a3ce0919d53d8c5f"
actual_addon="$(shasum -a 256 "$addon" | awk '{print $1}')"
actual_host="$(shasum -a 256 "$host" | awk '{print $1}')"
[[ "$actual_addon" == "$expected_addon" ]] || { printf 'Unexpected 1930s input SHA-256\n' >&2; exit 1; }
[[ "$actual_host" == "$expected_host" ]] || { printf 'Unexpected Style portrait input SHA-256\n' >&2; exit 1; }

[[ ! -e "$out" ]] || { printf 'Refusing to overwrite output directory: %s\n' "$out" >&2; exit 1; }
mkdir -p "$out"
work_dir="$(mktemp -d "${TMPDIR:-/tmp}/sony-1930s-patch.XXXXXX")"
trap 'rm -rf "$work_dir"' EXIT

"$apktool_bin" d -f "$addon" -o "$work_dir/addon"
python3 "$app_dir/tools/make_optional_library.py" \
  "$work_dir/addon/AndroidManifest.xml" com.sony.device
"$apktool_bin" b "$work_dir/addon" -o "$work_dir/addon-unsigned.apk"
"$zipalign_bin" -f -p 4 "$work_dir/addon-unsigned.apk" "$work_dir/addon-aligned.apk"
"$apksigner_bin" sign \
  --ks "$keystore" --ks-key-alias "$alias_name" \
  --ks-pass env:KEYSTORE_PASSWORD --key-pass env:KEY_PASSWORD \
  --out "$out/1930s-1.0.1-portable.apk" "$work_dir/addon-aligned.apk"

unzip -p "$host" AndroidManifest.xml > "$work_dir/host-manifest.xml"
python3 "$app_dir/tools/rewrite_binary_axml_attribute.py" \
  "$work_dir/host-manifest.xml" "$work_dir/AndroidManifest.xml" \
  --element application --attribute resizeableActivity \
  --from-resource-id 0x010104f6 --from-type boolean --from-value false \
  --to-resource-id 0x01010560 --to-type float --to-value 3.0
cp "$host" "$work_dir/host-unsigned.apk"
zip -q -d "$work_dir/host-unsigned.apk" 'META-INF/*' AndroidManifest.xml
(cd "$work_dir" && zip -q -D -X host-unsigned.apk AndroidManifest.xml)
"$zipalign_bin" -f -p 4 "$work_dir/host-unsigned.apk" "$work_dir/host-aligned.apk"
"$apksigner_bin" sign \
  --ks "$keystore" --ks-key-alias "$alias_name" \
  --ks-pass env:KEYSTORE_PASSWORD --key-pass env:KEY_PASSWORD \
  --out "$out/style-portrait-30.0.A.0.1-maxaspect.apk" "$work_dir/host-aligned.apk"

"$apksigner_bin" verify --verbose --print-certs "$out/1930s-1.0.1-portable.apk"
"$apksigner_bin" verify --verbose --print-certs "$out/style-portrait-30.0.A.0.1-maxaspect.apk"
shasum -a 256 "$out"/*.apk
