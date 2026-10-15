#!/usr/bin/env python3
"""Cross-target public TCP field behavior; native Linux requires a Linux host."""
import argparse
import os
from pathlib import Path
import platform
import shutil
import subprocess
from generate_socket_linux_fields import FIELDS

ROOT = Path(__file__).resolve().parents[1]


def generate_fixture():
    lines = ['// Reviewed Socket API; official glibc TCP bit positions.',
             '#import "Basic";', 'S :: #import "Socket";', '#assert OS == .LINUX;',
             '#assert #run verify();', 'verify :: () -> bool {',
             'if size_of(S.tcphdr) != 20 || size_of(S.tcp_info) != 104 return false;',
             'for index: 0..255 {', 'word: u16 = cast(u16) (index * 257);',
             'packet: S.tcphdr;', 'info: S.tcp_info;']
    for field, (record, member, result, shift, width) in sorted(FIELDS.items()):
        var = 'packet' if record == 'tcphdr' else 'info'
        word_type = 'u16' if member == '__bitfield_1' else 'u8'
        mask = ((1 << width) - 1) << shift
        max_word = 65535 if word_type == 'u16' else 255
        expected = f'(word & {mask}) != 0' if result == 'bool' else f'cast({result}) ((word >> {shift}) & {(1 << width)-1})'
        lines += [f'{var}.{member} = cast({word_type}) (word & {max_word});',
                  f'if S.get_{field}({var}) != ({expected}) return false;']
        if result == 'bool':
            lines += [f'S.set_{field}(*{var}, false);',
                      f'if {var}.{member} != (cast({word_type}) (word & {max_word}) & {max_word ^ mask}) return false;',
                      f'S.set_{field}(*{var}, true);',
                      f'if {var}.{member} != (cast({word_type}) (word & {max_word}) | {mask}) return false;']
        else:
            lines += ['for input: 0..255 {', f'{var}.{member} = cast({word_type}) (word & {max_word});',
                      f'value: {result} = cast({result}) input;',
                      f'S.set_{field}(*{var}, value);',
                      f'expected: {word_type} = (cast({word_type}) (word & {max_word}) & {max_word ^ mask}) | ((value & {(1 << width)-1}) << {shift});',
                      f'if {var}.{member} != expected || S.get_{field}({var}) != (value & {(1 << width)-1}) return false;', '}']
    lines += ['}', 'return true;', '}', 'main :: () { assert(verify()); }', '']
    path = ROOT / 'tests/portable-stdlib/linux-socket/fields.jai'
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text('\n'.join(lines))
    subprocess.run([str(ROOT/'target/jaifmt'), '--config', str(ROOT/'jaifmt.toml'), str(path)], check=True)
    return path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--native', action='store_true')
    args = parser.parse_args()
    if args.native and platform.system() != 'Linux':
        parser.error('native Linux execution requires an actual Linux host')
    source = generate_fixture()
    library = ROOT / 'target/portable-integration-stdlib'
    for relative in ['Socket', 'internal/net']:
        shutil.copytree(ROOT/'stdlib'/relative, library/relative, dirs_exist_ok=True)
    compiler = ROOT/'target/compiler/debug/jaic'
    env = dict(os.environ, JAIC_STDLIB=str(library))
    for cpu in ['x64', 'arm64']:
        subprocess.run([str(compiler), '-check', '-os', 'linux', '-cpu', cpu, str(source)],
                       env=env, check=True, timeout=180)
        print(f'Linux/{cpu} public TCP accessors executed in compile-time assertions', flush=True)
    if args.native:
        oracle = ROOT/'target/linux-socket-fields-sdk'
        subprocess.run(['cc', '-std=c11', '-Wall', '-Wextra', '-Werror',
                        str(ROOT/'tests/portable-stdlib/native/socket-fields-linux.c'),
                        '-o', str(oracle)], check=True)
        subprocess.run([str(oracle)], check=True)
        subprocess.run([str(compiler), '-interp', str(source)], env=env, check=True, timeout=180)
        for optimization in ['-O0', '-O2']:
            output = ROOT/f'target/linux-socket-fields{optimization}'
            subprocess.run([str(compiler), str(source), optimization, '-exe', str(output)], env=env, check=True)
            subprocess.run([str(output)], check=True)
    else:
        print('Native Linux execution and native SDK ABI verification remain pending')


if __name__ == '__main__':
    main()
