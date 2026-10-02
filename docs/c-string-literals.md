# C string literals

## What it is

A string literal in a `*u8` context produces immutable static bytes with one
appended NUL. This supports literal C-library arguments such as `fopen(path,
"rb")` without changing ordinary String values.

## How it works

```jai
inspect :: (bytes: *u8) -> int { return cast(int) bytes[0]; }
answer := inspect("A");
bytes: *u8 = "A\0B"; // backing bytes: 65, 0, 66, 0
```

Expected-type resolution recognizes the literal and the canonical unsigned-byte
pointer type. It validates a static `[N+1]u8` object and returns its first-element
address. Every source byte is preserved, including embedded or existing trailing
NULs; the compiler appends one additional NUL. Native lowering emits a private
constant global. The VM imports the same graph as readonly storage. Returning a
literal pointer does not borrow a procedure frame.

Ordinary String values retain their descriptor and byte count. A String variable
does not implicitly convert to a C pointer; use the library's explicit C-string
conversion when needed. Writing through a literal pointer fails in the VM;
native programs must respect the backing global's immutable storage.

## How to change it

Update `jai-sema/src/c_string_literals.rs` and the literal-only expected-type hook
together. Overload previews must retain literal origin rather than accepting all
String arguments. Preserve the appended terminator, static lifetime, and readonly
backing. Global/default pointer relocations require an explicit constant-storage
representation; this runtime expression adapter does not invent one.

Source/native tests live in `jai-codegen/tests/c_string_literals.rs`; VM-only
negative tests live in `jai-sema/tests/c_string_literals.rs`. Never execute a
native write to the constant backing as a negative test.

## Configuration

There are no feature-specific flags. Static-data object/node limits apply to
literal backing. Native fixtures use the trusted Clang selection described in
[Native test tools](native-test-tools.md).

## Dependencies

This feature uses canonical `jai-types` identities, expected-type source
resolution, validated IR StaticData/StaticAddress, readonly VM storage, and LLVM
constant globals. Foreign-call fixtures use newly authored C and installed libc;
original reference tools and native objects are never loaded.
