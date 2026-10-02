# Target type layouts

## What it is

`jai-types::layout` computes storage sizes, alignment, record offsets, and fixed-array strides from the shared frozen type registry and an explicit target policy. It does not derive layouts from Rust's host representation or establish a foreign procedure calling convention.

## How it works

`LayoutPolicy::new` validates primitive sizes and alignment. Integer entries correspond to 8, 16, 32, and 64 bits; float entries correspond to 32 and 64 bits. Alignment must be a nonzero power of two, and each primitive size must be a multiple of its alignment. Bool storage occupies one byte. Pointer and procedure-value layouts share the policy's pointer representation. `lp64()` is an explicit conventional profile, not automatic host detection.

`LayoutEngine::layout` walks dependencies iteratively and caches results. Struct fields keep declaration order, with padding before fields and at the end. Union fields all start at zero and share storage sized and aligned for their largest requirements. Fixed-array stride is the aligned element size, and multiplication checks for overflow. Empty arrays have zero size but retain element alignment. Empty records have zero size and alignment one. `Type` values hold one target-sized descriptor pointer; their layout does not depend on the represented type's storage size. Void and captured `Code` have no storage layout.

Pointers do not require pointee layouts, so a record containing a pointer to itself has a finite layout. The frozen registry rejects recursive by-value types; the layout walker also detects a recursive dependency defensively. Size addition, array multiplication, and alignment rounding return structured overflow errors. Failed queries may leave valid dependencies cached, but do not cache a failed result.

`tuple_layout(&[TypeId])` computes anonymous sequential aggregate storage without allocating a nominal type or inventing member names. It shares ordinary struct alignment, offset and tail-padding arithmetic, and resolves each child through the same iterative target-selected layout walk. Empty tuples have zero size and alignment one. Invalid or unsized children preserve their structured errors; overflow while assembling the tuple returns `LayoutError::TupleOverflow`.

Shared dependencies and repeated fields reuse one cached layout without being mistaken for recursive values. Zero-size fields still impose their alignment: a zero-length array of an eight-byte-aligned element can add padding even though it contributes no data bytes. The zero-size empty-record rule is this engine's storage policy; foreign ABI classification remains separate. Arithmetic is checked in the `u64` layout domain. A backend must also check the real target's representable object sizes before allocation or address generation.

Record placement metadata keeps a field cursor separately from the maximum occupied extent. `define_record_with_placements` binds checked anchor ordinals to the actual reserved record's `FieldId`s before publishing its definition. The layout engine rewinds the cursor to the earlier field, applies the next field's alignment, continues subsequent fields from the rewound position, and rounds the maximum extent to the final alignment. [Placement metadata](record-placement-layout.md) covers this API and its ownership checks. The native mapper uses byte-backed storage for placed records; source construction still requires ordered writes and genuine no-write initializer support, and its sparse constructors remain explicitly unsupported. Ordinary records supply no anchors and retain their existing layout.

Array views and strings use a descriptor with `count:s64` followed by a data pointer. The array tutorial gives this field order; `005_strings.jai:20` identifies strings as array views of `u8`. Resizable arrays use `count:s64`, data pointer, `allocated:s64`, and an allocator containing two pointers, matching the inspected Preload definition. The returned resizable descriptor offsets describe its four fields, with the allocator remaining one embedded field.

Recent consumer source agrees with the view rule: pinned jaison `typed.jai` reads the count as `s64` at offset zero and the data pointer at offset eight. Vk-Engine's `Common/string.jai` constructs strings as `.{count, pointer}`. Those sources corroborate the conventional 64-bit descriptor, without validating another target's ABI.

For example, the conventional 64-bit policy gives a view size of 16 bytes and resizable descriptor size of 40 bytes. A 32-bit policy with four-byte alignment for 64-bit integers gives sizes of 12 and 28 bytes respectively. These are policy-derived values, not assertions about every 32-bit target.

## How to change it

Record definitions carry `RecordLayout` constraints. `packed` suppresses natural field alignment and puts successive struct fields directly after their predecessors. `field_alignments` optionally overrides each field's alignment, including a reduction below natural alignment; an empty list keeps all fields at their defaults. `minimum_alignment` raises the whole record alignment; final size is rounded to that alignment, including for packed records. Nested records and array strides use the resulting layout. Invalid alignments produce `LayoutError::InvalidRecordAlignment`; a nonempty override list must match the field count. The Windows source `MINIDUMP_EXCEPTION_INFORMATION` combines `#no_padding` with explicit four-byte field alignment, motivating independent field constraints. Semantic checking maps these annotations to the constraints, but the exact tail-padding rule for every source annotation combination has not been established by an executed reference. The target-bound LLVM backend preserves custom offsets using typed packed payloads and verified zero-sized alignment carriers. Projected accesses carry their guaranteed alignment through nested fields and pointer aliases. Foreign C aggregate calls use target-specific classification for custom layouts on Apple ARM64 and Linux System V x86-64; [independent C fixtures](native-custom-record-abi.md) cover packed, reduced, increased alignment, nesting, and arrays.

Distinct and `isa` variants retain nominal identity but forward storage layout to their representation through the same iterative dependency walk. Pointer recursion stays finite; by-value cycles through variants are rejected.

Add type representation rules in `layout.rs` using the canonical `TypeKind` variants. Update `LayoutPolicy` when introducing a new primitive. Keep record metadata and nominal identity in the registry; layouts are derived target-specific results. A source placement adapter resolves an existing field structurally in its defining record, then supplies its ordinal to the transactional definition API. Stored anchors retain actual `FieldId` owners, and the layout engine validates them defensively before calling the private arithmetic helper.

Before connecting aggregate codegen, make its LLVM target data agree with the selected policy and verify generated offsets, allocation sizes, and access alignment against these results. Runtime bounds checks and aggregate initialization are consumers of layout; they do not belong in this module.

## Configuration

Callers select a validated `LayoutPolicy` explicitly; there are no environment variables. Do not select `lp64()` merely because the compiler itself runs on a 64-bit host. The target's primitive alignment requirements must determine the policy.

## Dependencies

The layout engine uses `jai-types`' frozen registry, integer/float domains, and the Rust standard library. Descriptor rules come from the statically inspected `reference/how_to/004_arrays.jai`, `reference/how_to/005_strings.jai`, and the public contracts now defined in the [authored compiler prelude](compiler-prelude.md). No supplied native compiler or library is executed, and there are no new external dependencies.
