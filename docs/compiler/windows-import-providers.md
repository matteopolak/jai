# Windows interpreter import-library providers

The Windows interpreter now resolves a selected import archive to its actual
runtime provider. A logical SDK link name need not equal the DLL filename.
No binding, preserved Extensions body, public Jai API, link_always flag or
library-specific alias table changes.

The loader searches the source directory for non-system libraries, then existing
metaprogram/driver library directories, then the selected SDK directories.
Within each location import archives precede guessed DLL names, matching native
archive selection; a source-directory DLL still precedes a later configured
directory. Explicit DLL/archive filenames retain their suffix. GNU import archive
names and LIBRARY_PATH are supported. The existing C-runtime name handling remains
unchanged.

MSVC discovery moved from jaic-llvm into the compiler core. The linker imports
that same module; it does not acquire a second SDK selection algorithm. Explicit
LIB takes priority, otherwise the existing complete-toolset/SDK selection is used.
This works with the LLVM-free interpreter. Import metadata must match the
interpreter host CPU, including when compile-time execution builds another target.

The pure reader follows archive boundaries and actual COFF records. It reads
Microsoft short import objects, GNU relocation-free .idata$7 name sections and
long COFF descriptor Name relocations. Unrelated DLL-looking strings and
per-symbol .idata$7 references are not providers. Names are preserved, including
providers with .drv or .ocx suffixes. Metadata bounds, terminators, archive padding,
short-header flags and machine identity are checked. Details follow
[Microsoft's import-library format](https://learn.microsoft.com/en-us/windows/win32/debug/pe-format#import-library-format)
and the documented section distinction in
[LLVM's dlltool reader](https://llvm.org/docs/doxygen/DlltoolDriver_8cpp_source.html).

A selected archive's real provider is searched next to that archive, in the
configured directories, then by the normal Windows loader. Failure does not
silently select a different lower-priority archive. The required-library error
retains its original prefix and adds the selected archive/provider or load error.
Win32 errors are captured immediately after LoadLibraryW failure, before temporary
allocation cleanup. Successful handles retain existing process lifetime and
symbol-lookup behavior.

Current limits are explicit: static archives cannot be dynamically loaded;
multiple-provider archives, incompatible machines and invalid metadata reject.
BigObj import metadata and provider names containing directory paths are not
supported. This is provider selection, not a new import-symbol-renaming mechanism.
No unsupported case reports successful loading.

## Verification and handoff

Exact accepted producer8e81e901 sources plus only this owned patch pass171 core
tests,8 metadata controls and17 LLVM unit tests. The metadata fixtures include
real LLVM-generated x64/ARM64 import libraries and a GNU MinGW-generated archive
for an independently named provider. They contain import records and tool-generated import thunks, not a DLL
implementation; no provider code was executed. Synthetic malformed/CPU/ordering controls are
separate from Windows runtime evidence. Fixture generation is documented beside
the committed archives.

LLVM-free Windows x64 and ARM64 CLI source checks and strict clippy checks pass.
Core/LLVM strict clippy and formatting are checked separately. All build outputs,
captures and source receipts use the compiler T7 namespace. Native Windows loading
is pending CI; no local GUI/SDK/fault program or benchmark was run while root held
the native lease.

The independent bindings owner already provides the required actual Windows
controls: required-only import, canonical provider/export identity, real COM blob
ownership, valid/invalid HLSL and a C SDK oracle. Integration must run
tools/check_windows_d3dcompiler_provider.py with the actual selected import archive,
then retain both interpreter/native WebGPU headless and120-frame window checks.
Missing DLLs or failed SDK calls remain failures. No provider rename/copy,
Extensions modification, assertion suppression or backend disabling is permitted.

The [machine-readable checkpoint](../status/windows-import-providers.json) pins
source, tests, remaining Windows CI proof and preserved initial failures.
