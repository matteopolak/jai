#!/usr/bin/env python3
"""Reviewed accessor signatures plus Apple's official tcp.h bitfield ABI.

No Jai implementation bodies are inputs. Output order is alphabetical by field,
with each query adjacent to its mutation; explicit ABI bit numbers stay fixed.
"""
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
FLAGS = {
    "tcpi_tfo_cookie_req": 0, "tcpi_tfo_cookie_rcv": 1, "tcpi_tfo_syn_loss": 2,
    "tcpi_tfo_syn_data_sent": 3, "tcpi_tfo_syn_data_acked": 4, "tcpi_tfo_syn_data_rcv": 5,
    "tcpi_tfo_cookie_req_rcv": 6, "tcpi_tfo_cookie_sent": 7, "tcpi_tfo_cookie_invalid": 8,
    "tcpi_tfo_cookie_wrong": 9, "tcpi_tfo_no_cookie_rcv": 10, "tcpi_tfo_heuristics_disable": 11,
    "tcpi_tfo_send_blackhole": 12, "tcpi_tfo_recv_blackhole": 13, "tcpi_tfo_onebyte_proxy": 14,
}


def main():
    spec = (ROOT / "docs/specs/stdlib/modules/socket.md").read_text()
    lines = ['// Accessors for the bitfields of Apple tcp.h structures.', '#assert OS == .MACOS;']
    exports = []
    for field, shift in [("th_off", 4), ("th_x2", 0)]:
        mask = 15 << shift
        lines += [f'get_{field} :: (fields: tcphdr) -> u32 {{ return cast(u32) ((fields.__bitfield >> {shift}) & 15); }}',
                  f'set_{field} :: (fields: *tcphdr, value: u32) {{ fields.__bitfield = (fields.__bitfield & {255 ^ mask}) | cast(u8) ((value & 15) << {shift}); }}']
        exports += [f"get_{field}", f"set_{field}"]
    for field, bit in sorted(FLAGS.items()):
        mask = 1 << bit
        lines += [f'get_{field} :: (fields: tcp_connection_info) -> bool {{ return (fields.__bitfield & {mask}) != 0; }}',
                  f'set_{field} :: (fields: *tcp_connection_info, value: bool) {{ if value fields.__bitfield |= {mask}; else fields.__bitfield &= ~cast(u32) {mask}; }}']
        exports += [f"get_{field}", f"set_{field}"]
    lines += ['get___pad2 :: (fields: tcp_connection_info) -> u32 { return fields.__bitfield >> 15; }',
              'set___pad2 :: (fields: *tcp_connection_info, value: u32) { fields.__bitfield = (fields.__bitfield & 0x7fff) | ((value & 0x1ffff) << 15); }',
              '']
    exports += ['get___pad2', 'set___pad2']
    for name in exports:
        if f'`{name} ::' not in spec:
            raise RuntimeError(f"accessor absent from reviewed surface: {name}")
    private = ROOT / "stdlib/internal/net/socket-fields-macos.jai"
    private.write_text('\n'.join(lines))
    formatter = str(ROOT / "target/jaifmt")
    for flags in [[], ['--check']]:
        subprocess.run([formatter, '--config', str(ROOT / 'jaifmt.toml'), *flags, str(private)], check=True)
    print(f"Generated {len(exports)} reviewed native field accessors")


if __name__ == '__main__':
    main()
