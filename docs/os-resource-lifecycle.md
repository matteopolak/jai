# OS resource lifecycle fixtures

## What it is

`crates/jai-codegen/tests/os_resource_lifecycle_source.rs` exercises real POSIX error state and thread-owned heap storage through independently authored typed Jai source. It is a focused native fixture, separate from complete unchanged File, Process, Thread, and File_Async module acceptance.

## How it works

The stream fixture writes one byte beneath its private temporary working directory, reopens the file read-only, and checks that a rejected write sets the stream error flag without EOF. It clears that error, reads beyond the file end, verifies EOF without an error, clears both indicators, rewinds, and reads again. An invalid descriptor read must return `-1` and the real host `EBADF` value; tiny authored C functions read actual libc `errno` and its installed header constant rather than guessing platform numbers.

The thread fixture creates a C-calling-convention Jai callback. The worker allocates and initializes heap storage through authored C wrappers around installed `malloc`, then returns its pointer. The caller joins before reading that storage, checks one outstanding allocation, releases it through the real `free` wrapper, and verifies the allocation count returns to zero. Atomic counters observe allocation ownership; they do not replace threading or allocation behavior. Opaque pointer-sized pthread handles are passed back unchanged.

Each program is freshly lowered at `O0` and `O2`, linked by trusted installed Clang, and must finish within ten seconds. The bounded VM must reject its foreign calls. No supplied native artifact is loaded. Fixtures remove their own temporary directories. This does not prove Thread allocator/context startup, asynchronous completion/cancellation, or full module execution.

Both tests passed on macOS ARM64 on October 2, 2026 after the RunFlags/using build gate advanced: four freshly generated native executions and four VM foreign-call rejection checks. This is a local completed runtime checkpoint; Linux and complete genuine library modules remain unverified.

## How to change it

Add observable error or ownership transitions rather than guessed platform layouts or undefined duplicate close/join behavior. Keep foreign signatures fixed and C-compatible, preserve the real host errno value immediately after a failed operation, and read worker-owned storage only after synchronization. Runtime source procedures must remain ordinary checked bodies; foreign fixture helpers may call trusted libc and observe state, but must not fabricate successful OS answers.

## Configuration

The fixtures run on 64-bit macOS and Linux and use the shared `support/native_tools.rs` Clang selector/environment scrubber. `JAI_RS_CLANG` or `LLVM_SYS_221_PREFIX` selects independently installed LLVM; source/native directories in this repository are rejected as tool locations. Native links include `-pthread`; macOS disables fixup chains for these generated test objects.

```sh
RUSTC_WRAPPER= LLVM_SYS_221_PREFIX=/opt/homebrew/opt/llvm CARGO_TARGET_DIR=target cargo test --offline -j1 -p jai-codegen --test os_resource_lifecycle_source
```

## Dependencies

The source module graph, semantic checker, checked VM, LLVM backend, trusted installed Clang and host libc/pthreads. Authored C support includes only the installed C standard-library and errno headers. No optional original source is required, so these fixtures remain mandatory in a public checkout.
