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
Temporary multiple lookup and Walk_Table are also unfinished. md5 returns the
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
