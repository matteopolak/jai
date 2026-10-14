#!/usr/bin/env python3
"""Fetch hash-pinned official native C sources and build real host libraries.

All downloads and outputs stay inside this clean-room workspace. No Git access,
credentials, reference binaries, or reference Jai sources are involved.
"""
import argparse
import hashlib
import json
from pathlib import Path
import platform
import subprocess
import urllib.request

ROOT = Path(__file__).resolve().parents[2]


def run(command):
    subprocess.run([str(x) for x in command], check=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, default=ROOT / '.work/native')
    args = parser.parse_args()
    vendor = ROOT / '.work/vendor'
    manifest = json.loads((Path(__file__).with_name('dependencies.json')).read_text())
    for name, source in manifest.items():
        for filename, expected in source['files'].items():
            path = vendor / name / filename
            if not path.exists():
                url = 'https://raw.githubusercontent.com/' + source['repository'] + '/' + source['revision'] + '/' + filename
                data = urllib.request.urlopen(url, timeout=60).read()
                if hashlib.sha256(data).hexdigest() != expected:
                    raise SystemExit('Hash mismatch: ' + url)
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_bytes(data)
            if hashlib.sha256(path.read_bytes()).hexdigest() != expected:
                raise SystemExit('Hash mismatch: ' + str(path))
    args.output.mkdir(parents=True, exist_ok=True)
    objects = args.output / 'objects'
    objects.mkdir(exist_ok=True)
    units = {
        'lz4': [vendor/'lz4/lib/lz4.c', vendor/'lz4/lib/lz4hc.c'],
        'xxhash070': [vendor/'xxhash/xxhash.c'],
        'meshoptimizer': sorted((vendor/'meshoptimizer/src').glob('*.cpp')),
    }
    macros = {'stb_image': 'STB_IMAGE_IMPLEMENTATION',
              'stb_image_resize': 'STB_IMAGE_RESIZE_IMPLEMENTATION',
              'stb_image_write': 'STB_IMAGE_WRITE_IMPLEMENTATION'}
    for name, macro in macros.items():
        header = ('deprecated/' if name == 'stb_image_resize' else '') + name + '.h'
        path = objects / (name + '.c')
        path.write_text('#define ' + macro + '\n#include "' + header + '"\n')
        units[name] = [path]
    units['stb_vorbis'] = [vendor/'stb/stb_vorbis.c']
    for name, sources in units.items():
        compiled = []
        for i, path in enumerate(sources):
            obj = objects / (name + str(i) + '.o')
            run(['c++' if path.suffix == '.cpp' else 'cc', '-O2', '-fPIC', '-I', vendor/'stb', '-c', path, '-o', obj])
            compiled.append(obj)
        run(['ar', 'rcs', args.output / ('lib' + name + '.a'), *compiled])
        suffix = '.dylib' if platform.system() == 'Darwin' else '.so'
        run(['c++' if name == 'meshoptimizer' else 'cc', '-dynamiclib' if suffix == '.dylib' else '-shared', *compiled,
             '-lm', '-o', args.output / ('lib' + name + suffix)])
        print('Built ' + name)


if __name__ == '__main__':
    main()
