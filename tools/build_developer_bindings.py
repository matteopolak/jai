#!/usr/bin/env python3
"""Build the independently authored binding tool beside its private stdlib sources.

Requires an official LLVM SDK containing clang-c headers and libclang. No SDK
binary or library is copied or vendored. Shared build integration is coordinator-owned.
"""
import argparse
import os
from pathlib import Path
import platform
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def build(prefix=None):
    if platform.system() not in {"Darwin", "Linux"}:
        raise RuntimeError("Binding tool build currently supports macOS/Linux hosts")
    prefix = Path(prefix or os.environ.get("DEVELOPER_TOOLS_LLVM_PREFIX", "/opt/homebrew/opt/llvm")).resolve()
    directory = ROOT / "stdlib/internal/developer-tools/clang-bindings"
    output = directory / "developer-tools-clang"
    subprocess.run([str(prefix / "bin/clang"), "-std=c11", "-O2", "-Wall", "-Wextra", "-Werror",
                    "-I", str(prefix / "include"), str(directory / "main.c"), "-L", str(prefix / "lib"),
                    "-Wl,-rpath," + str(prefix / "lib"), "-lclang", "-o", str(output)],
                   cwd=ROOT, check=True)
    library_name = "libclang.dylib" if platform.system() == "Darwin" else "libclang.so"
    library = prefix / "lib" / library_name
    if not library.is_file():
        raise RuntimeError(f"Official SDK is missing {library_name}")
    link = directory / library_name
    if link.is_symlink():
        link.unlink()
    elif link.exists():
        raise RuntimeError(f"Refusing to replace non-symlink native dependency: {link}")
    link.symlink_to(library)
    (directory / "compiler-path.txt").write_text(str(prefix / "bin/clang"))
    return output


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--llvm-prefix", type=Path)
    args = parser.parse_args()
    print("Built private binding tool from source:", build(args.llvm_prefix).relative_to(ROOT))


if __name__ == "__main__":
    main()
