# Preload and Runtime_Support bootstrap

## What it is

Every program implicitly loads two bootstrap modules {#prelude.1}, both plain Jai in this repo. Preload holds compiler-owned declarations (`Type_Info`, `Allocator`, intrinsics). Runtime_Support holds the entry point, context initialisation and write helpers.

## How it works

`prelude/Preload.jai` `#load`s its files (`platform`, `reflection`, `allocation`, `diagnostics`, `runtime-storage`, `intrinsics`, `context`) into one module. `stdlib/Preload.jai` just loads it, and `jaic-cli` points `Options::preload` at `stdlib/Preload.jai`. The wasm build bundles both `stdlib` and `prelude` (`crates/jai-wasm/build.rs`).

`Compiler::load_bootstrap` (`sema/driver.rs`) loads Preload, then, if `Options::runtime_support` is set, `stdlib/Runtime_Support.jai` with `DEFINE_SYSTEM_ENTRY_POINT=true`, `DEFINE_INITIALIZATION=true`, `ENABLE_BACKTRACE_ON_CRASH=false` and `TEMPORARY_STORAGE_SIZE` from `Options::temporary_storage_size`. Both are visible from every module (`sema/scope.rs`) {#prelude.2}.

A program can import Runtime_Support itself with other arguments and gets its own instance {#prelude.3}:

```jai
Runtime :: #import "Runtime_Support"(DEFINE_SYSTEM_ENTRY_POINT=false, DEFINE_INITIALIZATION=false, ENABLE_BACKTRACE_ON_CRASH=false);
```

Without the entry point there is no exported `main`: `no exported 'main' (is Runtime_Support loaded?)`.

`context_type` (`sema/structs.rs`) synthesises the `Context` struct. Preload's `FIRST_ADD_CONTEXT :: #code #add_context #as using base: Context_Base;` comes first, resolved in Runtime_Support's scope (which defines `Context_Base`), followed by every `#add_context` in load order {#prelude.4}.

The intrinsics in `prelude/intrinsics.jai` are bound by name in `sema/calls.rs` {#prelude.5}; see [intrinsics](../language/intrinsics.md). `get_current_workspace` has a fallback body returning workspace 0.

## How to change it

- Put a new Preload declaration in the file for its area. Descriptor field order and enum values are an ABI shared with `sema/typeinfo.rs`; don't reorder them.
- Keep Preload declarative: no imports, `#run` or side effects.
- Constants that depend on Preload (`OS`, `CPU`) are wired in `sema/scope.rs`; `sema/expr.rs` and `sema/decls.rs` report "requires Preload" if it is missing.
- Runtime behaviour (allocators, temporary storage, crash output) belongs in `stdlib/Runtime_Support.jai`. Its module parameters are the contract with `load_bootstrap`.

Test: `tests/stdlib/runtime-support-source.jai`.

## Configuration

`Options::preload`, `Options::runtime_support`, `Options::temporary_storage_size` (default 32768). A metaprogram sets the last through `Build_Options.temporary_storage_size`; see [workspaces](workspaces.md).

## Dependencies

`prelude/*.jai`, `stdlib/Runtime_Support.jai`, `stdlib/Runtime_Support_Crash_Handler.jai`, `sema/driver.rs`, `sema/modules.rs`.
