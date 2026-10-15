#!/usr/bin/env python3
"""Compare reviewed Socket accessors against source-built official Apple SDK C layouts."""
import os
from pathlib import Path
import platform
import shutil
import subprocess
from generate_socket_macos_fields import FLAGS

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "target/portable-socket-fields"


def generate_fixtures():
    native = ['#include <netinet/tcp.h>', '#include <stdint.h>', '#include <stdio.h>', '#include <string.h>',
              'int main(void) {', 'uint32_t header[4] = {0x54435031,256,sizeof(struct tcphdr),sizeof(struct tcp_connection_info)};',
              'if(fwrite(header,sizeof(header),1,stdout)!=1) return 1;',
              'for(uint32_t i=0;i<256;i++) {', 'uint32_t pattern=(i*0x01054321u)^0xa5c31f00u;',
              'struct tcphdr packet; memset(&packet,0xa5,sizeof(packet));', 'packet.th_off=pattern; packet.th_x2=~pattern;',
              'struct tcp_connection_info info; memset(&info,0xa5,sizeof(info));']
    jai = ['// Native SDK field assignments are the independent ABI oracle.', '#import "Basic";',
           'S :: #import "Socket";', 'F :: #import "File";', 'P :: #import "String";', 'main :: () {', '#if OS == .MACOS {',
           'filename := sprint("%/../../../target/portable-socket-fields/vectors.bin",P.path_strip_filename(#file));',
           'defer free(filename);', 'bytes, loaded := F.read_entire_file(filename);',
           'assert(loaded && bytes.count == 16+256*(size_of(S.tcphdr)+size_of(S.tcp_connection_info)));',
           'defer free(bytes);', 'assert(read_word(bytes.data)==0x54435031 && read_word(bytes.data+4)==256);',
           'assert(read_word(bytes.data+8)==size_of(S.tcphdr) && read_word(bytes.data+12)==size_of(S.tcp_connection_info));',
           'for i: 0..255 {', 'scaled := cast,truncate(u32) (cast(u64) i * 0x01054321);',
           'pattern := scaled ^ 0xa5c31f00;', 'packet: S.tcphdr; memset(*packet,0xa5,size_of(S.tcphdr));',
           'S.set_th_off(*packet,pattern); S.set_th_x2(*packet,~pattern);',
           'assert(S.get_th_off(packet)==(pattern&15) && S.get_th_x2(packet)==((~pattern)&15));',
           'info: S.tcp_connection_info; memset(*info,0xa5,size_of(S.tcp_connection_info));']
    for name, bit in sorted(FLAGS.items()):
        native.append(f'info.{name}=(pattern>>{bit})&1;')
        jai += [f'old_{bit} := info.__bitfield;', f'S.set_{name}(*info,(pattern & {1<<bit})!=0);',
                f'assert(S.get_{name}(info)==((pattern & {1<<bit})!=0));',
                f'assert(((old_{bit} ^ info.__bitfield)&~cast(u32) {1<<bit})==0);']
    native += ['info.__pad2=pattern;', 'if(fwrite(&packet,sizeof(packet),1,stdout)!=1) return 2;',
               'if(fwrite(&info,sizeof(info),1,stdout)!=1) return 3;', '}', 'return fflush(stdout)==0?0:4;', '}']
    jai += ['S.set___pad2(*info,pattern); assert(S.get___pad2(info)==(pattern&0x1ffff));',
            'expected := bytes.data+16+i*(size_of(S.tcphdr)+size_of(S.tcp_connection_info));',
            'for b: 0..size_of(S.tcphdr)-1 assert((cast(*u8) *packet)[b]==expected[b]);',
            'expected += size_of(S.tcphdr);',
            'for b: 0..size_of(S.tcp_connection_info)-1 assert((cast(*u8) *info)[b]==expected[b]);',
            '}', 'print("ok\\n");', '} else { assert(false,"Apple native field fixture requires macOS"); }', '}',
            '#scope_file', 'read_word :: (p: *u8) -> u32 { result:u32; for i:0..3 { part:=cast(u32)p[i]; result|=part<<(i*8); } return result; }']
    c_source = ROOT / 'tests/portable-stdlib/native/socket-fields-macos.c'
    jai_source = ROOT / 'tests/portable-stdlib/socket-fields/main.jai'
    jai_source.parent.mkdir(parents=True, exist_ok=True)
    c_source.write_text('\n'.join(native)+'\n')
    jai_source.write_text('\n'.join(jai)+'\n')
    subprocess.run([str(ROOT/'target/jaifmt'),'--config',str(ROOT/'jaifmt.toml'),str(jai_source)],check=True)
    return c_source, jai_source


def main():
    if platform.system() != 'Darwin':
        raise RuntimeError('actual Apple SDK oracle execution requires macOS')
    OUTPUT.mkdir(parents=True, exist_ok=True)
    c_source, source = generate_fixtures()
    native = OUTPUT/'oracle'
    subprocess.run(['clang','-std=c11','-O2','-Wall','-Wextra','-Werror',str(c_source),'-o',str(native)],check=True)
    with (OUTPUT/'vectors.bin').open('wb') as output:
        subprocess.run([str(native)],stdout=output,check=True)
    x64_oracle = OUTPUT/'oracle-x64'
    subprocess.run(['clang','-arch','x86_64','-std=c11','-O2','-Wall','-Wextra','-Werror',
                    str(c_source),'-o',str(x64_oracle)],check=True)
    with (OUTPUT/'vectors-x64.bin').open('wb') as output:
        subprocess.run([str(x64_oracle)],stdout=output,check=True)
    if (OUTPUT/'vectors.bin').read_bytes() != (OUTPUT/'vectors-x64.bin').read_bytes():
        raise RuntimeError('native Apple CPU record ABI differs; a shared oracle cannot be used')
    library = ROOT/'target/portable-integration-stdlib'
    for relative in ['Socket','internal/net']:
        shutil.copytree(ROOT/'stdlib'/relative,library/relative,dirs_exist_ok=True)
    env = dict(os.environ,JAIC_STDLIB=str(library))
    compiler = ROOT/'target/compiler/debug/jaic'
    commands = [[str(compiler),'-interp',str(source)]]
    for architecture, target in [('host',[]),('x64',['-target','x86_64-apple-darwin','-cpu','x64'])]:
        for optimization in ['-O0','-O2']:
            executable = OUTPUT/f'fields-{architecture}{optimization}'
            subprocess.run([str(compiler),*target,str(source),optimization,'-exe',str(executable)],env=env,cwd=ROOT,check=True)
            commands.append([str(executable)])
    for command in commands:
        result = subprocess.run(command,env=env,cwd=ROOT,text=True,capture_output=True,timeout=90)
        if result.returncode or result.stdout!='ok\n' or result.stderr:
            raise RuntimeError(f'{command!r}\n{result.stdout}{result.stderr}')
    print('36 public accessors match256 official SDK C record pairs in interpreter/native host+x64 O0/O2')


if __name__=='__main__':
    main()
