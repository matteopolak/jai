# Windows SDK runtime entrypoint resolution

Actual Windows CI 9d87e76 failed at Rust executable linking on x64 and ARM64:
LNK1181 could not open kernelbase.lib. This is a genuine compiler build defect.
Prior cross-target clippy/source checks did not invoke the native SDK linker.

The scheduler now resolves CompareObjectHandles by name in the already loaded
KernelBase.dll, using GetModuleHandleExW and GetProcAddress from Kernel32.lib.
The module is pinned once for process lifetime; OnceLock caches the exact
system-ABI function pointer. There is no static Kernelbase.lib dependency or
GetThreadId substitution, which would miss aliases without query rights. Private
identity probes preserve the caller's last-error value.

The SDK documents this API starting with Windows 10 / Server 2016. If unavailable
while live managed workers require alias discrimination, unmanaged suspend/resume
calls diagnose the missing capability. They cannot bypass the scheduler through
a failed identity probe. With no live workers, calls retain their native path.
This is an explicit capability limit, not support for that operation on older OSes.

Native foreign lookup also searches KernelBase.dll after Kernel32.dll. Microsoft
documents that SetThreadDescription/GetThreadDescription on Windows 10 1607,
LTSB 2016 and Server 2016 require runtime lookup there. Existing real calls,
HRESULTs, permissions, names and LocalFree ownership remain in effect. Absent
entrypoints still fail normal symbol resolution. No naming success is fabricated;
compiled native Jai SDK calls are unchanged.

Official contracts:

- [CompareObjectHandles](https://learn.microsoft.com/en-us/windows/win32/api/handleapi/nf-handleapi-compareobjecthandles)
- [GetModuleHandleExW and pinning](https://learn.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-getmodulehandleexw)
- [GetProcAddress and absent exports](https://learn.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-getprocaddress)
- [SetThreadDescription](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-setthreaddescription)
- [GetThreadDescription](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getthreaddescription)

## Verification

`python tools/check_windows_thread_sdk.py` requires a native Windows x64/ARM64
Rust host and SDK. It builds/links actual Rust test executables with cargo test
--no-run before executing scheduler units and all three owned Windows integration
targets, including the existing native naming/error fixture. A new native unit
checks actual runtime export resolution; the real
suspend-only alias regression checks last-error preservation for live and closed
handles. Existing alias exit, naming, permission and lifetime assertions remain.

The CI 7350b86 follow-up additionally builds/links both jaic and jailint before
tests, retaining the configured Rust CRT and workflow LLVM linkage. Use
--build-only for a prompt native link gate. See windows-crt-linkage.md for the
separate CRT import repair; the KernelBase implementation is unchanged.

This macOS worker cannot run that native gate: it explicitly exits nonzero here
(target/windows-kernelbase-native-gate.log). x64/ARM64 all-target core clippy with
warnings denied and an x64 Rust library/object build pass. Logs are
target/windows-kernelbase-{x64,arm64}-clippy.log and
target/windows-kernelbase-x64-object.log. The rlib is inspectable COFF, but lack
of .drectve does not prove executable linking: Rust also stores crate link metadata.

Six scheduler units and six API/callback host cases pass, recorded in
target/windows-kernelbase-host-{threads,api}.log. The full available core/backend
checkpoint remains 307 passed with the existing coordinator-owned corpus sweep
ignored; no redundant broad rerun is claimed for this Windows import fix.
Native Windows linking/runtime, including older supported export locations,
remain CI gates. Python ruff format/check passes. The first new cross-clippy run
caught a GetProcAddress declaration mismatch; the pointer signature was corrected
without a suppression. No raw CI log, vendor body, quarantined input or peer write.
