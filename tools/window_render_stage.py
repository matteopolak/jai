#!/usr/bin/env python3
"""Stage NEW independent producer stdlibs, then this worker's owned modules.

Does not inspect integration worktrees, Git history or transcripts.
Peer Extensions are excluded; this sanitized snapshot's Extensions are copied
unchanged to supply repository tool dependencies.
The target directory contains dependency source copies, never sole source copies.
"""
from pathlib import Path
import shutil

ROOT = Path(__file__).resolve().parents[1]
OWNED = {"Window_Type", "Window_Creation", "Input", "Keymap", "Gamepad", "Simp", "Srgb", "Clipboard"}
INTERNAL = {"window", "rendering", "input", "gamepad", "clipboard"}


def copy_modules(source, destination):
    for item in sorted(source.iterdir()):
        if item.name == "Extensions":
            continue
        target = destination / item.name
        if item.is_dir():
            shutil.copytree(item, target, dirs_exist_ok=True)
        else:
            shutil.copy2(item, target)


def main():
    destination = ROOT / "target/window-integration-stdlib"
    if destination.exists():
        shutil.rmtree(destination)
    destination.mkdir(parents=True)
    # Later producers own their public modules and internal namespaces.
    for producer in ["stdlib", "foundations", "bindings", "numerics", "compiler"]:
        copy_modules(ROOT.parent / producer / "stdlib", destination)
    shutil.copytree(ROOT / "stdlib/Extensions", destination / "Extensions")
    for name in sorted(OWNED):
        target = destination / name
        if target.exists():
            shutil.rmtree(target)
        shutil.copytree(ROOT / "stdlib" / name, target)
    for name in sorted(INTERNAL):
        target = destination / "internal" / name
        if target.exists():
            shutil.rmtree(target)
        shutil.copytree(ROOT / "stdlib/internal" / name, target)
    print("staged NEW producer dependencies and owned window/render sources")


if __name__ == "__main__":
    main()
