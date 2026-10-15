# Portable data/resource progress

Own source-built jaic/jailint and unchanged repository jaifmt execute here.
No old foundations staging or binaries were used.

Simple_Package implements all reviewed declarations, wire layout, copied names,
borrowed payloads, stable sorted/default and original-order writes, memory/file
and TOC-only loading. Original package-contract passes interpreter and native
O0/O2 on macOS ARM64, including direct TOC parsing, lookup identity, ownership,
real filesystem writes and malformed signature/version/name rejection.

Ico_File helpers have exact reviewed formulas. The provisional single-frame
encoder writes padded bottom-up RGB/RGBA and transparency masks. LLVM RC accepts
both fixtures and macOS sips decodes 16x16. Tiny fixtures are accepted by LLVM
but sips gives no dimensions: tiny decode success is not claimed. Fixed-frame
layout remains unspecified. Real File/stb loading execution remains pending.

Subtitles grammar/render contracts are ready for implementation. Resource defaults
and Icon host protocol still need review; focused remaining questions are ready at
docs/specs/questions/portable-data.md. See the per-API ledger.

Subtitles now implements all exports with live public CSV storage, real grammar,
selection, serialization, HTML and CSV. Interpreter/native O0/O2 pass, compiled
WASI passes filesystem tests. Package compiled WASI also passes. Broader package
checks cover every truncation, UTF-8 names, empty-package rejection, huge counts/
lengths, negative extents and TOC-only overlap. Python independently reads emitted
package and CSV. Real stb filename loading passes interpreter/native O0/O2.

Windows resource backend now has validated portable ICO group conversion and real
private Win32 transactions. Portable directory tests pass interpreter/native O0/O2
and compiled WASI. LLVM RC emits byte-identical group/image payloads and lld-link
links a real resource-only x64 DLL. Windows transactions are x64/ARM64 checked
with strict lint, with original native SDK readback tests prepared but NOT run.
Public Windows policies and all Icon host functions remain pending spec review.
