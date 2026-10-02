# Program exports and native entry points

## What it is

`#program_export` publishes a source procedure or global under an explicit native linker symbol. Export metadata preserves the exact source declaration and checked procedure/global identity independently of source module visibility and debug information.

## How it works

An annotation attaches only to the immediately following definition. With no string, it uses that definition's source name; an optional string gives the native symbol. Imported declarations retain their defining identities. Exporting a module-private declaration does not make it visible through a Jai module namespace.

```jai
#scope_module
#program_export "native_counter"
counter: s32 = 7;

#program_export "native_increment"
increment :: (delta: s32) -> s32 #c_call {
    counter += delta;
    return counter;
}
```

The semantic binder builds typed export targets, and IR publication validates their definitions, unique declaration/target identities, and native symbol names. Duplicate symbols and compiler-reserved `jai.`/`llvm.` names fail explicitly. Foreign prototypes may reuse an exported function symbol when their canonical signatures match; mismatched functions or function/global collisions fail. LLVM uses export metadata to name definitions and includes exported procedures as native reachability roots, including when a caller requests an otherwise empty selected library publication.

`#c_call` selects the existing target-specific C ABI and removes the implicit Jai context parameter. An exported procedure without `#c_call` retains its Jai calling convention. C consumers should use exported `#c_call` procedures and compatible global storage types.

An exported symbol named `main` has a checked C entry signature: `s32` return, no implicit context, and either no parameters or `(s32, **u8)` parameters. The native backend emits that source definition as the actual process entry and suppresses its generated wrapper. The checked program still retains its language `main` for VM execution. Runtime initialization and finalization exports remain ordinary source procedures; their names are not inferred from debug labels.

`__program_main :: () #entry_point;` binds the actual application's procedure identity and signature, including inside a runtime trampoline. It adds no foreign symbol, prototype implementation, or independent body. File aliases require matching canonical signatures; the current local form requires a matching parameterless void entry. Incompatible requests fail explicitly. Alias provenance does not overwrite the real body's debug location.

A `#c_call` trampoline must enter `push_context` before calling an application entry that uses the implicit Jai context. A global `first_thread_context: #Context;` retains the schema's nonzero field defaults and canonical callback identities. The schema is established before global initialization, so the trampoline pushes the same record used by ordinary Jai calls. The alias retains the usual context requirement.

## How to change it

Extend attachment syntax in `jai-syntax/src/program_exports.rs` and `modules.rs`; identity binding in `jai-sema/src/modules/program_exports.rs`; publication validation and entry metadata in `jai-ir/src/program_exports.rs`; and naming/reachability in `jai-codegen/src/program_exports.rs` and `native_reachability.rs`.

Preserve source identity when introducing aliases or parameterized module exports. Changing a C ABI requires updating its ABI classifier and independently written C fixtures. Do not recover native symbols from source text, debug information, or conventional procedure names.

## Configuration

`#program_export` optionally takes a quoted symbol and applies to procedure/global definitions only. It does not change `#scope_file`, `#scope_module`, or `#scope_export`. Dangling, repeated, import, type, constant, and prototype annotations fail.

Native publication uses checked export roots alongside selected entry/library roots. A source-exported C `main` chooses the source trampoline; programs without one retain the generated wrapper. Runtime support parameters still determine whether the original source declares its entry and initialization definitions.

## Dependencies

The parser, module graph and declaration identities, semantic procedure/global registries, checked IR, native reachability, C ABI classifier, and LLVM object emitter. Native interoperability tests compile only independently written source and new object files with an installed host Clang; supplied reference native files are never linked or executed.
