# Io and Args dependency migration

The Extensions retain their own APIs and ordinary appended history. These
adaptations use reviewed replacement dependencies without adding Basic exports.

Io's private `release_owned` temporarily selects the recorded allocator, calls
Basic's one-argument `free`, and restores the caller's allocator on return.
This retains Basic memory-debugger bookkeeping instead of bypassing it with a
raw allocator call. Channels, pipe links and pooled fiber records use this path.
Fiber records are allocated in the scheduler allocator without changing the
context inherited by the spawned fiber. Io owns each fiber's initial scratch
slab; Basic's reviewed paged-storage record owns overflow pages. Reset releases
overflow pages before Io releases the initial slab through its recorded owner.

Retained engine operations are allocated through the engine's owner, so the
allocator active in the first calling fiber cannot become their accidental
owner. File-pool records, per-engine pool links, resolver state and resolver jobs
record their allocation owner and use it during eventual teardown. An actual
cross-context file-operation regression originally failed in `engine_stop` with
an owner mismatch; it now also exercises worker-pool and localhost resolver
cleanup. Allocator procedures and their data must remain alive while objects
that use them exist, including a shared file pool's last user.

Thread startup uses the boolean preparation result and the void start operation.
Teardown explicitly waits with `thread_is_done(thread, -1)` before reaping each
worker, preserving the reviewed completion precondition. A wait error asserts;
it does not silently free live thread resources.
File-pool initialization failures still fall back to inline operations. Private
multi-thread startup uses canonical `Thread_Proc` and frees the allocation base
returned by `NewArray`, which can differ from its aligned data pointer. The pool
lock uses the existing compiler `compare_and_swap` operation.

Args privately selects native Basic `exit` or WASI preview1 `proc_exit(u32)`.
The WASI import names its real host module; no libc exit import, fake return,
new public API or compiler special case is introduced. Help/version still exit
0 and parser errors exit 2 after producing their normal output.

Verification is recorded in [the scoped status report](../status/extensions-dependencies.md).
This is not full integration acceptance.

Run the durable focused matrix with:

```sh
python3 tests/extensions/run-dependencies.py
```

This executes the existing fiber/context/channel/timer/stress and Args parse,
help/completion suites in interpreter/native O0/O2, real argv/environment and
exit cases in those modes plus actual WASI O0/O2, overflow checks, and Linux,
Windows and macOS source checks on x64/arm64. It writes every command and actual
result to ignored `artifacts/extensions-dependencies/results.json`, returns
nonzero for any failure, and does not turn unavailable dependencies into passes.

Linux currently remains blocked in the separately owned Io_Uring dependency:
its obsolete two-argument `atomic_load` declaration use is reduced in
`tests/extensions/io-uring-dependency-repro.jai`. Io's own ring backend now uses
canonical sequentially consistent loads/stores (the supplied compiler selects
`ORDER_SEQ_CST`), preserving at least the previous acquire/release strength.
No Io_Uring source is changed here. Windows/Linux executions require their real
native hosts; source checks alone establish neither native ABI nor runtime
success. Bare WebAssembly hosts using Args.parse must provide the declared WASI
process service; this implementation does not fabricate one for browser hosts.
