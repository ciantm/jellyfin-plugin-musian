#!/usr/bin/env python3
"""
update_manifest.py  —  run from the gh-pages branch root.
Inserts a new version entry into manifest.json, keeping the list
sorted newest-first so Jellyfin always picks the latest version.
"""

import argparse
import json
import os
import sys

PLUGIN_GUID        = "6c8a80b7-3e2f-4d5a-9b1c-f7e8d9a0b2c3"
REPO_OWNER         = "ciantm"
REPO_NAME          = "jellyfin-plugin-musian"
PLUGIN_NAME        = "Musian"
TARGET_ABI         = "10.9.0.0"   # minimum Jellyfin version required
MANIFEST_FILE      = "manifest.json"

# Catalogue copy. These are written on every run, not just when bootstrapping a
# fresh manifest: the live text lives in the gh-pages manifest.json, so editing
# only the bootstrap block below would change nothing for existing repositories.
DESCRIPTION = (
    "Play music from your Jellyfin library by tapping a mood on a colour wheel. "
    "Free and fully featured. The Android app adds Android Auto, background "
    "playback and lock-screen controls: "
    "https://play.google.com/store/apps/details?id=com.musian.app"
)
OVERVIEW = (
    "Tap anywhere on the wheel: energy runs top to bottom, positivity left to "
    "right, and Musian queues tracks from your library that match. No retagging, "
    "no cloud account, no analytics. Tested on Jellyfin 12.4."
)

BASE_URL = f"https://github.com/{REPO_OWNER}/{REPO_NAME}/releases/download"


def load_manifest() -> list:
    if os.path.exists(MANIFEST_FILE):
        with open(MANIFEST_FILE, "r") as f:
            return json.load(f)
    # Bootstrap a fresh manifest
    return [
        {
            "category":    "Music",
            "guid":        PLUGIN_GUID,
            "name":        PLUGIN_NAME,
            "description": DESCRIPTION,
            "overview":    OVERVIEW,
            "owner":       REPO_OWNER,
            "versions":    [],
            "imageUrl":    f"https://raw.githubusercontent.com/{REPO_OWNER}/{REPO_NAME}/main/assets/logo.png",
        }
    ]


def save_manifest(data: list) -> None:
    with open(MANIFEST_FILE, "w") as f:
        json.dump(data, f, indent=2)
    print(f"Wrote {MANIFEST_FILE}")


def version_tuple(v: str):
    return tuple(int(x) for x in v.split("."))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--version",   required=True, help="e.g. 1.0.0.0")
    parser.add_argument("--tag",       required=True, help="e.g. v1.0.0.0")
    parser.add_argument("--checksum",  required=True, help="MD5 of zip file")
    parser.add_argument("--timestamp", required=True, help="ISO 8601 UTC timestamp")
    parser.add_argument("--changelog", default="",    help="Release notes")
    args = parser.parse_args()

    artifact = f"Jellyfin.Plugin.Musian_{args.version}.zip"
    source_url = f"{BASE_URL}/{args.tag}/{artifact}"

    manifest = load_manifest()
    plugin = manifest[0]
    plugin["name"] = PLUGIN_NAME
    # Always refresh the catalogue copy, so the repository file is the source of
    # truth rather than whatever the gh-pages branch happened to contain.
    plugin["description"] = DESCRIPTION
    plugin["overview"] = OVERVIEW

    # Remove any existing entry for this version (idempotent re-runs)
    plugin["versions"] = [
        v for v in plugin["versions"] if v["version"] != args.version
    ]

    new_entry = {
        "version":    args.version,
        "changelog":  args.changelog or f"Release {args.version}",
        "targetAbi":  TARGET_ABI,
        "sourceUrl":  source_url,
        "checksum":   args.checksum,
        "timestamp":  args.timestamp,
    }

    plugin["versions"].append(new_entry)

    # Sort newest-first
    plugin["versions"].sort(
        key=lambda v: version_tuple(v["version"]), reverse=True
    )

    save_manifest(manifest)
    print(f"Added version {args.version}  ({source_url})")


if __name__ == "__main__":
    main()
