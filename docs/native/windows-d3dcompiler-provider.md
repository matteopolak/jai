# Windows D3DCompiler provider investigation

Windows CI job 117082710709 reports real WebGPU native headless/window passes
but interpreter startup fails loading required logical library `d3dcompiler`.
This is still an open required runtime failure, not an unavailable adapter.

Microsoft's [D3DCompile requirements](https://learn.microsoft.com/en-us/windows/win32/api/d3dcompiler/nf-d3dcompiler-d3dcompile)
identify the link library as `d3dcompiler.lib` and the DLL as
`d3dcompiler_47.dll`. These are distinct names for different artifacts.
The interpreter currently appends `.dll` to the logical library name without
consulting import-library metadata. Both the native binding and the preserved
WebGPU extension legitimately use the logical import-library name.

Independent official mingw-w64 14.0.0_3 x64 archive inspection confirms that
`libd3dcompiler.a` imports `D3DCOMPILER_47.dll`. An independently authored
official-header shader program cross-compiles/links with `-ld3dcompiler`;
its PE import table contains `D3DCOMPILER_47.dll!D3DCompile`. Neither archive
inspection nor cross-linking executes the compiler DLL or proves the current
Windows MSVC runner's installed provider. Those exact CI facts remain requested.

The narrow compiler-owner dependency is general Windows system import-library
to physical DLL resolution, using the selected SDK/provider's actual metadata
and library-search order. Do not special-case a Jai module, invent capability
success, remove required loading, rename/copy the DLL under an alias, or change
the preserved Extensions source. Changing only the d3d_compiler facade to a
versioned name would leave WebGPU startup broken. No such workaround was made.
If the physical DLL is genuinely absent, provision the matching official SDK
redistributable under its real name and architecture, with recorded hashes.
PATH alone cannot correct a mismatched logical name.

New producer controls are ready:

- `windows-import-library-required.jai` reduces required loading to one
  `#system_library,link_always "d3dcompiler"` and an empty main.
- `windows-d3dcompiler-provider.jai` requires canonical physical image/function
  identity, allocates/writes/reads/releases a real SDK blob, and compiles both
  valid and invalid HLSL while checking HRESULTs, diagnostics and COM ownership.
- `windows_d3dcompiler_sdk.c` provides an independent official-header positive/
  negative shader control.
- `check_windows_d3dcompiler_provider.py` records actual Windows load errors,
  resolved DLL paths/hashes/exports, then requires interpreter, build and native
  success for both Jai fixtures. Missing providers, failures and timeouts remain
  failures; there is no skip or adapter fallback.

Portable metadata mode parses archive boundaries, Microsoft short import records
and GNU COFF import-descriptor sections, rather than guessing from arbitrary DLL
strings. Its synthetic format/error tests are metadata-only evidence. Format
details follow Microsoft's [PE/COFF import-library specification](https://learn.microsoft.com/en-us/windows/win32/debug/pe-format#import-library-format).
Both Windows CPU source checks and complete binding strict lint pass on a fresh
own build of the current shared compiler. Actual Windows execution of these
new controls is pending; no runtime repair or Windows green status is claimed.

Integration owns workflow wiring and Git/index operations; SDL owns the WGL CI
runner. Add this provider check before WebGPU interpreter tests after the general
loader repair, supplying actual `--jaic`, `--stdlib`, `--import-library` and
`--report` paths. Preserve both WebGPU modes and real 120-frame presentation
checks. Root's host native lease remains respected: this worker ran only source,
build, metadata and pure Python checks, with all outputs under bindings T7.
