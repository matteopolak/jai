# Private target runtime configuration

The compiler carries the finalized workspace `temporary_storage_size` in private
target data. `stdlib/internal/compiler-api/runtime-config.jai` provides the
private no-context getter `temporary_storage_size() -> s64`; its intrinsic has
no parameters and an exact s64 result. No public Runtime_Support parameter or
Compiler facade export is added.

The getter emits a real load of one aligned eight-byte readonly global. Referencing
the intrinsic as a procedure value gets the same load in its ordinary generated
wrapper. After settling, reachable lowering and unused-code checking, the compiler
updates the data and refreshes its interpreter allocation. Interpreter entry-context
allocation uses the same settled option. Compile-time reads made before settlement
can see the then-current value; they do not freeze the final target value.
The Rust drivers refresh configuration again immediately before execution or
emission. Thus an unintercepted child changing the selected root workspace after
the root front end finishes still configures the actual root allocation.

Nondefault initialized target runtimes must read this configuration from their
exported target graph. Calls, procedure addresses, globals and relocations participate
in that graph. Merely inspecting it at compile time or checking an unused getter
does not remove the diagnostic for an older runtime. This establishes that the
target consumes the protocol; the runtime implementation remains responsible for
using the value consistently for allocation and size metadata. Actual allocation
accepts nonnegative values fitting the reviewed s32 option. NO_OUTPUT workspaces
retain metadata and do not allocate target runtime storage.

## Producer integration

The portable producer owns Runtime_Support and its private startup/allocator.
Required integration is explicit, with no peer edit from this worker:

- Remove TEMPORARY_STORAGE_SIZE from the public Runtime_Support parameter header
  and the facade's imports. Retain exactly the three reviewed boolean parameters.
- Remove the forwarded size from internal/runtime and internal/runtime/startup
  parameters/imports. Keep the backtrace flag in startup.
- In the private runtime initializer, read
  `Runtime_Config.temporary_storage_size()` into one local `temporary_size`.
  Use that local for `storage.size`, the positive-size condition and malloc extent.
  The private import is `Runtime_Config :: #import "internal/compiler-api/runtime-config";`.
- Retain allocation-failure cleanup, zero-size null data, original_size/data,
  overflow allocator and runtime finalization behavior.

`tests/compiler-semantics/runtime-configuration/stage-candidate.py` creates this
candidate only under this checkout's target/runtime-configuration-candidate.
It copies the canonical NEW library when present, otherwise the independently
assembled own-target library, and applies checked substitutions to
the three NEW runtime files, and copies the owned private helper. A changed input
old transport fails staging. An already adapted runtime with the private import
is retained and still must pass actual allocation tests. Generated declarations
are normalized consistently and regeneration passes jaifmt --check. This is a reviewable integration candidate; it is not a
change to the canonical portable producer or production integration evidence.

## Executed evidence

- Core: distinct compiler instances for sizes 0/65536/131072; late replacement of
  already-interpreted data; direct and procedure-value reads; invalid ABI/range
  diagnostics; old-runtime rejection after compile-time or unused reads.
- Native/WASM64 O0/O2: actual execution of both getter forms through the shared
  backend harness. That focused harness supplies real memcpy/memset and throws
  for unexpected runtime imports; it is not the production WASM runtime.
- Staged full runtime: interpreter and actual native O0/O2 allocate 65536 bytes
  after a public late root setter, verify original/data extents and touch the last
  byte. Two independently configured child workspaces build and execute native
  programs with 0 and 131072-byte storage. Zero storage retains null data; the
  larger allocation is accessed at its last byte. Compiler-API option round-trip
  alone is not counted as allocation support.
- Cross-workspace late update: an independently compiling NO_OUTPUT child changes
  its selected root setting after the root front end has finished. Actual root
  interpreter/native execution allocates 131072 bytes and accesses its last byte.
  The original regression failed before the driver refresh was added. The test
  uses the Rust registry's own TOP_LEVEL_WORKSPACE identity, not a new public Jai
  helper or an inferred reference-workspace numbering contract.

The isolated CLI integration test requires the explicit independent library
assembled in target/cleanroom-test-stdlib; an integrated checkout uses its canonical
NEW stdlib without that staging prerequisite. Its first child run used check-only mode and correctly
created no executable; the harness now runs the build metaprogram in interpreter
mode with workspace output enabled, then executes each child. The prior failed
log remains. Rebuilt repository jaifmt/jailint check the owned helper and fixtures;
stale-linter incomplete-compilation output is retained separately.

Production producer adoption and platform/full-corpus verification remain
coordinator gates. Windows cross-compilation checking is not runtime allocation
evidence on Windows. No unreviewed public size parameter is used by this compiler.

Reproduction commands (source-built tools, own durable output directories):

```sh
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo build --locked -p jaic-cli --bin jaic
python3 tests/compiler-semantics/runtime-configuration/stage-candidate.py
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo test --locked -p jaic-cli --test cleanroom_runtime_config
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo test --locked -p jaic -p jaic-llvm --test cleanroom_runtime_config --test cleanroom_namespaces
JAIC_STDLIB="$PWD/target/runtime-configuration-candidate/stdlib" python3 tools/dev.py fmt --check --lang jai stdlib/internal/compiler-api/runtime-config.jai tests/compiler-semantics/runtime-configuration
JAIC_STDLIB="$PWD/target/runtime-configuration-candidate/stdlib" target/debug/jailint -v -D warnings stdlib/internal/compiler-api/runtime-config.jai tests/compiler-semantics/runtime-configuration/main.jai tests/compiler-semantics/runtime-configuration/allocation.jai
```

Inspect verbose linter output as well as exit status: the earlier stale binary
returned zero while reporting incomplete compilation. The rebuilt final run
reports every requested root and no incomplete body.

The candidate's three edited runtime roots now also pass jaifmt --check and
rebuilt strict jailint. General linter repairs reviewed from the NEW platform
producer preserve library source origin, nested module names, actual configured
bootstrap instances and loaded-file reporting. Strict preparation of bootstrap
exports handles lazy required-parameter imports before reusing their instances.
IDE checking errors are reported, and incomplete checking always returns failure.
No source on disk is created to authorize private imports; the wrapper is virtual.
Original application-private-import rejection remains. Library-call rules follow
exported procedure IDs and their explicit instance trees, preserving local shadowing
instead of matching implementation directories or coincident source spans.
