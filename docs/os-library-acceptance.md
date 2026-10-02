# OS library acceptance

## What it is

`crates/jai-codegen/tests/os_library_source.rs` checks ordinary typed source across the installed POSIX C ABI. It reads reference Jai **source only** and executes newly generated objects linked by trusted installed Clang; it never loads supplied compiler, linker, object, or library bytes.

This is focused synchronous File, pthread, and asynchronous worker mechanism acceptance. Passing these tests does not establish that the complete File, Process, Thread, File_Async, or modern application modules compile or run.

## How it works

The File fixture copies the unchanged `File`, `is_valid`, `file_read`, `file_write`, `file_set_position`, `file_move`, and `file_delete` definitions from `reference/modules/File/unix.jai`. Self-authored test declarations supply opaque libc signatures, assertion/error traps, and a minimal `temp_c_string` helper. That helper only returns the input byte pointer: all filename arguments deliberately contain an explicit NUL byte, so this fixture does not prove the real temporary allocator or general C-string conversion.

The generated program creates a file in its private temporary working directory, writes bytes, seeks, verifies a short EOF read and bytes, checks a zero-size read, closes, renames, removes, and checks missing-file failure. The source Process fixture creates a pipe, forks a child, captures its byte and EOF, waits, and decodes its exit status. The Thread fixtures pass ordinary `#c_call` procedures to `pthread_create`, mutate the supplied stack argument, join before reading it, and check the returned pointer. One callback is a local declaration inside the thread initializer, matching the declaration pattern in the real Thread module. No name-based File/Process/Thread intrinsic replaces a library body.

Each fixture is lowered at `O0` and `O2`. Its executable must finish in ten seconds. Foreign calls in the bounded VM must report `UnsupportedForeignProcedure`; native OS effects are not silently implemented as compile-time effects. All file mutations occur beneath a test-owned temporary directory that is removed afterwards.

The mandatory asynchronous worker fixture uses independently authored synchronization wrappers. An optional source fixture runs the same protocol with unchanged `wake_up`, `block`, `lock`, and `unlock` definitions from `File_Async/thread_pool.jai` and checks that the newer Focus source has identical definitions after newline normalization. Its self-authored request protocol uses real pthread mutexes and condition variables to hand work and completions across a C callback. The worker waits behind a start gate while the caller publishes its saved context after `pthread_create`, matching Thread's suspended initialization order. It writes a file with `pwrite`, checks a short positioned `pread`, captures `EBADF` for an invalid descriptor, preserves completion cookies, and verifies ordinary calls mutate the worker's pushed context without changing the caller's context or saved snapshot. A stop request precedes `pthread_join`; only then are the condition, mutex, and file destroyed. The independently authored C adapter allocates real pthread structures using their installed header definitions and reports that no synchronization objects remain; Jai sees opaque handles rather than guessed layouts. It is compiled from fresh C source by installed Clang as part of each link.

All six fixtures passed on macOS ARM64 on 2026-10-02, including twelve native executions at `O0`/`O2` and twelve VM rejection checks. A separate run with `JAI_RS_OS_SOURCE_ROOT` pointing to an empty owned directory passed all four mandatory authored fixtures (eight native executions and eight VM rejection checks); the two original-dependent cases reported explicit missing-source skips. Rust reports these early-return cases as passed, so they are not counted as source acceptance. Linux is enabled by the fixture but was not executed during those checks.

Current source requirements extend further. Focus uses synchronous File calls in `src/files.jai` and `src/session.jai`, process execution in `src/build_system_unix.jai`, and a custom `modules/File_Async` backend. Jails reads and generates source files in `server/main.jai`, runs diagnostics processes in `server/diagnostics.jai`, and starts ordinary Thread workers. sgpu imports Thread in `memory.jai`, File in its shader/binding generation modules, and Process in `examples/build.jai`. The source hashes and revision-bound inventory live in `artifacts/project-requirements.json`.

`artifacts/os-graphics-project-b1b82044.json` checks the unchanged File, Process, Thread and File_Async module roots, including Focus's File_Async copy, against frozen CLI SHA-256 `b1b820444e2a6585cda11d8efc2bf2186c5a6623cf54312552ba403d4e64fd13`. All five roots pass direct parsing; none passes the complete module check. Dependency parsing first blocks File at `Objective_C/module.jai:702:14` (`struct #type_info_no_size_complaint`), Process at `String/module.jai:894:9` (`for #v2`), Thread at `thread_group.jai:143:7` (`#place info`), and the two async roots at their `thread_pool.jai:103:66`/`:105:66` baked callback expressions. These are actual graph checks with real Preload and `NoEffects`; direct root parsing is not full graph parsing or OS execution.

Focus's `File_Async/module.jai` selects Windows I/O completion ports, Linux `io_uring`, or a macOS pthread pool. The pinned reference module explicitly requires X64 on macOS because its assembly lacks ARM64 fallbacks; the newer Focus source omits that assertion but still contains assembly requiring separate target support. These fixtures test an authored single-worker protocol and the unchanged synchronization helpers, not the full source queues, cancellation, file watchers, full Process pipe capture/exec/timeout behavior, Thread allocator initialization, or any supplied graphics/Slang libraries. The compatibility modules under open-jai contain stubs and cannot establish reference OS library behavior.

## How to change it

Extend source fixtures with actual observable behavior and bounded temporary resources. Keep unchanged reference procedure extraction distinct from self-authored support declarations. Extraction requires an exact declaration name at the beginning of a line: matching `lock` as a suffix of `block` would silently alter the original definition. A reference-definition shape change must fail visibly instead of silently substituting a fabricated implementation.

Change ordinary syntax/type lowering in its owning crate when a library body exposes a compiler gap; change C ABI lowering when a libc signature exposes an ABI gap. Add OS compile-time behavior only through an explicit bounded effect interface, with rejection and resource tests. Importing the entire genuine module and running application workflows is a separate acceptance stage.

Use `tools/check_os_graphics.py` to rerun the eight fixed OS/graphics roots against another already-built frozen CLI. The helper verifies all source manifest hashes before any invocation, clears inherited compiler overrides, selects real Preload with Runtime_Support off, and records only the first diagnostic with its independently verified source hash. Module roots use `check-library`; genuine application/workspace roots use `check`. It never invokes code generation, a linker, a native library, or an upstream build script.

## Configuration

Tests are enabled on 64-bit macOS and Linux. `JAI_RS_OS_SOURCE_ROOT` selects the repository-style root of optional original source inputs; it defaults to the repository root. Missing originals print an explicit `SKIP optional original source` line. Only those source-dependent cases skip; authored Process, pthread, local-callback, and async worker cases remain mandatory. Other source read failures and changed definition shapes fail the test. The optional Focus definition comparison can skip while the pinned reference helper fixture still executes. They use `JAI_RS_CLANG` when supplied and otherwise the installed `clang`; pthread linkage uses `-pthread`. `pthread_t` is treated as opaque pointer-sized storage on these hosts; no pthread mutex or attribute structure layout is guessed. Windows and other OS/architecture combinations are outside this fixture.

Run locally with the repository's trusted LLVM installation:

```sh
RUSTC_WRAPPER= LLVM_SYS_221_PREFIX=/opt/homebrew/opt/llvm CARGO_TARGET_DIR=target cargo test --offline -j1 -p jai-codegen --test os_library_source
```

Reproduce the source-only baseline separately:

```sh
python3 tools/check_os_graphics.py \
  --compiler artifacts/integration-checkpoints/callback-baseline-20261002/jai-rs \
  --binary-sha256 b1b820444e2a6585cda11d8efc2bf2186c5a6623cf54312552ba403d4e64fd13 \
  --report artifacts/os-graphics-project-b1b82044.json
python3 -m unittest discover -s tools -p test_check_os_graphics.py
```

The baseline command exits with status 1 because the complete checks fail; it still writes the diagnostic report. `--timeout` bounds each source command (25 seconds by default). The report must remain under owned `artifacts/`; compiler selection is restricted to this repository's `target/` or `artifacts/integration-checkpoints/` and requires an exact SHA-256 checked before and after the run. Current working-tree hashes are deliberately not attributed to an older frozen executable.

## Dependencies

The parser/module graph, semantic resolver, checked VM, LLVM backend, trusted installed LLVM/Clang, and the host libc/pthread implementation. Original `.jai` text is optional at test runtime. Tests create their own executable and object files; supplied native dependencies are never used.
