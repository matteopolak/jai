#!/usr/bin/env python3
"""Generate independent native EC/SHA256 APK vectors; this is not SDK validation.

Uses the installed openssl command and public documented CLI only. Never uses a
reference compiler, reference APK library, peer binary or implementation body.
"""
import argparse
import hashlib
from pathlib import Path
import shutil
import struct
import subprocess

from build_portable_apk_signing_fixtures import (
    CHUNK, V2_ID, container, digest_sections, lp, pair, payload, signed_data, u32,
)


def invoke(openssl, arguments, data=None, expected_status=0):
    result = subprocess.run([openssl, *map(str, arguments)], input=data,
                            capture_output=True, check=False, timeout=60)
    if result.returncode != expected_status:
        raise RuntimeError(f"native vector command failed: {arguments[0]}: {result.stderr.decode(errors='replace')}")
    return result.stdout


def native_digest(openssl, sections):
    leaves = []
    for section in sections:
        for offset in range(0, len(section), CHUNK):
            chunk = section[offset:offset + CHUNK]
            leaves.append(invoke(openssl, ["dgst", "-sha256", "-binary"], b"\xa5" + u32(len(chunk)) + chunk))
    return invoke(openssl, ["dgst", "-sha256", "-binary"], b"\x5a" + u32(len(leaves)) + b"".join(leaves))


def build(destination):
    openssl = shutil.which("openssl")
    if not openssl:
        raise RuntimeError("installed openssl is required for independent native vectors")
    native = destination / "native"
    if native.exists():
        shutil.rmtree(native)
    native.mkdir(mode=0o700)
    java_home = Path(subprocess.check_output(["brew", "--prefix", "openjdk"], text=True).strip()) / "libexec/openjdk.jdk/Contents/Home"
    keytool = java_home / "bin/keytool"
    store = native / "keystore.jks"
    command = [str(keytool), "-genkeypair", "-storetype", "JKS", "-keyalg", "EC",
               "-groupname", "secp256r1", "-alias", "apk", "-dname", "CN=Independent APK JKS vector",
               "-validity", "1", "-keystore", str(store), "-storepass", "password",
               "-keypass", "password", "-noprompt"]
    subprocess.run(command, capture_output=True, check=True, timeout=60)
    subprocess.run([str(keytool), "-exportcert", "-keystore", str(store), "-storetype", "JKS",
                    "-storepass", "password", "-alias", "apk", "-file", str(native / "jks-certificate.der")],
                   capture_output=True, check=True, timeout=60)
    key = native / "key.pem"
    cert = native / "certificate.pem"
    public = native / "public.pem"
    invoke(openssl, ["ecparam", "-name", "prime256v1", "-genkey", "-noout", "-out", key])
    key.chmod(0o600)
    invoke(openssl, ["req", "-new", "-x509", "-key", key, "-days", "1",
                     "-subj", "/CN=Cleanroom APK vector/O=Independent", "-out", cert])
    certificate = invoke(openssl, ["x509", "-in", cert, "-outform", "DER"])
    private_key = invoke(openssl, ["pkcs8", "-topk8", "-nocrypt", "-in", key, "-outform", "DER"])
    rsa_key = native / "rsa-key.pem"
    invoke(openssl, ["genrsa", "-out", rsa_key, "2048"])
    rsa_key.chmod(0o600)
    (native / "rsa-private.der").write_bytes(invoke(openssl, ["pkcs8", "-topk8", "-nocrypt", "-in", rsa_key, "-outform", "DER"]))
    public.write_bytes(invoke(openssl, ["x509", "-in", cert, "-pubkey", "-noout"]))
    spki = invoke(openssl, ["pkey", "-pubin", "-in", public, "-outform", "DER"])
    unsigned = (destination / "unsigned.zip").read_bytes()
    end_at = unsigned.rindex(b"PK\x05\x06")
    central_at = struct.unpack_from("<I", unsigned, end_at + 16)[0]
    sections = [unsigned[:central_at], unsigned[central_at:end_at], unsigned[end_at:]]
    digest = native_digest(openssl, sections)
    assert digest == digest_sections(sections)
    for content_size in [CHUNK - 1, CHUNK, CHUNK + 1, 2 * CHUNK + 7]:
        content = (bytes(range(251)) * ((content_size + 250) // 251))[:content_size]
        boundary_sections = [content, b"central", sections[2]]
        assert native_digest(openssl, boundary_sections) == digest_sections(boundary_sections)
    data = signed_data(digest, certificate)
    signature = invoke(openssl, ["dgst", "-sha256", "-sign", key], data)
    signature_path = native / "signature.der"
    signature_path.write_bytes(signature)
    verified = invoke(openssl, ["dgst", "-sha256", "-verify", public, "-signature", signature_path], data)
    assert verified.strip() == b"Verified OK"
    corrupt = data[:-1] + bytes([data[-1] ^ 1])
    invoke(openssl, ["dgst", "-sha256", "-verify", public, "-signature", signature_path], corrupt, expected_status=1)
    block = container(pair(V2_ID, payload(data, signature, spki)))
    end = sections[2]
    new_end = end[:16] + u32(central_at + len(block)) + end[20:]
    signed = sections[0] + block + sections[1] + new_end
    (destination / "native-signed.zip").write_bytes(signed)
    (destination / "native-framing.bin").write_bytes(
        b"".join(map(lp, [block, data, digest, certificate, signature, spki])))
    private_path = destination / "native-private-key.der"
    private_path.write_bytes(private_key)
    private_path.chmod(0o600)
    (destination / "native-certificate.der").write_bytes(certificate)
    version = invoke(openssl, ["version"]).decode().strip()
    (destination / "native-provenance.txt").write_text(
        f"Provider: {version}\nExecutable: {openssl}\n"
        f"Unsigned SHA256: {hashlib.sha256(unsigned).hexdigest()}\n"
        f"Signed SHA256: {hashlib.sha256(signed).hexdigest()}\n"
        "Independent EC P256/SHA256 signature and tamper rejection verified with CLI.\n"
        "Chunk digest agrees with hashlib across 1 MiB boundaries.\n"
        "No Jai implementation, Android SDK or device validation in this command.\n")
    print(f"independent native EC/SHA256 and tamper vectors passed ({version}); SDK/device untested")


def verify_generated(destination, prefix="jai"):
    openssl = shutil.which("openssl")
    spki = destination / f"{prefix}-spki.der"
    public = destination / f"{prefix}-public.pem"
    public.write_bytes(invoke(openssl, ["pkey", "-pubin", "-inform", "DER", "-in", spki, "-outform", "PEM"]))
    data = (destination / f"{prefix}-signed-data.bin").read_bytes()
    result = invoke(openssl, ["dgst", "-sha256", "-verify", public,
                              "-signature", destination / f"{prefix}-signature.der"], data)
    assert result.strip() == b"Verified OK"
    signed = (destination / f"{prefix}-signed.zip").read_bytes()
    end_at = signed.rindex(b"PK\x05\x06")
    central_at = struct.unpack_from("<I", signed, end_at + 16)[0]
    block_size = struct.unpack_from("<Q", signed, central_at - 24)[0] + 8
    content = signed[:central_at - block_size]
    central = signed[central_at:end_at]
    end = signed[end_at:]
    normalized = end[:16] + u32(len(content)) + end[20:]
    expected = (destination / f"{prefix}-digest.bin").read_bytes()
    assert native_digest(openssl, [content, central, normalized]) == expected
    assert digest_sections([content, central, normalized]) == expected
    print(f"actual {prefix} signer output passes independent native EC/SHA256 signature and chunk-digest checks")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("output", type=Path)
    build(parser.parse_args().output)


if __name__ == "__main__":
    main()
