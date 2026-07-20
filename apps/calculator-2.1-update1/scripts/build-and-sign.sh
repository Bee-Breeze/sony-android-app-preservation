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
apktool_bin="${APKTOOL:-apktool}"
zipalign_bin="${ZIPALIGN:-zipalign}"
apksigner_bin="${APKSIGNER:-apksigner}"

for command_path in java "$apktool_bin" "$zipalign_bin" "$apksigner_bin" patch; do
  command -v "$command_path" >/dev/null || {
    printf 'Required command not found: %s\n' "$command_path" >&2
    exit 1
  }
done

"$script_dir/verify-input.sh" "$original"

work_dir="$(mktemp -d "${TMPDIR:-/tmp}/calculator-2.1-patch.XXXXXX")"
trap 'rm -rf "$work_dir"' EXIT

"$apktool_bin" d -f "$original" -o "$work_dir/decoded"
patch -d "$work_dir/decoded" -p1 \
  < "$app_dir/patches/calculator-2.1-update1-portable-responsive-v4.patch"
"$apktool_bin" b "$work_dir/decoded" -o "$work_dir/unsigned.apk"
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
