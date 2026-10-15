# ASN.1 primitive, value and binary parsing

Oracle: refreshed reviewed Android/Toolchain ASN.1/binary-helper behavior section.
Canonical declarations and private wire algorithms are independently grouped
under internal/android-toolchain. No native crypto or reference code is used.

Supported tags are one-octet universal declared types or context-specific0..30;
identifier0, high-tag, application/private classes and undeclared universal types
diagnose safely. Definite lengths support up to8 length octets, including
nonminimal encodings; indefinite/reserved/overwidth/truncated lengths diagnose.
INTEGER content is1..8 bytes with a clear sign bit; nonnegative s64 values and
redundant leading zeros are supported. Other forms diagnose rather than overread.
OID base128 supports12 u64 arcs, including first combined subidentifiers beyond
u64 when the resulting second arc fits. Dotted strings are caller-released and
include the reviewed trailing period. Equality compares all104 record bytes,
including inactive arcs. ASN1_KNOWN_OIDS is the immutable one-element known array.

ASN1_Value embeds/promotes its canonical tag. content borrows value bytes;
value_data borrows the complete TLV, both from caller storage. The reader advances
past a complete value. Its expected overload compares class and number/type but
deliberately ignores primitive/constructed form; mismatch diagnoses after full
consumption and returns the parsed value if assertions continue. Malformed reads
are checked and return empty records after diagnostics; no rollback contract is
claimed. Private success-bearing parsers prevent a continuing assertion from
turning a failed tag/length into a successful value parse.

read/read_silly_alias share one generic procedure for built-in1/2/4/8-byte integer
types; native-order or swapped input on supported little-endian targets.
read_block returns a checked borrowed view. read_length_prefixed_block reads an
explicit little-endian u32 prefix and borrowed payload; incomplete prefix/payload
diagnoses without committing its local cursor. No length truncation/allocation.

Run python3 -B tools/check_portable_asn1.py. Independent Python encoders provide
517 reviewed nonnegative INTEGER and183 OID vectors. Five programs cover primitive
shapes/overlay, all supported tag octets, all integer reader widths/signs/orders,
full-u64 length, record views/mutation/nesting, consumed expected-tag mismatch,
prefix widths/borrowed payload, all inactive OID slots and malformed safety.
Interpreter and host ARM64/translated x64 native O0/O2 pass. Four pure programs
check Linux/Windows x64/ARM64; vector File I/O remains host-only. Strict scoped
lint and owned formatting check pass. Evidence: target/asn1-reviewed-records-first.log
and target/asn1-reviewed-records-final.log. Native Linux/Windows execution is pending.

Production corrections after contract synchronization: known-OID type alias ->
one-element array; active-arc equality -> full-record equality; omitted trailing
period -> required period. Newly specified value/prefix APIs now have real bodies.
Signed/high-tag support was an earlier independent extension, not reference
proof; it now diagnoses outside the reviewed supported domain.

Test corrections are separate: older NEW provisional tests expected an alias,
counted-only equality and unpunctuated dotted text; those oracles contradicted the
refreshed behavior. They now assert exact known-array/whole-record/text contracts.
Negative INTEGER/high-tag success cases became explicit diagnosed unsupported
cases, preserving safety coverage. Generic signed binary reads remain supported
and tested. Historical primitive logs retain original evidence; those prior pass
totals are not current reference-equivalence proof.

Remaining implementation: three asn1_print overloads (behavior now reviewed),
X.509 extraction and crypto/signing helpers. Diagnostic UTC/calendar/banner finer
formatting and hex-array helper representation still need precise review; value
view/prefix questions are resolved and no longer blockers. No fake parser success,
disabled verification assertions, dangling returned payloads or blanket lint
suppression was introduced.
