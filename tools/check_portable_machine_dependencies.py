#!/usr/bin/env python3
"""Fail on missing native instruction semantics; never report these gaps as passes."""
import os
from pathlib import Path
import platform
import re
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def main():
    if platform.system() == 'Darwin':
        c_target = ['-arch', 'x86_64']
        jai_target = ['-target', 'x86_64-apple-darwin', '-cpu', 'x64']
    elif platform.system() == 'Linux' and platform.machine().lower() in ['amd64', 'x86_64']:
        c_target, jai_target = [], ['-cpu', 'x64']
    else:
        raise RuntimeError('Native instruction dependency probes require x64 or macOS translation')
    disassembler = shutil.which('llvm-objdump')
    if not disassembler:
        raise RuntimeError('llvm-objdump is required for native instruction verification')
    output = ROOT/'target/portable-machine-dependencies'
    output.mkdir(parents=True, exist_ok=True)
    env = dict(os.environ, JAIC_STDLIB=str(ROOT/'target/portable-integration-stdlib'))

    def checked(command):
        result = subprocess.run([str(p) for p in command], cwd=ROOT, env=env,
                                capture_output=True, text=True, timeout=90)
        if result.returncode or result.stderr:
            raise RuntimeError(f'{command!r}\n{result.stdout}{result.stderr}')
        return result.stdout

    def counts(program, names):
        assembly = checked([disassembler, '-d', program])
        (output/(program.name+'.asm')).write_text(assembly)
        return {name: len(re.findall(r'^\s*[0-9a-f]+:.*\b'+name+r'\b', assembly, re.MULTILINE))
                for name in names}

    compiler = ROOT/'target/compiler/debug/jaic'
    failures = []
    for label, fixture, names in [
        ('prefetch', 'prefetch-native-instruction', ['prefetcht0']),
        ('fences', 'native-fence-instructions', ['mfence', 'lfence', 'sfence']),
    ]:
        native = output/(label+'-c')
        checked(['clang', *c_target, '-std=c11', '-O2', '-Wall', '-Wextra', '-Werror',
                 ROOT/f'tests/portable-stdlib/native/machine-{label}.c', '-o', native])
        checked([native])
        expected = counts(native, names)
        if any(value == 0 for value in expected.values()):
            raise RuntimeError(f'Official native C instruction probe is invalid: {expected}')
        for optimization in ['-O0', '-O2']:
            program = output/(label+optimization)
            checked([compiler, *jai_target, optimization,
                     ROOT/f'tests/portable-stdlib/pending/{fixture}.jai', '-exe', program])
            checked([program])
            actual = counts(program, names)
            print(f'{label} {optimization}: C={expected}, Jai={actual}', flush=True)
            if any(actual[name] == 0 for name in names):
                failures.append(f'{label} {optimization} missing requested native instructions')
    if failures:
        raise RuntimeError('Compiler dependencies remain UNRESOLVED: '+ '; '.join(failures))
    print('Requested native instructions present; architectural/runtime semantics still require owner review')


if __name__ == '__main__':
    main()
