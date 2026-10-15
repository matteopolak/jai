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
Proper fix: File/bindings producer's supported WASI libc/file ABI, or coherent
conditional compiler API/library dependencies so unused runtime reflection
does not require unsupported native file declarations. No module-specific
compiler bypass or fabricated FILE layout is requested; no peer file is edited.

## Allocator capabilities and debugger macro review

Basic's reviewed get_capabilities must return flags and the allocator-supplied
name, while Allocator_Proc has one *void result. Specify the CAPS output-name
calling convention precisely. NEW runtime currently returns flag bits only.
Specify Preamble's caller-scope initialization/locking/defer effects as well.
These questions do not gate the other real implementations.

## Visualization producer coverage

The NEW Shared_Memory_Channel producer supports macOS/Linux mappings and
explicitly asserts those targets. The reviewed Basic channel protocol/lifecycle
requires a real channel; Windows/WASI visualization transports are pending
native producer coverage. The foundations backend must log explicit unsupported
connection behavior there rather than pretend a message was sent. Production
debugger allocation checking/reporting remains independently supported.
