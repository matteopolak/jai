# Windows section queries under interpretation

Filtered CI candidate 0100a1f verifies the argv/signed-wheel repair on both CPUs.
Its ARM64 Platform I/O step passes. The x64 step fails only crash-contract.jai's
first positive code-section assertion under interpretation, with and without --.
Other x64 cases pass; the overall x64 step remains red. The private ARM64 crash
backend was not in that candidate and has no native execution evidence yet.

The original assertion assumes interpreted `main` belongs to the native process
image. Our compiler's interp/mod.rs::proc_value represents ordinary interpreted
procedures as tagged IDs; only C-callable procedures get native callback addresses.
global_addr allocates interpreted global storage with ZeroedBlock on the heap.
The section query's GetModuleHandleW(NULL) instead identifies the calling process's
actual executable image. Reclassifying tagged IDs or heap blocks as PE sections
would fabricate native memory properties. This is an incorrect cross-mode fixture
assumption, not evidence that handler initialization failed: both init calls and
the symbols_initialized assertion precede the reported failure.

The interpreter's ForeignCall guard uses a vectored exception handler, not the
top-level filter installed by this module. It does not replace that filter on
each call. The new native filter-identity checks exercise actual installation and
callback ABI instead of inferring initialization failure from a PE lookup.

Original minimal pointer-representation reproducer, run with our source-built
compiler on the host in interpreter and native O0 modes:

```jai
#import "Basic";

global_value: s64;

main :: () {
    print("procedure=% global=%\n", cast(u64) cast(*void) main, cast(u64) *global_value);
}
```

The actual host run printed procedure=18369338455114121222 under interpretation
and procedure=4364337596 in the native executable. These are run-specific values,
not compatibility constants: the first is the interpreter's tagged FuncId and
the second a native code address. Durable source/output is under
target/platform-io-pointer-repro. This is host evidence for pointer representation,
not execution evidence for Windows SDK behavior.

Independent test design and implementation plan:

1. Keep the native code/data/stack assertions in a separate native-executable
   fixture, run at O0/O2 on x64. They remain mandatory compiler/ABI regressions.
2. In the shared interpreter/native fixture, compare code/global/local/callback
   pointers against VirtualQuery's actual main-image allocation and permissions.
   Include positive actual main-image code and writable-data addresses in every
   mode; require section name and permission identity from ImageNtHeader and
   ImageRvaToSection. Use that file-mapped RVA lookup only for file-backed probes;
   BSS can extend beyond SizeOfRawData and uses VirtualQuery classification.
   Null and stack pointers retain explicit negative assertions.
   The SDK oracle is a source-built test DLL, never a production substitution.
3. Verify init actually installs the public callback with the native exception
   filter API, preserves callback pointer identity across repeated initialization,
   and restore the previous filter before interpreted callback storage expires.
4. Retain --windows-crash ON/OFF/default startup, real access violations, exit
   status and multi-frame trace assertions on both CPUs, plus ARM64 cleanup tests.
5. Run source-built formatting, strict lint, host tests, native object checks and
   available cross-builds. Actual x64 interpreter/native and ARM64 backend execution
   remain required from the next coordinator CI candidate; do not dispatch CI here.

Official SDK sources:

- [GetModuleHandleW](https://learn.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-getmodulehandlew)
- [VirtualQuery](https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-virtualquery)
- [ImageNtHeader](https://learn.microsoft.com/en-us/windows/win32/api/dbghelp/nf-dbghelp-imagentheader)
- [ImageRvaToSection](https://learn.microsoft.com/en-us/windows/win32/api/dbghelp/nf-dbghelp-imagervatosection)

DbgHelp calls in this single-threaded fixture are sequential with handler init and
section queries. No worker concurrently invokes symbol APIs. The production
backend's own synchronization and genuine crash/failure assertions remain intact.

Local verification: the complete host interpreter/O0/O2 suite, four-target checks,
x64 C SDK DLL/import-library build, x64 cross-builds (including the mandatory
compiled-symbol fixture) and ON/OFF/default startup/fault cross-builds pass.
Strict four-target lint covers all 46 owned Jai files; jaifmt formatting/idempotence
passes. Logs: target/platform-io-0100a1f-{suite,lint}.log. The production section
query and public API are unchanged; no compiler pointer remapping was added.

Next native candidate, on each matching source-built compiler CPU:

```text
python tools/check_platform_io.py --jaic <own-jaic.exe> --stdlib <integrated-stdlib> --native --cross-check --windows-process --windows-crash --windows-build x64
python tools/check_platform_io.py --jaic <own-jaic.exe> --stdlib <integrated-stdlib> --native --cross-check --windows-process --windows-crash --windows-build arm64
```

Explicit architecture selects the matching native DLL even when a scripting host
is emulated on ARM64 hardware. Run each command only with its matching compiler.
This worker has no Windows runtime or ARM64 Windows linker; neither revised x64
fixture execution nor the private ARM64 crash backend is claimed natively verified.
RtlVirtualUnwind2's documented API minimum is Windows 11/Server 2022; the private
ARM64 executable backend targets native ARM64 Windows and requires that export at
runtime. This states the API minimum, not availability of an ARM64 Server SKU or
support for every older Windows deployment. Missing export fails initialization;
explicit public x64-context callback imports on ARM64 remain diagnosed.
