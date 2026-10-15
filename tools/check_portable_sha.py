#!/usr/bin/env python3
"""Verify reviewed SHA APIs against native hashlib across padding and binary input."""
import hashlib
import os
from pathlib import Path
import platform
import shutil
import struct
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def main():
    output = ROOT/'target/portable-sha'
    output.mkdir(parents=True, exist_ok=True)
    cases = [(length, 0) for length in list(range(257)) + [511, 512, 513, 1023, 1024, 1025, 4095, 4096, 4097, 65535, 65536, 65537]]
    cases.append((1000000, 1))
    wire = bytearray(struct.pack('<II', 0x53484132, len(cases)))
    for length, mode in cases:
        data = b'a'*length if mode else bytes((index*73+length*19) & 255 for index in range(length))
        wire += struct.pack('<II', length, mode) + hashlib.sha1(data).digest() + hashlib.sha256(data).digest()
    (output/'vectors.bin').write_bytes(wire)
    library = ROOT/'target/portable-integration-stdlib'
    for relative in ['Android/Toolchain', 'internal/android-toolchain', 'internal/crypto']:
        shutil.copytree(ROOT/'stdlib'/relative, library/relative, dirs_exist_ok=True)
    compiler = ROOT/'target/compiler/debug/jaic'
    env = dict(os.environ, JAIC_STDLIB=str(library))
    source = ROOT/'tests/portable-stdlib/android-digests/vectors.jai'
    commands = [[str(compiler), '-interp', str(source)]]
    targets = [([], 'host')]
    if platform.system() == 'Darwin' and platform.machine() == 'arm64':
        targets.append((['-target', 'x86_64-apple-darwin', '-cpu', 'x64'], 'translated-x64'))
    for flags, label in targets:
        for optimization in ['-O0', '-O2']:
            executable = output/(label+optimization)
            subprocess.run([str(compiler), str(source), *flags, optimization, '-exe', str(executable)],
                           cwd=ROOT, env=env, check=True, timeout=90)
            commands.append([str(executable)])
    for command in commands:
        result = subprocess.run(command, cwd=ROOT, env=env, capture_output=True, text=True, timeout=180)
        if result.returncode or result.stderr or result.stdout != 'ok\n':
            raise RuntimeError(f'{command!r}\n{result.stdout}{result.stderr}')
    for target in ['linux', 'windows']:
        for cpu in ['x64', 'arm64']:
            subprocess.run([str(compiler), '-check', '-os', target, '-cpu', cpu,
                            str(ROOT/'tests/portable-stdlib/android-digests.jai')], env=env, check=True)
    print(f'Both SHA algorithms match {len(cases)} native hashlib vectors: interpreter and {",".join(label for _, label in targets)} native O0/O2; both Linux/Windows CPU bodies check')


if __name__ == '__main__':
    main()
