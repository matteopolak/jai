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

Additional broad-suite test correction: faults/android-oid-count.jai previously
expected an assertion for count13. Whole-record equality never indexes by count,
so that guard is obsolete. Removed the old expected-fault entry and migrated its
safety intent into android-oid.jai: -1/13/s64 extrema compare identically only when
all count/arc bytes match, with every stored slot tested. No production change or
assertion disabling; the original broad failure remains in
target/android-sdk-asn1-active-full.log.

All three asn1_print overloads now traverse supported values using an explicit
heap-backed frame stack. SEQUENCE/SET descend normally; constructed context items
print their number and descend without indentation for that invocation. Primitive
context items preserve reviewed IMPLICT spelling and hex byte count. OID, NULL,
INTEGER (long content as hex), PRINTABLE/UTF8, UTC_TIME, zero-unused-bit BIT_STRING
and OCTET_STRING have real rendering. Unsupported/malformed forms diagnose;
NULL prints its required trailing space before checking content. The named-value
overload forwards only content, and name/data surrounds it with yellow banners.
Colors use the existing Print_Color API with its explicit portable ANSI backend.

Diagnostic conventions are independently chosen human text: lowercase spaced
hex, labeled lines and --- name --- banners. They are not claimed reference byte
serialization. UTC years use1950..2049 as documented for the official native C
[OpenSSL ASN1_UTCTIME](https://docs.openssl.org/master/man3/ASN1_TIME_set/); Calendar_Time
is filled directly and printed through the reviewed calendar_to_string. Exact
century/leap-second compatibility, empty-context newline, banner punctuation and
native Windows console color still await finer review. These choices are recorded
in specs questions; supported type traversal is implemented, not declaration-only.

Run python3 -B tools/check_portable_asn1_printer.py. Fifteen interpreter/native
ARM64+x64 O0/O2 runs cover all supported type families, all overloads,49/50 year
boundary, four-space/skip indentation,300 nested constructed frames and seven
diagnosed failures with fatal verification restored. Linux/Windows both CPUs and
strict scoped lint pass; target/asn1-printer-final.log. Source printf overhead is
deliberate for diagnostics: per-field/indent writes favor simple streaming and an
explicit traversal stack over a giant assembled output buffer. Allocation failure
follows Basic allocator policy; no extra fake success/fallback is introduced.
NEW foundation composition is read-only input copied into target/. Primitive,
Java and flag runners now use that same real dependency composition; all pass.

Remaining implementation: X.509 extraction and crypto/signing helpers; hex-array
helper representation still needs review. Value view/prefix questions are resolved.
Native Linux/Windows printer execution and native Windows console handling remain
unverified; ANSI emission is explicit supported fallback. No parser stubs, disabled
verification assertions, dangling payloads or blanket lint suppression introduced.
