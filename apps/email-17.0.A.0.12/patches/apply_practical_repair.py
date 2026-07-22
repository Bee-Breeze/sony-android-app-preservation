#!/usr/bin/env python3
"""Apply the Sony Email 17.0.A.0.12 right-edge action repair."""

from __future__ import annotations

import argparse
import hashlib
import xml.etree.ElementTree as ET
from pathlib import Path


EXPECTED_APK_SHA256 = "de9d4f5a0fb4cb5abfe38ac522acc6bd92dd05a3ebcaa42eed2763e17730da3f"
ANDROID_NS = "http://schemas.android.com/apk/res/android"
ANDROID = f"{{{ANDROID_NS}}}"
DIMEN_NAME = "list_item_action_edge_margin"
DIMEN_VALUE = "40.0dp"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def android_id(name: str) -> str:
    return f"@id/{name}"


def replace_once(text: str, old: str, new: str, description: str) -> str:
    count = text.count(old)
    if count != 1:
        raise SystemExit(f"expected one {description}, found {count}")
    return text.replace(old, new, 1)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--original-apk", required=True, type=Path)
    parser.add_argument("--decoded-dir", required=True, type=Path)
    args = parser.parse_args()

    actual = sha256(args.original_apk)
    if actual != EXPECTED_APK_SHA256:
        raise SystemExit(f"refusing unexpected original APK SHA-256: {actual}")

    dimens_path = args.decoded_dir / "res/values/dimens.xml"
    layout_path = args.decoded_dir / "res/layout/message_list_item_normal.xml"
    if not dimens_path.is_file() or not layout_path.is_file():
        raise SystemExit("decoded directory does not contain the expected Sony Email resources")

    dimens_root = ET.parse(dimens_path).getroot()
    matching = [node for node in dimens_root.findall("dimen") if node.get("name") == DIMEN_NAME]
    if matching:
        if len(matching) != 1 or matching[0].text not in {"40dp", DIMEN_VALUE}:
            raise SystemExit(f"existing {DIMEN_NAME} has an unexpected value")
    else:
        dimens_text = dimens_path.read_text(encoding="utf-8")
        anchor = '    <dimen name="list_item_edge_margin">16.0dp</dimen>'
        addition = f'{anchor}\n    <dimen name="{DIMEN_NAME}">{DIMEN_VALUE}</dimen>'
        dimens_path.write_text(
            replace_once(dimens_text, anchor, addition, "list-item edge-margin dimension"),
            encoding="utf-8",
        )

    layout_root = ET.parse(layout_path).getroot()
    targets = []
    for frame in layout_root.iter("FrameLayout"):
        if frame.get(ANDROID + "id") == android_id("star_flag_container"):
            targets.append(frame)
            continue
        if any(child.get(ANDROID + "id") == android_id("thread_number_of_childs_circle") for child in frame.iter()):
            targets.append(frame)
    if len(targets) != 2:
        raise SystemExit(f"expected two right-edge action containers, found {len(targets)}")

    expected_padding = "@dimen/list_item_edge_margin"
    repaired_padding = f"@dimen/{DIMEN_NAME}"
    padding_values = [frame.get(ANDROID + "paddingEnd") for frame in targets]
    if all(value == repaired_padding for value in padding_values):
        print("Sony Email practical repair v1 is already present")
        return
    if any(value != expected_padding for value in padding_values):
        raise SystemExit(f"unexpected action-container padding values: {padding_values}")

    layout_text = layout_path.read_text(encoding="utf-8")
    old = f'android:paddingEnd="{expected_padding}" android:layout_alignParentEnd="true"'
    new = f'android:paddingEnd="{repaired_padding}" android:layout_alignParentEnd="true"'
    if layout_text.count(old) != 2:
        raise SystemExit(f"expected two exact action-container padding anchors, found {layout_text.count(old)}")
    layout_path.write_text(layout_text.replace(old, new, 2), encoding="utf-8")
    print("Sony Email practical repair v1 applied to two action containers")


if __name__ == "__main__":
    main()
