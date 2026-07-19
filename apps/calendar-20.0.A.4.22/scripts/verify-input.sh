#!/usr/bin/env bash
set -euo pipefail

EXPECTED_SHA256="32bee2fab611f71914c2eed421630f2db9eae182476a07ae1cc2aa5ca0c61ae4"

if [[ $# -ne 1 ]]; then
  printf 'Usage: %s ORIGINAL.apk\n' "$0" >&2
  exit 2
fi

actual="$(shasum -a 256 "$1" | awk '{print $1}')"
if [[ "$actual" != "$EXPECTED_SHA256" ]]; then
  printf 'Input mismatch.\nExpected: %s\nActual:   %s\n' \
    "$EXPECTED_SHA256" "$actual" >&2
  exit 1
fi

printf 'Input verified: %s\n' "$actual"
