#!/usr/bin/env python3
"""Reviewed TCP accessors; official glibc/bionic public headers supply ABI bits."""
from pathlib import Path
import subprocess
from portable_api_spec import parse_spec

ROOT = Path(__file__).resolve().parents[1]
# Explicit ABI positions; independent declaration order groups adjacent operations.
FIELDS = {
    "anon_struct_th_off": ("tcphdr", "__bitfield", "u8", 4, 4),
    "anon_struct_th_x2": ("tcphdr", "__bitfield", "u8", 0, 4),
    "anon_struct_1_ack": ("tcphdr", "__bitfield_1", "bool", 12, 1),
    "anon_struct_1_doff": ("tcphdr", "__bitfield_1", "u16", 4, 4),
    "anon_struct_1_fin": ("tcphdr", "__bitfield_1", "bool", 8, 1),
    "anon_struct_1_psh": ("tcphdr", "__bitfield_1", "bool", 11, 1),
    "anon_struct_1_res1": ("tcphdr", "__bitfield_1", "u16", 0, 4),
    "anon_struct_1_res2": ("tcphdr", "__bitfield_1", "u16", 14, 2),
    "anon_struct_1_rst": ("tcphdr", "__bitfield_1", "bool", 10, 1),
    "anon_struct_1_syn": ("tcphdr", "__bitfield_1", "bool", 9, 1),
    "anon_struct_1_urg": ("tcphdr", "__bitfield_1", "bool", 13, 1),
    "tcpi_rcv_wscale": ("tcp_info", "__bitfield", "u8", 4, 4),
    "tcpi_snd_wscale": ("tcp_info", "__bitfield", "u8", 0, 4),
}


def main():
    spec = (ROOT / "docs/specs/stdlib/modules/socket.md").read_text()
    inventory = {(d.name, d.condition) for d in parse_spec(spec).declarations}
    lines = ['// Accessors for the little-endian bitfields of glibc and bionic TCP structures.',
             '#assert OS == .LINUX || OS == .ANDROID;', '#assert CPU == .X64 || CPU == .ARM64;']
    exports = []
    linux_exports = []
    for field, (record, word, result, shift, width) in sorted(FIELDS.items()):
        if record == 'tcp_info':
            lines += ['#if OS == .LINUX {']
        mask = ((1 << width) - 1) << shift
        word_type = 'u16' if word == '__bitfield_1' else 'u8'
        maximum = (1 << width) - 1
        read = f'(fields.{word} & {mask}) != 0' if result == 'bool' else f'(fields.{word} >> {shift}) & {maximum}'
        lines += [f'get_{field} :: (fields: {record}) -> {result} {{ return {read}; }}']
        if result == 'bool':
            body = f'if value fields.{word} |= {mask}; else fields.{word} &= ~cast({word_type}) {mask};'
        else:
            body = f'fields.{word} = (fields.{word} & ~cast({word_type}) {mask}) | ((value & {maximum}) << {shift});'
        lines += [f'set_{field} :: (fields: *{record}, value: {result}) {{ {body} }}']
        for action in ['get', 'set']:
            name = f'{action}_{field}'
            if (name, 'OS == .LINUX') not in inventory:
                raise RuntimeError(f'Unreviewed Linux export: {name}')
            if record == 'tcp_info':
                linux_exports.append(name)
            else:
                if (name, 'OS == .ANDROID') not in inventory:
                    raise RuntimeError(f'Unreviewed Android export: {name}')
                exports.append(name)
        if record == 'tcp_info':
            lines += ['}']
    lines += ['']
    private = ROOT / 'stdlib/internal/net/socket-fields-tcp-unix.jai'
    private.write_text('\n'.join(lines))
    for flags in [[], ['--check']]:
        subprocess.run([str(ROOT / 'target/jaifmt'), '--config', str(ROOT / 'jaifmt.toml'),
                        *flags, str(private)], check=True)
    print(f'Generated {len(exports)} shared Linux/Android TCP APIs and {len(linux_exports)} Linux scale APIs')


if __name__ == '__main__':
    main()
