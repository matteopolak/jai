# Portable standard library implementation

The reviewed public specifications in `docs/specs/stdlib/modules` are the API
oracle. All work is inline in this checkout. No reference implementation or
binary is an input. Extensions and the public corpus remain unchanged.

Use one dependency-light `stdlib/prelude/module.jai` containing the specified
bootstrap records. Public module folders contain canonical records and exact
public aliases; private algorithms live under `stdlib/internal` by subsystem.
Mutable public state stays in its facade unless a true entity reexport is
verified. Never replace an unsupported operation with a successful stub.

Sequence:

- [ ] Bootstrap metadata and Runtime_Support output, allocation, context and startup.
- [ ] Basic arrays/allocation, Memory overlap, String and Reflection foundations.
- [ ] Allocator families and temporary storage lifetime.
- [ ] Collections, hashing, sort, random and codecs.
- [ ] Files, paths, processes, threads and sockets.
- [ ] Toolchains, build, graphics, input, audio, fonts, resources and helpers.
- [ ] Review every owned module against its spec, including conditional exports.

For each increment, add spec-derived caller tests before implementation, run
them against a compiler built from the authorized Rust sources, review the diff,
update the module ledger and questions, and commit. Interpreter/native and
target checking are separate evidence; do not infer one from the other.

The module ledger lists every spec page, including reserved ownership and
unimplemented scope. The coordinator owns full integration/corpus/release checks.

Wav_File increment: use byte reads rather than casting potentially unaligned input.
Keep packed public metadata in internal/audio/wav.jai and explicit facade aliases.
Check RIFF/WAVE, bound parsing by both input and RIFF length, advance chunks with
even-byte padding, borrow the first data chunk, and accept PCM/IMA metadata only.
Test PCM, ADPCM extensions/fact, odd unknown chunks, clamped data, and malformed
headers before implementation; then run interpreter/native/target checks and lint.

Remap_Context increment: cache immutable copy plans keyed by foreign metadata
pointer, under a CAS lock. Flatten the leading base aggregate and match stored
field names/sizes, skipping constants and overlay aliases. Copy only validated
extents into a default own context and restore its context_info. The expansion
requires caller-scope push_context,defer_pop, currently blocked by the compiler
reproducer pending/macro-push-context.jai and withheld. Cache storage uses the default own
allocator, so foreign allocator fields cannot interfere with building a plan.
Verify default preservation, shallow pointers, reused plans and lexical restore.

System increment: implement Unix account lookup through reentrant POSIX calls,
copy exposed text into temporary storage, preserve errno's actual entity alias,
and read machine/executable paths through native APIs. Mac processor queries use
documented sysctl selectors; Linux initially falls back to online logical count
where detailed topology/performance selection is unavailable. Withhold CPU
counter and Windows APIs until their real backend is supplied. Tests exercise
real OS results, lookup failure and the selected target declarations.

Text_File_Handler increment: share a byte-line reader across memory/file handlers
and list/table helpers. Keep source remainder separate from owned file bytes;
restart releases only owned bytes and preserves the sticky failure flag. Parse
decimal bracketed version lines when enabled, strip one-byte comments, and track
physical lines. Return independently allocated helper strings so handler teardown
cannot dangle them. Record unresolved ownership/version whitespace contracts.

Overwriting_Allocator increment: retain the exact public table/mutex shape.
Capture its base allocator at construction, allocate bookkeeping from that base,
and serialize allocation tracking and byte poisoning with the real Thread mutex.
Resize allocates first, preserves the old region on failure, copies the common
prefix, poisons/frees the old region, and fills the growth suffix. Validate using
a real forwarding allocator that inspects poison before native free, plus an
injected allocation failure. Integrate the foundations worker's reviewed pointer
hash in target only; do not change its sources or invent a replacement hash.

Unmapping_Allocator increment: reserve anonymous POSIX mappings with a protected
trailing page; expose exactly the requested extent at the end of writable pages.
Track requested lengths in the canonical table. Successful free makes writable
pages read-only and removes the live entry while retaining the mapping. Resize
allocates first and protects the old mapping only after copying. Keep wrapper
owner allocation in a private prefix, since its public shape has no owner field.
Test guards/stale writes in forked children and verify actual signal termination,
plus failure preservation, resize and retained readable data per read-only mode.

Soa increment: generate fixed component arrays from nonconstant, nonoverlapping
stored fields. Preserve field types with type_of(T.member), not reconstructed
type names. Generate indexed gather/scatter code from the same selected fields,
and implement pointer iteration by a temporary element plus deferred scatter so
continue/break/return do not lose writes. Reject reverse iteration explicitly.

Print_Color increment: implement ANSI set/reset, formatted output and scoped Code
expansions with deferred reset. Keep enum values/order and parameter names exact.
Test stdout/stderr selection and reset on return. Native Windows console handling
is not yet supported; reject that branch explicitly while permitting its reviewed
ANSI import configuration. Record unspecified exact escape serialization.

Default_Allocator fallback increment: implement the documented C-runtime branch
using real malloc/realloc/free and its capability/lifecycle contract. Preserve
fallback parameter names and export only allocator_proc/unsafe_reset. Reject the
optimized X64/Switch branch explicitly until its heap API is implemented. Test
successful resize, real oversized failure preservation, free and capabilities.

Memory visualization protocol increment: define reviewed packet schemas in a
private debug subsystem with explicit facade aliases. Preserve every field and
tag value/order, canonical String_Index metadata and native pointer widths.
Validate packet size/offsets independently of any client or transport. Withhold
the comparator until the spec settles equality versus ordering semantics.

Xar increment: map indexes onto fixed exponentially sized chunks (a,a,2a,...),
capture/reuse the first allocator and keep chunk addresses stable. Populate real
iterator coordinates/pointers, implement forward/previous and unordered removal,
and sort in place over indexed chunk pointers. Preserve the quick_sort alias.
Test growth boundaries, lifetime accounting, pointer loops, iterators and sorts;
verify reverse custom iteration is rejected at compile time.

Mail transport increment: use the independent Curl bindings and official libcurl
C API documentation for SMTP/MIME. Compose explicit headers/envelope recipients,
use MIME for selected text/HTML body and binary file attachments, check every
native result, and release all per-send handles/lists. Authenticate only with
caller-provided fields and disable implicit netrc/proxy configuration. Test actual
SMTP on this checkout's loopback receiver: text/HTML, CC/BCC/attachment payloads,
recipient rejection and mandatory TLS failure against a plaintext-only receiver.
Record unresolved SSL policy/serialization and withhold unspecified scramble.

POSIX crash diagnostics increment: retain reviewed public signal/context prefixes,
install checked sigaction handlers, prewarm native backtrace, and provide a real
per-thread alternate stack through native TLS ownership. Emit diagnostics without
depending on the Jai context/allocator, reset/unblock/re-raise the fatal signal,
and verify actual SIGSEGV plus native stack text in separate source-built programs.
Do not interpret the reviewed x64-shaped register prefixes on ARM or claim recovery.

ZIP directory increment: independently decode bounded classic end/central records,
retain borrowed name views into owned directory storage, preserve the documented
retained-file ownership, and reject unsupported ZIP64/multidisk cases. Require
the specified assertions for signatures/descriptors. Verify late parse cleanup
with allocation accounting, and record unresolved position/extension contracts.
