# Required native libraries in interpreted programs

The interpreter previously opened a library only while resolving one of its
foreign symbols. A `link_always` library whose constructor registers classes or
other process state could remain unloaded. Actual native executables loaded it;
the same Objective-C program then failed only in the interpreter.

Required native library metadata is now resolved for named declarations during
import expansion, matching unnamed declarations. Only literal library metadata
is resolved: this does not lower unrelated exports, finalize Context or relax
private imports/module parameters. The interpreter loads required libraries
before runtime execution and before native foreign lookups, retaining handles
in its existing per-program library cache. New libraries appended by source
expansion are included. Failure is an explicit trap naming the required library.

Pure compile-time code does not load the native output's requirements merely to
evaluate a constant. Actual compile-time native foreign lookups initialize them.
SandboxHost never invokes the native loader. These are capability distinctions,
not a successful native-link claim for unavailable libraries.

An original source-built C constructor writes a real marker without exposing a
referenced function. Four cases cover named/unnamed declarations and runtime/
compile-time native execution; ordinary cases also build and execute actual Mac
ARM64 O0 executables without loader environment overrides. The original test
failed on the missing marker. Precise missing-library failure, pure compile-time
evaluation and SandboxHost isolation tests pass. The original Objective-C runtime
fixture now passes interpreter execution after its native execution already passed.
Linux/Windows native verification remains required; the C constructor test is
Unix-specific and supplies no Windows execution evidence.

A stronger Mac constructor checks pthread_main_np. It first aborted because
dlopen itself ran on the compiler worker. Native loading now uses the existing
synchronous main-thread dispatcher on Mac, including callback/crash attribution,
with the ordinary direct/fork/foreign-thread boundaries retained. This is a
general loader operation, independent of library names and exported symbols.
The strengthened original constructor cases and failure/isolation tests pass.

Each native lookup currently scans the program's library metadata and reuses
cached handles. This costs O(number of libraries) metadata checks; no benchmark
claim is made. A measured incremental cursor may optimize append-only programs,
provided dynamic source additions and failed-load diagnostics remain correct.
The existing non-required explicit-library/global-symbol fallback policy is
unchanged and requires separate reviewed lookup-policy audit.
