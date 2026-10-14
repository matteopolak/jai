#!/usr/bin/env python3
"""Assemble new independent foundation sources plus compiler-owned modules for local tests.

This reads the explicitly selected new library checkout and writes only this
checkout's target/cleanroom-test-stdlib directory. It does not integrate releases.
"""
import argparse
from pathlib import Path
import shutil


ROOT = Path(__file__).resolve().parents[1]
OWNED = ("Compiler", "Jai_Lexer", "Code_Visit", "Program_Print")
INTERNAL = ("compiler-api", "jai-lexer", "code-visit", "program-print")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--foundation", required=True, type=Path,
                        help="new independent stdlib root; never an old/reference distribution")
    parser.add_argument("--bindings", type=Path,
                        help="optional new independent bindings root for native file tests")
    parser.add_argument("--portable", type=Path,
                        help="optional NEW portable producer; retain current foundation-owned modules")
    args = parser.parse_args()
    source = args.foundation.resolve(strict=True)
    if not (source / "prelude/module.jai").is_file():
        parser.error("the new foundation must have prelude/module.jai")
    destination = ROOT / "target/cleanroom-test-stdlib"
    if destination.is_symlink():
        parser.error("refusing a symlink at the test overlay destination")
    if destination.exists():
        shutil.rmtree(destination)
    shutil.copytree(source, destination)
    if args.portable:
        portable = args.portable.resolve(strict=True)
        # Ownership, not source inference: foundation owns these facades and helpers.
        foundation_public = {"Basic", "String", "Hash", "File_Utilities"}
        foundation_private = {"basic", "basic-interface", "string", "hash"}
        foundation_files = {
            "paths.jai", "visit-info.jai", "filesystem.jai", "filesystem-windows.jai",
        }
        for path in portable.iterdir():
            if path.name in foundation_public or path.name in {*OWNED, "Extensions"}:
                continue
            if path.name == "internal":
                for helper in path.iterdir():
                    if helper.name not in foundation_private and helper.name not in INTERNAL:
                        if helper.is_dir():
                            if helper.name == "files":
                                for file in helper.iterdir():
                                    if file.is_file() and file.name not in foundation_files:
                                        shutil.copy2(file, destination / "internal/files" / file.name)
                            else:
                                shutil.copytree(helper, destination / "internal" / helper.name,
                                                dirs_exist_ok=True)
                continue
            if path.is_dir():
                shutil.copytree(path, destination / path.name, dirs_exist_ok=True)
    if args.bindings:
        bindings = args.bindings.resolve(strict=True)
        for name in ("POSIX", "Linux", "macOS", "Windows", "internal/bindings"):
            path = bindings / name
            if path.is_dir():
                shutil.copytree(path, destination / name, dirs_exist_ok=True)
    for name in OWNED:
        path = ROOT / "stdlib" / name
        if path.is_dir():
            shutil.copytree(path, destination / name, dirs_exist_ok=True)
    for name in INTERNAL:
        path = ROOT / "stdlib/internal" / name
        if path.is_dir():
            shutil.copytree(path, destination / "internal" / name, dirs_exist_ok=True)
    print(destination)


if __name__ == "__main__":
    main()
