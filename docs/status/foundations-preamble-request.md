# General host/target predicate needed by Preamble

Resolved through the NEW compiler producer's general compiler_host constant
support: BUILD_* now denote the compiler host and OS/CPU denote the target.
Read-only source refresh/rebuild passes the independent WASI predicate and
Preamble production WASI O0/O2, retaining native scoped behavior. No Rust or
private staging compiler patch was made. The original failure evidence below
is retained for review; this is no longer an outstanding cross blocker.

The synchronized Basic contract now defines Preamble's scoped effects and
cross-compilation early return. Its real native implementation and regression
are present: allocator-family exclusions, reentrancy flag, caller-scoped defers,
default logger substitution/restoration, and actual debugger index initialization.
Basic adds inside_memory_debugger once through internal/basic-context; do not
duplicate that field in Runtime_Support.Context_Base.

The supplied NEW compiler has no usable host/target distinction: decls.rs
target_constant handles OS/BUILD_OS together and CPU/BUILD_CPU together, using
self.options target values. Therefore the provisional library comparison
OS != BUILD_OS || CPU != BUILD_CPU is always false. Cross behavior is NOT claimed
complete and must not be accepted as a working cross-compilation flag.

Original general probe: tests/portable-stdlib/pending/host-target-predicate.jai.
On this native macOS/ARM64 compiler, the following should distinguish the WASI
target but currently fails its compile-time assertion:

```sh
JAIC_STDLIB=$PWD/target/foundation-integration/stdlib target/peer-compiler/debug/jaic -check -target wasm64-unknown-wasi tests/portable-stdlib/pending/host-target-predicate.jai
```

Requested semantics: a genuine general compile-time host/target predicate,
false for native compilation and true when target OS or CPU differs from the
compiler host. Producer can supply the appropriate host constants/API rather
than assuming BUILD_* semantics; Basic will use the supported mechanism.
No Basic/module/path/fixture-specific bypass, private staging Rust patch, or
new invented public Basic parameter is requested. Compiler ownership owns the
Rust fix. Test native, WASI, and same-OS/different-CPU compilation.

basic-preamble.jai verifies native scoped restoration and explicitly requires
zero bookkeeping calls for the WASI cross target, so it exposes this defect
rather than deriving its expectation from the broken BUILD_* comparison.
The actual Flat_Pool producer is absent; its documented CAPS_VERSION_STRING
is used to recognize that allocator family without importing a nonexistent
module. Exact family matching should be confirmed by dirty review.
