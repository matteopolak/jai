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
| to_calendar; calendar_to_apollo | Reentrant native UTC/local conversions on macOS/Linux/Android execute. NEW Windows SYSTEMTIME/FILETIME and dynamic-zone conversions type-check both CPUs, including configured Basic; native Windows execution remains unverified. Exact zero-based fields/milliseconds; POSIX delegates normalization and -1 sentinel collision to libc. Output failures log and return zero; Windows invalid input reports through assertion handling |
| ConvertToApollo | Exact no-result #expand header; caller-scoped return of full signed128 scaled value, with ordinary caller defer cleanup and single argument evaluation |
| calendar_to_string; calendar_to_iso_string | Reviewed English/ISO layouts, month clamping, UTC Z/local no suffix, minimum digit widths and real temporary storage implemented; all twelve English months and configured Basic tested |
| filetime_to_apollo; to_filetime | NEW exact Windows FILETIME wrappers, two-word integer scaling and bounded unsigned100ns conversion. Production arithmetic source executes interpreter/native O0/O2 on host; public canonical Windows ABI/body checks pass both CPUs, actual Windows execution unverified |
| seconds_since_init | Reviewed lazy FIRST CALL origin implemented; exact first-call capture, shared alias storage and private CAS publication. Actual host interpreter/native and eight-thread race tests pass; Windows body checks retain native-execution gate |

The refreshed reviewed policy supersedes the earlier strict invalid-date and
sentinel handling. POSIX tm_isdst=-1 and timegm/mktime choose normalization and
local DST behavior; no round-trip rejection is imposed. A seconds result of -1
returns zero Apollo_Time, including the valid Unix-epoch predecessor collision.
Millisecond components add exact duration units after native conversion.
day_of_week input is ignored. Output failures log ERROR and return a fully zero
Calendar_Time. Native output floors sub-millisecond precision. No local offset or
new type is invented; host timezone configuration remains native process state.

Windows invalid input/native conversion failures invoke assertion handling;
continuing handlers receive APOLLO_TIME_INVALID, never a fabricated timestamp.
Removed the stricter local DST round-trip rejection: native Windows rules remain
authoritative. Actual native Windows execution stays pending; both CPU bodies and
configured Basic source checks pass.

calendar-native.jai compares normalization cases to actual native C calls for UTC
and LOCAL, including overflow/negative components and milliseconds, ignored
weekday and -1 sentinel collision. calendar-text.jai checks all twelve English
months, exact ISO milliseconds/suffix, month clamps and independent result lifetime
until the temporary mark. Private bounded decimal assembly avoids introducing
generic formatting exports or modifying the foundations worker's implementation.
All field widths fit its128-byte scratch buffer; output is copied to real temporary
storage. Native O0/O2 execute with NEW foundations composition; strict active
implementation/tests pass. No fabricated backend or library oracle is used.

Tests corrected separately from production fixes: earlier2100 invalid-day
rejection and -1 round-trip assertions were this producer's obsolete policy
assumptions. They now assert native normalization and the reviewed sentinel
collision. Configured output-failure test now asserts ERROR logging/zero fields,
rather than assertion callback/negative fields. Windows invalid input fixture now
asserts actual callback invocation before accepting the continuing-handler
sentinel. All useful failure assertions remain. A newly written month text test
incorrectly assumed minimum23 characters (May is shorter); exact twelve-month
expected strings replace that faulty oracle. Failure evidence is retained at
target/calendar-text-green2.log and target/calendar-foundation-verified.log.

ConvertToApollo now follows the refreshed caller-return contract exactly:
(m:s64, FACTOR:s64) #expand has no result annotation; its backtick return exits
the containing Apollo_Time procedure. An independent signed64-by-signed64
product uses the existing unsigned full-width multiplication mechanism, with
sign corrections in the high word. Both sign combinations and extrema fit the
signed128 result domain; no narrowing s64 intermediate is used. Ordinary unit
converters are preserved. Private sign correction alone uses #no_aoc for required
two-word modular operations; no new public helper is exported.

apollo-caller-return.jai exercises the exact typed containing procedure, caller
defer execution, single evaluation, negative units, zero and both signed extrema.
It passes interpreter/host ARM64/translated x64 native O0/O2 against this worker
and the NEW foundations composition. Focused strict lint passes; the existing six
foundation/time/calendar fixtures pass interpreter/native O0/O2, with Windows
CPU source checks and formatting-stable composition. Evidence: target/apollo-
caller-return-green.log, target/apollo-caller-return-foundation.log,
target/apollo-caller-return-strict.log and target/apollo-time-regression.log.

The prior ordinary no-result macro value-expression probe did not model this
public API. It remains as original evidence in pending/expand-return-inference.jai
with a superseded-oracle comment; it is not a required stdlib compatibility
expectation or an established compiler defect. No arrow/header change is needed.

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


The refreshed Basic review explicitly establishes FIRST CALL as the
seconds_since_init origin; earlier missing-origin statements are superseded.
Implementation captures one monotonic sample on the winning first call and
returns0 at that instant. Later calls subtract the two-word timestamps before
float conversion. Shared private CAS states publish both origin words safely
before concurrent readers; this strengthens the reviewed single-thread-first-use
requirement without moving the origin to startup or adding an initialization API.

Tests sleep before the first call, verify its zero elapsed time, sleep afterward
and check real positive/monotonic results through another Basic import. Eight
threads synchronize before first use and each makes512 subsequent calls, checking
a shared origin and monotonic results. A separate actual-macOS fixture calls the
API at compile time then verifies target execution initializes a fresh origin;
it is not an unreviewed #no_reset workaround or target-dependent compile-time ABI
call. This pairing is explicitly macOS-only, while the ordinary elapsed fixture
also type-checks Windows x64/ARM64 and Linux. Windows elapsed execution remains
unverified on this host. The API/source first-call baseline is a confirmed
contract, not a workaround.

Elapsed final evidence: ordinary, eight-thread and compile-time-reset fixtures all pass interpreter/native O0/O2; full98-case/23-fault both-mode suite and prior rejection/integration/target checks pass. All305 owned files pass source-built formatting/check/strict lint. Windows ARM64 body checking also passes.


## Parameterized Basic integration regressions

The NEW foundations producer supplies its reviewed integer guards; this worker
does not duplicate that implementation. A focused composition copies only NEW
producer dependencies and portable-owned time files into target/, then adds the
reviewed time facade/load-list entries. It never changes another checkout.
tools/check_portable_time_foundation.py normalizes and regenerates those entries
twice, checks byte stability and exercises default/nondefault Basic in interpreter
and native O0/O2, with both Windows CPU body checks.

That test exposed a real nominal-type error: private Windows kernels returned
the default Basic instance's Apollo_Time into a nondefault instance. The compiler
correctly rejected expected Apollo_Time/found Apollo_Time. Private arithmetic now
exchanges primitive low/high words, and each wrapper constructs its own canonical
type. This preserves signatures/reflected names without casts across instances.

A stronger real-clock check exposed Native calls inside optional assert arguments.
ENABLE_ASSERT=false discards those arguments in the NEW producer, so queries did
not execute. Native clock calls now execute before independent status handling.
Operational failures invoke context.assertion_failed with recursion protection
even when optional assertions are disabled. If a handler continues, clocks return
APOLLO_TIME_INVALID, calendar output uses invalid negative date/time fields and
elapsed time returns quiet NaN. Failed first-origin initialization stays failed;
it does not silently choose a later origin. Callback continuation/error-marker
details remain independent policies needing review, distinct from the settled
first-call baseline. No native result is mocked.

Configured tests compare actual wall clocks and delay before checking positive
elapsed time. A genuine invalid timestamp tests the disabled-assert calendar error
path with a real caller-selected assertion callback. Production error-helper
tests check callback delivery, recursion suppression, state restoration and NaN.
These do not claim Windows native error injection or replace platform execution.

Initial composition substring matching confused to_apollo with seconds_to_apollo;
anchored declaration matching fixes that tool bug. An initial retry copied stale
private kernels; composition now explicitly includes current owned internal/time.
Failure logs remain target/time-foundation-integration*.log,
target/time-foundation-words.log and
target/time-configured-assert-off-failure.log. No assertion was removed.

Current rerun: target/time-checkpoint-foundation.log verifies regeneration,
interpreter/native O0/O2 and both Windows CPU bodies. Configured facade/private
root/fixture strict lint exits0 (target/time-checkpoint-foundation-lint.log).
The full99-case/23-fault runner exits0; whole owned strict lint still fails for
the separately inventoried reasons in portable-verification.md. Earlier lint
counts above are historical runs with the earlier tool, not current gate status.

## Windows calendar implementation

The exact two public signatures now also exist on Windows. UTC uses native
FileTimeToSystemTime/SystemTimeToFileTime with the existing FILETIME arithmetic.
Local conversion uses the dynamic-daylight-saving Ex pair, passing null for the
current active timezone. This avoids selecting the older API's documented
cross-year limitation. Native date range1601..30827 is explicit; month/day fields
are adjusted to the reviewed zero-based representation. Milliseconds are retained
and finer precision is truncated by native SYSTEMTIME output.

Public local wall times validate Gregorian fields; native zone conversion selects
DST behavior without additional round-trip rejection. Invalid native conversions
report through assertion handling. Tests compare
local calendar fields after round trip, not arbitrary timestamp identity inside
a repeated hour. UTC timestamps compare exactly at millisecond resolution.
The date validator exchanges only primitive integers, preserving parameterized
Basic type identity. Its exact production source executes host interpreter/native
tests, checking leap-century boundaries and146097 days over400 years.

Private Ex function completions use SYSTEMTIME from the NEW Windows producer.
Their dynamic-zone argument is an opaque pointer and is **always null**; there
is no guessed aggregate layout, allocation or dereference. The ABI is the official
timezoneapi.h three-pointer/BOOL signature. These APIs require Windows7 clients/
Server2012 according to native documentation; older target support is unfinished.
Native Windows default/nondefault UTC/local, leap-day, invalid-date and clock
round trips have fixtures, but have not executed on this host. Both CPU fixture
bodies check; no substituted Kernel32 or fake native result is used.

Official native C documentation (ABI/platform facts, not Jai API oracle):
[SYSTEMTIME](https://learn.microsoft.com/en-us/windows/win32/api/minwinbase/ns-minwinbase-systemtime),
[SystemTimeToFileTime](https://learn.microsoft.com/en-us/windows/win32/api/timezoneapi/nf-timezoneapi-systemtimetofiletime),
[FileTimeToSystemTime](https://learn.microsoft.com/en-us/windows/win32/api/timezoneapi/nf-timezoneapi-filetimetosystemtime),
[UTC to dynamic local time](https://learn.microsoft.com/en-us/windows/win32/api/timezoneapi/nf-timezoneapi-systemtimetotzspecificlocaltimeex),
[dynamic local time to UTC](https://learn.microsoft.com/en-us/windows/win32/api/timezoneapi/nf-timezoneapi-tzspecificlocaltimetosystemtimeex).

Focused reproduction: tools/check_portable_windows_calendar.py checks CPU bodies;
--native requires a real Windows host and runs interpreter/native O0/O2. NEW
foundation composition includes current calendar/kernel sources and checks
configured Windows exports. Host strict lint passes its requested roots, but
Windows-only bodies are inactive: jailint currently has no target selector.
Active Windows strict lint and actual Windows runtime remain required gates.
No synthetic OS constants or dropped assertions replace those gates.
