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

Use the source-built compiler with a complete independent dependency tree:

```
python3 tools/check_platform_io.py --jaic target/debug/jaic \
  --stdlib target/platform-io-stdlib --cross-check --native
```

The same command on native Windows x64/arm64 exercises actual Win32 operations
in interpreter and native O0/O2 modes. It is a coordinator CI runner hook; no
workflow is dispatched by the worker. Host cross-checks establish source support,
and cross-linking establishes executable generation, but neither proves Windows
runtime correctness. See the [progress](status/platform-io-progress.md) and
[deviations](status/platform-io-deviations.md) for executed evidence and gaps.

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
Fatal Jai checks still terminate through the CRT; optional Windows exception
backtraces require the outstanding public crash ABI clarification.

## Native API sources

- [CreateFileW](https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilew)
- [MapViewOfFile](https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-mapviewoffile)
- [MultiByteToWideChar](https://learn.microsoft.com/en-us/windows/win32/api/stringapiset/nf-stringapiset-multibytetowidechar)
- [SHGetKnownFolderPath](https://learn.microsoft.com/en-us/windows/win32/api/shlobj_core/nf-shlobj_core-shgetknownfolderpath)
- [Processor topology](https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-getlogicalprocessorinformationex)
- [Processor efficiency classes](https://learn.microsoft.com/en-us/windows/win32/api/winnt/ns-winnt-processor_relationship)
- [User profile directory](https://learn.microsoft.com/en-us/windows/win32/api/userenv/nf-userenv-getuserprofiledirectoryw)
- [Condition variable waits](https://learn.microsoft.com/en-us/windows/win32/api/synchapi/nf-synchapi-sleepconditionvariablecs)
