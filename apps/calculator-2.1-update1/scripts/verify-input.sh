#!/usr/bin/env bash
set -euo pipefail

EXPECTED_SHA256="76826e20297f97e31bf0fe381ab69590839d64f0bd943d07641551cf8a033b20"

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
