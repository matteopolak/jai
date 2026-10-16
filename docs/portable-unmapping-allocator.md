# Unmapping allocator implementation and verification

The public record remains exactly a pointer-to-size table and a mutex. Wrapper
allocation ownership is private; the facade exports the five reviewed declarations.
Allocation places the effective requested range immediately before a guard page.
On Windows, the effective size is at least eight bytes. The table retains the
original requested size; the private rounding calculation derives the same mapped
extent when protecting it later.

The private virtual-memory subsystem now provides read-only protection alongside
reservation, commit and release. Windows uses the actual SDK VirtualAlloc and
VirtualProtect operations. Successful FREE and RESIZE retain the old mapping,
change its writable pages to read-only, and remove only its live tracking entry.
Failed protection logs and retains that entry, including when an assertion handler
returns or the default assertions are disabled. Failed allocation leaves the old
resize source live. Deinitialization frees tracking metadata and the mutex, and
does not release retained mappings.

SDK contracts consulted: [VirtualAlloc](https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-virtualalloc),
[VirtualProtect](https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-virtualprotect),
and [VirtualFree](https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-virtualfree).
No external Jai implementation was consulted.

Run `tools/check_portable_unmapping_shared.py` with the assigned CARGO_TARGET_DIR.
The runner creates a fresh source-only disabled-default configuration, changing
only Basic's existing default. Its explicit assertion side effect checks the
loaded configuration. Tests cover zero/small allocations, resize copying, failed
resize retention, CAPS, tracking removal, and native SDK protection failure/retry.
The Mach helper lowers maximum protection on exactly one test-owned page, forcing
a real mprotect failure. It then replaces that same still-owned page before retry;
it never dereferences the protected pointer. The original implementation failed
the tracking-retention check at native O0 and O2.

The final receipt `stdlib/shared-target/unmapping-protection-167zerx6` records ten
Mac interpreter/native executions, eight native builds, six target source checks,
six complete strict lint manifests and formatting. Two existing allocator/Pool
regressions additionally pass interpreter/native O0/O2, including native guard-page
and freed-write faults in isolated children and concurrent allocations.

Native Windows SDK page-state assertions are authored and source checked for x64
and ARM64, but have not run on Windows. Native Linux and console verification
remain external gates. The custom Mach test helper is unavailable in the
interpreter; its failure/retry regression is explicitly native-only. Initial
custom-helper interpreter failure and an incorrect generated extension-bearing
`#library` name were test setup errors, corrected before establishing the native
red. No fabricated SDK result or passing platform claim replaces these limits.
