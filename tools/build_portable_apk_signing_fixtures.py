#!/usr/bin/env python3
"""Independent APK v2 framing/digest vectors; no SDK or crypto validation claim."""
import argparse
import hashlib
import io
from pathlib import Path
import struct
import zipfile

MAGIC = b"APK Sig Block 42"
V2_ID = 0x7109871A
ECDSA_SHA256 = 0x0201
CHUNK = 1 << 20


def u32(value):
    return struct.pack("<I", value)


def lp(value):
    return u32(len(value)) + value


def pair(identifier, value):
    return struct.pack("<QI", len(value) + 4, identifier) + value


def container(pairs):
    size = struct.pack("<Q", len(pairs) + 24)
    return size + pairs + size + MAGIC


def signed_data(digest, certificate):
    return lp(lp(u32(ECDSA_SHA256) + lp(digest))) + lp(lp(certificate)) + lp(b"")


def payload(data, signature, spki):
    signer = lp(data) + lp(lp(u32(ECDSA_SHA256) + lp(signature))) + lp(spki)
    return lp(lp(signer))


def digest_sections(sections):
    chunks = [section[start:start + CHUNK]
              for section in sections for start in range(0, len(section), CHUNK)]
    leaves = [hashlib.sha256(b"\xa5" + u32(len(chunk)) + chunk).digest()
              for chunk in chunks]
    return hashlib.sha256(b"\x5a" + u32(len(leaves)) + b"".join(leaves)).digest()


def digest_stream(sections):
    """Separate incremental formulation to check fixture assembly."""
    count = sum((len(section) + CHUNK - 1) // CHUNK for section in sections)
    root = hashlib.sha256(b"\x5a" + u32(count))
    for section in sections:
        for start in range(0, len(section), CHUNK):
            chunk = memoryview(section)[start:start + CHUNK]
            leaf = hashlib.sha256(b"\xa5")
            leaf.update(u32(len(chunk)))
            leaf.update(chunk)
            root.update(leaf.digest())
    return root.digest()


def end_record(offset, comment):
    return struct.pack("<IHHHHIIH", 0x06054B50, 0, 0, 1, 1, 46, offset, len(comment)) + comment


def build(destination):
    destination.mkdir(parents=True, exist_ok=True)
    digest = bytes(range(32))
    certificate = b"framing certificate only\x00\xff"
    signature = b"framing signature only\x00\x80"
    spki = b"framing public key only\x00\xfe"
    data = signed_data(digest, certificate)
    value = payload(data, signature, spki)
    block = container(pair(V2_ID, value))
    archive = io.BytesIO()
    with zipfile.ZipFile(archive, "w", compression=zipfile.ZIP_STORED) as writer:
        entry = zipfile.ZipInfo("payload.bin", date_time=(2020, 1, 1, 0, 0, 0))
        writer.writestr(entry, b"independent ZIP content\x00\xff")
        writer.comment = b"APK framing fixture\x00\xff"
    unsigned = archive.getvalue()
    end_at = unsigned.rindex(b"PK\x05\x06")
    central_at = struct.unpack_from("<I", unsigned, end_at + 16)[0]
    content = unsigned[:central_at]
    central = unsigned[central_at:end_at]
    end = unsigned[end_at:]
    signed_end = end[:16] + u32(central_at + len(block)) + end[20:]
    signed = content + block + central + signed_end
    with zipfile.ZipFile(io.BytesIO(signed)) as reader:
        assert reader.read("payload.bin") == b"independent ZIP content\x00\xff"
    (destination / "unsigned.zip").write_bytes(unsigned)
    (destination / "framed.zip").write_bytes(signed)
    (destination / "zip-digest.bin").write_bytes(digest_sections([content, central, end]))
    (destination / "framing.bin").write_bytes(
        b"".join(map(lp, [block, data, digest, certificate, signature, spki])))
    good_containers = [block, container(pair(0xDEADBEEF, b"ignored") + pair(V2_ID, value)),
                       container(pair(V2_ID, value) + pair(0xDEADBEEF, b"ignored"))]
    bad_containers = [block[:end] for end in range(len(block))]
    bad_containers += [block + b"trailing", block[:-1] + b"!",
                       struct.pack("<Q", 0xFFFFFFFFFFFFFFFF) + block[8:],
                       container(b"\x00"), container(struct.pack("<Q", 3) + b"123"),
                       container(pair(V2_ID, value) + pair(V2_ID, value))]
    bad_values = [value[:end] for end in range(len(value))]
    bad_values += [value + b"trailing", lp(b""), lp(lp(b"")),
                   lp(value[4:] + value[4:]),
                   payload(data + b"trailing", signature, spki),
                   payload(lp(b"") + lp(lp(certificate)) + lp(b""), signature, spki),
                   payload(lp(lp(u32(ECDSA_SHA256) + lp(digest))) + lp(b"") + lp(b""), signature, spki),
                   payload(data[:-4] + lp(lp(u32(1))), signature, spki),
                   payload(data, b"", spki), payload(data, signature, b""),
                   payload(signed_data(digest[:31], certificate), signature, spki),
                   payload(signed_data(digest, b""), signature, spki)]
    (destination / "reader-cases.bin").write_bytes(
        u32(len(good_containers)) + b"".join(map(lp, good_containers)) +
        u32(len(bad_containers)) + b"".join(map(lp, bad_containers)) +
        u32(len(bad_values)) + b"".join(map(lp, bad_values)))
    verification_good = [
        container(pair(0x42726577, bytes(32)) + pair(V2_ID, value)),
        container(pair(0x1B93AD61, b"unknown v3.1") + pair(V2_ID, value)),
        container(pair(0xDEADBEEF, b"unknown") + pair(V2_ID, value)),
    ]
    verification_bad = [
        container(pair(0xF05368C0, b"unsupported v3") + pair(V2_ID, value)),
        container(pair(0x42726577, b"\x00\x01\x00") + pair(V2_ID, value)),
        block[:8] + block[8:-24] + struct.pack("<Q", 24) + MAGIC,
    ]
    digest_record = lp(u32(ECDSA_SHA256) + lp(digest))
    many_digests = lp(digest_record * 2) + lp(lp(certificate)) + lp(b"")
    many_certificates = lp(digest_record) + lp(lp(certificate) * 2) + lp(b"")
    signature_record = lp(u32(ECDSA_SHA256) + lp(signature))
    many_signatures = lp(lp(lp(data) + lp(signature_record * 2) + lp(spki)))
    verification_bad += [
        container(pair(V2_ID, payload(many_digests, signature, spki))),
        container(pair(V2_ID, payload(many_certificates, signature, spki))),
        container(pair(V2_ID, many_signatures)),
    ]
    (destination / "verification-structure.bin").write_bytes(
        u32(len(verification_good)) + b"".join(map(lp, verification_good)) +
        u32(len(verification_bad)) + b"".join(map(lp, verification_bad)))

    rows = []
    for length in [0, 1, CHUNK - 1, CHUNK, CHUNK + 1, 2 * CHUNK + 7]:
        content = (bytes(range(251)) * ((length + 250) // 251))[:length]
        central = b"independent central bytes\x00\xff"
        end = end_record(length + 4096, b"EOCD comment\x00\xff")
        normalized = end[:16] + u32(length) + end[20:]
        expected = digest_sections([content, central, normalized])
        assert expected == digest_stream([content, central, normalized])
        if content:
            assert expected != digest_sections([content + central + normalized])
        rows.append(lp(content) + lp(central) + lp(end) + expected)
    (destination / "digests.bin").write_bytes(u32(len(rows)) + b"".join(rows))
    print(f"wrote independent framing and {len(rows)} section/chunk digest vectors to {destination}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("output", type=Path)
    build(parser.parse_args().output)


if __name__ == "__main__":
    main()
