# Preload and Runtime_Support bootstrap

## What it is

Every program implicitly loads two bootstrap modules: Preload (compiler-owned declarations such as `Type_Info`, `Allocator`, intrinsics) and Runtime_Support (entry point, context initialization, write helpers). Both are plain Jai in this repository.

## How it works

`prelude/Preload.jai` `#load`s seven files into one module: `platform`, `reflection`, `allocation`, `diagnostics`, `runtime-storage`, `intrinsics`, `context`. `stdlib/Preload.jai` just loads `../prelude/Preload.jai`, and `jaic-cli` sets `Options::preload` to `stdlib/Preload.jai`. The wasm build bundles both `stdlib` and `prelude` (`crates/jai-wasm/build.rs`).

`Compiler::load_bootstrap` (`sema/driver.rs`) loads Preload, then, when `Options::runtime_support` is set, `stdlib/Runtime_Support.jai` as a parameterized module with `DEFINE_SYSTEM_ENTRY_POINT=true`, `DEFINE_INITIALIZATION=true`, `ENABLE_BACKTRACE_ON_CRASH=false` and `TEMPORARY_STORAGE_SIZE` from `Options::temporary_storage_size`. Both are visible from every module (`sema/scope.rs`). A program may import Runtime_Support itself with other arguments and gets its own instance:

```jai
Runtime :: #import "Runtime_Support"(DEFINE_SYSTEM_ENTRY_POINT=false, DEFINE_INITIALIZATION=false, ENABLE_BACKTRACE_ON_CRASH=false);
```

(`tests/stdlib/runtime-support-source.jai`). Without the entry point the program has no exported `main` ("no exported 'main' (is Runtime_Support loaded?)").

The `Context` struct is synthesized by `context_type` (`sema/structs.rs`): the statements of Preload's `FIRST_ADD_CONTEXT :: #code #add_context #as using base: Context_Base;` come first, resolved in Runtime_Support's scope (which defines `Context_Base`), followed by every `#add_context` in load order. Intrinsics declared in `prelude/intrinsics.jai` (`memset`, `memcpy`, `memcmp`, `compare_and_swap`) are bound by name in `sema/calls.rs`; `get_current_workspace` has a fallback body returning workspace 0.

## How to change it

- Add a Preload declaration to the file for its protocol. Descriptor field order and enum values are an ABI shared with `sema/typeinfo.rs`; do not reorder casually.
- Keep Preload declarative: no imports, `#run` or side effects.
- Compiler-provided constants that depend on Preload (`OS`, `CPU`) are wired in `sema/scope.rs`; `sema/expr.rs` and `sema/decls.rs` report "requires Preload" if the module is missing.
- Runtime behavior (allocators, temporary storage, crash output) belongs in `stdlib/Runtime_Support.jai`, whose module parameters are the contract with `load_bootstrap`.

## Configuration

`Options::preload`, `Options::runtime_support`, `Options::temporary_storage_size` (Runtime_Support defaults it to 32768). A metaprogram sets the last through `Build_Options.temporary_storage_size`; see [workspaces.md](workspaces.md).

## Dependencies

`prelude/*.jai`, `stdlib/Runtime_Support.jai` and `Runtime_Support_Crash_Handler.jai`, `sema/driver.rs`, `sema/modules.rs`.
