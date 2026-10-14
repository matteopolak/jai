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

Temporary-storage implementation is pending a compiler inherited-overlay gap.
Its exact public type declaration and algorithms are retained in
`internal/basic/temporary.jai`, which is deliberately not loaded or exported.
The associated test is a pending reproducer, not a passing functionality claim.

## Verification

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

Remaining runtime work includes synchronized output, embedding initialization,
temporary-storage lifetime, one-time synchronization, platform startup and fault
hooks. Windows/WASI native libc adaptation has not been implemented.
