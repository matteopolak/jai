#!/usr/bin/env python3
"""Check reviewed registry ABI; real native testing requires actual Windows."""
import argparse
import os
from pathlib import Path
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--native', action='store_true')
    args = parser.parse_args()
    if args.native and os.name != 'nt':
        parser.error('native registry verification requires actual Windows')
    produced = [ROOT/'stdlib/Windows_Registry/module.jai', ROOT/'stdlib/internal/windows-registry/abi.jai']
    def generate():
        subprocess.run([sys.executable, '-B', str(ROOT/'tools/generate_windows_registry.py')], check=True)
        return tuple(path.read_bytes() for path in produced)
    if generate() != generate():
        raise RuntimeError('Registry regeneration is not byte-stable')
    library = ROOT/'target/portable-integration-stdlib'
    for relative in ['Windows_Registry', 'internal/windows-registry']:
        shutil.copytree(ROOT/'stdlib'/relative, library/relative, dirs_exist_ok=True)
    lint_sources = [library / path.relative_to(ROOT / 'stdlib') for path in produced]
    if any(original.read_bytes() != staged.read_bytes() for original, staged in zip(produced, lint_sources)):
        raise RuntimeError('Registry strict lint requires byte-identical staged production sources')
    compiler = ROOT/('target/compiler/debug/jaic.exe' if os.name == 'nt' else 'target/compiler/debug/jaic')
    env = dict(os.environ, JAIC_STDLIB=str(library))
    directory = ROOT/'tests/portable-stdlib/windows-registry'
    for cpu in ['x64', 'arm64']:
        for filename in ['constants.jai', 'main.jai']:
            subprocess.run([str(compiler), '-check', '-os', 'windows', '-cpu', cpu, str(directory/filename)],
                           env=env, check=True, timeout=90)
        print(f'Windows/{cpu} actual registry call bodies and public constant ABI check', flush=True)
        triple = 'x86_64-pc-windows-msvc' if cpu == 'x64' else 'aarch64-pc-windows-msvc'
        linter = ROOT / ('target/compiler/debug/jailint.exe' if os.name == 'nt' else 'target/compiler/debug/jailint')
        subprocess.run([str(linter), '-target', triple, '-D', 'warnings',
                        *[str(path) for path in lint_sources], str(directory/'constants.jai'), str(directory/'main.jai')],
                       env=env, check=True, timeout=90)
        rejected = subprocess.run([str(compiler), '-check', '-os', 'windows', '-cpu', cpu,
                                   str(directory/'constant-store.jai')], env=env, capture_output=True, text=True, timeout=90)
        if rejected.returncode == 0 or 'cannot assign' not in rejected.stderr:
            raise RuntimeError(f'predefined handle must remain immutable: {rejected.stdout}{rejected.stderr}')
    if not args.native:
        print('Native Windows registry behavior, including zero-extended pseudo-handles, remains unexecuted')
        return
    commands = [[str(compiler), '-interp', str(directory/'main.jai')]]
    for optimization in ['-O0', '-O2']:
        executable = ROOT/f'target/windows-registry{optimization}.exe'
        subprocess.run([str(compiler), str(directory/'main.jai'), optimization, '-exe', str(executable)], env=env, check=True)
        commands.append([str(executable)])
    for command in commands:
        result = subprocess.run(command, env=env, text=True, capture_output=True, check=True, timeout=90)
        if result.stdout != 'ok\n' or result.stderr:
            raise RuntimeError(f'{command!r}\n{result.stdout}{result.stderr}')
    print('Real registry interpreter/native O0/O2 passed, including reviewed zero-extended pseudo-handles')


if __name__ == '__main__':
    main()
