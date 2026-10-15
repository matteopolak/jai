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
| current_time_consensus; current_time_monotonic | NEW native realtime/monotonic queries on macOS/Linux/Android. Realtime includes Unix epoch offset; monotonic has native arbitrary origin. Query errors assert explicitly |
| to_calendar; calendar_to_apollo | NEW reentrant native UTC/local conversions on macOS/Linux/Android, exact zero-based fields and millisecond resolution. Invalid calendar inputs return invalid sentinel; unrepresentable calendar output asserts |
| ConvertToApollo | Expansion caller-local requirements remain unspecified; not exported |
| calendar_to_string; calendar_to_iso_string | Exact text/zone/fraction formats unresolved; not exported |
| filetime_to_apollo; to_filetime | Windows platform integration unfinished; not exported |
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
