#!/usr/bin/env bash
set -euo pipefail

EXPECTED_SHA256="dbac9c685f3d5072413d037ffa7de12f7617015dd20ace236802ddd2ea707551"

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
