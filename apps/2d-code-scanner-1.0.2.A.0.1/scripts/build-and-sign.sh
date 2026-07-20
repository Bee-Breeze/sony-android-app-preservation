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
zipalign_bin="${ZIPALIGN:-zipalign}"
apksigner_bin="${APKSIGNER:-apksigner}"

for command_path in python3 unzip shasum "$zipalign_bin" "$apksigner_bin"; do
  command -v "$command_path" >/dev/null || {
    printf 'Required command not found: %s\n' "$command_path" >&2
    exit 1
  }
done
java -version >/dev/null 2>&1 || {
  printf 'Java is present but not runnable. Set JAVA_HOME to a working JDK 17+.\n' >&2
  exit 1
}
"$script_dir/verify-input.sh" "$original"
[[ ! -e "$output" ]] || { printf 'Refusing to overwrite: %s\n' "$output" >&2; exit 1; }

work_dir="$(mktemp -d "${TMPDIR:-/tmp}/sony-2d-scanner-patch.XXXXXX")"
trap 'rm -rf "$work_dir"' EXIT
unzip -p "$original" AndroidManifest.xml > "$work_dir/manifest-original.xml"

python3 "$app_dir/tools/rewrite_binary_axml_attribute.py" "$work_dir/manifest-original.xml" "$work_dir/manifest-api33.xml" --element uses-sdk --attribute minSdkVersion --from-resource-id 0x0101020c --from-type int --from-value 34 --to-resource-id 0x0101020c --to-type int --to-value 33

python3 "$app_dir/tools/rewrite_binary_axml_attribute.py" "$work_dir/manifest-api33.xml" "$work_dir/AndroidManifest.xml" --element uses-library --attribute required --from-resource-id 0x0101028e --from-type boolean --from-value true --to-resource-id 0x0101028e --to-type boolean --to-value false

python3 "$app_dir/tools/rebuild_zip_with_replacement.py" "$original" "$work_dir/unsigned.apk" --replace AndroidManifest.xml --with-file "$work_dir/AndroidManifest.xml"
"$zipalign_bin" -f -p 4 "$work_dir/unsigned.apk" "$work_dir/aligned.apk"
"$apksigner_bin" sign --ks "$keystore" --ks-key-alias "$alias_name" --ks-pass env:KEYSTORE_PASSWORD --key-pass env:KEY_PASSWORD --out "$output" "$work_dir/aligned.apk"
[[ -s "$output" ]] || { printf 'Signing did not create the requested output.\n' >&2; exit 1; }
"$apksigner_bin" verify --verbose --print-certs "$output"
"$zipalign_bin" -c -p 4 "$output"
unzip -t "$output"
shasum -a 256 "$output"
