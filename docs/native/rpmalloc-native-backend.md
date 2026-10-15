# Private rpmalloc SDK backend

`internal/bindings/rpmalloc-sdk` is a complete private binding to the pinned
official C SDK. It is not either public Jai allocator implementation. The
public module still has 23 unresolved and 57 partially implemented declarations; configuration
failures remain active. No public callback/config/heap record is cast to C.

Production SDK compilation now uses `rpmalloc-heaps/bridge.c`, which includes
the pinned official SDK source with the hash-recorded heap-pool page fix and adds canonical record ownership,
atomic field marshalling, real deferred-free routing and unmap-driven retirement.
The original 35 native SDK functions and storage ABI remain unchanged. Public
and private evidence are distinguished in the canonical heap design document.

The private STATISTICS module parameter selects separately compiled enabled
and disabled SDK libraries. Disabled exports use the generated
`binding_rpmalloc_nostats_` prefix for every header/source function. The matching
callback library prefixes its own lifecycle functions and calls that same SDK
domain. Checked alignment imports the same parameterized SDK. The production
dependency builder reads the verified complete export metadata and compiles
the prepared pinned source with ENABLE_STATISTICS=0 for the alternate domain.
The original vendor files stay untouched; the separate build patch and all
hashes are documented in the canonical heap design. Mixed-profile native programs verify
allocation, failure rollback and lifetime isolation. Default-profile native
Heap/Span layout probes do not establish disabled-profile heap layout; no public
heap operation uses either native record as its public representation.

`vendor_rpmalloc.py` verifies the complete native header/source/license pins in
`dependencies.json`, parses the real header through Clang with first-class heaps
disabled and enabled separately, and emits all 35 native function declarations.
The complete source-definition scan retains the main-thread setter omitted
from the public C header; it never infers a Jai helper body from native code.
It organizes functions by lifecycle, thread management, statistics, allocations
and heaps. Native records retain field order and nested anonymous record arrays;
unrecognized types, associations, unions, attributes and bitfields fail generation
instead of being dropped or flattened. The native heap remains an opaque pointer
type confined to this backend, never a public `Heap`/`rpmalloc_heap_t` alias.

All three complete SDK config/statistics records and 40 field size/offset probes
are generated from that header. The C probes compile against complete native
headers for six desktop target triples. Actual C/Jai size/offset comparisons run
on macOS x64 (OS translation) and ARM64. Source/header checks do not establish
Windows/Linux native execution. Generation metadata and the per-function
inventory appear as a supplemental private backend in `bindings-coverage.json`;
they do not increase public implemented counts.

The explicit private C build profile enables native configurable sizes,
first-class heaps, statistics, assertions and argument validation, and disables
malloc overriding. These choices are centralized in
`tools/native_bindings/config.py`; they are not inferred public Jai defaults.
Other public option combinations require their own faithful implementation or
reviewed native adapters. `build_dependencies.py` now builds the hash-verified prepared
source into `binding_rpmalloc_sdk`, plus the generated C layout probe. The actual
full native dependency builder passed with outputs in
`.work/native-production-check`; this is dependency-build evidence, not final
production stdlib integration.

The generated backend explicitly rejects non-64-bit pointer ABIs. Its Windows
native packaging/SDK/CRT/advapi32 linkage still needs the coordinator's native
build pipeline; the worker dependency builder is verified on the actual macOS
host. Linux/Windows artifacts and execution are not supplied by the two-CPU Mac
test archive. The returned native configuration pointer is borrowed/read-only,
even though Jai has no C const-pointer qualifier in this private declaration.

The real private native unit calls every one of the 35 SDK entry points. It
checks preserved realloc data, aligned allocations, calloc zeroing, actual
usable sizes, matching heap ownership, bulk free/release, current-heap changes,
thread/global lifecycle, both initialization routes, real nonempty statistics
file output with checked I/O, and canaries around complete statistics buffers.
Allocation/config callbacks are null in this test; custom callback invocation
and concurrency are not established by these results.
The pinned native SDK itself implements `rpmalloc_thread_collect` with an empty
body. Forwarding/calling that real symbol does not establish deferred-collection
functionality; the public Jai implementation still must meet its reviewed
contract. The native linker-reference hook is also intentionally empty, as its
header documents. Neither native no-op is authored here or credited as completed
public behavior.

An invalid-alignment experiment expected an error for alignment 3 and aborted
on both CPUs. Triage against the complete official header/source classified
that expectation as an incorrect oracle for the raw SDK: power-of-two alignment
is a caller precondition, and its small-alignment fast path precedes validation.
The POSIX-named entry point also writes caller output directly. No public Jai
compatibility defect is inferred from this out-of-contract SDK request. The
private `rpmalloc-checked.posix_memalign` offers a separately defined safe
boundary and now rejects
null output slots, non-power-of-two/too-small/span-sized alignment before the
SDK call. It forwards valid requests through the actual SDK, uses temporary
output storage, propagates native allocation errors and only commits the output
on success. Active tests retain invalid-alignment/null-output/oversized-allocation
failures and unchanged output canaries. The original failing experiment remains
in `.work/rpmalloc-sdk-alignment-before-guard.json`. This helper is not exposed
as a public convenience or counted as completed public validation semantics.

Private units and their generated dependencies are copied byte-for-byte into
their legitimate staged library boundary by `place_private_unit`; public facade
files and compiler privacy checks stay intact. The same general runtime placement
now applies to existing DXC units as well as the iOS toolchain unit. Outside that
boundary, the compiler correctly rejects private imports. The initial x64 SDK
link failure used a host-only archive; rebuilding real x64/ARM64 objects into a
universal archive fixes it without extra library-search overrides. Its failure
report is `.work/rpmalloc-sdk-before-universal-archive.json`.

Verification: `.work/rpmalloc-sdk-both-cpus-tools.json` records actual two-CPU
execution, staged source hashes, artifact hashes, production formatting, strict
lint, regeneration and generator tests. `.work/rpmalloc-sdk-private-current.json`
keeps the six public module failures separate from passing private native/source
checks. `.work/native-dependency-production-build.json` records the real builder.
Reproduce generation with `vendor_rpmalloc.py --check --formatter <own jaifmt>`;
build dependencies, then run `verify.py --module rpmalloc --runtime --compiler
<own compiler>`. That command must still fail until the public implementation is
finished; private SDK successes are not a substitute for it.

The default rewrite now has actual public lifecycle/allocation/statistics and
callback/configuration adapters; see [public adapter scope](rpmalloc-public-adapter.md).
Remaining proper implementation: full callback/context policy and option coverage,
both allocator variants and exact contextual heap/span
behavior, all module options, allocator-procedure integration, canonical alias
reflection/storage identity and all public overloads. The private first-class
heap default still needs reviewed clarification; raw aliases are now correctly
mode-guarded. Complete contextual heap shapes are specified and generated and remain actual
implementation work, not missing header contracts. Do not turn this backend's
opaque heap into a public nominal alias or ignore options to make imports pass.
