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

## Native API sources

- [CreateFileW](https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilew)
- [MapViewOfFile](https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-mapviewoffile)
- [MultiByteToWideChar](https://learn.microsoft.com/en-us/windows/win32/api/stringapiset/nf-stringapiset-multibytetowidechar)
- [SHGetKnownFolderPath](https://learn.microsoft.com/en-us/windows/win32/api/shlobj_core/nf-shlobj_core-shgetknownfolderpath)
