# Nominal type variants

## What it is

`#type,distinct` and `#type,isa` create nominal types with an existing type as their storage representation. Transparent aliases continue to share the target's identity.

## How it works

Named variants reserve their identity before aliases and record fields resolve. The registry retains the variant kind and representation identity; target layout follows the representation without replacing the nominal identity. Representation and ancestry walks are iterative and diagnose cycles.

The runtime helpers in `modules/aggregates/variants.rs` permit literal conversion and same-identity copying. A nonliteral base value needs an explicit cast to a variant. `isa` values can convert to their base and through further `isa` ancestors, but bases and sibling variants do not implicitly convert to a child. This follows the examples in `reference/how_to/180_type_variants.jai`.

Explicit casts unwrap the source variant chain, perform the requested scalar conversion, and wrap the destination chain. Integer checked casts retain the existing range checks. Numeric binary and unary operations operate on the underlying value and rewrap numeric results; comparisons return bool. For example, `Handle :: #type,distinct u32; a: Handle = 5; b: Handle = 3*a + 2;` retains `Handle` for `b`. `value: u32 = 5; a: Handle = value;` requires `cast(Handle) value`.

Anonymous variants, variants of record member storage, and the experimental `isa` operator-overload result restoration are not fully implemented. Registry/layout support alone does not establish runtime support for every representation.

## How to change it

Change nominal reservation and named alias resolution in aggregate `types.rs`. Add conversion and operator rules in `variants.rs`, then connect the shared aggregate coercion and expression-dispatch hooks. Keep variant identity explicit with IR `Distinct`/`UnwrapDistinct` nodes; do not replace it with a scalar expression type. A future mutable projection into a record variant needs a checked representation projection in the common place model.

## Configuration

Source type-variant syntax selects the relationship. There are no environment variables or runtime flags. Layout still uses the selected target policy.

## Dependencies

Variants use syntax type expressions, module declaration identities, the common type registry, checked scalar casts, common IR wrappers, and their VM/LLVM consumers. No reference compiler or native library is executed, and no external dependency is added.
