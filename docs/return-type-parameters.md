# Return type parameters

## What it is

A procedure can introduce a Type variable in an original result annotation and receive that Type as a named compile-time argument. For example, `convert :: (text: string) -> result: $T, success: bool` accepts `convert(text, T = float64)`.

## How it works

Header discovery visits parameter and result annotations. The template retains every result-introduced Type leaf with its original result ordinal, span, and restriction pattern. Named call matching binds those inputs in result declaration order before checking dependent parameter types. The canonical Type binding joins the existing specialization key; the original runtime parameter list and parameter IDs retain their original positions.

A result Type input must be supplied once by name and must describe a checked compile-time Type. Positional arguments continue to address the original source formals. Duplicate introductions, unknown names, missing inputs, and non-Type values are diagnosed before specialization publication. Pointer, array-element, procedure, and nominal-record result patterns retain their original structure. Result-only inferred counts and record values require an explicit baked source parameter.

Callback Type arguments retain their actual source annotation policy alongside their canonical Type. Names and executable callable policy join the existing specialization key; per-use result obligations such as `#must` follow the checked source call and the original result annotation. Canonical Type equality alone does not supply callback names or obligations.

A `#modify` result introduction keeps its existing modifier-owned slot. The checked modifier can introduce its value before final signature publication without a required named result input.

## How to change it

Update `polymorphism/template.rs` for header discovery and original result-pattern retention. Update `overloads/result_types.rs` and the named matcher in `overloads.rs` for binding or restrictions. Keep result inputs separate from `ArgumentBinding` and source runtime formals. When adding a new candidate constructor, initialize its result inputs explicitly.

Callback policy changes also need the source policy collector and `procedure_values/contracts/generics.rs`. Preserve actual named argument syntax through call binding. Tests in `return-type-parameters.rs` execute genuine source specializations and inspect their runtime signatures; matcher tests cover canonical ordering and accepted projection integrity.

## Configuration

There are no new environment variables or flags. Existing target layout, source preparation, specialization limits, and compile-time execution policy apply.

## Dependencies

This feature uses the source syntax and symbols, the overload matcher, canonical Type registry, existing substitution and specialization worklist, nominal record patterns, and callback source-policy metadata. Runtime lowering and VM execution consume ordinary checked procedure signatures.
