#!/usr/bin/env python3
"""Build the integrated compiler and linter directly from this checkout."""
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def main():
    subprocess.run(["cargo", "build", "--locked", "-p", "jaic-cli", "-p", "jailint"],
                   cwd=ROOT, check=True)


if __name__ == "__main__":
    main()
