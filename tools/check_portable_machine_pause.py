#!/usr/bin/env python3
"""Verify native pause opcodes against the official C intrinsic and no-call baseline."""
import os
from pathlib import Path
import platform
import re
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def main():
    system = platform.system()
    if system == 'Darwin':
        c_target = ['-arch', 'x86_64']
        jai_target = ['-target', 'x86_64-apple-darwin', '-cpu', 'x64']
    elif system == 'Linux' and platform.machine().lower() in ['x86_64', 'amd64']:
        c_target, jai_target = [], ['-cpu', 'x64']
    else:
        raise RuntimeError('Native pause verification requires actual x64 or macOS x64 translation')
    disassembler = shutil.which('llvm-objdump')
    if not disassembler:
        raise RuntimeError('LLVM llvm-objdump is required to verify actual emitted instructions')
    output = ROOT/'target/portable-machine-pause'
    output.mkdir(parents=True, exist_ok=True)
    library = ROOT/'target/portable-integration-stdlib'
    for relative in ['Machine_X64', 'internal/machine']:
        shutil.copytree(ROOT/'stdlib'/relative, library/relative, dirs_exist_ok=True)
    compiler = ROOT/'target/compiler/debug/jaic'
    env = dict(os.environ, JAIC_STDLIB=str(library))

    def checked(command, stdout=None):
        result = subprocess.run([str(p) for p in command], cwd=ROOT, env=env,
                                capture_output=True, text=True, timeout=90)
        if result.returncode or result.stderr or (stdout is not None and result.stdout != stdout):
            raise RuntimeError(f'{command!r}\n{result.stdout}{result.stderr}')
        return result.stdout

    def opcode_count(path):
        listing = checked([disassembler, '-d', path])
        (output/(path.name+'.asm')).write_text(listing)
        return len(re.findall(r'^\s*[0-9a-f]+:.*\bpause\s*$', listing, re.MULTILINE))

    oracle = output/'native-c-intrinsic'
    checked(['clang', *c_target, '-std=c11', '-O2', '-Wall', '-Wextra', '-Werror',
             ROOT/'tests/portable-stdlib/native/machine-pause.c', '-o', oracle])
    checked([oracle], '')
    oracle_count = opcode_count(oracle)
    if oracle_count == 0:
        raise RuntimeError('Official C intrinsic did not emit an observable pause opcode')
    for optimization in ['-O0', '-O2']:
        counts = []
        for fixture in ['pause-baseline', 'pause']:
            source = ROOT/f'tests/portable-stdlib/machine-x64/{fixture}.jai'
            program = output/(fixture+optimization)
            checked([compiler, *jai_target, optimization, source, '-exe', program])
            checked([program], 'ok\n')
            counts.append(opcode_count(program))
        if counts[1] <= counts[0]:
            raise RuntimeError(f'Calling public pause emitted no additional opcode: {counts}')
        print(f'Actual x64 {optimization}: baseline={counts[0]} public-pause={counts[1]} C-intrinsic={oracle_count}', flush=True)
    for target in ['macos', 'linux', 'windows']:
        checked([compiler, '-check', '-os', target, '-cpu', 'x64',
                 ROOT/'tests/portable-stdlib/machine-x64/pause.jai'])
    linter = ROOT/'target/compiler/x86_64-apple-darwin/debug/jailint' if system == 'Darwin' else ROOT/'target/compiler/debug/jailint'
    checked([linter, '-D', 'warnings',
             library/'Machine_X64/module.jai', library/'internal/machine/x64-hints.jai',
             ROOT/'tests/portable-stdlib/machine-x64/pause.jai',
             ROOT/'tests/portable-stdlib/machine-x64/pause-baseline.jai',
             ROOT/'tests/portable-stdlib/machine-x64/pause-compile-time.jai'])
    print('Public pause runs actual x64 native; compile-time interpreter models a cooperative hint, with no delay or memory-order guarantee')


if __name__ == '__main__':
    main()
