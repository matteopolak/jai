# Windows x64 M128A and CONTEXT alignment

Windows MSVC940 CI job `117173045723` reported two SDK ABI mismatches:
`M128A` and `CONTEXT` were 16-byte aligned in C but 8-byte aligned in Jai.
The focused Jai regression independently reproduced the M128A failure before
the repair. Both canonical records now carry `#align 16`. No fields, defaults,
types, overlays, order, padding members or public names changed. CONTEXT retains
`#type_info_none`. No ABI assertions or expected SDK values were relaxed.

The public Microsoft SDK header explicitly declares both records with
`DECLSPEC_ALIGN(16)`. The pinned official input is
[Microsoft win32metadata winnt.h](https://github.com/microsoft/win32metadata/blob/0f012441d654d3bb7de898fdc664b5fcad52bdcc/generation/WinSDK/RecompiledIdlHeaders/um/winnt.h),
SHA256 `404019933323ca25f5db8ce14437483e1054398ce454d5c75df2e187cec2ae40`.
The original full header and download provenance are retained in own T7
scratch; only public SDK declarations were consulted. Microsoft also documents
[explicit record alignment](https://learn.microsoft.com/en-us/cpp/cpp/align-cpp?view=msvc-170).
The SDK architecture distinction matters: this proof concerns its AMD64
CONTEXT, not an inferred ARM64 register record.

The new Jai and C fixtures require size 16/alignment 16 for M128A and size
1232/alignment 16 for x64 CONTEXT. They preserve key offsets including Rip,
FltSave, Xmm0 and VectorRegister. Containers with a leading byte and two-element
arrays verify embedded offsets, aggregate alignment and strides. Thus aligning
one local variable or adding artificial padding cannot satisfy the controls.
The Jai fixture also verifies canonical public field types. Its first authored
version used the reserved identifier `context`; that test-authoring error was
corrected to `saved_context`, without production changes or weakened assertions.

`verify_windows_context_alignment.py` captures current shared stdlib and focused
inputs, checks Windows x64 source and strict lint, verifies production/fixture
formatting, and compiles the C assertions against actual MinGW Windows headers.
It requires the independently pinned official Microsoft header hash and its
two explicit alignment declarations, and records compiler-discovered C SDK
dependencies plus object/tool/source hashes. It never executes a program.

**Evidence boundary:** host Mac source checking and Windows x64 COFF cross
compilation are not native MSVC execution. The original Windows ABI suite must
rerun unchanged on Windows x64; native proof remains pending CI. No ARM64 SDK
ABI correctness or Windows runtime behavior is inferred from this batch.
The receiver repair is unchanged and remains separately qualified by its
existing Mac native receipts.

The declaration generator reads reviewed shape annotations. The spec reviewer
has been asked to carry these two explicit alignment annotations into the live
Windows shapes, preserving all fields, so regeneration retains the SDK repair.
The focused alignment gate will reject output that loses either directive;
no generator special case or shared ledger overwrite was added here.

Integration alone owns Git/index operations and global README updates. Please
selectively link this document from `docs/README.md` and consume the exact narrow
manifest in `docs/status/bindings-windows-context-alignment-ready.json`.
