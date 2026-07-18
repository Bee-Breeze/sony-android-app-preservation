#!/usr/bin/env python3
"""Make exactly one decoded Android uses-library declaration optional."""

import argparse
import xml.etree.ElementTree as ET
from pathlib import Path


ANDROID = "http://schemas.android.com/apk/res/android"
ET.register_namespace("android", ANDROID)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("manifest", type=Path)
    parser.add_argument("library")
    args = parser.parse_args()

    tree = ET.parse(args.manifest)
    application = tree.getroot().find("application")
    if application is None:
        raise SystemExit("Manifest has no application element")
    name = f"{{{ANDROID}}}name"
    required = f"{{{ANDROID}}}required"
    matches = [node for node in application.findall("uses-library")
               if node.get(name) == args.library]
    if len(matches) != 1:
        raise SystemExit(f"Expected one {args.library} declaration, found {len(matches)}")
    if matches[0].get(required) != "true":
        raise SystemExit("Expected android:required=true before patching")
    matches[0].set(required, "false")
    tree.write(args.manifest, encoding="utf-8", xml_declaration=True)


if __name__ == "__main__":
    main()
