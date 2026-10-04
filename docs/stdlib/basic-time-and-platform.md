# Basic calendar time, working directory and platform exports

## What it is

Public API parity work for `stdlib/Basic`: `to_calendar` / `calendar_to_apollo`, `to_timespec` / `to_filetime`,
`get_working_directory` / `set_working_directory`, the macOS-only exports of the reference `osx.jai`, and
`append_indentation`. Related parity fixes live in `Machine_X64.jai`, `String` (`scan`, `scan2`, `atof`),
`System` (`get_passwd_for_user`) and `Bucket_Array.jai`.

## How it works

- **Calendar (`Basic/Apollo_Time.jai`)**: UTC conversion uses our own proleptic-Gregorian civil-date algorithm
  (`civil_days_from_date` / `civil_date_from_days`), so it is exact on every OS and supports dates before 1970.
  `to_calendar` rounds to milliseconds. `calendar_to_apollo` normalizes out-of-range fields (month 12, hour 25...).
- **LOCAL zone**: the only OS query is `os_local_offset_seconds(utc_seconds)` in `Basic/platform-time.jai`
  (`localtime_r` + `tm_gmtoff` on POSIX). `calendar_to_apollo` resolves the local offset in two steps so DST works.
  On Windows LOCAL currently behaves like UTC (`@Incomplete`).
- **`to_timespec`** (POSIX only) returns `POSIX.timespec`; it fails for instants before 1970 like the reference.
  **`to_filetime`** is Windows-only and returns the module-local `Clock_Filetime`.
- **Working directory / exit / sleep**: live in `Basic` (as in the reference); `System` and `File` no longer define
  `get_working_directory`/`set_working_directory`, otherwise importing both would be ambiguous. `exit` and
  `sleep_milliseconds` now take `s32` like the reference. The results of `get_working_directory` are temporary storage.
- **Machine_X64**: `rdtsc`, `rdtscp`, `rdrand`, fences and `pause` use jaic's scalar `#asm` (see [asm](../compiler/asm.md)).
  `prefetch` is a no-op, `rdseed` falls back to `rdrand`, and `get_cpu_info` runs `cpuid`, which jaic lowers to zeros
  (vendor `.UNKNOWN`, no feature bits).
- **Bucket_Array**: same layout as the reference (`count`, `allocator`, `all_buckets`, `unfull_buckets`, `Bucket`,
  `Bucket_Locator{bucket_index, slot_index}`); `legacy/Bucket_Array.jai` is a separate older copy that Treemap and Keymap still import.

## How to change it

- New OS-specific time behavior goes in `Basic/platform-time.jai`; keep portable logic in `Apollo_Time.jai`.
- Not added on purpose: reference names that are file-scope helpers or inside comments (`timelocal`, `timegm`,
  `get_january_1_1601_apollo_time`, `append_repeated_character` (nested in `stb_print_float`), demo/test procs).

## Configuration

None. `LOCAL` follows the process time zone (`TZ`).

## Dependencies

`POSIX` (imported privately by Basic on Linux/macOS/Android for `localtime_r`/`timespec`), libc `getcwd`/`chdir`,
Windows `kernel32`. Tests: `tests/stdlib/basic-calendar.jai`, `basic-working-directory.jai`,
`bucket-array-shape.jai`, `machine-x64-intrinsics.jai`, `string-scan.jai`.
