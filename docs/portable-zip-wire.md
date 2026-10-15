# Android archive wire utilities

Reviewed Android/Toolchain APIs implemented under internal/archive/android-zip-wire:
canonical three-u8 Zip_Version, encode/decode, four exact signature/EOCD constants,
CRC32, mutable EOCD central-directory offset get/set and the two int unit macros.
Only these12 declarations are credited; APK loading/iteration/writer/header
records and omitted ZIP_VERSION_DEFAULT remain genuine missing public surface.

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

Writer/record review request: own reviewed-field layout probe reports local32 and
end24, whereas wire records are30/22. No compiler bug or packing change is assumed.
Exact public layout versus wire size, default version, compression support,
max_alignment/padding ownership/finalization, APK entry offset and deinit/iteration
semantics are recorded in specs questions. Probe:
tests/portable-stdlib/pending/zip-header-layout.jai; evidence:
target/zip-header-layout-question.log. Do not publish guessed packed record types
or declaration-only writer stubs to clear the inventory. Native Linux/Windows/
Android runtime and actual APK writer/signing integration remain pending.
