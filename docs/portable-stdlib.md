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
operations use the context allocator. Scanning, wildcard matching and numeric
token parsing remain unfinished.

## Verification

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
