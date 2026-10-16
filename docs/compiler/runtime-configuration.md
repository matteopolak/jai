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

Nondefault initialized target runtimes must consume this configuration through the
private getter or the reviewed public compiler constant TEMPORARY_STORAGE_SIZE in their
exported target graph. Calls, procedure addresses, globals and relocations participate
in that graph. Merely inspecting it at compile time or checking an unused getter
does not remove the diagnostic for an older runtime. This establishes that the
target consumes the protocol; the runtime implementation remains responsible for
using the value consistently for allocation and size metadata. Actual allocation
accepts nonnegative values fitting the reviewed s32 option. NO_OUTPUT workspaces
retain metadata and do not allocate target runtime storage.

## Retained startup dependencies (2026-10-16)

Configuration validation follows the effective target image of reachable
`#no_reset` globals, rather than their declaration-time relocations.
A private startup callback installed during compile-time execution must count
as a real target reader. Conversely, replacing an initially configured callback
with a non-reader must remove the old dependency. Unreachable retained globals
and globals reset before target execution cannot authorize the protocol.

The validator indexes retained globals and uses the existing canonical
aggregate-to-target serializer for each reached materialized global. This can
materialize pointed-to IR data just as emission does; it introduces no new
pointer-reading mechanism. Current-image edges replace initializer edges.
The original retained global initializer and registration are not prematurely
baked or consumed, so later settlement/validation still observes updated state.
Serializer failures propagate. Visited function/global sets bound cyclic graphs.

The rejection retains its original message and adds actual workspace, size,
entry/initialization, exported-target count and lowered-reader facts to distinguish
missing startup lowering from an unreachable reader. It adds no public API.

Independent tests retain old-runtime/compile-time-only rejection, invalid ABI and
range checks. They cover direct startup, retained callbacks, overwritten callbacks,
reset/unreachable callbacks, nested aggregate/array callbacks and cycles.
A true runtime-support fixture executes its private retained startup reader on
native and bare WASM at O0/O2. Canonical approved e0 runtime allocation of 1048576
bytes additionally passes interpreter/native O0/O2 checks of size/original_size,
data/original_data identity and the last valid byte.

## Public compiler constant startup transport (2026-10-16)

Custom runtime providers may use the reviewed immutable compiler constant
\`TEMPORARY_STORAGE_SIZE\` to size target static storage. This retains the canonical
s64 constant and ordinary type/storage identity; no public parameter or new API
is introduced. The private getter remains available for dynamically allocated
runtime storage.

The compiler records dependencies when the actual builtin binding resolves.
Dependencies survive cached constant aliases, array type aliases and record
layouts. They attach to resolved declarations and emitted procedure bodies,
rather than structurally interned array TypeIds. Reachability then follows the
same exported target graph used for the private getter. An unrelated hardcoded
array of the same type, a shadowing ordinary constant, compile-time assertions,
and unused declarations cannot opt a runtime in.

Static target storage cannot silently change extent after binding. If a reached
constant dependency captured a different size from the final workspace setting,
finalization diagnoses both values, including changes back to the default.
A private dynamic reader cannot mask a stale static extent. Set the workspace
option before resolving static target declarations. General provenance through
arbitrary compile-time procedure results is not established by this checkpoint;
those cases retain conservative rejection rather than fabricating a dependency.

Independent controls cover direct/aliased extents, cached record layouts,
scalar target reads, compile-time-only/unused/shadowed negatives, late conflicts
and mixed static/dynamic consumers. Native C and bare WASM controls execute O0/O2
startup and inspect the actual first and last bytes of 1048576-byte storage.
The canonical e0 private runtime separately allocates real 1MB root and child
storage under interpreter and native O0/O2 execution.

Root's matching e0+owned-patches Focus replay now passes \`-check\` with only the
two authorized version-rejection calls bypassed. This is qualified application
evidence; it does not claim unmodified Focus or the combined integration candidate
passes. Build/execution and the separate custom Basic replacement-interface
dependency remain root-owned gates. The excluded Focus Runtime body was never
read; root supplied only its public-constant/static-extent contract and diagnostic
facts. Source pins and retained failure receipts are in the
[checkpoint](../status/runtime-config-startup.json).

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
