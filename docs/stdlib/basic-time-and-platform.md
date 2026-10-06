# Basic calendar time, working directory and platform helpers

## What it is

Calendar conversion (`to_calendar`, `calendar_to_apollo`), OS time formats (`to_timespec`, `to_filetime`), the working directory, the macOS-only exports of Basic, and `append_indentation`. Also covers `Machine_X64` and the layout of `Bucket_Array`.

## How it works

- **Calendar** (`Basic/Apollo_Time.jai`): UTC conversion uses a proleptic-Gregorian civil-date algorithm (`civil_days_from_date`, `civil_date_from_days`), so it is exact on every OS and handles dates before 1970. `to_calendar` rounds to milliseconds; `calendar_to_apollo` normalises out-of-range fields (month 12, hour 25, ...).
- **Local time**: the only OS query is `os_local_offset_seconds(utc_seconds)` in `Basic/platform-time.jai` (`localtime_r` and `tm_gmtoff` on POSIX). `calendar_to_apollo` resolves the offset in two steps so DST transitions work. On Windows, `LOCAL` currently behaves like UTC (`@Incomplete`).
- `to_timespec` (POSIX only) returns a `POSIX.timespec` and fails for instants before 1970. `to_filetime` is Windows-only and returns the module-local `Clock_Filetime`.
- `get_working_directory`, `set_working_directory`, `exit` and `sleep_milliseconds` live in `Basic` only, as in the official API; defining them in `System` or `File` too would make importing both ambiguous. `exit` and `sleep_milliseconds` take `s32`. `get_working_directory` returns temporary storage.
- **Machine_X64**: `rdtsc`, `rdtscp`, `rdrand`, fences and `pause` use jaic's `#asm` (see [`#asm`](../compiler/asm.md)). `prefetch` is a no-op, `rdseed` falls back to `rdrand`, and `get_cpu_info` runs `cpuid`, which jaic lowers to zeros (vendor `.UNKNOWN`, no feature bits).
- **Bucket_Array** keeps the public layout (`count`, `allocator`, `all_buckets`, `unfull_buckets`, `Bucket`, `Bucket_Locator{bucket_index, slot_index}`) and supports `remove` inside `for`.

## How to change it

New OS-specific time behaviour goes in `Basic/platform-time.jai`; keep portable logic in `Apollo_Time.jai`. Only public API belongs here; internal helpers of the official module are intentionally absent.

Tests: `tests/stdlib/basic-calendar.jai`, `basic-working-directory.jai`, `bucket-array-shape.jai`, `machine-x64-intrinsics.jai`.

## Configuration

`LOCAL` follows the process time zone (`TZ`).

## Dependencies

`POSIX` (imported privately on Linux, macOS and Android for `localtime_r` and `timespec`), libc `getcwd`/`chdir`, Windows `kernel32`.
