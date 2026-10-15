#!/usr/bin/env python3
"""Execute public ancillary helpers against actual host socket.h macro vectors."""
import os
from pathlib import Path
import platform
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def main():
    if platform.system() not in ['Darwin', 'Linux']:
        raise RuntimeError('Ancillary SDK vector verification requires a supported Unix host')
    output = ROOT/'target/portable-socket-cmsg'
    output.mkdir(parents=True, exist_ok=True)
    native = output/'sdk-probe'
    subprocess.run(['cc', '-std=c11', '-Wall', '-Wextra', '-Werror',
                    str(ROOT/'tests/portable-stdlib/native/socket-cmsg.c'), '-o', str(native)], check=True)
    vectors = subprocess.run([str(native)], capture_output=True, check=True)
    if vectors.stderr or len(vectors.stdout) != 16+4097*32:
        raise RuntimeError('Actual native SDK vector probe failed')
    (output/'vectors.bin').write_bytes(vectors.stdout)
    library = ROOT/'target/portable-integration-stdlib'
    for relative in ['Socket', 'internal/net']:
        shutil.copytree(ROOT/'stdlib'/relative, library/relative, dirs_exist_ok=True)
    compiler = ROOT/'target/compiler/debug/jaic'
    env = dict(os.environ, JAIC_STDLIB=str(library))
    source = ROOT/'tests/portable-stdlib/socket-cmsg/main.jai'
    commands = [[str(compiler), '-interp', str(source)]]
    targets = [([], 'host')]
    if platform.system() == 'Darwin' and platform.machine() == 'arm64':
        targets.append((['-target', 'x86_64-apple-darwin', '-cpu', 'x64'], 'translated-x64'))
    for flags, label in targets:
        for optimization in ['-O0', '-O2']:
            program = output/f'contract-{label}{optimization}'
            subprocess.run([str(compiler), str(source), *flags, optimization, '-exe', str(program)], env=env, check=True)
            commands.append([str(program)])
    for command in commands:
        result = subprocess.run(command, env=env, capture_output=True, text=True, check=True)
        if result.stdout != 'ok\n' or result.stderr:
            raise RuntimeError(f'{command!r}\n{result.stdout}{result.stderr}')
    for target in ['linux', 'macos']:
        for cpu in ['x64', 'arm64']:
            subprocess.run([str(compiler), '-check', '-os', target, '-cpu', cpu,
                            str(ROOT/'tests/portable-stdlib/socket-cmsg/compile-time.jai')], env=env, check=True)
    print('Four public ancillary APIs match4097 actual host SDK vectors: interpreter/native O0/O2; Linux/macOS bothCPU #run assertions pass')
    print('Native execution covers this actual host only; other native platforms/target-aware lint remain pending. CMSG_SIZE remains absent pending reviewed semantics')


if __name__ == '__main__':
    main()
