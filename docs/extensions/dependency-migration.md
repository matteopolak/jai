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

Thread startup uses the boolean preparation result and the void start operation.
File-pool initialization failures still fall back to inline operations. Private
multi-thread startup uses canonical `Thread_Proc` and frees the allocation base
returned by `NewArray`, which can differ from its aligned data pointer. The pool
lock uses the existing compiler `compare_and_swap` operation.

Args privately selects native Basic `exit` or WASI preview1 `proc_exit(u32)`.
The WASI import names its real host module; no libc exit import, fake return,
new public API or compiler special case is introduced. Help/version still exit
0 and parser errors exit 2 after producing their normal output.

Initial verification (2026-10-15): reproduced the original two compile failures;
fiber context passed interpreter/native O0/O2; the original native overflow test
passed, including its interpreted failure assertion; the actual WASI formatter
passed all 24 goldens and its 414-line input. Broader focused ownership, argument,
target and strict lint checks are ongoing. This is not full integration acceptance.
