# Compile-time state does not reach runtime

## What it is

Global variables changed by `#run` code (or any compile-time execution) are put back to their
initial contents before `main` runs, as in `jai`. A declaration marked `#no_reset` keeps its
compile-time value.

## How it works

- `resolve_global_var` (`sema/decls.rs`) records every user global that is not `#no_reset` in
  `Program.reset_globals`.
- `Compiler::run_program` calls `Interp::reset_globals` just before calling `main`. For each listed
  global that was materialized during compile time it zeroes the memory, copies the `init`
  bytes and re-applies relocations. Globals never touched at compile time need nothing.
- Initial values are computed at compile time into `Global.init`, so `x := #run f();` keeps the
  value. `resolve_global_var` evaluates `f` once and reuses the typed result as the initializer
  (it used to run it twice: once to infer the type and once for the bytes).
- Internal globals (type info, string data, `run.result`, the compile-time context) are not in the
  list.

## How to change it

New kinds of user-visible variables that live in `Global`s must be pushed to `reset_globals` where
they are created. `jaic build` does not use this: the produced binary gets `init` data only.

## Configuration

`#no_reset` on the declaration (`#no_reset x: int;`).

## Dependencies

`ir::Program::reset_globals`, `Interp::reset_globals`. Test: `tests/stdlib/compile-time-globals-reset.jai`.
