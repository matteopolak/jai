# Windows resource implementation and integration

The public facade currently exports the three reviewed records only on Windows.
It does not invent default IDs or silently complete missing functions. Canonical
Windows.WORD/DWORD types retain shared identity; target checks verify ICONDIR is
6 bytes and ICONDIRENTRY is 16 bytes. Manifest_Options defaults are exact.

| Reviewed export | Status |
| --- | --- |
| ICONDIR / ICONDIRENTRY / Manifest_Options | Exact shapes/defaults, Windows-target checked |
| set_icon_by_filename / set_icon_by_data | Private validated wire/transaction backend ready; public ID/language policy pending |
| generate_manifest / add_manifest_to_executable | Native resource writer ready; XML identity/DPI/option policy pending |
| find_windows_kit_root(version) / find_windows_kit_root() | Registry/version-selection contract pending |
| find_visual_studio_in_a_ridiculous_garbage_way | Discovery and path-result contract pending |
| disable_runtime_console | Compiler workspace effect pending |

Private icon-directory code preflights all entries before forming payload views.
It produces 14-byte group entries with 16-bit image resource IDs, retaining the
12 common directory bytes. This follows Microsoft's [resource-format documentation](https://devblogs.microsoft.com/oldnewthing/20120720-00/?p=7083/).
IDs and language are explicit private caller policy, not guessed public defaults.
Directory metadata is owned; image/field views borrow the original ICO bytes.

Private transactions use canonical Windows types and three small official SDK
ABI declarations. Unicode paths reuse the NEW canonical filesystem conversion.
Begin/Update/End resource calls commit complete updates, discard failed updates,
and diagnose real native errors. Existing-resource deletion is passed explicitly
to BeginUpdateResourceW. SDK references:
[Begin](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-beginupdateresourcew),
[Update](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-updateresourcew),
[End](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-endupdateresourcew).

## Evidence and pending native gate

Library-owned tests live under stdlib/tests so the normal compiler private-source
policy admits their library imports; no test facade exports or compiler bypass
were added. Application tests continue to use public facades only.

The portable resource-directory test passes interpreter/native O0/O2 and compiled
WASI. It checks borrowed payloads, group bytes, two-frame ID boundaries, every
truncated prefix and invalid offsets. sdk_resources.py invokes real LLVM RC,
independently reads .res records and compares image/group payloads exactly, then
links a resource-only x64 PE DLL with lld-link.

Win32 transactions are source/strict-lint checked for Windows x64/ARM64. They are
NOT native-executed on this macOS host. The library-owned Windows test creates a
Unicode DLL copy, updates icon and manifest resources, uses actual SDK resource
loading/readback, verifies preservation, and tests delete-existing behavior.
Execute it on Windows after producing SDK fixtures:

    jaic -O0 stdlib/tests/portable-data-resource-windows.jai -exe target/portable-data/resource-win-O0.exe
    target/portable-data/resource-win-O0.exe <absolute-fixture-directory>
    jaic -O2 stdlib/tests/portable-data-resource-windows.jai -exe target/portable-data/resource-win-O2.exe
    target/portable-data/resource-win-O2.exe <absolute-fixture-directory>

No native Windows pass is claimed until those run successfully. No Wine or fake
kernel imports are used. Public function integration awaits focused reviewed
contracts in specs/questions/portable-data.md. Icon still has no guessed plugin
implementation: all six exports await option/host/lifecycle policy.
