# Portable implementation

This checkout implements the reviewed compatibility specs, using the supplied
Rust compiler and original public-contract fixtures. It preserves Extensions.
The [ledger](portable-stdlib-ledger.md) records all remaining modules explicitly.

## Current foundations

`prelude/module.jai` is the only bootstrap definition site. Its public metadata
records preserve the specified names, field order, enum values and defaults.
Runtime_Support creates the base context, emits output, formats integer radices,
duplicates elements and provides a libc-backed default allocator. Its native
entry wrapper passes an initialized context into the program entry.

Basic facades explicitly alias internal procedures, keeping overload sets and
default argument metadata. Arrays retain their allocator across growth, expose
non-owning writable views, initialize newly added slots, and release storage on
reset. Memory's generic copy implements directional overlapping moves.
String_Builder has a canonical reflected name, inline storage and linked overflow
buffers. It preserves allocation failure state and releases every overflow buffer.
Basic formatting currently handles integer, boolean and string arguments; other
reflected types fail explicitly and remain unimplemented.

String implements byte searches, comparisons, splitting, trimming, replacement,
ASCII case conversion, CRLF normalization, basic token parsing and paths. Fields
returned by split/search/path operations borrow their input. Allocation-returning
operations use the context allocator. Scanning and wildcard matching remain
unfinished.

Reflection implements scalar assignment with cursor consumption, integer range
checks, enum lookup/storage, struct-field lookup and array count/data queries.
Basic integer parsing supports signed limits, overflow rejection and bases 2–36;
floating parsing uses the native C `strtod` ABI. Its locale/error-range behavior
still needs contract review. Numeric String token parsers consume extracted tokens.

The compiler worker resolved inherited overlay layout. Temporary storage is now
enabled with its exact public record, aligned scratch allocation, overflow pages,
marks, resize copying and caller-scope release. Interpreter/native tests verify
that restoring a mark releases overflow pages and restores byte accounting.
Runtime startup now creates owned scratch storage and embedding contexts;
teardown frees its own storage even when a client replaces the active scratch
pointer. Context records honor their required alignment.

The runtime heap uses per-allocation headers around native allocations, with
alignment derived from request size. Typed allocations and array growth therefore
honor over-aligned element layouts with this allocator. Resizing preserves the
common prefix even when alignment changes or the raw allocation shrinks.
NewArray supports explicit alignment and returns the allocation base separately.
Other allocators must supply sufficient alignment for typed New/array storage;
those paths assert insufficient alignment instead of returning invalid typed
pointers. Scratch allocation similarly aligns request sizes and checks overflow.

## Verification

File provides Unix stdio operations, offset whole-file reads, preserving or
truncating writes, builder writes, path resolution, directories and links.
Its native types come from the bindings worker's newly generated POSIX module;
focused tests assemble a separate tree under `target/portable-integration-stdlib`.
No reserved binding source is modified or committed by this worker. Unix file
and reduced-path fixtures pass interpreter/native checks in that assembled tree.
Windows/Android-specific file behavior and the unresolved Seek_Type API remain
unfinished. File_Utilities currently provides component/path manipulation only.

Basic Apollo duration conversion handles signed 64-bit extrema using two-limb
arithmetic. Calendar/clock and floating-to-Apollo APIs remain unfinished.

Bucket_Array maintains stable bucket storage, physical locators, free-slot reuse,
and forward/reverse value/pointer iteration. Runtime output now serializes
native writes with atomic compare/exchange. Runtime algorithms live under
`internal/runtime`; the facade keeps canonical bootstrap records and mutable
synchronization storage. Fault hooks report failures and abort rather than
returning fabricated success. The one-time initializer passes an explicit-Code
test; implicit block conversion through its alias is a recorded compiler gap.

Hash implements the specified byte/string/array sdbm, djb2, FNV-1a and Knuth
operations. Scalar seed mixing and the scalar FNV overload remain unresolved.
Hash_Table implements open addressing, custom callbacks, string keys, tombstones,
duplicates, growth, removal and reset. Default scalar keys fail specialization
until the missing hash formula is reviewed; the original scalar-key acceptance
fixture is retained unchanged and currently fails for that documented reason.
Walk_Table is also unfinished. Temporary multiple lookup now uses the enabled
scratch allocator. md5 returns the
32-character digest and passes three standard digest vectors in both modes.

PCG implements the reviewed pre-advance XSH-RR sequence and all state/global
overloads. Crc implements the non-reflected CRC-64/WE recurrence. Base64 exports
immutable decoder tables and both standard and URL codecs; permissive tails,
LF-only whitespace, first-padding termination and partial errors are tested.

Bit_Array preserves canonical metadata, padding-word mutation and logical versus
selected-bit iteration. Bit_Operations provides generic byte reversal, bit scans
and population count. Sort and IntroSort sort caller views in place. Unicode
implements immutable tables, strict/non-strict decoding, encoding and iteration;
its strict malformed-byte count and truncated-tail behavior have focused tests.
Adpcm implements nibble saturation and complete block decoding to interleaved
little-endian PCM. A two-channel nine-frame block is checked byte for byte.

Pool implements aligned bulk allocation, separate oversized allocations,
accounting, reset retention, stamping, release and allocator modes. Its optional
`USE_UNMAPPING_ALLOCATOR=true` configuration fails explicitly until the native
unmapping subsystem is available. It is not counted as supported configuration.

Basic now includes canonical two-limb integer records, portable full-width
multiplication and signed/unsigned division. Twenty-four independently generated
128-bit division vectors supplement boundary checks. Random uses the reviewed
128-bit multiplicative recurrence and context-backed state; seeding and output
ranges have interpreter/native checks. Memory's optional candidate and unwrap
exports use the portable copying backend, preserving fixed-width byte counts.

The worker built the compiler worker's independent Rust sources with `--locked`
and `CARGO_TARGET_DIR` under this checkout, first without LLVM and then with the
default LLVM feature. No supplied reference binary was executed.

Use `JAIC_STDLIB=$PWD/stdlib target/compiler/debug/jaic -interp <case>` for
interpreter checks. Native checks compile with `-exe target/<name>` and execute
only that generated program. The bootstrap, runtime, array, overlapping-memory,
String and builder tests are separate cases; their passing does not establish
full module or target conformance.

Remaining runtime work includes optional crash backtraces and platform startup
adaptation. Windows/WASI native libc adaptation has not been implemented.

RadixSort implements stable byte passes for u32/u64/float rank arrays, retained
capacity, invalidation, reordering and resource release. Relative_Pointers
implements signed-width XOR encoding, null/self references and relocation.
File_Utilities adds Unix metadata, recursive enumeration and copying with cycle
detection, and rejects copying a file onto itself or a directory into itself.

Socket exposes reviewed native declarations generated from specs, plus Unix
blocking/keepalive, formatting, accept/bind/close and fd-set helpers. Focused IPv4
loopback and numeric IPv6 formatting pass interpreter/native tests. Windows
wrappers, iOS/console targets, some native shapes and ancillary-data helpers
remain incomplete; [native declaration ledger](socket-native-ledger.json) records
declaration status separately from runtime and ABI verification. The macOS
in_addr shape was checked against Apple's public SDK netinet/in.h. The spec
parser used by the generator is new independent work copied from the bindings
worker; no other checkout was modified.

Thread implements POSIX release mutexes, condition variables, semaphores,
suspended startup, per-thread context/scratch ownership, completion and joining.
Its mutable public initialization handler is read through the actual facade
entity; assigning it after init but before start is tested. Work groups provide
queues, stealing, completion retrieval and bounded shutdown. Tests verify actual
worker execution, recursive mutexes, condition wakeups, copied borrowed storage,
and a failed zero-timeout shutdown followed by successful completion/cleanup.
Windows/iOS/console, debug tracking, race-detector and automatic workspace
metadata remain unfinished. Parameterized records are loaded into the public
module scope so default-versus-explicit module instances preserve nominal
identity; Hash_Table and Pool use the same pattern.

Run the focused worker regression set with:

```sh
python3 -B tools/check_portable_stdlib.py \
  --posix-root ../bindings/stdlib/POSIX --native \
  --check-target linux/x64 --check-target windows/x64
```

The current run passes 47 cases in interpreter/native modes, plus bootstrap
checks and supported portable target checks. Platform-dependent cases are not
represented as Windows support. Pending compiler reproducers are stored under
`tests/portable-stdlib/pending` and are not counted as passing functionality.

Process implements Unix argument-array launching, launch-error reporting,
independent stdout/stderr capture, bounded waits, cancellation, native status,
and stream APIs. A supervisor owns/reaps the actual child, honors parent-exit
cancellation and its opt-out, and reports the actual child pid. Supervisors close
inherited handles from other Process instances so a retained second process
cannot suppress the first one's parent-exit notification. Four additional
interpreter/native parent-lifetime scenarios verify this OS-visible behavior.
Large dual-stream capture, nonzero exit, failed launch, timeout, actual pid and
broken stdin are tested. Pipe writes preserve the calling thread's signal mask
and consume only a newly generated SIGPIPE, avoiding process termination on
ordinary EPIPE errors. Windows and the noted interactive/live teardown contracts
remain unfinished or under review; unknown final status asserts rather than
fabricating an exit result.

Command_Line generates canonical Is_Set(T) boolean fields from runtime metadata,
preserves option defaults and explicitness, handles fixed arrays/scalars, rejects
duplicates and enum flags, and returns caller-owned free arguments. Its default
argument path acquires/frees the vector while borrowing the OS argument strings.
Help emits notes/comments and honors sorting/prefix/alignment flags; exact help
wording and the recorded parser edges remain under review. Interpreter regression
invocations use the documented trailing -- so argv-dependent tests receive the
same executable-name convention as native programs; the library does not invent
an argument when an embedding host explicitly supplies argc=0.

The source-built jailint passes with `-D warnings` on Command_Line, its argument
acquisition helper and caller tests. The jaifmt build was retried against the new
integration modules and currently fails at jaifmt/main.jai:53: missing Basic.exit.
That completion now belongs to the foundations worker. Formatting/check evidence
remains outstanding; no formatter success is claimed. The Basic print-to-builder
overload alias was added while attempting that tool build.

Apollo duration arithmetic currently assumes signed integer femtoseconds. The
reviewed page does not explicitly settle representation and rounding edges;
round-trip tests are internal arithmetic evidence only. See the questions page
before relying on compatibility or adding calendar/native-time conversions.

The single prelude entry loads independent subsystem files for platform,
allocation, storage, reflection, diagnostics, intrinsics and context declarations.
All share the same bootstrap module scope; no duplicate bootstrap/types/storage
were introduced. Socket generation groups layout types, native calls, mutable
data and constants, sorting independent names while preserving overload order
within a name and every aggregate member/enum value.

Lint with the new POSIX integration dependency exposed unused native-result
variables that the dependency-incomplete root analysis had not reached. Process
now checks supervisor pipe delivery, signal-disposition installation, child
cancellation/reaping and cancellation-request failures. Supervisor report-write
failure exits with a failure status; a failed initial announcement cancels and
reaps the unannounced child. No ignored-result renaming or lint suppression was
used to resolve these findings.

The integrated source-built lint command passes with `-D warnings` for prelude,
Runtime_Support/runtime, Process, Thread, Command_Line, Wav_File/audio, Pool and
allocation internals, Hash_Table/collection internals, Socket/net internals.
The same post-change regression command passes all 47 cases plus the four
parent-lifetime scenarios and selected portable target checks. Formatting remains
blocked by the documented formatter dependency, separately from lint success.

Remap_Context provides both remap_context overloads with immutable cached copy
plans protected by a CAS lock. Stored field names and byte sizes are matched
across base/custom fields; invalid extents are skipped and diagnosed. Absent or
size-mismatched fields keep own-context defaults, pointers remain shallow copies,
and context_info always identifies the own context. Cache allocations use the
default own allocator, independent of the foreign allocator being copied.
Cache metadata persists for the module lifetime, matching the metadata-lifetime
requirement. Tests cover defaults, pointers and values changing under a reused
plan. The Remap_Context expansion is withheld pending its documented compiler
scope failure; the failed assertions remain in the pending reproducer.
