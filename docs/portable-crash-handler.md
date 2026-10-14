# POSIX crash diagnostics

`Runtime_Support_Crash_Handler` implements the reviewed Linux/macOS declarations
and initialization/handler entrypoints. `Runtime_Support` installs it when the
bootstrap's `ENABLE_BACKTRACE_ON_CRASH` parameter is enabled. Explicit imports
share that bootstrap instance; use `Compiler.Build_Options.backtrace_on_crash`
to configure a compiled workspace.

The facade loads canonical public records separately from private operations.
The implementation uses a newly written C backend for native signal handlers
and pthread TLS destructors. These callbacks can execute after the interpreter
ends, so they cannot retain interpreter procedures. The backend pins its own
dynamic library for process lifetime and initializes signal handling once.
Each calling thread receives its own alternate signal stack; thread-exit cleanup
disables and frees that owned stack. Repeated calls are idempotent. Initialization
errors are checked and reported through the normal assertion path.

The fatal handler writes the signal and a best-effort native backtrace, resets
the signal disposition, and raises the original signal again. Recursive or
concurrent fatal handling exits immediately. It avoids the Jai allocator and
context. Native `backtrace` and symbol output still have platform crash-safety
limits; this is diagnostic support, never recovery. Public x64 context prefixes
are retained exactly as reviewed but are not dereferenced on other architectures.

Build the private library from our source before compiling dependent programs:

```sh
python3 -B tools/build_portable_runtime.py
```

The focused regression runner performs this step automatically. The library is
currently generated beside its private source so the compiler's source-relative
library lookup works. The macOS generated library uses a build-tree install name;
deployment relocation/packaging remains coordinator integration work. No generated
binary is committed. Linux is compile-checked from the Jai side on this host;
Linux native C building/execution and Windows exception handling remain unverified
or unimplemented respectively.

Tests require actual fatal signal termination and diagnostic bytes for both
explicit SIGSEGV and a real protected-page write, in interpreter and native runs.
Four simultaneous worker threads verify distinct alternate stacks and clean exit.
The source-built Compiler workspace test verifies native startup with the option
ON and an OFF control, without manually calling handler initialization.

Initialization replaces a preexisting alternate stack and installed handlers;
there is no reviewed teardown API and no restoration of previous handlers/stack.
Callers needing another signal owner must coordinate installation. Symbol names
and signal text are diagnostics, not an asserted byte-for-byte reference format.
