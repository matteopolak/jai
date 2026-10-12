// Deadlines, which backend is running, and one scheduler per thread.

// Limits every IO call (and `sleep`) in `body` to `milliseconds` from now: one that is still
// waiting then returns `.TIMED_OUT`, and so does a call made after the limit. Deadlines nest; the
// earlier one wins. Channel and lock operations are not IO and ignore it.
//
//     with_deadline(2000, #code {
//         count, error = read(conn, buffer);       // .TIMED_OUT after two seconds without data
//     });
with_deadline :: (milliseconds: s64, body: Code) #expand {
    previous_deadline := set_deadline(milliseconds);
    defer restore_deadline(previous_deadline);

    #insert body;
}

// The procedure form of `with_deadline`: starts a deadline for the running fiber and returns what
// to give `restore_deadline` when the guarded work is over.
set_deadline :: (milliseconds: s64) -> s64 {
    fiber := current_fiber();
    previous := fiber.deadline;

    limit := now_nanoseconds() + max(milliseconds, 0) * 1_000_000;

    if previous == 0 || limit < previous fiber.deadline = limit;

    return previous;
}

restore_deadline :: (previous: s64) {
    fiber := current_fiber();

    fiber.deadline = previous;
}

Backend :: enum u8 {
    // No IO on this system (Windows for now): every operation fails with `.UNSUPPORTED`.
    NONE;
    IO_URING;
    EPOLL;
    KQUEUE;
}

name_of_backend :: (backend: Backend) -> string {
    if backend == {
        case .IO_URING; return "io_uring";
        case .EPOLL; return "epoll";
        case .KQUEUE; return "kqueue";
    }

    return "none";
}

// What the engine found it could use. Backends fill in what applies.
Capabilities :: struct {
    // io_uring: the setup flags the kernel accepted.
    single_issuer: bool;
    defer_taskrun: bool;
    coop_taskrun: bool;
    // io_uring: waits with a timeout in one call (Linux 5.11).
    ext_arg: bool;
    // io_uring: how many operations the kernel's probe lists.
    kernel_ops: s64;
}

// The backend the running scheduler uses: `.IO_URING`, `.EPOLL`, `.KQUEUE`, or `.NONE` where IO is
// not implemented yet. Set `JAI_IO_BACKEND` to `io_uring`, `epoll` or `kqueue` before `io_run` to
// ask for one; a backend the system cannot offer is replaced (see `backend_reason`).
backend :: () -> Backend {
    scheduler := current_scheduler();

    return scheduler.engine.backend;
}

// `backend()` as text: "io_uring", "epoll", "kqueue" or "none".
backend_name :: () -> string {
    return name_of_backend(backend());
}

// Why the running scheduler does not use the backend that was asked for or is the first choice on
// this system (for example "io_uring is disabled here"). Empty when it does.
backend_reason :: () -> string {
    scheduler := current_scheduler();

    return scheduler.engine.fallback_reason;
}

// What the engine found it could use.
capabilities :: () -> Capabilities {
    scheduler := current_scheduler();

    return scheduler.engine.caps;
}

// The number of processors, for sizing `io_run_threads`.
processor_count :: () -> s64 {
    return sys_processors();
}

// Starts `count` schedulers, each on a thread of its own, runs `proc` as the first fiber of every
// one, and returns when all have finished. Fibers never move between them. With `reuse_port`
// listeners (`tcp_listen(..., reuse_port = true)`) each thread accepts its own connections:
//
//     io_run_threads(4, () {
//         listener, error := tcp_listen(":8080", reuse_port = true);
//         while true { conn := accept(listener); spawn(handle, conn); }
//     });
//
// `count` 0 means one per processor. Call it from outside any `io_run`.
io_run_threads :: (count: s64, proc: $P) {
    Block :: struct {
        proc: P;
    }

    block: Block;
    block.proc = proc;

    entry :: (thread: *Thread.Thread) -> s64 {
        block := cast(*Block) thread.data;
        io_run(block.proc);

        return 0;
    }

    run_threads(count, entry, *block);
}

io_run_threads :: (count: s64, proc: $P, data: $T) {
    Block :: struct {
        proc: P;
        data: T;
    }

    block: Block;
    block.proc = proc;
    block.data = data;

    entry :: (thread: *Thread.Thread) -> s64 {
        block := cast(*Block) thread.data;
        io_run(block.proc, block.data);

        return 0;
    }

    run_threads(count, entry, *block);
}

#scope_module

run_threads :: (count: s64, entry: Thread.Native_Thread_Proc, data: *void) {
    count = ifx count <= 0 then processor_count() else count;

    threads := NewArray(count, Thread.Thread);

    defer free(threads.data);

    started := 0;

    for 0..count - 1 {
        thread := *threads[it];

        assert(Thread.thread_init(thread, entry), "Io: could not prepare a thread");
        thread.data = data;

        assert(Thread.thread_start(thread), "Io: could not start a thread");
        started += 1;
    }

    for 0..started - 1 Thread.thread_deinit(*threads[it]);
}
