#!/usr/bin/env python3
"""Rewrite one compiled Android XML attribute without rebuilding resources."""

from __future__ import annotations

import argparse
import struct
from pathlib import Path

from patch_binary_axml_bool import (
    RES_STRING_POOL_TYPE,
    RES_XML_START_ELEMENT_TYPE,
    read_string_pool,
    u16,
    u32,
)


RES_XML_RESOURCE_MAP_TYPE = 0x0180
VALUE_TYPES = {
    "float": 0x04,
    "int": 0x10,
    "boolean": 0x12,
}


def parse_value(kind: str, value: str) -> int:
    if kind == "boolean":
        if value not in {"true", "false"}:
            raise ValueError("Boolean values must be true or false")
        return 0xFFFFFFFF if value == "true" else 0
    if kind == "float":
        return struct.unpack("<I", struct.pack("<f", float(value)))[0]
    return int(value, 0) & 0xFFFFFFFF


def rewrite_attribute(
    data: bytearray,
    element_name: str,
    attribute_name: str,
    old_resource_id: int,
    old_type: int,
    old_value: int,
    new_resource_id: int,
    new_type: int,
    new_value: int,
) -> tuple[int, int]:
    root_type, root_header_size, root_size = struct.unpack_from("<HHI", data, 0)
    if root_type != 0x0003 or root_size != len(data):
        raise ValueError("Input is not a complete Android binary XML document")

    offset = root_header_size
    strings: list[str] | None = None
    resource_map: tuple[int, int] | None = None
    matches: list[tuple[int, int]] = []

    while offset < len(data):
        chunk_type, header_size, chunk_size = struct.unpack_from("<HHI", data, offset)
        if chunk_size < header_size or offset + chunk_size > len(data):
            raise ValueError(f"Invalid chunk at 0x{offset:x}")
        if chunk_type == RES_STRING_POOL_TYPE and strings is None:
            strings = read_string_pool(data, offset)
        elif chunk_type == RES_XML_RESOURCE_MAP_TYPE:
            resource_map = (offset + header_size, (chunk_size - header_size) // 4)
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
                    if data[attribute + 15] != old_type or u32(data, attribute + 16) != old_value:
                        raise ValueError(
                            f"Unexpected typed value for {element_name}/{attribute_name}"
                        )
                    matches.append((attribute, attr_name_index))
        offset += chunk_size

    if len(matches) != 1:
        raise ValueError(
            f"Expected exactly one {element_name}/{attribute_name} match, found {len(matches)}"
        )
    if resource_map is None:
        raise ValueError("Binary XML has no resource map")

    attribute, attr_name_index = matches[0]
    map_start, map_count = resource_map
    if attr_name_index >= map_count:
        raise ValueError("Attribute string index has no resource-map entry")
    map_entry = map_start + attr_name_index * 4
    if u32(data, map_entry) != old_resource_id:
        raise ValueError(
            f"Resource ID is 0x{u32(data, map_entry):08x}, expected 0x{old_resource_id:08x}"
        )

    struct.pack_into("<I", data, map_entry, new_resource_id)
    data[attribute + 15] = new_type
    struct.pack_into("<I", data, attribute + 16, new_value)
    return map_entry, attribute + 15


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("input", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--element", required=True)
    parser.add_argument("--attribute", required=True)
    parser.add_argument("--from-resource-id", type=lambda value: int(value, 0), required=True)
    parser.add_argument("--from-type", choices=VALUE_TYPES, required=True)
    parser.add_argument("--from-value", required=True)
    parser.add_argument("--to-resource-id", type=lambda value: int(value, 0), required=True)
    parser.add_argument("--to-type", choices=VALUE_TYPES, required=True)
    parser.add_argument("--to-value", required=True)
    args = parser.parse_args()

    if args.input.resolve() == args.output.resolve():
        raise SystemExit("Refusing to patch in place")
    if args.output.exists():
        raise SystemExit(f"Refusing to overwrite existing output: {args.output}")

    old_type = VALUE_TYPES[args.from_type]
    new_type = VALUE_TYPES[args.to_type]
    data = bytearray(args.input.read_bytes())
    map_offset, value_offset = rewrite_attribute(
        data,
        args.element,
        args.attribute,
        args.from_resource_id,
        old_type,
        parse_value(args.from_type, args.from_value),
        args.to_resource_id,
        new_type,
        parse_value(args.to_type, args.to_value),
    )
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_bytes(data)
    print(
        f"Patched resource map at 0x{map_offset:x} and typed value at 0x{value_offset:x}"
    )


if __name__ == "__main__":
    main()
