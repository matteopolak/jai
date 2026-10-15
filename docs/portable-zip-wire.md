# Android archive wire utilities

Reviewed Android/Toolchain APIs implemented under internal/archive/android-zip-wire:
canonical three-u8 Zip_Version, encode/decode, four exact signature/EOCD constants,
CRC32, mutable EOCD central-directory offset get/set and the two int unit macros.
The original12 wire declarations and11 newly completed record/writer entries are
credited. APK loading/iteration remains next; signing/build APIs remain missing.

Version words split high-byte mapping from low-byte major*10+minor. Every u16
pattern round-trips; no platform mapping values are invented. Unsupported input
digits/byte overflow diagnose. Constants use reviewed signature member values,
22-byte EOCD size and field offset16. Offset helpers read/write four little-endian
bytes directly, including unaligned caller buffers. Setter changes the original
shared backing; it does not replace a snapshot string. Input must be a complete
EOCD with correct signature, and setters require writable storage. Bounds/signature
rejection logs/asserts and never mutates the rejected record; finer invalid-input
reference policy remains unestablished, so no recovery equivalence is claimed.

zip_crc32 is the portable reflected ZIP CRC32 polynomial0xedb88320, allones init
and final inversion. It has no native-library dependency and remains separate from
the Crc module's reviewed CRC64/WE. Bitwise streaming is deliberately tableless;
lower speed than lookup/hardware CRC is an explicit performance tradeoff. Future
optimization must retain native-zlib vectors and exact output. Negative/null
unreadable storage diagnoses outside the supported input domain. Units are exact
#expand int multiplications1024/1048576, with single argument evaluation and normal
language overflow behavior; no public signature/default or extra export added.

python3 -B tools/check_portable_zip_wire.py verifies65536 words,264 native-zlib
checksum vectors (empty/NUL/all bytes/random/block edges through65537), backing
mutation/neighbor retention, private visibility, unit macro side effects and five
diagnosed unsupported cases. Three programs pass interpreter/ARM64+x64 native
O0/O2 (15 runs); pure main/failure bodies source-check Linux/Windows both CPUs.
Strict scoped lint and owned formatting pass. Vector File I/O is host-only.
Evidence: target/android-zip-wire-red.log, android-zip-wire-final.log and
android-zip-wire-staged.log. Initial test arithmetic correction: minor digits come
from the low byte, not the whole word including mapping; corrected before running
the implementation. No inherited compatibility test was weakened.

One shared tools/portable_android_stage.py now stages the exact owned facade,
private Android/crypto/archive paths and real NEW foundation dependency composition.
All seven Android-focused runners use it. This removes repeated partial copy lists
that could miss cross-subsystem #load files or retain stale codecs. Only target/
is written; peers remain read-only, no fake API shim or compiler path exception.
ADB's actual assertion-configuration/native protocol regression passes after the
change (target/android-stage-adb-regression.log).

The refreshed review resolves prior record questions: #align1 fields and
#no_padding establish exact30/46/22 layouts; default version is typed u16 0x14.
The old32/24 probe omitted those directives, so its result was a transcription
gap, not evidence of a compiler layout bug. The probe/report remain historical.

Writer lifecycle, temporary File_Info/padding storage, borrowed names, default
CRCs/dummy CRC, optional initialization, local4096-alignment padding, file reads
and actual directory/end emission are now implemented. Callers keep temporary
storage and filenames alive until emission and add all entries before finalizing
once; no invented reset/finalized registry/API. Oversized ZIP32 input/offsets and
invalid alignment/capacity diagnose before appending. Unsupported compression
logs and returns false. Deflate uses valid raw stored blocks with LEN/NLEN and a
real final marker, including empty and multi-block input. This trades compression
ratio for a portable independently written encoder; output may exceed input size.
It does not claim a native-library ratio/performance match. A future LZ/Huffman
encoder can improve size while preserving the wire/behavior tests.

`python3 -B tools/check_portable_zip_writer.py` passes six interpreter/native Mac
O0/O2 runs, independent zipfile/zlib decompression and CRC validation, boundaries
65534/65535/65536/131071, stored/empty/file/memory cases, implicit initialization,
payload alignment/local-only padding, dummy CRC fields and eight failure cases.
Strict scoped lint and repository formatting/--check pass. Evidence:
target/zip-writer-workflow.log. An initial genuine encoder offset bug added5 to
u16 length before widening; boundary decompression caught it, and native-width
offset arithmetic fixes it. A separate diagnostic listing originally printed
an unverified label; it was not a validation gate or counted pass. Actual full
archive reads are the gate. New test corrections: use #file for the source filename
and explicit argv output directory, not #filepath/source-cwd assumptions; restore
the assertion hook before verifying captured negative results. Native Linux/
Windows/Android and actual APK signing remain pending.
