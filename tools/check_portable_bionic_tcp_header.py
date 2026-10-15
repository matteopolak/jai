#!/usr/bin/env python3
"""Execute an official bionic TCP C header probe on the host, not on Android."""
import argparse
import hashlib
from pathlib import Path
import platform
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--header', required=True, type=Path,
                        help='official public bionic libc/include/bits/tcphdr.h')
    args = parser.parse_args()
    header = args.header.resolve(strict=True)
    if not header.is_relative_to(ROOT/'target'):
        parser.error('keep the explicitly supplied official C header under this checkout target/')
    print(f'Official C header SHA256: {hashlib.sha256(header.read_bytes()).hexdigest()}', flush=True)
    targets = [([], 'host')]
    if platform.system() == 'Darwin' and platform.machine() == 'arm64':
        targets.append((['-target', 'x86_64-apple-darwin'], 'translated-x64'))
    for flags, label in targets:
        output = ROOT/f'target/socket-bionic-header-{label}'
        subprocess.run(['clang', '-std=c11', '-Wall', '-Wextra', '-Werror', *flags,
                        f'-DPORTABLE_BIONIC_TCP_HEADER="{header}"',
                        str(ROOT/'tests/portable-stdlib/native/socket-bionic-header.c'),
                        '-o', str(output)], check=True)
        subprocess.run([str(output)], check=True)
        print(f'Actual bionic header65536-word C ABI probe passed: {label}', flush=True)
    print('This verifies host C layout of the public header; Android Jai checking/native execution remain pending')


if __name__ == '__main__':
    main()
