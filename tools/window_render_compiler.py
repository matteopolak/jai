#!/usr/bin/env python3
"""Build NEW independent compiler sources plus the reviewed general metadata fix.

Only this worker's target staging is changed. No peer checkout or Git history is
accessed. The durable patch originates in the independent bindings producer.
"""
from pathlib import Path
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def main():
    source = ROOT.parent / "compiler"
    destination = ROOT / "target/window-compiler-source"
    destination.mkdir(parents=True, exist_ok=True)
    shutil.copytree(source / "crates", destination / "crates", dirs_exist_ok=True)
    for name in ["Cargo.toml", "Cargo.lock", "rust-toolchain.toml"]:
        if (source / name).exists():
            shutil.copy2(source / name, destination / name)
    patch = ROOT / "docs/native/window-render-procedure-reflection.patch"
    subprocess.run(["patch", "--dry-run", "-p1", "-d", str(destination), "-i", str(patch)], check=True)
    subprocess.run(["patch", "-p1", "-d", str(destination), "-i", str(patch)], check=True)
    subprocess.run(["cargo", "build", "--manifest-path", str(destination / "Cargo.toml"), "--locked",
                    "-p", "jaic-cli", "-p", "jailint", "--target-dir", str(ROOT / "target/window-compiler")], check=True)


if __name__ == "__main__":
    main()
