# Procedure values, prototypes, and context

## What it is

Procedure signatures carry their parameter and result types, calling convention, and context mode. Foreign and compiler-provided declarations are bodyless `ProcedurePrototype` declarations, separate from procedures with source bodies.

## How it works

The parser preserves `args: .. T` as a typed variadic parameter, including its position among later named parameters. This is the syntax used by the pinned recent Focus source: Jai procedures use typed packs and C declarations use the same spelling with a C calling convention. Their runtime argument representations differ, so semantic lowering must inspect the convention rather than treating every pack as C ellipsis.

`#c_call` selects C calling convention and disables implicit context. An explicit `#no_context` alongside it is accepted. `#foreign` also selects C calling convention and no context, and preserves its optional library name and external symbol alias. For example:

```jai
c_free :: (memory: *void) #foreign libc "free";
Handler :: #type (values: ..int) -> int #c_call;
```

A foreign prototype has no executable block. Its declaration must become an external IR prototype or produce a diagnostic; lowering it as an empty defined procedure would incorrectly validate missing returns and generate a function implementation.

`#compiler` declarations preserve an optional string tag in a compiler binding. A following source block remains a defined procedure with a compiler annotation: the compile-time VM can use its registered compiler operation, while ordinary runtime compilation retains and validates the fallback body. Parsing a tag does not grant access to a compiler host capability. The compiler binding resolver must identify supported declarations from trusted source scopes.

Procedure values preserve their canonical signature when stored, passed, and called indirectly. This includes ABI and context mode, so assigning a C callback to an implicit-context Jai procedure type fails. Indirect calls evaluate the callee once, then argument expressions in source order. Multiple results use result destinations rather than constructing a runtime tuple.

Procedure storage defaults to a typed null value, and `null` can initialize or clear a callback. Conditions test whether a callback is bound. Equality compares procedure identity while requiring the same canonical signature. Code addresses cannot participate in data-pointer arithmetic or dereferencing. An explicit cast can retain the same canonical procedure signature or create a typed null; a different ABI, context mode or argument/result shape remains invalid.

C variadic calls omit the source pack from their fixed signature and promote booleans and integers narrower than 32 bits to `s32`, and floats to `float64`. Enum arguments use their declared integer representation before these promotions; wider enum representations retain their width and signedness. Jai variadic calls construct an ordered temporary fixed array and an owning-frame slice view; trailing declared parameters require defaults and are supplied by name.

`callee(..values, extra)` forwards a typed Jai slice or array to the variadic slot without boxing its elements again. The spread marker closes that slot, so following positional arguments bind the declared trailing parameters. A C variadic signature cannot accept a Jai descriptor spread. A scalar prefix followed by a spread slice uses ordered concatenation into temporary backing storage. The normal descriptor-forwarding path remains direct. Temporary backing must stay inside the owning call frame; the VM and native backend reject escaping references rather than returning a dangling slice.

Named callback arguments use metadata attached to the source binding. An annotation such as `callback: (left: int, right: int) -> int` supplies those names; an inferred `callback := procedure_name` retains that declaration's names and defaults. Parameter annotations, record fields, and type aliases retain their names too. Inferred global and record callback defaults inherit the initially bound declaration's names and defaults, while explicit annotations retain their own contract. Result-use annotations such as `#must` follow the same source-binding metadata paths; see [required procedure results](result-obligations.md). Names, defaults and result-use annotations do not participate in canonical signature equality, so two bindings of the same procedure type can expose different parameter names without changing their ABI.

```jai
digits :: (a: int, b: int = 2) -> int { return a * 10 + b; }
main :: () -> int {
    callback := digits;
    return callback(a = 4); // 42
}
```

Unnamed procedure type parameters support positional calls. Naming an argument that has no binding name produces a diagnostic. Explicit type annotations supply their own names rather than inheriting the assigned procedure's parameter names or defaults.

Implicit context is preserved in signature identity and uses the shared typed carrier described in [implicit context](implicit-context.md).

## How to change it

Edit `jai-syntax/src/procedures.rs` for signature modifiers, parameters, and prototype bindings. Update module declaration handling whenever adding a prototype binding or new declaration kind. Keep defined procedures and prototypes separate so downstream consumers explicitly choose whether source bodies or external declarations are supported.

The procedure type parser shares modifier parsing with declarations. Track explicit modifier repetition separately from effective context mode: `#c_call #no_context` is valid although both disable implicit context. Variadic parameters cannot be baked, `using`, defaulted, or repeated. Multiple results and result defaults are independent of variadic parameters.

`jai-sema/src/procedure_values/bind_arguments.rs` is the shared binder for direct and indirect calls. Keep emitted argument expressions in source order even when their parameter indices differ. `bindings.rs` tracks callback names and defaults by storage or field identity; putting them in a table keyed only by canonical `TypeId` would mix metadata from distinct source bindings. Defaults use typed `ParameterDefault` metadata: constants are copied, while caller locations materialize from the actual call source span. Generated context helpers receive the already-bound arguments, so they preserve caller provenance.

## Configuration

These rules are source syntax; there are no environment variables. `#c_call`, `#no_context`, `#foreign`, and `#compiler` affect signature or binding metadata. The library and symbol in a foreign binding are preserved names; parsing does not load that library.

The source parity suite executes both the independent VM and freshly compiled native objects:

```sh
LLVM_SYS_221_PREFIX=/opt/homebrew/opt/llvm RUSTC_WRAPPER= CARGO_TARGET_DIR=target cargo test -p jai-codegen --test procedure_values -j1
```

The prefix selects the trusted installed LLVM toolchain. Fixtures never load reference compiler binaries or reference objects.

## Dependencies

The lexer supplies directive and range tokens. `jai-types` defines calling conventions and context modes. Module scope resolution supplies library-name identities and compiler-binding trust boundaries. Native ABI lowering is responsible for C argument promotions and target-specific foreign calls; Jai pack construction depends on sequence descriptors.
