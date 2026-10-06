# Memory limit (`JAIC_MEMORY_LIMIT`)

## What it is

An exact cap on the bytes a `jaic` process allocates. Set `JAIC_MEMORY_LIMIT` and the first allocation that would take the live total past it stops the process with

```
error: memory limit of 3072 MiB exceeded
```

on stderr and exit status **120** (`jaic::memory_limit::EXIT_CODE`). The corpus sweep sets it for every case (see [jaic sweep](../tools/jaic-sweep.md)), so a runaway case fails at the limit instead of being sampled and killed after the fact.

## How it works

`crates/jaic/src/memory_limit.rs` holds the counter; `crates/jaic-cli/src/main.rs` installs it.

- `CountingAllocator` is the `jaic` binary's `#[global_allocator]`. It forwards to `std::alloc::System` and, once armed, adds `layout.size()` to a relaxed `AtomicIsize` on alloc (and the growth on realloc) and subtracts it on free. Unarmed, every call costs one relaxed load and a branch.
- `main` calls `arm_from_env()` before anything else. Blocks allocated before arming and freed afterwards make the total slightly low, which is why it is signed.
- Compiler memory (sema, IR, diagnostics) and the interpreter's own memory (its stack, globals, the sandbox heap used by `-os wasm` and the browser engine) are ordinary Rust allocations, so they are counted.
- A natively linked program allocates through C `malloc` (the default Jai allocator calls it, at compile time and under `jaic run`). While the limit is armed, `Interp::foreign_addr` resolves `malloc`, `calloc`, `realloc`, `free`, `posix_memalign` and `aligned_alloc` to counting wrappers (`memory_limit::foreign_override`) instead of libc's. The wrappers return real libc blocks and charge `malloc_size` (macOS) / `malloc_usable_size` (Linux), so C code may free them and `free` of a block they never handed out still works.
- Over the limit, `exceeded` formats the message into a stack buffer, `write(2)`s it and calls `_exit`: it must not allocate (it runs inside the allocator) and must not run `atexit` handlers that could wait on a lock another thread holds. Buffered program output is therefore not flushed.

What is **not** counted:

- Memory C/C++ libraries allocate on their own: LLVM during `jaic build` (C++ `operator new`), libclang for C header imports, a `#foreign` library that calls `malloc` internally (only calls the Jai program makes by name go through the wrappers), and allocators that map pages themselves (`rpmalloc`).
- Thread stacks (the 1 GiB compiler stack and program threads) and mapped files.
- Child processes: the linker, `dsymutil`, programs a metaprogram launches, the executable `jaic build` produces.
- On Windows the C allocator is not wrapped; only Rust allocations count.

The counter measures requested (virtual) bytes, not resident memory: a large zeroed block nobody touches counts in full.

## How to change it

- Another C allocation entry point (`valloc`, `reallocf`, ...): add a wrapper and a name in `sys::foreign_override`.
- A different reaction (fail the allocation instead of exiting): `charge` is the single place that decides. Returning null from `GlobalAlloc` would abort through `handle_alloc_error`, so an exit with a clear message is the friendlier default.
- The exit status is mirrored in `tools/jaic-sweep.py` (`MEMORY_LIMIT_EXIT`); change both together.
- Another binary that wants the limit (`jailsp`) declares the same `#[global_allocator]` and calls `arm_from_env()`.

## Configuration

`JAIC_MEMORY_LIMIT=<n>`: bytes, or with a `K`, `M` or `G` suffix (binary multiples): `3221225472`, `3G`, `512M`. Unset or `0` means no limit. A value that does not parse is a usage error (exit status 2).

```sh
JAIC_MEMORY_LIMIT=256M jaic run grow.jai; echo $?   # error: memory limit of 256 MiB exceeded / 120
```

## Dependencies

Rust `std` only, plus libc's `malloc` family, `malloc_size`/`malloc_usable_size`, `write` and `_exit` on Unix. Tested by `memory_limit_stops_unbounded_allocation` in `crates/jaic-cli/tests/cli.rs` (run-time heap, `#run`, and `-os wasm`).
