# Portable time and calendar API inventory

The canonical Apollo_Time/Calendar_Time/Time_Zone declarations remain in Basic's
existing private implementation and are reexported as the same types. New work
adds no public helper types. Native conversions use the NEW POSIX types directly.

| Reviewed API | Current support |
| --- | --- |
| seconds/milliseconds/microseconds/nanoseconds_to_apollo | Existing exact signed-integer scaling |
| ConvertFromApollo; to_seconds/milliseconds/microseconds/nanoseconds | Existing bounded signed conversion, optional integer rounding |
| compare_apollo_times; to_float64_seconds | Existing signed ordering and floating conversion |
| to_apollo | NEW exact binary-significand scaling into two words; finite fractions truncate toward zero at femtosecond resolution. Supports durations exceeding s64 seconds. Nonfinite/overflow returns APOLLO_TIME_INVALID |
| timespec_to_apollo; to_timespec | NEW macOS/Linux/Android native ABI conversions; reviewed Unix epoch constant, normalized seconds/nanoseconds, negative timestamps use floor seconds; reverse conversion reports out-of-range/invalid failure |
| current_time_consensus; current_time_monotonic | Native POSIX realtime/monotonic queries execute on host; NEW Windows system-FILETIME/QPC code and fixture bodies type-check both CPUs. Counter arithmetic executes host interpreter/native. Realtime includes epoch, monotonic has arbitrary native origin; errors assert. Actual Windows calls/cache remain unverified |
| to_calendar; calendar_to_apollo | NEW reentrant native UTC/local conversions on macOS/Linux/Android, exact zero-based fields and millisecond resolution. Invalid calendar inputs return invalid sentinel; unrepresentable calendar output asserts |
| ConvertToApollo | Expansion caller-local requirements remain unspecified; not exported |
| calendar_to_string; calendar_to_iso_string | Exact text/zone/fraction formats unresolved; not exported |
| filetime_to_apollo; to_filetime | NEW exact Windows FILETIME wrappers, two-word integer scaling and bounded unsigned100ns conversion. Production arithmetic source executes interpreter/native O0/O2 on host; public canonical Windows ABI/body checks pass both CPUs, actual Windows execution unverified |
| seconds_since_init | Required initialization origin and interpreter/native startup integration unresolved; not exported. A first-query baseline would give misleading elapsed time and is not substituted |

The reviewed constants and existing duration conversions establish the working
femtosecond representation. Detailed floating rounding, invalid-date/leap-second,
DST ambiguity/gap and native clock-origin policies need oracle clarification.
Current explicit policy: no leap-second input; reject normalized invalid dates
or local DST-gap times by checking the native round trip. Ambiguous local times
use libc's tm_isdst=-1 selection. day_of_week input is derived, not used to resolve
a date. Native output floors discarded sub-millisecond precision. No UTC/local
offset field or new type is invented. Host timezone configuration remains libc
process-global state; no new synchronization guarantee is claimed.

Original tests cover exact integer/binary fractional/large duration conversion,
NaN/infinity/overflow, native nanosecond round trips including negative epochs,
one femtosecond before Unix epoch, epoch Thursday, leap day and non-leap-century
rejection, -1 as a valid native second, UTC/local millisecond round trips and real
clock comparison with native time(). Interpreter, native default and native O2
execute these assertions. Full focused suite passes 93 cases in both modes,
22 faults/eight rejections and existing integration/target checks.

The first missing-export compile failure is retained at target/time-conversion-red.log.
No reference compiler or old library supplied input. Foundation facade/load-list
overlaps must be merged by coordinator; that worker's checkout was not modified.
This remains staged NEW producer verification, not full corpus/platform release.

Android source branches are not validated: compiler CLI rejects -os android and lists only linux/windows/macos/wasm. No Android native or target-check claim is made.


FILETIME conversion uses native DWORD fields separately, preserving the canonical
NEW Windows type and four-byte alignment rather than aliasing an unaligned u64.
Private arithmetic uses the reviewed Apollo Unix epoch and Gregorian1601 UTC
offset11644473600 seconds, exactly100000000 femtoseconds per tick. All unsigned
ticks round-trip; timestamps before1601, reserved invalid and out-of-range values
return failure. Sub-tick precision is truncated; that fine rounding policy remains
independent pending review. Existing explicit widened field locals also avoid the
recorded generic compiler cast/bitwise narrowing issue; no symbol-specific fix.

Original unit tests load the exact private production arithmetic source and check
Unix epoch, native UTC1601 Monday, word boundaries/fullu64 range, invalid/pre-epoch/
overflow cases and sub-tick truncation. This verifies the real arithmetic rather
than a duplicate fixture implementation. Public Windows fixture bodies separately
check native FILETIME8-byte/four-byte alignment and canonical field round trips.
Both Windows CPUs type-check; these checks are not Windows runtime execution.

Official native C contract:
[FILETIME](https://learn.microsoft.com/en-us/windows/win32/api/minwinbase/ns-minwinbase-filetime).
No native timestamp pointer is reinterpreted as an aligned64-bit pointer.

Full focused suite now passes96 positive cases and23 checked faults in both modes,
eight compile rejections and prior integration/Linux+Windows checks. The production
arithmetic unit also executes native O2;297 owned Jai files pass source-built
jaifmt --check and jailint -D warnings. Red missing-source evidence remains at
target/filetime-kernel-red.log; no assertion was disabled.


Windows clock exports use GetSystemTimeAsFileTime for realtime and typed
QueryPerformanceCounter/QueryPerformanceFrequency overloads for monotonic time.
Frequency is cached with existing64-bit compare-and-swap; concurrent initializers
publish one positive native value. This caches a boot-fixed conversion factor,
not an elapsed-time origin. Failed query/nonpositive frequency/negative counter
diagnose. Private counter arithmetic exactly scales integer ticks to femtoseconds
before division, truncating sub-femtosecond fractions. No float intermediate,
invented intrinsic or source-name compiler special case is used.

Production-source arithmetic tests cover full positive signed64 counter range,
integer and fractional frequencies, tiny fractions, invalid arguments and2048
monotonic steps. Native O2 additionally executes these checks. Public Windows
clock fixture compares realtime with an independent native FILETIME query and
checks monotonic values; both CPU bodies type-check but have not executed here.
The actual Windows cache race/native accuracy remain platform gates.
General unsigned128 division costs128 bit steps; the native realtime API retains
system clock resolution rather than claiming precise-clock accuracy.

Official native C contracts:
[QueryPerformanceCounter](https://learn.microsoft.com/en-us/windows/win32/api/profileapi/nf-profileapi-queryperformancecounter),
[QueryPerformanceFrequency](https://learn.microsoft.com/en-us/windows/win32/api/profileapi/nf-profileapi-queryperformancefrequency),
[GetSystemTimeAsFileTime](https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-getsystemtimeasfiletime).

Full suite now passes97 cases and23 checked faults in both modes, eight negative
compile cases and prior SMTP/IPC/parent/startup/Linux+Windows checks;300 owned Jai
files pass formatter/check/strict lint. These are host/staged producer results,
not Windows runtime or full distribution integration.
