# Native reachability

## What it is

Native lowering emits procedures demanded by runtime roots. Compiler-only requests and helpers used solely by `#run` remain in checked IR for virtual execution but disappear from an executable's LLVM module.

## How it works

`Reachable::executable` starts from the checked `EntryPoint`. A breadth-first graph walk follows direct calls and every `ProcedureValue`, including callbacks supplied to indirect calls. The walker also visits argument expressions, projected place indices and pointer bases, scoped context values, and referenced cleanup bodies. A condition known from `#compile_time` selects its runtime branch; ordinary conditional branches and loop bodies are visited conservatively.

An expression `Bind` visits each producer in source order and then its body. Bound values are reads of those checked producers, so callback roots cannot disappear behind a `Bound` reference or an unused capture. Scoped phase facts remain available while the body is visited and are removed on scope exit. Place traversal is refreshed at these boundaries because a projected place can depend on the current captured value.

Globals and the default context are emitted regardless of procedure demand, so their typed constant trees are visited before procedure roots. `ConstantKind::Procedure` retains the actual callback identity in aggregates and defaults. Static data referenced by an emitted body, including runtime type descriptor data, is scanned across the entire graph reserved by the static-data emitter. Exhaustive matches require each new constant/static variant to define its dependencies.

A reached `PrototypeOrigin::Compiler` or body explicitly marked `ProcedureExecution::CompileTimeOnly` produces an error containing the shortest deterministic chain of `ProcedureId` indices. This includes callback addresses stored in globals, context defaults, and static descriptor data. Ordinary source bodies that implement a `#compiler` fallback retain their runtime availability. LLVM declarations and bodies are built only after this check, without substituting stub bodies for compiler requests.

`lower_library` and `lower_library_for_target` require an explicit publication policy. `Publication::AllBodies` starts from every runtime-available checked body and omits unused `#compile_time` bodies. `Publication::Selected(ids)` publishes those roots and their dependencies; explicitly selecting a compile-time-only identity is an error. Both policies diagnose compiler requests and compile-time-only bodies reached through runtime dependencies, and omit the executable `main` wrapper. Callers must include every externally published body in a selected root list; procedure values referenced by those bodies retain callback implementations automatically.

Bodyless `PrototypeOrigin::SourceContract` declarations preserve their actual Jai signature, including the descriptor-based variadic ABI. Library/object publication can emit them as typed unresolved declarations. `lower_program_object_for_target` publishes an entry-root program object with its C entry bridge; library publication omits that bridge. Executable reachability rejects a demanded source contract without a checked implementation provider, including a callback address retained in a global or static graph. The private typed publication purpose follows the genuine executable/object/library APIs; a filename or symbol spelling does not establish a provider. An emitted object declaration alone is not executable linkage proof.

```jai
compiler_create_workspace :: (name:string)->s64 #compiler;
recipe :: ()->int { return compiler_create_workspace("phase-fixture"); }
answer :: #run recipe();
main :: ()->int { return answer; }
```

The source regression resolves this fixture with an independent Rust effects handler returning workspace ID 42. It verifies that the compiler prototype and `recipe` are absent from LLVM, emits an actual object with LLVM, links it with installed Clang, and executes the new binary with result 42. Changing `main` to call `recipe()` produces a runtime compiler-request diagnostic. Independent IR tests also execute an indirectly invoked callback and check dependencies nested in projected places and exit cleanups.

## How to change it

Update `crates/jai-codegen/src/native_reachability.rs` when adding an IR expression, statement, constant, static-data variant, or prototype origin. Its exhaustive matches intentionally prevent new dependency-bearing nodes from silently bypassing reachability. Keep identities typed; native symbol names are serialization details, not the graph's keys.

Add regressions to `tests/native_reachability.rs` for checked-IR dependencies and `tests/source_run.rs` for phase behavior. Native target setup, debug metadata, global storage, and declaration construction remain shared in `lower_unit`.

## Configuration

Executable publication is fixed by `Program::entry()`. Library publication is selected through the `Publication` argument. Target options remain the existing `NativeTarget` configuration.

Run the focused checks with `LLVM_SYS_221_PREFIX=/opt/homebrew/opt/llvm RUSTC_WRAPPER= CARGO_TARGET_DIR=target cargo test -p jai-codegen --test native_reachability --test source_run --locked -j1`. Native fixtures require installed Clang and execute only newly generated objects.

## Dependencies

The graph uses immutable `jai-ir::Library`, typed `ProcedureId`, its checked execution-phase ledger, and checked place/static-data arenas. LLVM emission uses Inkwell and the existing target backend. Source regressions additionally depend on `jai-modules`, `jai-sema`, and the independent `jai-vm::CompilerEffects` interface.
