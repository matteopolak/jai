#!/usr/bin/env python3
"""Generate explicit Android POSIX records from complete pinned official C headers.

Clang parses the real Bionic header graph for both target CPUs. Static C ABI
assertions validate every emitted field size/offset and complete record layout.
These are C source checks, not execution of Android SDK/Jai programs.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import shlex
import subprocess
import tarfile

ROOT = Path(__file__).resolve().parents[2]
NAMES = ('iovec', 'pollfd', 'sched_param', 'timeval')
OUTPUT = ROOT/'stdlib/internal/bindings/vendor/android-posix-shapes.json'
INCLUDES = '#include <sys/uio.h>\n#include <poll.h>\n#include <sched.h>\n#include <sys/time.h>\n#include <stddef.h>\n'
SCALARS = {'int':('s32',4,4), 'short':('s16',2,2),
           'long':('s64',8,8), 'unsigned long':('u64',8,8), 'void *':('*void',8,8)}


def digest(data):
    return hashlib.sha256(data).hexdigest()


def record_shape(record):
    if not record.get('completeDefinition') or record.get('tagUsed') != 'struct':
        raise ValueError('A complete ordinary C struct is required')
    if any(n['kind'] not in ('FieldDecl','FullComment') for n in record.get('inner',[])):
        raise ValueError('Unsupported nested/attributed C record; never flatten or omit it')
    fields, offset, alignment = [], 0, 1
    for field in record['inner']:
        if field['kind'] != 'FieldDecl':
            continue
        if not field.get('name') or field.get('isBitfield') or field.get('inner'):
            raise ValueError('Unsupported anonymous, bitfield or attributed C field')
        ty = field['type']
        canonical = ty.get('desugaredQualType',ty['qualType'])
        if canonical not in SCALARS:
            raise ValueError('Unreviewed LP64 field type: '+canonical)
        jai, size, align = SCALARS[canonical]
        offset = (offset+align-1)//align*align
        fields.append({'name':field['name'],'native_type':ty['qualType'],
                       'canonical_c_type':canonical,'jai_type':jai,
                       'offset':offset,'size':size,'alignment':align})
        offset += size
        alignment = max(alignment,align)
    if not fields:
        raise ValueError('No complete fields in native C record')
    name = record['name']
    return {'name':name,'code':name+' :: struct {\n'+
            '\n'.join('    '+f['name']+': '+f['jai_type']+';' for f in fields)+'\n}',
            'size':(offset+alignment-1)//alignment*alignment,'alignment':alignment,'fields':fields}


def assertions(shapes):
    lines = ['_Static_assert(sizeof(void*) == 8 && sizeof(long) == 8 && sizeof(int) == 4 && sizeof(short) == 2, "LP64 scalar ABI");']
    for shape in shapes:
        name = shape['name']
        for expression, expected in [('sizeof(struct '+name+')',shape['size']),
                                     ('_Alignof(struct '+name+')',shape['alignment'])]:
            lines.append('_Static_assert('+expression+' == '+str(expected)+', "'+name+' layout");')
        for field in shape['fields']:
            member = field['name']
            lines.append('_Static_assert(offsetof(struct '+name+', '+member+') == '+str(field['offset'])+', "'+name+'.'+member+' offset");')
            lines.append('_Static_assert(sizeof(((struct '+name+'*)0)->'+member+') == '+str(field['size'])+', "'+name+'.'+member+' size");')
    return '\n'.join(lines)+'\n'


def run(command):
    return subprocess.run([str(x) for x in command],check=True,capture_output=True,text=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check',action='store_true')
    parser.add_argument('--report',type=Path,default=ROOT/'.work/android-posix-header-checks.json')
    args = parser.parse_args()
    pin = json.loads((ROOT/'tools/native_bindings/dependencies.json').read_text())['bionic']
    archive = ROOT/'.work/vendor/bionic.tar.gz'
    if digest(archive.read_bytes()) != pin['archive']['sha256']:
        raise SystemExit('Pinned official Bionic archive hash mismatch')
    vendor = ROOT/'.work/vendor'/pin['archive']['root']
    resource = Path(run(['clang','-print-resource-dir']).stdout.strip())
    work = ROOT/'.work/bionic-shape-generation'
    work.mkdir(exist_ok=True)
    probe = work/'probe.c'
    result = {'scope':'Official native C header delegates; Android Jai target/runtime remains unverified',
              'revision':pin['revision'],'archive_sha256':pin['archive']['sha256'],
              'header_hashes':{},'targets':{}}
    report = {'scope':result['scope'],'clang':run(['clang','--version']).stdout,'checks':[]}
    with tarfile.open(archive) as source_archive:
        for cpu, arch, triple in [('arm64','asm-arm64','aarch64-linux-android35'),
                                  ('x64','asm-x86','x86_64-linux-android35')]:
            includes = [vendor/'libc/include',vendor/'libc/kernel/uapi',
                        vendor/'libc/kernel/uapi'/arch,vendor/'libc/kernel/android/uapi',resource/'include']
            command = ['clang','-target',triple,'-nostdinc']
            for path in includes:
                command += ['-isystem',path]
            command += ['-std=c11','-Wall','-Wextra','-Werror']
            probe.write_text(INCLUDES)
            ast = json.loads(run([*command,'-fsyntax-only','-Xclang','-ast-dump=json',probe]).stdout)
            records = [n for n in ast['inner'] if n['kind']=='RecordDecl' and
                       n.get('completeDefinition') and n.get('name') in NAMES]
            if sorted(n['name'] for n in records) != sorted(NAMES):
                raise SystemExit('Missing/ambiguous native SDK record definitions')
            shapes = [record_shape(n) for n in sorted(records,key=lambda n:n['name'])]
            probe.write_text(INCLUDES+assertions(shapes))
            checked = run([*command,'-fsyntax-only',probe])
            dependencies = shlex.split(run([*command,'-M',probe]).stdout.split(':',1)[1].replace('\\\n',' '))
            native_headers, compiler_headers = {}, {}
            for filename in dependencies:
                path = Path(filename).resolve()
                if path == probe.resolve():
                    continue
                if path.is_relative_to(vendor):
                    relative = str(path.relative_to(vendor))
                    data = path.read_bytes()
                    pinned = source_archive.extractfile(pin['archive']['root']+'/'+relative).read()
                    if data != pinned:
                        raise SystemExit('Native header differs from pinned archive: '+relative)
                    native_headers[relative] = digest(data)
                    result['header_hashes'][relative] = digest(data)
                elif path.is_relative_to(resource):
                    compiler_headers[str(path.relative_to(resource))] = digest(path.read_bytes())
                else:
                    raise SystemExit('Unexpected non-SDK/non-Clang header dependency: '+str(path))
            result['targets'][cpu] = {'condition':'OS == .ANDROID && CPU == .'+cpu.upper(),
                                     'triple':triple,'shapes':shapes,
                                     'headers':sorted(native_headers)}
            report['checks'].append({'cpu':cpu,'phase':'C-header-layout-assertions','exit':checked.returncode,
                                     'status':'passed','command':[str(x) for x in [*command,'-fsyntax-only',probe]],
                                     'probe_sha256':digest(probe.read_bytes()),
                                     'native_headers':native_headers,'compiler_resource_headers':compiler_headers})
    data = json.dumps(result,indent=2,sort_keys=True)+'\n'
    if args.check:
        if OUTPUT.read_text() != data:
            raise SystemExit('Stale Android POSIX header delegates')
    else:
        OUTPUT.write_text(data)
    args.report.write_text(json.dumps(report,indent=2)+'\n')
    print('Both Android C header/ABI checks passed; no Android Jai/runtime pass claimed')


if __name__ == '__main__':
    main()
