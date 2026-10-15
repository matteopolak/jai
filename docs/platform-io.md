# Platform I/O backends

The File facade selects native operations without changing its public record
names or overloads. Shared whole-file and String_Builder operations live in
`internal/files/file.jai`; Unix retains stdio and POSIX path operations in
`native-unix.jai`. Windows uses real Win32 handles in `native-windows.jai`.

Windows read opens are binary and read-only; writing requests read/write access,
using CREATE_ALWAYS or OPEN_ALWAYS according to `keep_existing_content`. Handles
are non-inheritable and allow read/write/delete sharing. Counts are split into
bounded DWORD transfers, positions and lengths are signed 64-bit, and no text
newline conversion occurs. Native errors propagate as failure results; close
failures are logged and retain the handle for retry.

Native end-of-file and closed-pipe read statuses become successful short/empty reads;
other failures preserve the bytes already read and return failure.

The private encoding bridge rejects malformed UTF-8 and embedded NULs before
calling the wide Win32 APIs. Paths use native Windows namespace/length rules;
explicit extended paths are accepted. Recursive directory creation recognizes
drive roots. Native hard links and moves follow their OS failure behavior.
Canonical paths come from GetFinalPathNameByHandleW, including its volume prefix;
absolute paths use GetFullPathNameW and need not name an existing file.

Windows mappings are read-only views, with separate file and mapping handles.
An empty file has an empty view and an owned file handle. Cleanup releases the
view, mapping, then file, retaining any unreleased resource after failure for
retry. A string converted with `string_to_map_file_info` on Windows is borrowed;
its empty mapping state prevents freeing caller storage. Unix's existing wrapper
continues to hold allocated file contents and frees that storage on end.

Returned whole-file, canonical-path and known-folder strings belong to the
caller's allocator. Known-folder COM memory is converted and released with
CoTaskMemFree. These operations require neither COM initialization nor a
reference compiler.

## Verification

Wasm File shares the stream operations with Unix while importing the private
`internal/files/wasi-libc` ABI instead of POSIX. Opaque C streams/directories
come from the preserved `Extensions/Wasi_Runtime` when compiled, or the
compiler's sandbox when interpreted. Directory existence uses an actual
open/close pair, avoiding an invented native `stat` layout. The POSIX platform
guard is unchanged. `--wasm` runs the unchanged File fixture in the Wasm
interpreter and real WASI O0/O2, and checks every reachable implementation with
`-no_dce`; normal CI includes this gate. WASI filesystem capability and rights
limits are returned as operation failures by the existing runtime.

Use the source-built compiler with a complete independent dependency tree:

```
python3 tools/check_platform_io.py --jaic target/debug/jaic \
  --stdlib stdlib --cross-check --native --wasm
```

The same command on native Windows x64/arm64 exercises actual Win32 operations
in interpreter and native O0/O2 modes. It is a coordinator CI runner hook; no
workflow is dispatched by the worker. Host cross-checks establish source support,
and cross-linking establishes executable generation, but neither proves Windows
runtime correctness. See the [progress](status/platform-io-progress.md) and
[deviations](status/platform-io-deviations.md) for executed evidence and gaps.
Unresolved contracts are recorded in the [platform I/O questions](specs/stdlib/platform-io-questions.md).
The [compiler/tool handoff](platform-io-compiler-handoff.md) records remaining
interpreter and semantic-lint requirements. The scoped format/lint runner is
`tools/format_platform_io.py`. Its strict lint mode selects macOS ARM64, Linux x64,
Windows x64 and Windows ARM64, fails on incomplete checking, verifies staged owned
files byte-for-byte and requires every owned file in the checked-file manifests.

## System, Thread and runtime

Windows System converts native wide account and path strings into temporary UTF-8
storage. Current-user profiles use GetUserProfileDirectoryW; named accounts resolve
their SID and registered ProfileImagePath. A missing account/profile returns failure.
CPU queries enumerate variable-size processor-core records across processor groups;
logical counts count affinity bits, physical counts count cores, and performance
queries select the highest EfficiencyClass reported by Windows. Native error strings
use FormatMessageW and release its LocalAlloc storage after conversion.

Windows Thread uses critical sections, condition variables and counted semaphores.
Thread creation uses `_beginthreadex` with CREATE_SUSPENDED; ResumeThread starts the
callback with its captured context and temporary storage. Completion is observed on
the actual thread handle before teardown. The unusual reviewed Windows public
thread_is_done behavior (any wait result except TIMEOUT reports true) is preserved;
internal teardown additionally requires successful completion. CRT suspended-thread
interpreter support remains a compiler integration gap with an original reproducer.

Runtime byte output uses WriteFile on GetStdHandle, preserving binary bytes and LF.
Native Windows process entry parses GetCommandLineW with CommandLineToArgvW and
strictly converts to UTF-8; the allocations outlive the runtime context and are freed
after its finalization. Direct initialization calls retain their supplied argc/argv.
Fatal Jai checks still terminate through the CRT. Optional Windows hardware exception
diagnostics implement the reviewed public x64 crash-handler facade through a private
source-built C backend. Its SDK size/offset assertions check the byte-shaped public
records; contexts are copied to aligned native storage before stack walking. Mutable
public handler state retains its documented names and storage.

Build the DLL and import library with `tools/build_platform_io_runtime.py --stdlib
target/platform-io-stdlib --cpu x64`. The runner's `--windows-crash` option
builds this dependency and an enabled-startup access-violation fixture, checking the
native exception code and emitted diagnostics when run on Windows. This is a real
production dependency requiring coordinator native CI/package integration. The
diagnostic handler prints up to 64 actual frames and resolves available symbols;
missing unwind/symbol information is not synthesized. DbgHelp calls are serialized.
A fault that interrupts an active symbol operation prints an explicit stack-unavailable
message instead of deadlocking. The public section query inspects the running main
executable's PE section table and returns the real section name and write permission.

Crash initialization occurs only from the configured system entry point. An
initialization-only import does not install or import the handler. The reviewed
public Windows crash ABI remains x64-only, and direct ARM64 use diagnoses. The
coordinator authorized an independent portability improvement for Runtime_Support
entry: a separate private ARM64 SDK backend, preserving ON/AUTO defaults and never
reinterpreting a native ARM64 context as the public x64 record. It uses dynamically
resolved RtlVirtualUnwind2 (Windows 11/Server 2022 minimum), stack bounds, a unique
process handle and serialized DbgHelp. Missing API produces an initialization error.
Normal shutdown restores the previous exception filter/error mode and releases the
symbol session/handle. See [design and limits](platform-io-arm64-crash-plan.md).

Select `--cpu arm64` in the native dependency build on ARM64. The architecture-
matching DLL/import library must be built, and the DLL packaged beside executables.
The native runner executes ordinary startup and real faults under ON, OFF and
untouched public defaults at O0/O2. ARM64 also runs native C lifecycle assertions.
Enabled faults require the real exception status and at least two actual frames;
source checks and cross-builds are separate from these native assertions. The
fault fixture suppresses interactive Windows error boxes while retaining the actual
access violation and native exit code. Independent test failures are accumulated:
an interpreter failure does not prevent native O0/O2 or later fixtures from running,
and any failure still makes the runner exit nonzero. Failed builds never execute
an older artifact. This retains the pending interpreter failures in native CI.

## Public Windows Process

`internal/platform-io/windows-process.jai` implements actual native process and pipe
mechanisms over the canonical reviewed public records in `internal/process/windows-types.jai`.
The public facade selects `internal/process/windows.jai`, retaining all names,
overloads, parameter names and defaults. Launch uses Unicode command lines and
an explicit inherited-handle list. Named byte pipes use overlapped I/O and kernel
events; reads wait on stdout and stderr together and drain canceled operations
before returning caller buffers. Job objects provide parent-exit cleanup and are
assigned before the suspended child starts. Callers can explicitly opt out.
Transfer counts always come from GetOverlappedResult, including immediate completion;
a zero-byte native pipe write is not treated as EOF.

Public 64-bit wait durations are split into finite native DWORD-sized waits,
repeating only after an actual WAIT_TIMEOUT. Zero polls and negative infinite waits
retain their native modes. Large finite inputs are not truncated to a single native
wait. This preserves the OS's wait-time accounting; the only extra work for long
durations is another native wait at each completed chunk.

Windows verification can be added to the runner with `--windows-process`; cross-build
fixtures with `--windows-build x64` (or arm64 with that native toolchain installed).
The tests import the actual public facade; the earlier temporary test module has
been removed. The generated native `windows-process-O0.exe`/`windows-process-O2.exe` take the child
fixture executable as their argument; real Windows execution is required. The runner
also exercises job ownership on parent exit on a native Windows host.

## Native API sources

- [CreateFileW](https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilew)
- [ReadFile completion and pipe semantics](https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-readfile)
- [MapViewOfFile](https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-mapviewoffile)
- [MultiByteToWideChar](https://learn.microsoft.com/en-us/windows/win32/api/stringapiset/nf-stringapiset-multibytetowidechar)
- [SHGetKnownFolderPath](https://learn.microsoft.com/en-us/windows/win32/api/shlobj_core/nf-shlobj_core-shgetknownfolderpath)
- [Processor topology](https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-getlogicalprocessorinformationex)
- [Processor efficiency classes](https://learn.microsoft.com/en-us/windows/win32/api/winnt/ns-winnt-processor_relationship)
- [User profile directory](https://learn.microsoft.com/en-us/windows/win32/api/userenv/nf-userenv-getuserprofiledirectoryw)
- [Condition variable waits](https://learn.microsoft.com/en-us/windows/win32/api/synchapi/nf-synchapi-sleepconditionvariablecs)
- [CRT thread lifecycle](https://learn.microsoft.com/en-us/cpp/c-runtime-library/reference/beginthread-beginthreadex?view=msvc-170)
- [Explicit inherited process handles](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-updateprocthreadattribute)
- [Native wait duration and result semantics](https://learn.microsoft.com/en-us/windows/win32/api/synchapi/nf-synchapi-waitformultipleobjects)
- [Asynchronous I/O cancellation](https://learn.microsoft.com/en-us/windows/win32/api/ioapiset/nf-ioapiset-cancelioex)
- [Job lifetime limits](https://learn.microsoft.com/en-us/windows/win32/api/jobapi2/nf-jobapi2-setinformationjobobject)
- [Windows stack walking](https://learn.microsoft.com/en-us/windows/win32/api/dbghelp/nf-dbghelp-stackwalk64)
