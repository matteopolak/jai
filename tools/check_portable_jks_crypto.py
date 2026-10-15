#!/usr/bin/env python3
"""Independent hashlib fixtures and clean-clone-only JKS/EVP verification.

Never loads producer overlays, peers, supplied compilers, or reference artifacts.
All generated data/binaries live in this worker's assigned Cargo target.
"""
import argparse
import hashlib
import json
import os
import platform
from pathlib import Path
import shutil
import struct
import subprocess

from portable_toolchain import assigned_target, checked_compiler, default_compiler

ROOT = Path(__file__).resolve().parents[1]


def sha(data):
    return hashlib.sha1(data).digest()


def tlv(tag, data):
    n = len(data)
    length = bytes([n]) if n < 128 else bytes([0x80 + (n.bit_length()+7)//8]) + n.to_bytes((n.bit_length()+7)//8, 'big')
    return bytes([tag]) + length + data


def protect(plain, password, salt):
    pw = password.encode('utf-16-be')
    block = salt
    stream = bytearray()
    while len(stream) < len(plain):
        block = sha(pw + block)
        stream.extend(block)
    return salt + bytes(a ^ b for a, b in zip(plain, stream)) + sha(pw + plain)


def wrapper(protected, parameters=b'\x05\x00'):
    oid = bytes.fromhex('2b060104012a02110101')
    return tlv(0x30, tlv(0x30, tlv(6, oid) + parameters) + tlv(4, protected))


def store(encrypted, password, certificates, version=2):
    def utf(data):
        return struct.pack('>H', len(data)) + data

    def blob(data):
        return struct.pack('>I', len(data)) + data

    data = struct.pack('>IIII', 0xfeedfeed, version, 1, 1)
    data += utf(b'fixture') + struct.pack('>Q', 0x0123456789abcdef)
    key_offset = len(data) + 4
    data += blob(encrypted) + struct.pack('>I', len(certificates))
    certificate_offset = 0
    for certificate in certificates:
        if version == 2:
            data += utf(b'X.509')
        certificate_offset = len(data) + 4
        data += blob(certificate)
    digest = sha(password.encode('utf-16-be') + b'Mighty Aphrodite' + data)
    return data + digest, key_offset, certificate_offset


def fixtures(output):
    output.mkdir(parents=True, exist_ok=True)
    cases = []
    # Both sides of SHA1 keystream and SHA message padding boundaries.
    for password in ['', 'password', 'a\x00z']:
        for length in [0, 1, 19, 20, 21, 39, 40, 41, 55, 56, 63, 64, 65, 127, 128, 257]:
            plain = bytes((i * 37 + length) % 256 for i in range(length))
            salt = bytes((i * 13 + length) % 256 for i in range(20))
            protected = protect(plain, password, salt)
            encrypted = wrapper(protected, parameters=b'' if length % 2 else b'\x05\x00')
            certs = [b'first-cert', b'last\x00certificate']
            encoded, key_offset, certificate_offset = store(encrypted, password, certs)
            cases.append((password.encode(), plain, protected, encrypted, encoded,
                          certs[-1], key_offset, certificate_offset))
    wire = bytearray(struct.pack('<I', len(cases)))
    for case in cases:
        for field in case[:6]:
            wire += struct.pack('<I', len(field)) + field
        wire += struct.pack('<QQ', *case[6:])
    (output / 'vectors.bin').write_bytes(wire)
    # A version1 store without certificates is covered explicitly.
    v1, _, _ = store(b'opaque key', 'password', [], version=1)
    (output / 'version1.jks').write_bytes(v1)
    (output / 'valid.jks').write_bytes(cases[17][4])
    (output / 'protected.bin').write_bytes(cases[17][2])
    (output / 'wrapped.der').write_bytes(cases[17][3])
    def checksum(body):
        return body + sha('password'.encode('utf-16-be') + b'Mighty Aphrodite' + body)

    original = cases[17][4][:-20]
    mutants = []
    # Isolate framing restrictions by recomputing the store integrity checksum.
    for offset, replacement in [(0, b'\x00\x00\x00\x00'),
                                (4, struct.pack('>I', 3)),
                                (8, struct.pack('>I', 2)),
                                (12, struct.pack('>I', 2)),
                                (16, b'\xff\xff'),
                                (33, b'\xff\xff\xff\xff')]:
        body = bytearray(original)
        body[offset:offset+len(replacement)] = replacement
        mutants.append(checksum(body))
    mutants.append(checksum(original + b'trailing'))
    body = original.replace(b'X.509', b'other')
    mutants.append(checksum(body))
    damaged = bytearray(cases[17][4])
    damaged[-1] ^= 1
    mutants.append(bytes(damaged))
    negatives = bytearray(struct.pack('<I', len(mutants)))
    for mutant in mutants:
        negatives += struct.pack('<I', len(mutant)) + mutant
    (output / 'negative-stores.bin').write_bytes(negatives)
    protected = cases[17][2]
    valid_wrapper = wrapper(protected)
    malformed_wrappers = [valid_wrapper + b'trailing',
                          valid_wrapper.replace(bytes.fromhex('2b060104012a02110101'), bytes.fromhex('2b060104012a02110102')),
                          wrapper(protected, parameters=tlv(5, b'nonempty')),
                          wrapper(protected, parameters=tlv(2, b'\x01')),
                          wrapper(protected, parameters=b'\x05\x00\x05\x00'),
                          b'\x10' + valid_wrapper[1:],
                          wrapper(b'short'),
                          wrapper(protected[:-1] + bytes([protected[-1] ^ 1]))]
    negatives = bytearray(struct.pack('<I', len(malformed_wrappers)))
    for malformed in malformed_wrappers:
        negatives += struct.pack('<I', len(malformed)) + malformed
    (output / 'negative-wrappers.bin').write_bytes(negatives)
    metadata = {'cases': len(cases), 'vectors_sha256': hashlib.sha256(wire).hexdigest()}
    (output / 'fixtures.json').write_text(json.dumps(metadata, indent=2) + '\n')
    return metadata


def run(command, env=None, **kwargs):
    subprocess.run(list(map(str, command)), env=env, check=True, timeout=180, **kwargs)


def stage(output):
    library = output / 'stdlib'
    if library.exists():
        shutil.rmtree(library)
    baseline = ROOT / 'artifacts/verification-base-934a6918/stdlib'
    if not (baseline / 'internal/compiler-api/runtime-config.jai').exists():
        raise RuntimeError('named complete clean stdlib dependency 934a6918 is required')
    shutil.copytree(baseline, library)
    for name in ['jks-reader.jai', 'jks-decryption.jai', 'crypto-provider.jai']:
        shutil.copyfile(ROOT / 'stdlib/internal/android-toolchain' / name,
                        library / 'internal/android-toolchain' / name)
    facade = library / 'Android/Toolchain/module.jai'
    loads = ''.join(f'#load "../../internal/android-toolchain/{name}";\n' for name in
                    ['jks-reader.jai', 'jks-decryption.jai', 'crypto-provider.jai'])
    # Test-only aliases expose the same canonical module-private handles/ABI.
    # Production declarations remain implementation-scoped per reviewed contract.
    aliases = ['evp_pkey_st', 'EVP_PKEY_free', 'EVP_PKEY_is_a', 'EVP_MD_CTX_new',
               'EVP_MD_CTX_free', 'EVP_sha256', 'EVP_DigestVerifyInit',
               'EVP_DigestVerifyUpdate', 'EVP_DigestVerifyFinal']
    loads += '\n#scope_export\n' + ''.join(f'test_{name} :: {name};\n' for name in aliases)
    text = facade.read_text()
    assert text.count('#scope_file') == 1
    facade.write_text(text.replace('#scope_file', loads + '\n#scope_file'))
    return library


def sdk_fixtures(output, openssl):
    # The installed SDK tools create fresh keys; no reference compiler involved.
    keytool = Path('/opt/homebrew/opt/openjdk/bin/keytool')
    (output / 'message.bin').write_bytes(bytes(range(256)) + b'\x00exact message\xff' * 13)
    for kind in ['ec', 'rsa']:
        pem = output / f'{kind}.pem'
        options = ['-algorithm', 'EC', '-pkeyopt', 'ec_paramgen_curve:P-256'] if kind == 'ec' else ['-algorithm', 'RSA', '-pkeyopt', 'rsa_keygen_bits:2048']
        run([openssl, 'genpkey', *options, '-out', pem], stderr=subprocess.DEVNULL)
        run([openssl, 'pkcs8', '-topk8', '-nocrypt', '-in', pem, '-outform', 'DER', '-out', output / f'{kind}.der'])
        run([openssl, 'pkey', '-in', pem, '-traditional', '-outform', 'DER', '-out', output / f'{kind}.traditional.der'], stderr=subprocess.DEVNULL)
        run([openssl, 'pkey', '-in', pem, '-pubout', '-outform', 'DER', '-out', output / f'{kind}.spki'])
        run([openssl, 'pkey', '-in', pem, '-pubout', '-out', output / f'{kind}.public.pem'])
        run([openssl, 'dgst', '-sha256', '-sign', pem, '-out', output / f'{kind}.sdk-signature', output / 'message.bin'])
    keystore = output / 'sdk.jks'
    keystore.unlink(missing_ok=True)
    run([keytool, '-genkeypair', '-storetype', 'JKS', '-keystore', keystore,
         '-storepass', 'password', '-keypass', 'password', '-alias', 'fixture',
         '-keyalg', 'EC', '-groupname', 'secp256r1', '-dname', 'CN=Independent fixture', '-validity', '1'], stderr=subprocess.DEVNULL)
    run([keytool, '-exportcert', '-keystore', keystore, '-storepass', 'password',
         '-alias', 'fixture', '-file', output / 'sdk.certificate.der'], stderr=subprocess.DEVNULL)
    result = subprocess.run([str(openssl), 'x509', '-inform', 'DER', '-in', str(output / 'sdk.certificate.der'), '-pubkey', '-noout'], capture_output=True, check=True)
    (output / 'sdk.public.pem').write_bytes(result.stdout)
    run([openssl, 'pkey', '-pubin', '-in', output / 'sdk.public.pem', '-outform', 'DER', '-out', output / 'sdk.spki'])
    # Validate independent protection fixture design against an actual SDK store.
    data = keystore.read_bytes()
    assert struct.unpack('>IIII', data[:16]) == (0xfeedfeed, 2, 1, 1)
    assert sha('password'.encode('utf-16-be') + b'Mighty Aphrodite' + data[:-20]) == data[-20:]
    offset = 18 + struct.unpack('>H', data[16:18])[0] + 8
    length = struct.unpack('>I', data[offset:offset+4])[0]
    encoded = data[offset+4:offset+4+length]

    def content(encoded, at):
        tag, size = encoded[at:at+2]
        at += 2
        if size & 128:
            n = size & 127
            size = int.from_bytes(encoded[at:at+n], 'big')
            at += n
        return tag, encoded[at:at+size], at+size

    tag, seq, end = content(encoded, 0)
    assert tag == 0x30 and end == len(encoded)
    tag, algorithm, end = content(seq, 0)
    assert tag == 0x30
    tag, payload, end = content(seq, end)
    assert tag == 4 and end == len(seq)
    salt, encrypted, digest = payload[:20], payload[20:-20], payload[-20:]
    # Applying the XOR stream twice recovers its input.
    plain = protect(encrypted, 'password', salt)[20:-20]
    assert sha('password'.encode('utf-16-be') + plain) == digest
    (output / 'sdk.independent-decrypted.der').write_bytes(plain)
    run([openssl, 'pkey', '-inform', 'DER', '-in', output / 'sdk.independent-decrypted.der',
         '-pubout', '-outform', 'DER', '-out', output / 'sdk.independent-spki'])
    assert (output / 'sdk.independent-spki').read_bytes() == (output / 'sdk.spki').read_bytes()


def native_library(library):
    # Install a test copy beside the binding, matching the distribution layout.
    # A package producer must provide the real platform library in that location.
    if platform.system() != 'Darwin':
        raise RuntimeError('this SDK packaging verifier currently requires Mac')
    destination = library / 'internal/android-toolchain/android-crypto'
    destination.mkdir(parents=True)
    sdk_lib = Path('/opt/homebrew/opt/openssl@3/lib')
    shutil.copyfile(sdk_lib / 'libcrypto.a', destination / 'libcrypto.a')
    shutil.copyfile(sdk_lib / 'libcrypto.dylib', destination / 'libcrypto.dylib')
    run(['install_name_tool', '-id', '@rpath/libcrypto.dylib', destination / 'libcrypto.dylib'], capture_output=True)
    # Modifying Mach-O invalidates the SDK signature; sign only this test copy.
    run(['codesign', '--force', '--sign', '-', destination / 'libcrypto.dylib'], capture_output=True)


def sdk_abi(output):
    sdk = Path('/opt/homebrew/opt/openssl@3')
    for opt in ['-O0', '-O2']:
        executable = output / f'sdk-abi{opt}'
        run(['cc', '-std=c11', '-Wall', '-Wextra', '-Werror', opt,
             '-I', sdk / 'include', ROOT / 'tests/native/android-crypto/abi.c',
             sdk / 'lib/libcrypto.a', '-o', executable])
        run([executable])


def test_program(command, env, output, source, openssl):
    result = subprocess.run(list(map(str, command)), env=env, cwd=output,
                            capture_output=True, text=True, timeout=180)
    if result.returncode or result.stdout != 'ok\n' or result.stderr:
        raise RuntimeError(f'{command!r}\nexit={result.returncode}\n{result.stdout}{result.stderr}')
    if source.name == 'android-native-crypto.jai':
        for kind in ['ec', 'rsa', 'sdk']:
            run([openssl, 'dgst', '-sha256', '-verify', output / f'{kind}.public.pem',
                 '-signature', output / f'{kind}.jai-signature', output / 'message.bin'])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--fixtures-only', action='store_true')
    parser.add_argument('--sdk-only', action='store_true',
                        help='verify independent fixture design and C ABI, without claiming Jai execution')
    parser.add_argument('--compiler', type=Path, default=default_compiler())
    parser.add_argument('--openssl', type=Path, default=Path('/opt/homebrew/opt/openssl@3/bin/openssl'))
    args = parser.parse_args()
    output = assigned_target() / 'jks-crypto'
    print(json.dumps(fixtures(output)))
    if args.fixtures_only:
        return
    sdk_fixtures(output, args.openssl)
    sdk_abi(output)
    if args.sdk_only:
        print('SDK fixture integrity/decryption/SPKI and C ABI O0/O2 pass; Jai execution is unverified')
        return
    compiler = checked_compiler(args.compiler, parser)
    library = stage(output)
    native_library(library)
    env = dict(os.environ, JAIC_STDLIB=str(library), JKS_CRYPTO_FIXTURES=str(output))
    fixture_declaration = 'FIXTURE_ROOT :: ' + json.dumps(str(output)) + ';'
    for name in ['android-jks-crypto.jai', 'android-jks-crypto-failures.jai',
                 'android-native-crypto.jai', 'android-native-crypto-failures.jai']:
        source = ROOT / 'tests/portable-stdlib' / name
        test_program([compiler, '-interp', '-add', fixture_declaration, source], env, output, source, args.openssl)
        for opt in ['-O0', '-O2']:
            executable = output / (source.stem + opt)
            run([compiler, opt, '-add', fixture_declaration, source, '-exe', executable], env)
            test_program([executable], env, output, source, args.openssl)
    run([compiler.parent / 'jailint', '-D', 'warnings', '--add', fixture_declaration,
         '--context', ROOT / 'tests/portable-stdlib/android-native-crypto.jai',
         *[library / 'internal/android-toolchain' / name for name in
           ['jks-reader.jai', 'jks-decryption.jai', 'crypto-provider.jai']]], env)
    run([compiler.parent / 'jailint', '-D', 'warnings', '--add', fixture_declaration,
         ROOT / 'tests/portable-stdlib/android-jks-crypto.jai',
         ROOT / 'tests/portable-stdlib/android-jks-crypto-failures.jai',
         ROOT / 'tests/portable-stdlib/android-native-crypto.jai',
         ROOT / 'tests/portable-stdlib/android-native-crypto-failures.jai'], env)
    private_test = ROOT / 'tests/portable-stdlib/negative/android-crypto-private-provider.jai'
    result = subprocess.run([str(compiler), '-check', str(private_test)], env=env,
                            capture_output=True, text=True, timeout=180)
    if result.returncode != 1 or 'EVP_PKEY_free' not in result.stderr:
        raise RuntimeError(f'private EVP scope check failed: {result!r}')
    for target in ['linux', 'windows']:
        for cpu in ['x64', 'arm64']:
            for name in ['android-jks-crypto.jai', 'android-jks-crypto-failures.jai',
                         'android-native-crypto.jai', 'android-native-crypto-failures.jai']:
                run([compiler, '-check', '-os', target, '-cpu', cpu, '-add', fixture_declaration,
                     ROOT / 'tests/portable-stdlib' / name], env)
    formatter = compiler.parent / 'jaifmt'
    run([formatter, '--config', ROOT / 'jaifmt.toml', '--check',
         *[ROOT / 'stdlib/internal/android-toolchain' / name for name in
           ['jks-reader.jai', 'jks-decryption.jai', 'crypto-provider.jai']],
         *[ROOT / 'tests/portable-stdlib' / name for name in
           ['android-jks-crypto.jai', 'android-jks-crypto-failures.jai',
            'android-native-crypto.jai', 'android-native-crypto-failures.jai']], private_test])
    print('JKS/EVP interpreter, native Mac O0/O2, SDK signatures, strict lint, format and foreign-target source checks pass')


if __name__ == '__main__':
    main()
