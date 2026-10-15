#!/usr/bin/env python3
"""Review-derived ASN.1 shape tests and independent native integer/wire vectors."""
import os
from pathlib import Path
import platform
import random
import shutil
import struct
import subprocess
from check_portable_time_foundation import compose, LIBRARY

ROOT = Path(__file__).resolve().parents[1]


def main():
    output = ROOT / "target/portable-asn1"
    output.mkdir(parents=True, exist_ok=True)
    integers = list(range(256)) + [0, 2**63-1, 32767, 32768, 65535]
    rng = random.Random(80411)
    integers += [rng.randrange(2**63) for _ in range(256)]
    wire = bytearray(struct.pack('<I', len(integers)))
    for value in integers:
        length = next(n for n in range(1, 9) if -2**(8*n-1) <= value < 2**(8*n-1))
        data = value.to_bytes(length, 'big', signed=True)
        wire += struct.pack('<I', len(data)) + data + struct.pack('<q', value)
    identifiers = [[0, 0], [0, 39], [1, 0], [1, 39], [2, 0], [2, 40], [2, 2**64-1]]
    identifiers += [[2, rng.randrange(2**64), *[rng.randrange(2**64) for _ in range(count-2)]]
                    for count in range(2, 13) for _ in range(16)]
    wire += struct.pack('<I', len(identifiers))
    for arcs in identifiers:
        data = bytearray()
        for value in [arcs[0]*40+arcs[1], *arcs[2:]]:
            digits = [value & 127]
            value >>= 7
            while value:
                digits.append((value & 127) | 128)
                value >>= 7
            data.extend(reversed(digits))
        text = ('.'.join(map(str, arcs)) + '.').encode('ascii')
        wire += struct.pack('<I', len(data)) + data + struct.pack('<I', len(arcs))
        wire += b''.join(struct.pack('<Q', arc) for arc in arcs) + struct.pack('<I', len(text)) + text
    (output / 'vectors.bin').write_bytes(wire)
    library = ROOT / 'target/portable-integration-stdlib'
    for relative in ['Android/Toolchain', 'internal/android-toolchain']:
        shutil.copytree(ROOT / 'stdlib' / relative, library / relative, dirs_exist_ok=True)
    compose()
    library = LIBRARY
    env = dict(os.environ, JAIC_STDLIB=str(library))
    compiler = ROOT / 'target/compiler/debug/jaic'
    targets = [([], 'host')]
    if platform.system() == 'Darwin' and platform.machine() == 'arm64':
        targets.append((['-target', 'x86_64-apple-darwin'], 'x64'))
    sources = [ROOT / 'tests/portable-stdlib/android-asn1.jai',
               ROOT / 'tests/portable-stdlib/android-asn1/vectors.jai',
               ROOT / 'tests/portable-stdlib/android-asn1/failures.jai',
               ROOT / 'tests/portable-stdlib/android-asn1/records.jai',
               ROOT / 'tests/portable-stdlib/android-oid.jai']
    for source in sources:
        commands = [[str(compiler), '-interp', str(source)]]
        for flags, label in targets:
            for opt in ['-O0', '-O2']:
                executable = output / (source.stem + label + opt)
                subprocess.run([str(compiler), *flags, opt, str(source), '-exe', str(executable)], env=env, check=True, timeout=90)
                commands.append([str(executable)])
        for command in commands:
            result = subprocess.run(command, env=env, capture_output=True, text=True, timeout=90)
            if result.returncode or result.stdout != 'ok\n' or result.stderr:
                raise RuntimeError(f'{command!r}\n{result.stdout}{result.stderr}')
    for target in ['linux', 'windows']:
        for cpu in ['x64', 'arm64']:
            for source in [sources[0], *sources[2:]]:
                subprocess.run([str(compiler), '-check', '-os', target, '-cpu', cpu, str(source)], env=env, check=True)
    subprocess.run([str(ROOT / 'target/compiler/debug/jailint'), '-D', 'warnings',
                    str(library / 'Android/Toolchain/module.jai'),
                    *[str(library / 'internal/android-toolchain' / name) for name in ['asn1-tags.jai', 'asn1-values.jai', 'asn1-records.jai', 'asn1-identity.jai', 'byte-readers.jai']],
                    *map(str, sources)], env=env, check=True, timeout=90)
    print(f'{len(integers)} reviewed nonnegative INTEGER and {len(identifiers)} OID vectors; shape/record/cursor/failure/equality tests pass interpreter/native both CPUs O0/O2, target checks and strict lint')


if __name__ == '__main__':
    main()
