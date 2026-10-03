# Field conversions

## What it is

A record field marked `#as` provides a directional implicit conversion from the containing record to that field's canonical type. `using` controls member-name promotion independently; a field can support either feature or both.

## How it works

```jai
Base :: struct { value: int; }
Derived :: struct {
    padding: int;
    unrelated: Base;
    #as base: Base;
}
read :: (value: Base) -> int { return value.value; }
```

Passing a `Derived` value to `read` reads `base`, regardless of field order or another field with the same type. The source expression evaluates once and the resulting `Base` is a value copy. A `*Derived` supplied where `*Base` is expected projects the address of the marked embedded field; writes through that pointer reach the original storage.

Conversion lookup follows marked fields by `TypeId` and `FieldId`. A unique chain may reach a target through several marked records. Multiple paths to the requested target produce an ambiguity diagnostic; the resolver does not choose the first field or prefer a shorter path. Marked cycles and excessive traversal also produce diagnostics. Reverse conversions require explicit casts and are not supplied by this feature.

Typed record constants use the same path lookup for global initializers and declaration-site field and parameter defaults. Constant projection keeps the selected field's canonical type and retains the existing depth and cell budgets; it does not reinterpret an unrelated nominal record with the same shape.

Overload applicability queries this metadata without executing the source argument. Exact parameter types rank ahead of an embedded-field conversion. Binding the selected call then emits the projection once; multiple call results are captured before any converted destination is written.

The reference tutorials establish value and pointer conversions, independence from `using`, and marked fields at nonzero offsets (`008_types.jai`, `160_type_restrictions.jai`, and `170_modify.jai`). Transitive marked chains occur in supplied bindings; unique reachability and ambiguity rejection are explicit policies in this implementation because the available sources do not fully describe their tie-breaking rules.

Union conversion fields remain unsupported because their active-alternative rules are not established. Pointer conversion uses the shared projected-place address operation; behavior for null pointers projected to a non-first embedded field is not yet established by the source corpus. Pointer-valued marked fields convert a record value to that field's pointer type; they do not introduce implicit pointee dereferencing.

## How to change it

`jai-sema/src/field_conversions.rs` owns directional lookup and lowering. Keep record values on `ValueExpr::Field` and pointer addresses on the shared place arena; neither source names nor byte-offset guesses identify a conversion. `expr_expected` handles mutable pointer projection, and `coerce_value` applies record-value conversions before checking the target domain. Declaration-site defaults call the same pure path finder and project the immutable constant tree. The closed literal evaluator also handles a checked `ValueExpr::Field` when retained field-default jobs lower the source through ordinary expression checking. It validates the owning record and selected field against the canonical schema, converts the entire closed source tree before selecting the field, and rejects expressions requiring execution. Checked integer, float and Boolean wrappers retain their canonical scalar type while exposing an already closed projection. A named typed record refused by the scalar float lookup can use that same closed projection under the actual expected float type. The scalar evaluator retains source rounding, width and arithmetic diagnostics; this fallback accepts only a named closed constant and never executes calls or loads. This keeps field-default preparation consistent with global and parameter constants without skipping source effects.

Local, module, context, and specialized records must retain `FieldDeclaration.conversion` in their shared `RecordMetadata`. Changing the metadata collector must not turn `#as` into `using` or discard either attribute. Source VM tests cover field selection and nominal rules; native fixtures verify copies and pointer mutation through the LLVM backend.

## Configuration

Lookup currently permits at most 128 field projections and 4096 visited states per conversion. These constants bound malformed or highly branching conversion graphs and return diagnostics rather than exhausting the host. There are no new CLI flags or environment variables.

## Dependencies

The implementation uses `jai-syntax` field attributes, `jai-types` canonical field descriptors, semantic record metadata, and `jai-ir` values and projected places. `jai-vm` and `jai-codegen` execute the same checked projection nodes.
