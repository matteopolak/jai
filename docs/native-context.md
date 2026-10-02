# Native implicit context

## What it is

Jai procedures with implicit context receive a hidden pointer to the workspace's checked context record. Native execution shares that record across calls and creates scoped record copies for `push_context`.

## How it works

`Library.context()` owns the record type, its canonical pointer type, and the checked default constant. `TypeLowerer` adds the pointer before ordinary parameters only for implicit-context signatures. Direct and indirect calls pass the active pointer; C and `#no_context` procedures keep their declared parameter lists.

The executable entry wrapper allocates and initializes the default record once for an implicit-context entry. Field assignment writes through its address, so changes in a callee remain visible to its caller. Evaluating `context` loads a whole record snapshot; taking its address or a field address retains reference semantics.

`push_context value` evaluates the record using the previous context, copies it into function-local storage, and emits its body with that address active. Leaving the lexical body restores the compiler's previous pointer, including paths that return, break, or continue. Each push has an entry-block allocation, avoiding repeated stack allocations when a loop executes the push many times. A bare `push_context` starts from the schema's default constant.

Deferred cleanup carries its lexical context origin in checked IR: either the procedure's incoming carrier or a branded push identity. Native lowering selects that carrier while emitting the cleanup and restores the previous active pointer afterward. Thus an outer defer reached by a return from an inner push still observes the outer record. Return values are evaluated before cleanup mutates either record.

## How to change it

Change `crates/jai-codegen/src/context.rs` for initialization, snapshots, and scoped pointer handling. The backend root wires parameter storage, context places, statement dispatch, and calls; `types.rs` controls the hidden ABI parameter. Preserve source argument evaluation order when inserting hidden arguments.

Context pointers are compiler-generated ABI parameters. They are not host globals or thread-local lookups. Any new execution backend must implement the same carrier and copy semantics from checked IR.

## Configuration

Source `#add_context` declarations determine the schema and defaults. `#no_context`, `#c_call`, and `#foreign` disable implicit context for the corresponding signature. Context use in these procedures requires a lexical `push_context`.

There are no context environment variables. Native tests use the independently installed `clang` and the repository's configured LLVM installation, and execute only newly generated fixture programs.

## Dependencies

`jai-ir` supplies the verified schema, context values and places, and push statement. `jai-types` supplies context modes and canonical record/pointer identity. `inkwell` builds LLVM types and instructions; aggregate lowering supplies default constants and record snapshots. Target layout and the memory helpers preserve record allocation and access alignment. `jai-codegen/tests/context.rs` checks source, VM, native execution, and directly constructed checked IR.
