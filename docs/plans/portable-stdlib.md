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

Atomics increment: preserve bootstrap aliases as entities and implement remaining
integer/pointer arithmetic plus integer/enum bitwise updates with supported CAS.
Retain a minimal failing canonical-intrinsic compiler reproducer. Verify width
wrapping, byte pointer steps, negative bit indices and contended prior values;
do not count missing load/store/exchange lowering as executable alias support.

Deep_Copy increment: preserve public records/globals; register allocation origins
before recursive traversal, use caller/local maps, and honor callback/preallocated
roots. Validate reflected layout and reject fixed arrays/Any explicitly. Keep
the graph regression pending while the compiler emits zero struct alignment;
count only independently verified scalar/string/scalar-array functionality.

BuildCpp increment: use real Unix compiler/archive commands with explicit argv,
reserve per-build intermediate directories, stage complete outputs and check
cleanup before compiler ERROR reporting. Verify static linking, dynamic loading,
standalone objects, working directories/flags, stale archive removal and macOS
universal architecture presence. Reject missing/wrong-target tools and record
unresolved output conventions and unimplemented Windows/cross toolchains.

Treemap increment: stable bucket nodes and copied names, descendant weight sums,
descending sort and cached squarified geometry. Keep Math delegated, call supplied
border procedures with actual parent display records, and use shared boundaries
to prevent accumulated row drift. Validate hierarchy/non-overlap/areas/cache and
growth beyond one bucket; record unresolved border/range/coordinate conventions.

Shared-memory increment: exclusive POSIX objects and captured mapping/name/allocator
ownership; SPSC packet reservation/publication, validated reads/completion and
explicit wrap notifications. Query native backing extent instead of assuming the
requested size. Test full/max-packet/wrap/corruption and mixed interpreter/native
processes; journal test-owned names and retain historical cleanup limitations.
Record unresolved wire contracts rather than claiming reference interoperability.

Autorun increment: exact public helpers/lifecycle over a canonical private Plugin
with typed Compiler bridges, copied arguments and stable singleton storage. Test
real workspace completion/output/child markers and actual error/skip logs. Retain
mixed-spread and CLI orchestration failures; use explicit argv without changing
public signatures, and withhold unspecified callback module parameters.

MPEG increment: canonical live buffer state and checked bit/VLC/start-code/file
operations; generate immutable tables strictly from reviewed data; adapt licensed
public C pixel/IDCT algorithms with explicit bounds and overflow handling. Test
all real paths and canonical reflected names before checkpointing. Continue with
transactional sequence-header parsing and three-frame storage, then demux and
complete audio/video decoding using the authorized MPEG fixture. Do not expose
guessed ambient macros or count missing decoders as complete. Qualified imports
preserve Buffer identity while retaining the original compiler failure. File and
Windows backend completion belongs to the platform-io worker.

Audio increment: checked MPEG-1 Layer II frame/header and allocation/scalefactor
decoding, actual synthesis and interleaved output; preserve canonical quantizer
storage through whole-table addressing, retaining the failing compiler regression.
Compare the independent direct cosine matrix with licensed C basis vectors, and
test zero-allocation silence plus the authorized sixteen-frame tone payload with
rewind. Reject unsupported CRC/format transitions explicitly; retain qualified
constant-write gaps. Continue real PS demux and Plm lifecycle, then seeking and
broader B/AC/stereo fixtures before completing the codec scope.

Program-stream increment: independently bounded private Demux state over canonical
Packet/Plm, with finite MPEG-1 PES and checked timestamps. Feed real public decoder
buffers/callbacks, never extracted test payloads in production. Test whole clip,
bytewise pending headers, larger-than-capacity file refill, borrowed handles,
loop/tick callbacks, tracked cleanup and linear seek behavior. Preserve retained
assertions for truncated PES/timestamps and signaled ring compaction. Document
linear seeks/system-header bounds/buffering and all unsupported formats precisely.

Original MPEG fixture increment: derive valid bitstreams from reviewed VLC data,
not an encoder/reference binary. Exercise intra-coded B display ordering and a
nonconstant AC block, preserving all frame/pixel/timing assertions. Fix EOF pending
reference flush and reject B pictures under the no-delay assumption. Keep direct
motion tests and expand into nonzero stereo/joint-stereo and CRC coverage next.

Stereo increment: original nonzero separate/dual/shared sample fixtures with
channel gains four-to-one. Retain independent range/amplitude/rewind assertions.
Refactor raw quantized decoding from channel reconstruction, avoiding cursor replay
or ignored right-channel scalefactors. Consult only permitted official native C
for scaling/CRC facts, preserve reviewed arrays and record provenance. Continue
protected frames with real checksum validation rather than retaining a CRC skip.

Compiler-refresh increment: source rebuild, then verify original pending atomic,
caller-scope context, reflected alignment/graph and mixed-spread assertions in both
modes. Promote only demonstrated passes; enable the reviewed Remap_Context macro
with nested/early-exit restoration tests and remove Autorun's extra argv array.
Retain constructor/constant/workspace/bitwise failures. Reclassify the scalar __reg
probe accurately and verify actual vector operands before any Meow support claim.

Protected audio increment: retain canonical Audio layout while owning private
checksum state by object identity. Capture its allocator and release metadata in
audio_destroy. Validate the real header/control CRC before reconstruction; test
protected joint stereo, corruption, rewind and tracked cleanup. Reject missing
parsed-header identity instead of silently bypassing CRC; record manual/copy
lifetime and linear registry costs as unresolved contracts/performance limits.

Meow increment: use canonical register operands and exact mutable oracle arrays;
adapt the permitted licensed calico native C algorithm with separate data/register/
finalization/stream responsibilities. Verify whole/fragmented/block flows and both
128-byte outputs against own-source-built C data, including edits/offsets/tails;
check native O0/O2 and interpreter. Preserve scalar rejection and real dump output.
Record raw scratch/store/dump/state-byte/window contracts and untuned backend cost.
Keep NEW-foundation legacy verification in a dedicated target overlay.

SIMD increment: execute allocation-free reviewed scalar operations first; retain exact canonical aggregate ABI, public flags and qualified imports. Record missing load result and gather/looping/interleaving contracts rather than invent signatures. Next implement bounded executable container parsers from reviewed records and official native format documentation, with malformed-input and native/interpreter verification.
