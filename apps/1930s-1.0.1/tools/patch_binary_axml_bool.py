#!/usr/bin/env python3
"""Patch one boolean attribute in a compiled Android binary XML file."""

from __future__ import annotations

import argparse
import struct
from pathlib import Path


RES_STRING_POOL_TYPE = 0x0001
RES_XML_START_ELEMENT_TYPE = 0x0102
TYPE_INT_BOOLEAN = 0x12
UTF8_FLAG = 0x00000100


def u16(data: bytes | bytearray, offset: int) -> int:
    return struct.unpack_from("<H", data, offset)[0]


def u32(data: bytes | bytearray, offset: int) -> int:
    return struct.unpack_from("<I", data, offset)[0]


def decode_length8(data: bytes | bytearray, offset: int) -> tuple[int, int]:
    first = data[offset]
    if first & 0x80:
        return ((first & 0x7F) << 8) | data[offset + 1], 2
    return first, 1


def decode_length16(data: bytes | bytearray, offset: int) -> tuple[int, int]:
    first = u16(data, offset)
    if first & 0x8000:
        return ((first & 0x7FFF) << 16) | u16(data, offset + 2), 4
    return first, 2


def read_string_pool(data: bytes | bytearray, offset: int) -> list[str]:
    chunk_type, header_size, chunk_size = struct.unpack_from("<HHI", data, offset)
    if chunk_type != RES_STRING_POOL_TYPE:
        raise ValueError(f"Expected string pool at 0x{offset:x}, found 0x{chunk_type:04x}")
    if offset + chunk_size > len(data):
        raise ValueError("String pool exceeds input size")

    string_count = u32(data, offset + 8)
    flags = u32(data, offset + 16)
    strings_start = u32(data, offset + 20)
    offsets_start = offset + header_size
    strings_base = offset + strings_start
    strings: list[str] = []

    for index in range(string_count):
        string_offset = strings_base + u32(data, offsets_start + index * 4)
        if flags & UTF8_FLAG:
            _, consumed16 = decode_length8(data, string_offset)
            byte_length, consumed8 = decode_length8(data, string_offset + consumed16)
            start = string_offset + consumed16 + consumed8
            strings.append(bytes(data[start : start + byte_length]).decode("utf-8"))
        else:
            utf16_length, consumed = decode_length16(data, string_offset)
            start = string_offset + consumed
            strings.append(bytes(data[start : start + utf16_length * 2]).decode("utf-16le"))
    return strings


def patch_bool(
    data: bytearray,
    element_name: str,
    attribute_name: str,
    expected: bool,
    replacement: bool,
) -> int:
    root_type, root_header_size, root_size = struct.unpack_from("<HHI", data, 0)
    if root_type != 0x0003 or root_size != len(data):
        raise ValueError("Input is not a complete Android binary XML document")

    offset = root_header_size
    strings: list[str] | None = None
    matches: list[int] = []
    expected_value = 0xFFFFFFFF if expected else 0

    while offset < len(data):
        chunk_type, header_size, chunk_size = struct.unpack_from("<HHI", data, offset)
        if chunk_size < header_size or offset + chunk_size > len(data):
            raise ValueError(f"Invalid chunk at 0x{offset:x}")

        if chunk_type == RES_STRING_POOL_TYPE and strings is None:
            strings = read_string_pool(data, offset)
        elif chunk_type == RES_XML_START_ELEMENT_TYPE:
            if strings is None:
                raise ValueError("Start element appeared before string pool")
            extension = offset + header_size
            name_index = u32(data, extension + 4)
            if name_index >= len(strings):
                raise ValueError("Element name index is outside the string pool")
            if strings[name_index] == element_name:
                attribute_start = u16(data, extension + 8)
                attribute_size = u16(data, extension + 10)
                attribute_count = u16(data, extension + 12)
                if attribute_size < 20:
                    raise ValueError("Unexpected binary XML attribute size")
                first_attribute = extension + attribute_start
                for index in range(attribute_count):
                    attribute = first_attribute + index * attribute_size
                    attr_name_index = u32(data, attribute + 4)
                    if attr_name_index >= len(strings):
                        raise ValueError("Attribute name index is outside the string pool")
                    if strings[attr_name_index] != attribute_name:
                        continue
                    value_type = data[attribute + 15]
                    value = u32(data, attribute + 16)
                    if value_type != TYPE_INT_BOOLEAN:
                        raise ValueError(
                            f"{element_name}/{attribute_name} is type 0x{value_type:02x}, not boolean"
                        )
                    if value != expected_value:
                        raise ValueError(
                            f"{element_name}/{attribute_name} is 0x{value:08x}, expected 0x{expected_value:08x}"
                        )
                    matches.append(attribute + 16)
        offset += chunk_size

    if len(matches) != 1:
        raise ValueError(
            f"Expected exactly one {element_name}/{attribute_name} match, found {len(matches)}"
        )
    struct.pack_into("<I", data, matches[0], 0xFFFFFFFF if replacement else 0)
    return matches[0]


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("input", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--element", required=True)
    parser.add_argument("--attribute", required=True)
    parser.add_argument("--from", dest="expected", choices=("true", "false"), required=True)
    parser.add_argument("--to", dest="replacement", choices=("true", "false"), required=True)
    args = parser.parse_args()

    if args.input.resolve() == args.output.resolve():
        raise SystemExit("Refusing to patch in place")
    if args.output.exists():
        raise SystemExit(f"Refusing to overwrite existing output: {args.output}")
    data = bytearray(args.input.read_bytes())
    changed_offset = patch_bool(
        data,
        args.element,
        args.attribute,
        args.expected == "true",
        args.replacement == "true",
    )
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_bytes(data)
    print(f"Patched offset 0x{changed_offset:x}: {args.expected} -> {args.replacement}")


if __name__ == "__main__":
    main()
