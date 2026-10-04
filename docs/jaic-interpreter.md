# jaic interpreter

## What it is

`crates/jaic/src/interp` runs IR: `#run` and other compile-time code, `jaic run` programs, and the browser
playground. Memory is real host memory; foreign procedures are called natively (`native.rs`) or through a
`Host` shim where there is no dynamic linker (wasm).

## How it works

- `Interp::call` is the entry from the compiler; `exec` / `run` / `step` interpret functions. Procedure
  values are tagged addresses (`FUNC_TAG`); foreign procedures without a native address are tagged
  `FOREIGN_TAG` and trap with "foreign procedure '...' is not available here" when called.
- `Host::foreign` may implement a foreign symbol itself (libc shims in `SandboxHost`, used in the browser).
- `#compiler` procedures of the `Compiler` module are hooks (`Hook`, `run_hook`) handled in `build.rs`
  (`MetaOp`).
- `codes` mirrors the compiler's `Code` values (AST and source text) so `compiler_get_nodes` can export them;
  `made_codes` lists codes compile-time code created (`compiler_get_code`), adopted by the compiler later.
- **fork**: compile-time code may `fork()` (the `Process` module does, to run commands). If the child comes
  back to the compiler instead of `exec`ing (exec failed, or it trapped, e.g. on a foreign procedure that the
  host lacks), `Interp::call` ends the child with `_exit` instead of letting it carry on as a second
  compiler. The flag is set when a native `fork` returns 0 in `call_foreign`.

## How to change it

- New host-provided foreign procedures: `Host::foreign` implementations (`SandboxHost` for the browser).
- New compiler primitives: a `MetaOp` in `build.rs` plus a bodiless `#compiler` declaration in
  `stdlib/Compiler/records.jai`.
- Calls with by-value struct arguments to native code are not supported yet (`call_native` traps).

## Configuration

`STACK_SIZE` (32 MiB interpreter stack) and `MAX_DEPTH` (20,000 frames) in `interp/mod.rs`.

## Dependencies

`ir` (programs), `build.rs` (compiler hooks), the platform's dynamic loader for native foreign calls.
