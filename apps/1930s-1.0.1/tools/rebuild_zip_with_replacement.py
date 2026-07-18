#!/usr/bin/env python3
"""Rebuild a clean ZIP/APK while replacing one entry and dropping signatures."""

from __future__ import annotations

import argparse
import copy
import zipfile
from pathlib import Path


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("input", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--replace", required=True, help="Archive entry to replace")
    parser.add_argument("--with-file", type=Path, required=True)
    parser.add_argument(
        "--drop-prefix",
        action="append",
        default=["META-INF/"],
        help="Archive entry prefix to omit; may be repeated",
    )
    args = parser.parse_args()

    if args.input.resolve() == args.output.resolve():
        raise SystemExit("Refusing to rebuild in place")
    if args.output.exists():
        raise SystemExit(f"Refusing to overwrite existing output: {args.output}")

    replacement = args.with_file.read_bytes()
    replaced = 0
    seen: set[str] = set()
    args.output.parent.mkdir(parents=True, exist_ok=True)

    with zipfile.ZipFile(args.input) as source, zipfile.ZipFile(
        args.output, "w", allowZip64=True
    ) as destination:
        for source_info in source.infolist():
            name = source_info.filename
            if any(name.upper().startswith(prefix.upper()) for prefix in args.drop_prefix):
                continue
            if name in seen:
                raise SystemExit(f"Duplicate input entry: {name}")
            seen.add(name)

            info = copy.copy(source_info)
            info.extra = b""
            info.comment = b""
            info.flag_bits = 0
            data = replacement if name == args.replace else source.read(source_info)
            if name == args.replace:
                replaced += 1
            destination.writestr(info, data, compress_type=source_info.compress_type)

    if replaced != 1:
        args.output.unlink(missing_ok=True)
        raise SystemExit(f"Expected one {args.replace} entry, replaced {replaced}")

    with zipfile.ZipFile(args.output) as result:
        bad_crc = result.testzip()
        if bad_crc is not None:
            raise SystemExit(f"CRC verification failed for {bad_crc}")
        if any(info.extra for info in result.infolist()):
            raise SystemExit("Unexpected extra field in clean archive")
        print(f"rebuilt {len(result.infolist())} clean entries: {args.output}")


if __name__ == "__main__":
    main()
