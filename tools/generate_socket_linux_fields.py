#!/usr/bin/env python3
"""Reviewed Linux TCP accessors; public glibc netinet/tcp.h supplies ABI bits."""
from pathlib import Path
import subprocess

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
    lines = ['// Official glibc tcp.h little-endian ABI; reviewed signatures.',
             '#assert OS == .LINUX;', '#assert CPU == .X64 || CPU == .ARM64;']
    exports = []
    for field, (record, word, result, shift, width) in sorted(FIELDS.items()):
        mask = ((1 << width) - 1) << shift
        word_type = 'u16' if word == '__bitfield_1' else 'u8'
        maximum = (1 << width) - 1
        read = f'(fields.{word} & {mask}) != 0' if result == 'bool' else f'(fields.{word} >> {shift}) & {maximum}'
        lines += [f'get_{field} :: (fields: ABI.{record}) -> {result} {{ return {read}; }}']
        if result == 'bool':
            body = f'if value fields.{word} |= {mask}; else fields.{word} &= ~cast({word_type}) {mask};'
        else:
            body = f'fields.{word} = (fields.{word} & ~cast({word_type}) {mask}) | ((value & {maximum}) << {shift});'
        lines += [f'set_{field} :: (fields: *ABI.{record}, value: {result}) {{ {body} }}']
        for action in ['get', 'set']:
            name = f'{action}_{field}'
            if f'`{name} ::' not in spec:
                raise RuntimeError(f'Unreviewed export: {name}')
            exports.append(name)
    lines += ['#scope_file', 'ABI :: #import "internal/net/socket-abi";', '']
    private = ROOT / 'stdlib/internal/net/socket-fields-linux.jai'
    private.write_text('\n'.join(lines))
    facade = ROOT / 'stdlib/Socket/linux-fields.jai'
    facade.write_text('#if OS == .LINUX {\n' + ''.join(f'{name} :: Fields.{name};\n' for name in exports)
                      + '}\n#scope_file\n#if OS == .LINUX Fields :: #import "internal/net/socket-fields-linux";\n')
    for flags in [[], ['--check']]:
        subprocess.run([str(ROOT / 'target/jaifmt'), '--config', str(ROOT / 'jaifmt.toml'),
                        *flags, str(private), str(facade)], check=True)
    print(f'Generated {len(exports)} Linux TCP accessor APIs')


if __name__ == '__main__':
    main()
