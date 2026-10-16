#!/usr/bin/env python3
"""Exercise real relocated LLVM consumers and dependency notice retention on Mac."""
import argparse
import ctypes
import hashlib
import json
import os
from pathlib import Path
import platform
import shutil
import subprocess
import tempfile

import developer_native_runtime as runtime


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--sdk', type=Path, required=True)
    parser.add_argument('--binding-helper', type=Path, required=True)
    parser.add_argument('--demangler', type=Path, required=True)
    parser.add_argument('--output-root', type=Path, required=True)
    args = parser.parse_args()
    if platform.system() != 'Darwin':
        parser.error('actual Mac loader execution required; other platforms remain unverified')
    args.output_root.mkdir(parents=True, exist_ok=True)
    work = Path(tempfile.mkdtemp(prefix='relocated-runtime-', dir=args.output_root))
    stage = work / 'before-move'
    images = stage / 'runtime'
    inputs = {str(p.resolve()): runtime.sha256(p) for p in (args.binding_helper, args.demangler)}
    names = {'libclang.dylib'}
    names.update(Path(name).name for name in runtime.dependencies(args.demangler)
                 if not runtime.system_library(name))
    runtime.stage_macos_sdk(args.sdk.resolve(), images, sorted(names))
    manifest = json.loads((images / 'runtime-sdk.json').read_text())
    for name, entry in manifest.items():
        assert entry.get('notices'), 'Missing staged license/notice receipt for ' + name
        for notice in entry['notices']:
            assert runtime.sha256(images / notice['staged_path']) == notice['sha256']
    helper = stage / 'binding-helper'
    demangler = stage / 'libdeveloper_tools_check.dylib'
    shutil.copy2(args.binding_helper, helper)
    shutil.copy2(args.demangler, demangler)
    runtime.relocate_macos_helper(helper, images)
    runtime.relocate_macos_helper(demangler, images, library=True)
    relocated = work / 'after-move'
    stage.rename(relocated)
    assert not stage.exists()
    for image in [relocated / 'binding-helper', relocated / demangler.name,
                  *(relocated / 'runtime' / name for name in manifest)]:
        assert all(runtime.system_library(name) or name.startswith('@loader_path/')
                   for name in runtime.dependencies(image)), str(image)
        subprocess.run(['codesign', '--verify', '--strict', str(image)], check=True,
                       capture_output=True, text=True, timeout=60)
    header = work / 'probe.h'
    header.write_text('typedef struct RuntimePackageProbe { long long value; int flag; } RuntimePackageProbe;\n')
    output = work / 'generated.jai'
    env = {k: v for k, v in os.environ.items() if not k.startswith('DYLD_')}
    result = subprocess.run([relocated / 'binding-helper', header, output, 'c', '--jai-no-library'],
                            env=env, capture_output=True, text=True, timeout=60)
    assert result.returncode == 0 and not result.stderr, result.stderr
    generated = output.read_text()
    assert 'RuntimePackageProbe' in generated and 'value: s64' in generated and 'flag: s32' in generated

    class Signature(ctypes.Structure):
        _fields_ = [('result', ctypes.c_void_p), ('arguments', ctypes.c_void_p),
                    ('argument_count', ctypes.c_int64), ('used_bytes', ctypes.c_int64),
                    ('status', ctypes.c_int32), ('error', ctypes.c_char_p)]

    assert ctypes.sizeof(Signature) == 48
    library = ctypes.CDLL(str(relocated / demangler.name))
    parse = library.developer_check_parse
    parse.argtypes = [ctypes.c_char_p, ctypes.c_int64, ctypes.c_int32, ctypes.c_int32, ctypes.c_int32]
    parse.restype = ctypes.POINTER(Signature)
    for name, windows in [(b'_Z3fooi', 0), (b'?func@@YAHH@Z', 1)]:
        signature = parse(name, len(name), windows, 8, 1).contents
        assert signature.status == 0 and signature.argument_count == 1 and not signature.error
    unlicensed = work / 'missing-notice-sdk' / 'lib' / 'libclang.dylib'
    unlicensed.parent.mkdir(parents=True)
    shutil.copy2(args.sdk / 'lib/libclang.dylib', unlicensed)
    try:
        runtime.stage_notices({'libclang.dylib': unlicensed}, work / 'rejected-package')
    except RuntimeError as error:
        assert 'lacks top-level license/notice' in str(error)
    else:
        raise AssertionError('Missing native SDK notice was accepted')
    notice = next(iter(manifest.values()))['notices'][0]
    staged_notice = relocated / 'runtime' / notice['staged_path']
    original_notice = staged_notice.read_bytes()
    staged_notice.write_bytes(b'conflicting package notice\n')
    try:
        source = Path(next(iter(manifest.values()))['sdk_image'])
        runtime.stage_notices({'conflict': source}, relocated / 'runtime')
    except RuntimeError as error:
        assert 'Conflicting staged SDK notice' in str(error)
    else:
        raise AssertionError('Conflicting native SDK notice was overwritten')
    finally:
        staged_notice.write_bytes(original_notice)
    assert runtime.sha256(staged_notice) == notice['sha256']
    assert all(runtime.sha256(Path(name)) == digest for name, digest in inputs.items())
    report = dict(host='macos-' + platform.machine(), source_inputs=inputs,
                  moved_from=str(stage), moved_to=str(relocated), dependency_manifest=manifest,
                  passed=['dependency notices/hash identity', 'loader-relative closure after move',
                          'real libclang record generation', 'real Itanium demangler',
                          'real Microsoft demangler', 'original helper identity',
                          'native code signatures after relocation', 'missing notice rejection',
                          'conflicting notice rejection and exact restoration'],
                  failed=[], other_native_platforms='unverified')
    (work / 'verification.json').write_text(json.dumps(report, indent=2) + '\n')
    print(work / 'verification.json')


if __name__ == '__main__':
    main()
