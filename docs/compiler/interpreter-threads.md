# Threads under `jaic run`

## What it is

Programs that use `Thread` (`pthread_create`, mutexes, condition variables, `sleep`) run in the
interpreter on a cooperative scheduler: several OS threads exist, but only the one holding the
"baton" executes interpreted code.

## How it works

- `interp/threads.rs` intercepts the pthread/mutex/cond foreign calls in `call_foreign`
  (`thread_foreign`). `pthread_create` spawns an OS thread (256 MiB native stack, 8 MiB
  interpreter value stack) that waits for the baton.
- The baton moves only when a thread joins, blocks on a mutex or condition variable, sleeps,
  yields, or has executed `PREEMPT_TICKS` basic blocks (`preempt`, called from the `run` loop
  while `Interp.multi` is set). The preemption is what lets busy waits on an atomic progress.
- Per-thread interpreter state (value stack, `sp`, call depth, current line) is swapped in and out
  of `Interp` on a switch. Mutexes and condition variables are emulated in the scheduler, never
  passed to libc, so a blocked thread cannot hold the baton. If every thread is blocked the
  scheduler wakes one with a deadlock error.
- Output order of racing threads is deterministic apart from sleep timing, but differs from a real
  run.
- The `compare_and_swap` intrinsic takes a 4th argument, the operand width in bytes
  (`emit_intrinsic` in `sema/calls.rs`, `asm.rs`). Without it a `bool` field was compared as 8
  bytes and `atomic_swap` spun forever.

## How to change it

New blocking primitives need a `Block` variant and a case in the scheduler's wake-up scan. Keep
all `Interp` access on the baton holder.

## Configuration

None. Not available on wasm32 (`mod threads` is cfg-gated).

## Dependencies

`stdlib/Thread/`, `stdlib/Atomics.jai`. Test: `tests/stdlib/threads-cooperative.jai`.
