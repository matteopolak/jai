# Custom record C ABI verification

## What it is

`foreign_custom_records.rs` checks custom record arguments and results against independently compiled C code. `foreign_custom_records_source.rs` also resolves actual Jai declarations, calls a C function, and passes a generated `#c_call` procedure to C as a callback. Its main procedure also reads an implicit context field initialized to two; the C callback excludes the hidden Jai context pointer.

## How it works

The direct fixture builds checked registry types and uses the production C classifier, parameter decoder, call marshaler, and return encoder. C consumes returned fields and calls generated definitions, which forward their decoded arguments to C and return the resulting records. Every field has a nonzero expected value, so passing the wrong carrier, field offset, or indirect storage is observable. Both LLVM and C run at `O0` and `O2`; linked programs must return `42` before a five-second deadline.

The C source uses no headers and asserts record size, alignment, and selected field offsets with `_Static_assert`. Its declarations match these semantic layouts:

| Case | C attributes | Size / alignment | Field offsets |
| --- | --- | --- | --- |
| `u8, u64` packed | record `packed` | 9 / 1 | 0, 1 |
| `u8, u64` reduced | record `packed, aligned(4)`, field `aligned(4)` | 12 / 4 | 0, 4 |
| two `u64`, alignment 32 | record `aligned(32)` | 32 / 32 | 0, 8 |
| two `float`, packed | record `packed` | 8 / 1 | 0, 4 |
| two `float`, alignment 16 | record `aligned(16)` | 16 / 16 | 0, 4 |
| packed parent with packed child | both records `packed` | 10 / 1 | 0, 1 |
| array of two packed children | child record `packed` | 18 / 1 | 0 |
| one `u64`, packed | record `packed` | 8 / 1 | 0 |
| one `u64`, alignment 16 | record `aligned(16)` | 16 / 16 | 0 |
| nested single `float` | no attributes | 4 / 4 | 0 |

A separate test asks installed Clang to emit LLVM for ARM64 and x86-64 macOS/Linux/Windows, wasm32/wasm64, ARM64 Android and iOS targets. It compares actual function carriers and `sret`, `byval`, and alignment attributes with the selected canonical classifier. Nested homogeneous-float return structures are normalized to the same floating-register members because Clang retains nested grouping while the backend uses a flat carrier; the native nested-float fixture verifies both adapter directions. Other carrier shapes are compared exactly. Named source structures are normalized by their carrier members; names and LLVM packedness do not establish a register calling convention. The same builder has an object-emission gate at `O0` and `O2` for all ten targets, verifying parameter decoders, direct and indirect outgoing calls and return encoders. These cross-target checks do not execute cross-target binaries.

The edge cases distinguish layout from register classification. Packed single-word storage can still use a direct integer carrier. System V x86-64 ignores trailing padding when no field occupies that eightbyte; Apple uses an `i128` carrier for a small non-HFA aggregate with alignment 16. Packed contiguous floats remain homogeneous on Apple, while extra tail padding prevents that classification. Unaligned integer fields require System V x86-64 memory passing with parameter alignment at least eight bytes and source alignment retained on the result pointer.

## How to change it

Add a case to the registry definitions, literal tree, and independently written C declarations. Keep size and offset assertions in both languages. Exercise both incoming parameters and outgoing results; a test that only declares a function cannot verify marshaling. Add source coverage when introducing syntax or nominal-type behavior, and keep it separate from the dependency-only classifier fixture.

Classifier changes belong in `abi.rs`; argument, result, and definition adapters belong in `foreign.rs`. The physical custom record representation is documented in [LLVM type lowering](llvm-types.md). Pointer-derived accesses must preserve their proven alignment when reading or writing custom fields.

## Configuration

```sh
LLVM_SYS_221_PREFIX=/opt/homebrew/opt/llvm RUSTC_WRAPPER= CARGO_TARGET_DIR=target cargo test -p jai-codegen --test foreign_custom_records --test foreign_custom_records_source --locked -j1
```

The fixture uses the shared [native test tool selector](native-test-tools.md) to locate and verify installed Clang 22 without assuming a platform prefix. Native emission uses the selected host target. The canonical target oracle explicitly selects each target and `-ffreestanding`; it requires no target headers, libraries, linker, or emulator. macOS linking uses `-Wl,-no_fixup_chains` to permit packed pointer relocations. No reference native object or runtime is loaded.

## Dependencies

The direct fixture uses `jai-types`, `jai-codegen`, `jai-llvm`, Inkwell/LLVM, and Rust's standard library. Source coverage additionally uses `jai-syntax`, `jai-modules`, `jai-sema`, and the VM's no-effects compiler adapter. Trusted installed Clang compiles only the self-authored C fixture and links only newly emitted objects with the installed system runtime.
