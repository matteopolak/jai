# Windows time-zone ABI repair

Normal CI 449 reported 18 ABI mismatches: `TIME_ZONE_INFORMATION` was empty,
with size 0/alignment 1 and seven absent SDK fields. The public declaration now
contains those actual fields, in SDK order, using ordinary record layout.
There is no opaque size, padding array, alignment override or ABI-check exception.

The [official SDK record](https://learn.microsoft.com/en-us/windows/win32/api/timezoneapi/ns-timezoneapi-time_zone_information)
uses signed 32-bit `LONG`, two arrays of 32 unsigned 16-bit `WCHAR`, and canonical
`SYSTEMTIME` dates. This facade already spells those scalar types `s32` and `u16`;
it has no established public `LONG`/`WCHAR` names. That absence was declared in the
shared inbox before production editing; the patch introduces no aliases.
Existing [SYSTEMTIME](https://learn.microsoft.com/en-us/windows/win32/api/minwinbase/ns-minwinbase-systemtime)
has the eight correct `u16` fields and is unchanged. Dependency size/alignment
and every member offset are checked directly alongside the repaired record.

| Member | Jai type | Offset |
| --- | --- | --- |
| Bias | s32 | 0 |
| StandardName | [32]u16 | 4 |
| StandardDate | Windows.SYSTEMTIME | 68 |
| StandardBias | s32 | 84 |
| DaylightName | [32]u16 | 88 |
| DaylightDate | Windows.SYSTEMTIME | 152 |
| DaylightBias | s32 | 168 |

The resulting record is 172 bytes, aligned to 4. These numbers are test
expectations derived from SDK members, not production size substitutions.
Mac source checks cover both Windows x64/arm64 layout, member types, signed
negative bias assignments, unsigned name elements, and warnings-denied lint.
The independent regression failed on the original size assertion before editing.

`tools/check_windows_time_zone.py` uses assigned `CARGO_TARGET_DIR`, freshly
source-builds CLI/lint, checks actual source-built jaifmt, and captures all inputs,
tool hashes and source drift. It never uses a staged stdlib overlay. On a real
Windows CI host with its configured MSVC/SDK environment, the coordinator should
add `--sdk-runtime`. That builds the independent C test against `<windows.h>`
with `/W4 /WX`, then compares 39 actual C metrics to Jai interpreter and native
O0/O2 output: sizes, alignments, all member offsets/sizes, signed bias values,
and both name-array counts. C macros compute SDK values directly; neither side
copies the other's serialized result. Each executable and object stays in its
unique worker target directory. The runner refuses SDK runtime mode on Mac.

Actual Windows SDK compilation/execution remains pending normal CI dispatch.
Mac cross-source success is not Windows native acceptance. No extra native
helper/library dependency, system time-zone mutation, reference access or native
Mac program is involved. File_Watcher source manifest and its audit are unchanged.
Integration alone stages/commits; please index this document in global docs.

Integration: actual Windows CI receives explicit compiler/linter/formatter paths from the matching MSVC target job. The runner retains fresh builds by default; provided tools are hashed and not counted as a runner build. Each existing Windows native job runs the real SDK metric comparison independently of watcher failure, preserving both exit codes. Mac source checks do not constitute native Windows ABI verification.
