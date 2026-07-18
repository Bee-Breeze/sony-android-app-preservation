#!/usr/bin/env bash
set -euo pipefail

EXPECTED_SHA256="90e13103c10c9f092f8ff587250dd02fe0c1b4aee010300ae4d4573035f254c2"

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

