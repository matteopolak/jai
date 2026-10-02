# Universal values

`Any` is a universal language type whose storage contains a `*Type_Info` and a
`*void`. Its payload remains in the original storage. It is the element type used
by Jai formatting argument packs such as `args: .. Any`.

## Source contract

The static input contracts are `reference/modules/Preload.jai:239`,
`reference/how_to/030_any.jai:89`, and `reference/modules/Basic/Print.jai:323`.
These source files are read as evidence; the supplied compiler and native
libraries are not loaded or executed.

- A place converted to `Any` retains that place's address. Subsequent writes to
  the place are visible through `value_pointer`.
- A value without storage is evaluated once and materialized in its evaluating
  procedure's frame. A top-level compile-time evaluation owns the temporary for
  that request. The descriptor borrows this temporary.
- An `Any` converted to `Any` copies its descriptor without another boxing layer.
- The pointers have no implicit ownership or reference counting. Returning an
  `Any` that borrows local storage does not extend that storage's lifetime.
- The zero value has two null pointers. Formatting source explicitly handles
  this value before reading its type tag.
- `Any = ---` starts uninitialized. Writing each pointer field makes that field
  readable; the whole descriptor becomes readable once both fields are written.
  The VM tracks initialization instead of supplying implicit null values.

`String.scan` explicitly allocates and copies each payload into temporary
allocator storage (`reference/modules/String/module.jai:689`). That source-level
copy is separate from compiler boxing. `scan2` accepts pointer arguments boxed as
`Any`, reads the pointer from their payload, and constructs a descriptor for the
pointed-to value (`reference/modules/String/module.jai:744`).

`Basic.Print` uses canonical descriptor pointer equality to recognize formatter
records and reads the payload according to its descriptor. Its `.ANY` case
recursively reads a descriptor already embedded in a struct or array. Reflection
must report tag `10` for the universal type, rather than treating it as an
ordinary named struct.

## Representation and flow

`TypeKind::Any(RecordId)` gives the universal type a distinct language identity
while sharing record storage, field identities, projection, and byte encoding.
`AnySchema` binds that identity to the compilation's actual `Type_Info` header
type. It validates the two field IDs and the exact `[*Type_Info, *void]` shape.
An arbitrary struct with the same fields does not acquire universal conversion
rules.

Conversion rechecks the schema's universal identity, header, and field owners
against the supplied type view before classifying identity or borrowing. A
schema from another compilation cannot certify boxing even when the source
value is a valid scalar in the new registry. Freezing preserves the original
schema and its conversion behavior.

The contextual compiler tag `Universal :: #type any;` selects the same canonical
type, as used by the pinned OpenJai compatibility sources. Ordinary lower-case
`any` remains a named type or value and may be shadowed; it is not a global
builtin spelling. This tag does not adopt OpenJai's separately declared
`Type_Info` records or add host bindings to its foreign printing declarations.

`AnyStorageBridge` certifies the designated source `Any_Struct` mirror against
the exact pointer types and selected target layout. Its fields retain their own
nominal owner IDs. Explicit pointer views may expose the same bytes, while a
mirror value converted to `Any` is boxed as its ordinary record type. The bridge
does not merge the source declaration with the universal language identity.

The storage accessors shared by layout, checked IR, the VM, and LLVM accept
record-backed types. Source nominal record lookup remains separate. This keeps
universal values usable by normal field and aggregate operations without
changing what a source record declaration means.

Box construction obtains the represented type's canonical immutable descriptor,
takes or materializes the payload address at the point of evaluation, erases the
payload pointer to `*void`, and builds the descriptor. Jai argument packing then
collects descriptors into a slice. Foreign C variadic calls instead apply their
ABI promotions and pass ordinary arguments.

The public `type` and `value_pointer` fields remain writable. A schema proof
validates their storage types; it does not prove that a descriptor manually
assembled by source code describes the allocation behind its pointer. Extracting
a value uses the explicit typed pointer cast and dereference operations, which
retain VM address provenance, bounds, and released-storage checks.

## How to change it

`crates/jai-types/src/any.rs` owns schema proofs, field choices, and conversion
classification. Changes to the universal storage must also update the canonical
registry definition, reflection tag materialization, and target layout tests.

Preserve the difference between borrowing a place and evaluating a value.
Hoisting a temporary assignment before a conditional or call changes branch and
argument evaluation order. Materialization must remain an expression operation,
evaluate its operand once, and register its storage with the caller's frame.

Descriptor copies must retain both pointers. Do not clone the payload or move
temporary ownership to the callee. Keep string descriptor backing storage and
the descriptor slot's lifetime distinct.

Compile-time calls may consume boxed arguments and publish scalar results. A
borrowed pointer into request-owned temporary storage must not be promoted into
persistent compiler state. The VM checks publication while handles are still
live, then releases the request's temporary allocations.

Runtime metatype support coordinates target layout, typed IR, VM byte encoding,
and LLVM storage. A type value's payload contains the
canonical `*Type_Info` address, because the formatter dereferences an
`**Type_Info` payload. A numeric registry ID or a fabricated descriptor cannot
substitute for that pointer cell.

## Configuration

Storage uses the compilation's `LayoutPolicy`: the fields begin at offsets `0`
and `pointer.size`; total size is twice the pointer size and alignment is the
pointer alignment. VM allocation, value-cell, evaluation-depth, and fuel limits
also apply to materialized payloads. There are no Any-specific environment
variables or hidden allocators.

## Dependencies and current boundaries

The active source fixtures in `crates/jai-sema/tests/any_values.rs` cover borrowed
fields and indexes, conditional evaluation, mutable descriptors, frame escape,
and Jai argument forwarding. Mixed scalar/spread packs check evaluation once,
preserved payload aliases, and caller temporary lifetime. Native fixtures in
`crates/jai-codegen/tests/any_values.rs` compare VM results with LLVM emitted by
this compiler and fresh executables compiled by the installed Clang. They also
check fixed `#c_call` descriptor arguments and results. These fixtures use only
independently authored input; they do not execute supplied native tooling.
`crates/jai-codegen/tests/foreign_abi.rs` additionally exchanges the descriptor
with an independently authored C function and verifies both returned pointer
identities and mutation of the pointed-to integer.

Run the focused checks with `cargo test -p jai-types any::tests --lib`,
`cargo test -p jai-sema --test any_values`, and
`cargo test -p jai-codegen --test any_values`. Native tests accept `JAI_RS_CLANG`
to select the trusted Clang executable.

Universal values depend on the canonical type registry, the reflection header
schema and static descriptor addresses, record storage validation, pointer
provenance, and frame temporary cleanup. Formatting still requires the actual
`Basic` builder, allocator, reflection, and output dependencies; boxing alone
does not establish full standard-library acceptance.

Runtime `Type` payloads use the compilation's validated `RuntimeTypeSchema` and
canonical immutable descriptor addresses. Literal types are reified before
boxing; dynamic type lvalues retain their original pointer cell, so later
assignments are visible through the descriptor. `Basic.Print` reads that payload
as `**Type_Info`.

Procedure payloads retain a callable cell with the canonical procedure signature.
Reading that cell through its actual procedure type preserves call validation.
The original formatter additionally reads it through `**void`
(`reference/modules/Basic/Print.jai:795`). The VM now retains an opaque code
origin from a Memory-certified complete procedure relocation. Null tests,
identity, pointer truth, exact integer roundtrips, and reboxed recovery with the
original signature preserve the canonical code token. Data reads, nonzero
offsets, wrong-signature recovery, transformed integer inverses, and portable
`#run` publication are rejected. No data allocation or numeric `ProcedureId`
stands in for the address. See [virtual code addresses](virtual-code-addresses.md)
for the certificate and lifetime contract.

Full procedure printing also needs its ordinary pointer formatter: the boxed
code address is read as `u64`, divided into digits, and used for control and
alphabet indexing. Those address-derived operations remain unsupported in the
VM until diagnostic value/control taint and output consumption are implemented.
The opaque cell view alone does not establish full formatter acceptance.

Captured `Code` has no runtime storage. The pinned Jaison library's
`corpus/upstream/rluba--jaison/typed.jai:44` constructs descriptors by assigning
the supplied `*Type_Info` and payload pointer before calling the ordinary
`print_item_to_builder` body. Its integer, floating-point, and enum cases depend
on writable descriptor fields and unchanged borrowed payload storage. This is a
source contract for the existing construction path; complete JSON parsing and
printing also require Jaison's reflection, allocator, string-builder, and Basic
dependencies. See [Focus and Jaison acceptance](focus-and-jaison-acceptance.md)
for the measured application boundary.
