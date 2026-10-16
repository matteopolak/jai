# Real Windows resource fixture provider

`tools/build_windows_resource_fixture.py` supplies the real files required by
the existing Windows resource/discovery tests. It changes no production module,
test assertion, platform capability or application source.

Run the producer with the **actual target CPU** and a fresh caller-owned directory:

```
python tools/build_windows_resource_fixture.py --cpu x64 --out <owned-x64-directory>
python tools/build_windows_resource_fixture.py --cpu arm64 --out <owned-arm64-directory>
```

It requires actual LLVM or Microsoft SDK tools. `--rc`, `--linker` and `--readobj`
can name explicit executables; otherwise PATH supplies `llvm-rc`, `lld-link` and
`llvm-readobj` (Microsoft `rc.exe`/`link.exe` can supply the first two on Windows).
There are no hardcoded developer paths, downloaded binaries, fake DLLs, inferred
host-CPU substitutions or codec/runtime-provider fallbacks. Missing tools and SDK
errors are fatal. Existing fixture files are not replaced: choose a fresh output
directory instead of reusing a previous CPU's artifacts.

Only after successful completion and receipt validation should integration set
`JAIC_TEST_WINDOWS_RESOURCE_DIR` to that output directory. Confirm
`fixture-receipt.json` has `status: verified_cross_build` and the requested `cpu`;
verify its artifact hashes before publishing the path. The native consumers still
receive this real directory as argv[1]. Integration owns workflow/env/argv wiring.

## Contents and validation

The independent ICO has five actual uncompressed, opaque 32-bit BGRA DIB images,
sizes 256, 128, 64, 32 and 16, each with real varying pixels and a DWORD-aligned
AND mask. This deliberately avoids a runtime image-codec dependency in fixture
provisioning; its uncompressed size is larger than a PNG-backed ICO. It does not
replace coverage of the library's own ICO/image encoders.

The source RC script is:

```
LANGUAGE 9, 1
101 ICON "resource.ico"
```

Actual SDK RC compilation produces `resource.res`; actual PE linking uses
`/DLL /NOENTRY /MACHINE:<requested-cpu>`. This is the
[documented resource-only DLL mechanism](https://learn.microsoft.com/en-us/cpp/build/creating-a-resource-only-dll).
The helper does not generate PE headers or resource directories itself. LLVM
linking uses timestamp zero; Microsoft linking requests reproducible output.

An independent `llvm-readobj --file-headers --coff-resources` capture is retained.
The helper also reads the actual linked PE and requires:

- PE32+ DLL, requested machine x64 `0x8664` or ARM64 `0xaa64`;
- zero entry point, zero code/imports and no executable section;
- exactly six resource leaves, language 1033: five `RT_ICON` IDs 1–5 and one
  `RT_GROUP_ICON` ID 101;
- a 76-byte group, with every group field and every image payload byte matching
  the input ICO.

The [Microsoft PE specification](https://learn.microsoft.com/en-us/windows/win32/debug/pe-format)
defines the inspected headers, machine identifiers and resource tree. The
[Microsoft icon-resource description](https://devblogs.microsoft.com/oldnewthing/20120720-00/?p=7083)
describes the separation of ICO images from their group directory. No other Jai
implementation or library source is an input.

All successful artifacts (`resource.ico`, `.rc`, `.res`, `resource-only.dll` and
`inspection.txt`) are SHA256-pinned in the receipt, together with actual SDK tool
paths/hashes and command stdout/stderr. The full SDK inspection output is kept
for audit, including resource data, so receipts/captures are larger than a terse
header summary. Build files remain in private staging until verification; SDK
failures produce a failed receipt and never publish an unverified DLL.

The first publisher renamed SDK-created files after inspecting them. A later
independent T7 audit found both DLLs had become zero-filled despite their valid
build-time receipts; other artifacts still matched. That RED capture is retained
as `publication-red.json`, and the initial `verified/` directories must not be
used. The precise SDK/filesystem/transport cause has not been established.
An isolated later audit also found a directly linked, fsynced SDK DLL zeroed,
while ordinary byte-written copies retained the exact verified SDK hash. This
does not establish a particular LLVM or filesystem implementation defect.
Publication now writes the **actual verified SDK bytes**, flushes/fsyncs files
and receipts, and rechecks every final hash plus PE resources after staging
cleanup. It never synthesizes a replacement PE or retries with another provider.
This costs an additional artifact copy and synchronous I/O. Separate tool-call
audits of the corrected `durable/` outputs match all ten artifact hashes; this is
durable cross-build evidence, not native Windows API proof.

## Preserved consumer contracts and evidence

`stdlib/tests/portable-data-resource-windows.jai` requires initial group 101,
language 1033 and group length 76. It then checks native updates at group 501 /
image IDs beginning 600, manifest 1, delete-existing replacement at group 700 /
image IDs beginning 800, and public default group 2 / explicit group 900. All
those assertions and SDK readback/cleanup remain unchanged.
`portable-data-discovery-windows.jai` needs the caller's actual writable directory
for its independent SDK CSV report; no installed SDK/Visual Studio facts are
invented. `build_windows_images.py` provisions stb DLLs and is not this resource
fixture producer.

Five focused tests pass, including three real SDK builds x64/ARM64/x64-repeat;
ICO, RES and DLL hashes repeat identically for x64, while the ARM64 PE correctly
differs. Independent DIB structure/pixel/mask checks, wrong CPU, nonzero entry
point, altered actual image payload, truncation, missing tool and existing-output
controls remain strict. Two final CLI captures also pass in own T7 directories
containing spaces and Unicode. Ruff lint/format and whitespace checks pass.

These are **cross-build and file-inspection results only** on macOS. Microsoft
RC/link execution, Windows icon decoding, `LoadLibraryExW`, resource updates,
registry/SDK discovery and the actual public Windows tests remain unverified
locally and required in native x64/ARM64 CI. Every receipt says
`native_verified: false`. The root LSP/native/timing lease was respected; no
host SDK runtime, GUI, fault, benchmark or native fixture program was executed.

The separate console fixture still requires the reviewed literal linker options
`/SUBSYSTEM:windows` and `/ENTRY:mainCRTStartup`. Passing those raw strings to
Clang as filenames is a general compiler driver/linker forwarding issue; it is
routed to the compiler owner, not waived or patched by fixture name here.
An independent six-command C/Clang reduction reproduces raw-option rejection
and successful forwarding through `-Xlinker` on both target CPUs; the linked PE
has GUI subsystem 2 and a nonzero entry point. Its self-contained diagnostic C
object uses no CRT solely to isolate argument grammar; this is not a production
runtime recipe. The [official Clang linker-option contract](https://clang.llvm.org/docs/ClangCommandLineReference.html#cmdoption-clang-Xlinker)
documents forwarding. All original public option/argument assertions remain
required, and direct-linker/driver behavior belongs in a general compiler repair.
The previously reported File_Utilities main:53 native assertion and ARM64 TLS
`inet_pton` link gate remain required, outside this resource producer repair.


Integration workflow closure: both Linux-host cross jobs use pinned LLVM RC/LLD to build target-specific resources before packaging cross executables. Windows run jobs verify downloaded receipt status, exact CPU and every artifact SHA before exporting the caller directory. Native x64/ARM64 jobs independently construct their fixture before any stdlib/native consumer. No Windows native readback is claimed by this construction wiring. Five local fixture tests pass, including three real RC/PE cross builds and repeat-payload equality; resource-only DLLs were inspected, never executed.
