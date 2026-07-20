#!/usr/bin/env bash
set -euo pipefail

expected="883cd3561721602d9efa3f8bde0982151d4dbf87349837439355665eaf05ba39"
[[ $# -eq 1 ]] || { printf 'Usage: %s ORIGINAL.apk\n' "$0" >&2; exit 2; }
actual="$(shasum -a 256 "$1" | awk '{print $1}')"
[[ "$actual" == "$expected" ]] || {
  printf 'Input mismatch.\nExpected: %s\nActual:   %s\n' "$expected" "$actual" >&2
  exit 1
}
printf 'Input verified: %s\n' "$actual"
