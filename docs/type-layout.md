# Target type layouts

## What it is

`jai-types::layout` computes storage sizes, alignment, record offsets, and fixed-array strides from the shared frozen type registry and an explicit target policy. It does not derive layouts from Rust's host representation or establish a foreign procedure calling convention.

## How it works

`LayoutPolicy::new` validates primitive sizes and alignment. Integer entries correspond to 8, 16, 32, and 64 bits; float entries correspond to 32 and 64 bits. Alignment must be a nonzero power of two, and each primitive size must be a multiple of its alignment. Bool storage occupies one byte. Pointer and procedure-value layouts share the policy's pointer representation. Metatypes currently have no runtime storage. `lp64()` is an explicit conventional profile, not automatic host detection.

`LayoutEngine::layout` walks dependencies iteratively and caches results. Struct fields keep declaration order, with padding before fields and at the end. Union fields all start at zero and share storage sized and aligned for their largest requirements. Fixed-array stride is the aligned element size, and multiplication checks for overflow. Empty arrays have zero size but retain element alignment. Empty records have zero size and alignment one. Void and `Type` have no storage layout.

Pointers do not require pointee layouts, so a record containing a pointer to itself has a finite layout. The frozen registry rejects recursive by-value types; the layout walker also detects a recursive dependency defensively. Size addition, array multiplication, and alignment rounding return structured overflow errors. Failed queries may leave valid dependencies cached, but do not cache a failed result.

Shared dependencies and repeated fields reuse one cached layout without being mistaken for recursive values. Zero-size fields still impose their alignment: a zero-length array of an eight-byte-aligned element can add padding even though it contributes no data bytes. The zero-size empty-record rule is this engine's storage policy; foreign ABI classification remains separate. Arithmetic is checked in the `u64` layout domain. A backend must also check the real target's representable object sizes before allocation or address generation.

Array views and strings use a descriptor with `count:s64` followed by a data pointer. The array tutorial gives this field order; `005_strings.jai:20` identifies strings as array views of `u8`. Resizable arrays use `count:s64`, data pointer, `allocated:s64`, and an allocator containing two pointers, matching the inspected Preload definition. The returned resizable descriptor offsets describe its four fields, with the allocator remaining one embedded field.

Recent consumer source agrees with the view rule: pinned jaison `typed.jai` reads the count as `s64` at offset zero and the data pointer at offset eight. Vk-Engine's `Common/string.jai` constructs strings as `.{count, pointer}`. Those sources corroborate the conventional 64-bit descriptor, without validating another target's ABI.

For example, the conventional 64-bit policy gives a view size of 16 bytes and resizable descriptor size of 40 bytes. A 32-bit policy with four-byte alignment for 64-bit integers gives sizes of 12 and 28 bytes respectively. These are policy-derived values, not assertions about every 32-bit target.

## How to change it

Add type representation rules in `layout.rs` using the canonical `TypeKind` variants. Update `LayoutPolicy` when introducing a new primitive or an explicit alignment directive. Keep record metadata and nominal identity in the registry; layouts are derived target-specific results. Padding/packing annotations, foreign ABI argument classification, native FFI ABI verification, and backend target-data agreement require additional work before external aggregate calls can be supported.

Before connecting aggregate codegen, make its LLVM target data agree with the selected policy and verify generated offsets, allocation sizes, and access alignment against these results. Runtime bounds checks and aggregate initialization are consumers of layout; they do not belong in this module.

## Configuration

Callers select a validated `LayoutPolicy` explicitly; there are no environment variables. Do not select `lp64()` merely because the compiler itself runs on a 64-bit host. The target's primitive alignment requirements must determine the policy.

## Dependencies

The layout engine uses `jai-types`' frozen registry, integer/float domains, and the Rust standard library. Descriptor rules come from `reference/how_to/004_arrays.jai`, `reference/how_to/005_strings.jai`, and the already vendored `vendor/jai-0.2.009/modules/Preload.jai`. No supplied native compiler or library is executed, and there are no new external dependencies.
