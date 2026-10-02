# Type values

## What it is

`Type` values identify canonical source types and can occupy ordinary runtime
locals, fields, arrays, parameters, and results. Their storage is one target
pointer to the represented type's immutable `Type_Info` header; a default value
is null. Builtin type expressions and annotations share the same catalog.

## How it works

Expression names first resolve lexical declarations, local values, module
parameters, globals, named types, procedures, and reflection declarations.
Only an unresolved unqualified name falls back to
`jai_syntax::BuiltinType::from_spelling`. This preserves shadowing: after
`int := 42;`, `*int` takes the local value's address; otherwise `*int`
constructs the builtin pointer type. Qualified namespace members do not use a
builtin fallback.

Explicit syntax such as `#Context` resolves through the annotation path.
`size_of(*int)` and `size_of(*#Context)` therefore inspect pointer types without
reading storage. Size queries require an explicitly selected target layout;
`*int` itself does not depend on the target pointer width.

When a type expression acquires runtime `Type` context, semantic resolution
materializes its existing reflection descriptor and creates a checked
`RuntimeTypeConstant`. Each immutable descriptor object owns a private binding
to its represented type, canonical header projection, and target layout. The
binding checks the serialized header and complete supported payload, including
pointer targets, array counts, procedure signature views, enum aliases, and
record member types, offsets, flags, and notes. Child references must name other
checked descriptor bindings. An ordinary record with identical header bytes
cannot become a type identity.

Initialized Type globals use this same checked expression path. `#run` can
return Type cells directly or inside supported record, array, union, and
distinct constants. The VM decoder recovers an opaque identity from the actual
returned pointer, then `RuntimeTypeConstant::from_identity` pairs it with the
retained immutable publication and verifies the exact object binding. Only
certified static descriptor relocations escape the VM; arbitrary virtual
pointers remain non-materializable.

The VM stores virtual descriptor pointers and checks their canonical allocation
and byte offset before recovering a `RuntimeTypeIdentity`. LLVM emits constant
descriptor relocations. Both consumers reject descriptor storage built for a
different target policy. Numeric `TypeId` values are never encoded as pointers.
Same-graph static Type cells use symbolic addresses; nested static-data graphs
inside Type constants are rejected at admission so validation and disposal stay
bounded.

Runtime Type equality compares canonical descriptor addresses while retaining
nominal identity: two separately declared, equally shaped records remain
different types. An explicit pointer cast exposes the real descriptor header.
`Any` boxes a Type by borrowing a typed pointer cell, so source code that reads
`.*cast(**Type_Info) item.value_pointer` obtains the represented descriptor.
The `Any.type` descriptor identifies `Type` itself (tag 13). Captured `Code`
remains a compile-time value without runtime storage.

```jai
identity :: (value: Type) -> Type { return value; }
main :: () -> int {
    value: Type = identity(s32);
    header := cast(*Type_Info) value;
    return header.runtime_size; // 4
}
```

## How to change it

Add builtin spellings once in `jai-syntax/src/types.rs`. Extend annotation
resolution for a new builtin category; `jai-sema/src/type_values.rs` forwards
expression fallback to that resolver. Keep the fallback after ordinary name
resolution in `modules/aggregates/mod.rs` so adding a builtin cannot silently
replace an existing lexical value.

For storage changes, keep `jai-types::RuntimeTypeSchema`, the immutable bindings
in `jai-ir/runtime_types`, the VM pointer codec, and LLVM pointer lowering in
agreement. Extend descriptor serialization and its payload proof together; a
new tag must not gain identity from a matching header alone. Procedure varargs
remain part of canonical signature identity; the source `Type_Info_Procedure`
schema has no separate variadic flag to serialize.

Source fixtures cover default nulls, calls and results, C callbacks, nominal
record identity, record and array cells, conditionals, cyclic reflection
aliases, initialized globals, and nested `#run` Type results. Pure proof tests
reject wrong pointees, truncated descriptor objects, foreign arenas, imitated
headers, and nested static-data ownership chains.

## Configuration

`ResolveOptions.target` or `ResolveOptions.layout` selects target-dependent
reflection. There are no type-value-specific environment variables or flags.
`StaticDataLimits.value_nodes` also bounds retained descriptor metadata and
cumulative descriptor-view validation work. Sharing one backing array across
many descriptor views does not evade that work budget. Native descriptor
lowering requires matching selected `TargetData`; `lower` selects the native
target, while `lower_for_target` accepts a caller-selected target.

## Dependencies

This feature depends on the canonical `jai-syntax` builtin catalog, semantic
scope and annotation resolution, `jai-types` nominal identities and layouts,
reflection graphs and static storage, the VM relocation codec, and LLVM's
selected `NativeTarget`. It introduces no external dependencies.
