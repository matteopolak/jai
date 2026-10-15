# Basic public context and arithmetic repair

The latest user assignment extends this worker to these focused Basic/Math
changes. Earlier Extensions commits remain intact; no Extensions production,
portable clock/calendar implementation, or compiler scaffolding is edited.
The explicitly authorized independent candidate8b134bdb compiler source is
staged in ignored artifacts/core-candidate and source-built into local T7.
This reads that authorized candidate tree only, not original or quarantined
history. Its relevant library substrate matches the current working sources.

## Shared context and configured builder layouts

Unparameterized internal/basic-context now owns the one `Context.print_style`
field, alongside the existing memory-debugger context flag. Formatter records
have one canonical owner, so configured Basic instances expose the same
Print_Style/FormatInt/FormatFloat/FormatStruct/FormatArray/Formatter identities.
The public facades retain their declaration names and alias the shared types.
Printer entry points consume the actual context field; no local style fallback
or conditional absence check remains.

String_Builder retains its reviewed configuration-dependent layout. A small
parameterized pure type module owns that layout, and the canonical context
callback signature uses its assert-enabled configuration. Instances with
ENABLE_ASSERT=true share that exact builder type and call callbacks directly.
ENABLE_ASSERT=false printers bridge through a correctly typed canonical scratch
builder: copy the existing byte prefix, invoke the real callback, transfer its
result and failure/allocator state back, then release scratch buffers through
the owning implementation. No incompatible builder pointer is reinterpreted.
The bridge may allocate/copy, which is an explicit cost of crossing these two
reviewed buffer layouts. Cross-configuration raw buffer-pointer identity is not
offered; the reviewed spec already requires consistent configuration when
exchanging String_Builder values.

Regressions verify one reflected context field across three Basic
instances, shared type identities, real style-sensitive integer/array output,
context-copy isolation, and a5000-byte custom callback that reads its prefix.
The callback runs through both layouts under a counting allocator with no live
allocations remaining. Declining callbacks preserve their bytes before default
rendering, and explicitly formatted values cross Basic instances with canonical
formatter identities. The existing Basic configuration/formatter and Json
numeric ownership regressions also pass interpreter/native O0/O2.

`python3 tests/portable-stdlib/check-core-public.py` replays seven focused
programs in all three modes plus warnings-denied lint of the four new roots.
The measured result is39/39 commands passing. Actual formatting and loaded-source
strict lint also pass. The actual host is Mac arm64; no cross-platform runtime
or full public-corpus integration is claimed. Durable commands/stdout/stderr
are in ignored artifacts/core-public-verification/results.json.

## Public arithmetic and existing supported APIs

Reviewed S128 addition/subtraction and U128 subtraction use full limb arithmetic
with carry/borrow and modular128-bit results. Apollo_Time inherits the reviewed
S128 interface: normal public time conversions accept expressions such as
`to_milliseconds(end - start)` without a fabricated Apollo-specific export.
Reviewed Vector2 scalar multiplication is symmetric, and division works in
both scalar positions. Componentwise vector multiplication/division are also
implemented; scalar addition/subtraction are not added.

Basic.free(pointer/string) and Hash_Table default hashes for integers, booleans,
enums, pointers, floats and strings already work on the authorized substrate.
Regression coverage uses real allocator ownership, table_set versus duplicate
table_add semantics, and record keys with the reviewed explicit hash/equality
callbacks. Unsupported default record hashes are not invented. No allocator
named arguments, Basic.get_time, Swap or bubble_sort aliases are introduced.

The adopted compiler checkpoint also closes the earlier independently reduced
Http client audit dependency: the exact production lint context and its
18-check reduction/control runner now pass. This is verified source-built
candidate behavior; no Extensions production workaround or compiler source
edit was introduced in this worker.
