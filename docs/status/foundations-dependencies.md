# Current Basic dependency requests

## Compiler/File unused-code target dependency

Real leak reports use the reviewed Compiler.get_runtime_info global segment
metadata. The new implementation passes production WASI O0/O2 execution;
strict unused-code WASI checking additionally traverses Compiler's unrelated
file helpers and fails in the File producer's native-unix backend because
POSIX.FILE is not exported on that target. Read-only NEW platform-io File and
Windows text-source refresh resolves Windows x64/arm64; WASI remains failing.

Minimal original source: pending/basic-unused-platform-dependency.jai, containing
only `#import "Basic"; main :: () { assert(true); }`. The real API use also
keeps the minimal source valid under strict unused-import lint. Reproduce:

```sh
JAIC_STDLIB=$PWD/target/foundation-integration/stdlib target/peer-compiler/debug/jaic -check -no_dce -target wasm64-unknown-wasi tests/portable-stdlib/pending/basic-unused-platform-dependency.jai
```

Observed diagnostic: internal/files/native-unix.jai, `handle: *P.FILE`, POSIX
has no exported FILE. The preceding snapshot failed Windows too, in file.jai;
that failure is preserved in the progress evidence. No check was disabled.
Proper fix: File/integration owner should guard its private native ABI/backend
for unsupported WASI targets, or implement a supported WASI libc/file ABI. Use
coherent
conditional compiler API/library dependencies so unused runtime reflection
does not require unsupported native file declarations. No module-specific
compiler bypass or fabricated FILE layout is requested; no peer file is edited.

## Allocator CAPS provider and host/target support

The new sync supplies the exact name-out ABI: CAPS receives zero sizes, *string
as old_memory, and null allocator_data; its return encodes flags. Basic now
implements it and the owned temporary allocator supplies a name. NEW runtime
and Pool providers still require audit: the runtime returns flags without a
name, and the snapshot Pool asserts allocator_data is non-null before handling
CAPS even though get_capabilities passes null. Correct their producer bodies
without changing Basic's reviewed ABI. Basic must not manufacture their names.
Original pending/pool-capabilities-name.jai reproduces the Pool failure using
only public APIs; it is not counted as a completed runtime case.

Preamble native scoped effects and cross early return now pass with the NEW
compiler general BUILD_OS/BUILD_CPU host fix. The separate predicate request
retains the original failure and current native/WASI verification evidence.
No Basic-specific compiler bypass was introduced.

## Visualization producer coverage

The NEW Shared_Memory_Channel producer supports macOS/Linux mappings and
explicitly asserts those targets. The reviewed Basic channel protocol/lifecycle
requires a real channel; Windows/WASI visualization transports are pending
native producer coverage. The foundations backend must log explicit unsupported
connection behavior there rather than pretend a message was sent. Production
debugger allocation checking/reporting remains independently supported.
