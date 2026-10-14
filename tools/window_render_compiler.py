#!/usr/bin/env python3
"""Build NEW independent compiler sources with their integrated metadata fix.

Only this worker's target staging is changed. No peer checkout or Git history is
accessed. Historical producer patches remain documentation, not build inputs.
"""
from pathlib import Path
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def main():
    source = ROOT.parent / "compiler"
    destination = ROOT / "target/window-compiler-source"
    destination.mkdir(parents=True, exist_ok=True)
    if (destination / "crates").exists():
        shutil.rmtree(destination / "crates")
    shutil.copytree(source / "crates", destination / "crates")
    for name in ["Cargo.toml", "Cargo.lock", "rust-toolchain.toml"]:
        if (source / name).exists():
            shutil.copy2(source / name, destination / name)
    subprocess.run(["cargo", "build", "--manifest-path", str(destination / "Cargo.toml"), "--locked",
                    "-p", "jaic-cli", "-p", "jailint", "--target-dir", str(ROOT / "target/window-compiler")], check=True)


if __name__ == "__main__":
    main()
