# Windows resources, plugin, and native integration

Windows_Resources exports every reviewed declaration, only on Windows. Shared
Windows.WORD/DWORD identities and Compiler Workspace remain canonical. ICONDIR
is 6 bytes, ICONDIRENTRY 16 bytes, and Manifest_Options defaults match the spec.

| API | Actual implementation / verification |
| --- | --- |
| set_icon_by_filename / set_icon_by_data | Real File read/free and validated Win32 transaction; group default 2, images resource_id+index, English/default 1033 |
| generate_manifest | Caller-owned XML, eight option combinations, independent XML consumer and native portable engine |
| add_manifest_to_executable | Real RT_MANIFEST insertion, default 1, preserves existing resources |
| find_windows_kit_root(version) | Unicode installed-roots registry value query, temporary result |
| find_windows_kit_root() | Windows 10 then 8.1, numeric directory selection, caller-owned selected path |
| find_visual_studio_in_a_ridiculous_garbage_way | First suitable Setup COM instance then 14/12/11/10 registry fallback; temporary x64 directories |
| disable_runtime_console | Real #run workspace update; appends both reviewed linker arguments |

All resource/discovery native effects remain a Windows execution gate. x64/ARM64
checking and strict lint establish source/ABI consistency, not those effects.

Icon allocates a private record with canonical Metaprogram_Plugin as its first
field. It installs the reviewed callbacks, borrows the last -icon filename,
rejects missing/unknown arguments, and frees only that record on shutdown.
POST_WRITE_EXECUTABLE uses the message workspace's output path and executable
name. A Windows compiler host and Windows output are required for native mutation;
other dispatch logs unsupported. No communication_proc protocol is invented.
Lifecycle/options/help/nonphase checks pass interpreter/native, and real #run
phase tests exercise the supported non-Windows diagnostic path. Positive Windows
attachment remains pending.

## Native implementation

Private icon-directory code validates entries before forming views and builds
14-byte group entries. Directory metadata is owned; payload views borrow ICO.
Win32 transactions make aligned frame copies and keep them until EndUpdateResource.
Failure discards the pending transaction and reports actual SDK errors.
delete_existing_resources removes ALL previous resources as reviewed.

SDK references: [icon resource format](https://devblogs.microsoft.com/oldnewthing/20120720-00/?p=7083/),
[BeginUpdateResource](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-beginupdateresourcew),
[UpdateResource](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-updateresourcew),
[EndUpdateResource](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-endupdateresourcew).
The three ABI declarations use canonical Windows types.

COM ABI prefixes are independently declared from Microsoft's native
Setup.Configuration.h 3.14.2075. Query/Release/Next/path slots are exact; unused
method slots are opaque pointers, not callable stubs. COM initialization and
BSTR/interface releases are balanced. Official package archive SHA-256:
d2b96400b32056efdee3d21c93084a318d50448a910e0a8d976c5bf94096750f.
No Microsoft SDK source bodies are copied into Jai implementations.

The current Compiler Build_Options API borrows its argument slice. Console helper
buffers therefore remain owned for compiler-process lifetime; freeing immediately
caused the original #run regression to fail. No flags are accepted and ignored.

## Evidence and native gate

Library-owned tests under stdlib/tests use normal library-owned private imports;
no compiler exception or invented test export is needed. Public application tests
use facades only. Portable directory tests pass interpreter/native O0/O2, checking
payload borrowing, group bytes, ID limits, truncated directories/tails and invalid
offsets. Real LLVM RC emits byte-identical five-frame group/image resources and
lld-link creates a resource-only x64 PE DLL. ImageIO decodes five-frame ICO output.

On Windows with native stb dependencies and SDK fixtures, execute:

    jaic -O0 stdlib/tests/portable-data-resource-windows.jai -exe target/portable-data/resource-win-O0.exe
    target/portable-data/resource-win-O0.exe <absolute-fixture-directory>
    jaic -O2 stdlib/tests/portable-data-resource-windows.jai -exe target/portable-data/resource-win-O2.exe
    target/portable-data/resource-win-O2.exe <absolute-fixture-directory>

The test copies a Unicode DLL, verifies raw SDK resource readback, preservation,
delete-existing behavior, and public default/explicit IDs and manifest contents.
Run the discovery test on Windows, then independently compare its report through
Python's native registry and filesystem SDK consumers:

    jaic stdlib/tests/portable-data-discovery-windows.jai -exe target/portable-data/discovery-win.exe
    target/portable-data/discovery-win.exe <absolute-fixture-directory>
    python tests/portable-data/sdk_discovery.py <absolute-fixture-directory>

This comparison checks real registry values, maximum numeric SDK directory,
owned/temporary return usage and actual runtime/linker files when discovery
succeeds. Empty results are checked against the SDK's actual absence/failure,
rather than counted as installed-tool success. It has not run on Windows here.
For positive end-to-end Icon attachment use the unchanged compiler plugin host:

    jaic tests/portable-data/package-contract.jai -exe <fixture-directory>/with-icon.exe +Icon -icon <fixture-directory>/resource.ico

Inspect the resulting PE with LLVM's resource reader; expected icon group ID is 2,
with frame IDs 2 through 6. This command has not been executed on Windows here.
No Windows mutation/discovery/attachment success is claimed from source checking.

The scoped runner now performs the prepared native resource/discovery/console
tests and the real +Icon CLI plus independent ctypes Win32 SDK readback when
run on Windows. Its macOS execution does not enter those native cases and reports
the gate explicitly. Build actual Windows C dependencies with the dedicated
[SDK recipe](portable-data-testing.md). Numeric resource IDs use the full 16-bit
range including zero, with safe rejection of out-of-range extents before update.
