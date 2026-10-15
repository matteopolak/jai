# ASN.1 primitive parsing contract and design

API oracle: reviewed Android/Toolchain page. Implement independently grouped
tag/length/integer/OID primitives and canonical enum/tag types under
internal/android-toolchain. Byte readers use checked cursor transactions; no
unchecked caller-buffer reads or native crypto dependency.

Supported wire domain: definite-length ASN.1 tag/length encoding, signed64-bit
INTEGER results, and the public twelve-u64-arc OID representation. High tags
must fit the public u8 number. OID base128 decoding handles the first combined
identifier with carry, including second arcs near UINT64_MAX. No silent wrapping,
truncated arc count, indefinite-length sentinel or fabricated parse success.

Unresolved reviewed contracts: ASN1_Value.content versus value_data meaning;
expected-tag mismatch/invalid-input cursor policy; ASN.1 printer exact text and
depth/hack_skip_depth behavior; read_length_prefixed_block prefix width/endian;
hex-array formatting/storage. Do not invent these to count the value reader,
printer, block-prefix or signing helpers completed. Primitive invalid-input
diagnostics with unchanged cursor are independent safety behavior, not an
established reference recovery guarantee. OID dotted strings are context-owned.

Implemented13 reviewed declarations: three enums, the canonical union-backed
tag record, exact canonical ASN1_KNOWN_OIDS type alias, tag/length/signed-integer/
OID readers and dotted rendering, checked binary block reader and generic integer
reader with its exact read alias. No guessed known-OID table is introduced: the
reviewed declaration is a type alias and preserves ASN1_Object_Identifier metadata.
Generic binary integer reading supports built-in1/2/4/8-byte signed/unsigned types
and both wire byte orders on the compiler's supported little-endian targets.
Other reflected kinds diagnose at compile time; finer accepted-type scope remains
a review question. ASN.1 long lengths above eight octets, indefinite lengths,
tags above255, integers outside s64 and excess/overflowing OID arcs diagnose.
No unsupported value is silently truncated into a valid result.

`python3 -B tools/check_portable_asn1.py` generates517 INTEGER and183 OID vectors
with independent Python integer/base128 encoding, including signed extrema,
all OID counts2..12, UINT64_MAX arcs and first-combined values above64 bits.
It verifies numeric decoding and exact dotted strings against those oracles.
Separate shape/overlay/alias/cursor tests cover all ordinary tag octets, full-u64
length and all eight built-in integer widths/sign kinds in both byte orders.
Seven malformed-input checks require diagnostics and unchanged input cursor;
fatal assertion handlers are restored before checking the results.

All three programs pass interpreter/host ARM64/translated x64 native O0/O2.
Public primitive bodies check Linux/Windows x64/ARM64; scoped strict lint and
formatting/check pass. Evidence: target/asn1-primitives-red.log,
asn1-primitives-first.log, asn1-primitives-vectors.log and asn1-primitives-final.log.
No native crypto library, key material, device/auth access or reference body is
used. Value-reader, printing, X.509 extraction and signing remain unimplemented
where their reviewed public contracts do not yet establish required behavior.
