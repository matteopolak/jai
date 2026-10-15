#!/usr/bin/env python3
"""Real relocated JKS/signature consumers; no stale binaries or peer overlays.

Configured SDK/build/consumer-source prefixes are disposable copies which are
removed before execution. dyld image records and a missing-dylib negative prove
default distribution loading and static native linking without Homebrew crypto.
"""
import hashlib
import json
import os
from pathlib import Path
import platform
import re
import shutil
import subprocess

import build_android_crypto as package
import check_portable_jks_crypto as crypto
from portable_toolchain import assigned_target, default_compiler

ROOT = Path(__file__).resolve().parents[1]
SDK = Path('/opt/homebrew/opt/openssl@3')
SOURCES = ['android-jks-crypto.jai', 'android-jks-crypto-failures.jai',
           'android-native-crypto.jai', 'android-native-crypto-failures.jai']


def run(command, env=None, **kwargs):
    return subprocess.run(list(map(str, command)), check=True, env=env,
                          capture_output=True, text=True, timeout=180, **kwargs)


def execute(command, env, moved, forbidden, label):
    env = dict(env, DYLD_PRINT_LIBRARIES='1')
    result = run(command, env=env, cwd=moved)
    if result.stdout != 'ok\n':
        raise RuntimeError(f'{label}: unexpected output {result.stdout!r}')
    images = []
    other = []
    for line in result.stderr.splitlines():
        match = re.match(r'^dyld\[\d+\]:\s+(?:<[^>]+>\s+)?(/.*)$', line)
        if match:
            images.append(match[1])
        else:
            other.append(line)
    if other or not images:
        raise RuntimeError(f'{label}: no usable dyld trace or unexpected diagnostics: {result.stderr}')
    for path in images:
        if any(path == str(prefix) or path.startswith(str(prefix) + '/') for prefix in forbidden):
            raise RuntimeError(f'{label}: forbidden loaded image {path}')
    loaded_crypto = [path for path in images if 'libcrypto' in Path(path).name]
    expected = moved / 'stdlib/internal/android-toolchain/android-crypto/libcrypto.dylib'
    if label.endswith('interpreter') and label.startswith('android-native-crypto'):
        if loaded_crypto != [str(expected)]:
            raise RuntimeError(f'{label}: wrong interpreter crypto image {loaded_crypto}')
    elif loaded_crypto:
        raise RuntimeError(f'{label}: native should statically link crypto: {loaded_crypto}')
    return {'label': label, 'images': images, 'stdout': result.stdout}


def main():
    if platform.system() != 'Darwin':
        raise RuntimeError('actual Mac dyld gate only; no Linux/Windows native inference')
    work = assigned_target() / 'android-crypto-relocation'
    build = work / 'build-prefix'
    moved = work / 'moved distribution'
    for directory in [build, moved]:
        if directory.exists():
            shutil.rmtree(directory)
    source = build / 'source-distribution'
    source.mkdir(parents=True)
    # Copy only authorized SDK inputs. Neither implementation sources nor a
    # prebuilt SDK shared library is used to build the package.
    sdk_copy = build / 'configured-sdk'
    spec = json.loads(package.MANIFEST.read_text())
    for name in spec['sdk_inputs']:
        destination = sdk_copy / name
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(SDK / name, destination)
    # The ABI harness needs the SDK's public header closure, not vendor bodies.
    shutil.copytree(SDK / 'include', sdk_copy / 'include', dirs_exist_ok=True)
    crypto.fixtures(source)
    crypto.sdk_fixtures(source, SDK / 'bin/openssl')
    library = crypto.stage(source)
    installed = package.build(sdk_copy, library)
    (source / 'bin').mkdir()
    compiler = source / 'bin/jaic'
    shutil.copy2(default_compiler(), compiler)
    consumers = source / 'consumers'
    consumers.mkdir()
    for name in SOURCES:
        shutil.copyfile(ROOT / 'tests/portable-stdlib' / name, consumers / name)
    env = dict(os.environ, JAIC_STDLIB=str(library))
    # Test default lookup without changing the invoking shell's existing overrides.
    for key in ['JAIC_NATIVE_LIBS', 'JAIC_CROSS_LIBS', 'DYLD_LIBRARY_PATH',
                'DYLD_FALLBACK_LIBRARY_PATH', 'DYLD_INSERT_LIBRARIES']:
        env.pop(key, None)
    declaration = 'FIXTURE_ROOT :: ' + json.dumps(str(moved)) + ';'
    original_paths = [build, source, sdk_copy]
    source.rename(moved)
    shutil.rmtree(build)
    if any(path.exists() for path in original_paths):
        raise RuntimeError('configured SDK/build/source prefixes must be unavailable')
    env['JAIC_STDLIB'] = str(moved / 'stdlib')
    # Compile after relocation/removal too: the linker must discover the moved
    # archive by the binding's ordinary distribution-relative library name.
    native_dependencies = {}
    for name in SOURCES:
        for opt in ['-O0', '-O2']:
            executable = moved / 'bin' / (Path(name).stem + opt)
            run([moved / 'bin/jaic', opt, '-add', declaration,
                 moved / 'consumers' / name, '-exe', executable], env)
            linked = package.dependencies(executable)
            if any('crypto' in dependency or not dependency.startswith('/usr/lib/') for dependency in linked):
                raise RuntimeError(f'non-system native dependency: {linked}')
            native_dependencies[executable.name] = linked
    # The SDK's original installation is not moved or modified. No loaded image
    # may come from it; the missing-packaged-dylib negative also forbids fallback.
    forbidden = original_paths + [ROOT, SDK, SDK.resolve()]
    evidence = []
    for name in SOURCES:
        stem = Path(name).stem
        commands = [([moved / 'bin/jaic', '-interp', '-add', declaration,
                      moved / 'consumers' / name], stem + '-interpreter')]
        for opt in ['-O0', '-O2']:
            commands.append(([moved / 'bin' / (stem + opt)], stem + opt))
        for command, label in commands:
            evidence.append(execute(command, env, moved, forbidden, label))
            if name == 'android-native-crypto.jai':
                for kind in ['ec', 'rsa', 'sdk']:
                    run([SDK / 'bin/openssl', 'dgst', '-sha256', '-verify', moved / f'{kind}.public.pem',
                         '-signature', moved / f'{kind}.jai-signature', moved / 'message.bin'])
    dylib = moved / 'stdlib/internal/android-toolchain/android-crypto/libcrypto.dylib'
    hidden = dylib.with_suffix('.unavailable')
    dylib.rename(hidden)
    try:
        result = subprocess.run([str(moved / 'bin/jaic'), '-interp', '-add', declaration,
                                 str(moved / 'consumers/android-native-crypto.jai')], env=env,
                                capture_output=True, text=True, timeout=180)
        if result.returncode != 1 or 'foreign procedure `d2i_PUBKEY` is not available' not in result.stderr:
            raise RuntimeError(f'missing-library fallback negative failed: {result}')
    finally:
        hidden.rename(dylib)
    report = {
        'configured_build_sdk_source_prefixes_removed': list(map(str, original_paths)),
        'installed_sdk_unmodified_but_forbidden_in_loaded_images': [str(SDK), str(SDK.resolve())],
        'negative_missing_packaged_dylib': 'interpreter fails; no SDK fallback',
        'consumer_source_sha256': {name: hashlib.sha256((moved / 'consumers' / name).read_bytes()).hexdigest() for name in SOURCES},
        'crypto_manifest_sha256': hashlib.sha256(package.MANIFEST.read_bytes()).hexdigest(),
        'compiler_sha256': hashlib.sha256((moved / 'bin/jaic').read_bytes()).hexdigest(),
        'runs': evidence,
        'native_built_after_relocation_and_prefix_removal': native_dependencies,
        'linux_windows_native_verified': False,
        'sandbox_exec': 'nested host sandbox rejected sandbox_apply; actual disposable prefixes removed instead'
    }
    (work / 'loaded-images.json').write_text(json.dumps(report, indent=2) + '\n')
    print('Moved distribution: 12 real JKS/crypto interpreter/native Mac O0/O2 runs pass; removed build/SDK/source prefixes, loaded images and missing-dylib negative verified')


if __name__ == '__main__':
    main()
