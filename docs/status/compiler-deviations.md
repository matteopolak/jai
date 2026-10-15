# Compiler deviations and implementation gaps

Windows worker lifecycle now has real CRT entry/result and kernel completion, private join ownership, cooperative teardown and compiler-owner drop ordering; no parked OS workers are counted complete. Native CI is pending. Explicit bounds: native Rust panic=unwind dependency with tested abort diagnostic; nonreturning foreign work/callback shutdown coordination; private join handles/records retained until teardown; short final OS completion polling; unregistered alias suspend/resume unsupported with rights-independent identity checks; interpreter custom stack/security/unsupported flags diagnose. UCRT/Kernelbase/Windows 10+ dependencies need native linking/execution evidence. All locations, effects, rationale, failure evidence, risk and proper long-term fixes: compiler/windows-thread-entry-lifecycle.md. Full-suite classification and missing coverage: compiler/full-suite-triage.md. No integration reporting-hook/LSP algorithms, peer files or Extensions changed. Initial extra LSP verification raced a concurrent owned runtime-candidate rebuild (25 library pass, auto-import 15/16); failure retained and serial rerun passes 25/16. Root cause repaired with per-process CLI fixture staging; concurrent runtime/LSP checks pass and shared candidate metadata stays unchanged, without LSP code/assertion changes.

Checked-expression results use actual per-procedure semantic snapshots; no module exception or fabricated result descriptor. Snapshots add O(checked expressions) memory/hash work without a throughput claim. Repeated source spans with incompatible expansion types remain explicitly ambiguous/null; generic templates and unchecked syntax have no concrete result-type guarantee. Constant-array .data still copies through address_of; reviewed identity/lifetime/mutation is unresolved, so no shared writable pooling change was invented to satisfy the retained assertion. Exact locations/effects/evidence/risks/long-term fixes and test-setup corrections: compiler/typed-expression-metadata.md. No peer writes or broader status globs occurred after resumption.

RESUMED by explicit user authorization: coordinator verified the four status excerpts came from independent integration-clean baseline 769acd1 and contain no forbidden implementation. Disclosure retained locally; exclude incident report from final published history. No broader provenance inspection performed. Named NEW developer-tools reproducers are the current scope.

CPUID review: no fake CPU result, module exception or public API workaround remains in its implemented scope. LLVM register constraints retain architectural serialization and ABI saving; interpreter queries its executing x64 host. Non-x64 hosts/targets explicitly reject execution/lowering. Actual Windows/Linux native execution remains a platform gate, and no throughput claim is made. Initial uninstalled GNU Rust-target and CLI cross-selection failures are retained, then corrected using installed MSVC targets/explicit target triple. Source-built x64 jailint validates the active x64 fixture. Separate preexisting synthetic RDRAND/RDSEED, RDTSCP processor ID and WASM counter paths remain genuine gaps and are not counted complete. Exact location/effect/risk/long-term fixes and evidence: compiler/cpuid.md.

Forward-overlay review: no module-specific workaround or public-field reordering remains in the implemented layout/type scope. Iterative graph uses linear extra storage; promoted-name searches still scan using paths, with no throughput benchmark claim. Mapper results cache per declaration/instance to prevent repeated execution. SDK ABI discrepancies and missing D3D binding dependency remain producer/spec gates, not compiler successes. Initial stale-linter and concurrent candidate/LSP staging failures are retained; stable rebuilt verification passes. Conditional field-selection fixed-point behavior remains a precise reviewed-contract question. Exact locations, evidence and proper follow-ups: compiler/forward-overlay-layout.md.

Windows managed thread handles now retain real kernel ownership and names/HRESULTs remain native; no fake success, name cache or module exception. No avoidable naming workaround remains in the reviewed source scope, but native Windows runtime verification is pending. Unmanaged duplicate suspension/resumption diagnoses unsupported behavior; duplicate exit/wait APIs remain native rather than scheduler aliases. Existing parked-worker teardown behavior is retained while owned Windows references are released. Extra native-handle registry lookup uses a mutex; no measured performance claim. Exact code/test scope, staging repairs, protected-close semantics and gates: compiler/windows-thread-handles.md.

Windows unwind follow-up: proper async ABI metadata is emitted generally before/after optimization, without changing optimization, calling conventions or inventing frames. Safe LLVM metadata construction is necessary because the C API lacks the documented Max flag enum; errors propagate. Two linear module sweeps cover synthesized definitions (performance not benchmarked). Six cross object/PE cases and SDK driver cross-builds pass; actual Windows x64/ARM64 backtrace execution remains a platform gate. The unchanged producer O2 true-leaf assertion is unsound and remains unmodified/unclaimed. Details, retained harness parsing failures and exact artifacts: compiler/windows-unwind.md. No new peer writes or forbidden-source access occurred.

Host-target follow-up uses a shared private host mapping, with no module exceptions or new public Jai exports. Unsupported compiler hosts now fail the Rust build explicitly rather than masquerading as Linux/X64. Actual cross-native execution is not claimed; cross-WASI/native execution and wasm32 host identity are verified. Browser child failure now stops parent execution; structured failure is workspace-level while original child diagnostics remain on stderr (separate source maps). Broader browser suite has eight preserved dependency/legacy failures; cross-only predicate cannot pass native-only jailint and its failure is recorded. Candidate runtime adoption remains pending; no new peer writes occurred. Locations, evidence, risks and remaining work: compiler/host-target-constants.md.

Late cross-workspace runtime configuration is now refreshed by the Rust CLI and
workspace emission drivers immediately before execution/output. The original
child-to-root update test failed before this repair and now executes real 131072
root allocation in interpreter/native modes. The test uses the compiler registry's
own root identity, not an asserted public reference numbering scheme. Changes
after object emission/custom linking are not given a new code-rebuild guarantee.

Strict linter follow-up: NEW platform producer root/context and diagnostic fixes
were reviewed and integrated generally. A virtual library-owned wrapper preserves
private import policy; strict bootstrap preparation resolves real lazy parameter
bindings before reuse. Incomplete compile/IDE checking now diagnoses and fails.
Original privacy, required-binding, CLI failure and generic alias/shadowing tests
pass. All existing linter rule expectations remain unchanged; the rule test helper
now honors explicit JAIC_STDLIB selection. The first unconfigured CLI regression
run failed library discovery; its log is retained. Candidate startup lint initially
lost privacy and then required parameters; both root causes are repaired rather
than inventing argument defaults. The lazy fixture's C caller needed an explicit
no-context helper; that invalid test setup was corrected with the failure retained.
Procedure alias matching uses exact IDs/instance relationships, improving on the
NEW producer's span comparison. Public export/instance searches add linear work
for private-alias rule calls; cache the resolved public identity graph if profiling
shows a material cost. Warm bootstrap preparation adds a strict compiler finish
for module roots. Target-selection/manifest and other platform producer linter
features are not all ported in this scoped repair; no full-platform lint claim.

Nondefault runtime storage now has private compiler-provided finalized target
data and a no-context getter, with ABI/range checks and direct/procedure-value
interpreter/native/WASM64 execution. The finalized option also configures new
interpreter entry contexts. Actual staged NEW runtime allocation passes for a
late 65536 root setting and independent native 0/131072 child workspaces.
Production adoption is pending in the portable-owned runtime; the checked test
adapter modifies only own target copies of three NEW runtime files, removing
public size parameters and reading the private getter for allocation/metadata.
This is candidate integration evidence, not production/corpus verification.
Older target runtimes retain diagnostics even after compile-time or unused
getter reads. Invalid allocation sizes reject; NO_OUTPUT metadata is distinct.
Existing host compile-time contexts are not resized by later setters; that exact
contract question is recorded. Startup allocation-failure behavior remains the
runtime's responsibility. Existing debugger/AST/backend limits below remain.
See compiler/runtime-configuration.md for location, commands and producer edits.
Initial child check-only and stale-linter failures are retained; neither is
counted as native allocation or strict lint success.

LSP alias documentation resolves simple named-import/load/local alias graphs
with lexical/export visibility and cycle guards. The token index still falls
back to the original expression for computed aliases, struct namespaces and
unnamed import/filter resolution; it does not fabricate signatures. Existing
four-header/200-byte display bounds remain. local_decls retains private metadata
in the scan cache for lexical resolution, increasing cached declaration storage;
stdlib scans are discarded by the existing cache lifecycle. Full semantic alias
documentation would use the compiler's resilient symbol graph once available.
The auto-import test helper now accepts explicit JAIC_STDLIB selection; actual
original Basic print/ranking assertions pass without modification or substitute.

Windows suspended-thread gap repaired through scheduler suspend counts and CRT
entry/exit interception. Host-executed original tests exercise real Rust OS
threads under the baton, not native Windows APIs. Non-Windows id values are
scheduler-test identities; Windows records actual GetCurrentThreadId values.
Actual Windows x64/ARM64 execution of the staged producer repro remains required.
SuspendThread while a target is inside native code and termination of entry or
adopted native callback threads explicitly diagnose unsupported behavior. Existing
interpreter thread stack sizing/security-attribute emulation remains reduced;
the requested native stack size/security descriptor is not implemented. Managed
handles support the intercepted operations, not arbitrary native HANDLE APIs.
Proper remaining work: platform runtime validation, configured stack/security
support and deliberate native-handle interoperability. No Windows runtime pass
is claimed from a cross-target check.

Qualified constant-write gap repaired in sema/stmt.rs: validation follows all
aggregate containers, preserves pointer boundaries and caller-scope macro names,
and applies to existing-target declarations. Original invalid and real mutable
interpreter/native/WASM regressions pass. Exact staged NEW MPEG failures now
diagnose const writes after refreshing portable/numerics dependencies. This is
language assignment validation, not a readonly raw-pointer type system; existing
raw-address semantics and the separate indexed-constant lifetime question remain.

## Unintended producer-runtime artifact write (2026-10-14)

Running NEW `../stdlib/tests/portable-stdlib/mpeg-buffer.jai` in interpreter mode
executed its file-writing assertions. The fixture derives its path from #file,
so it wrote and then deleted `../stdlib/target/portable-tests/mpeg-buffer.bin` outside this worker
checkout. This violated the no-peer-writes constraint even though no producer
source was edited. The test printed ok; its source contains that successful
write and delete assertions. The test file was removed by the fixture itself;
preexisting contents, if any, cannot be inferred. No peer artifact/status/history was inspected or changed to
clean up. No forbidden source exposure occurred. Further producer executions
must stage test source under this checkout and audit source-relative outputs;
the independent loaded-constructor tests already use only this worker's target.
Coordinator/producer can audit any effect on a preexisting artifact. This incident is not hidden
under a blanket no-peer-writes claim.

Current continuation: mixed variadic packs use caller stack storage; yielding
continuations retain dynamic storage on the thread frame stack. Baked packs
snapshot interpreter memory and reuse content-keyed storage. Native/WASM64 O0/O2
execution passes, including unwind/rewind. The focused WASM harness provides real
memcpy; it is not production runtime integration. Interface matching compares
full procedure types and macro category; argument names/defaults and generic
required-interface declarations remain unspecified/unverified. Register, CLI
plugin and independent probe/reflection repairs now have focused regressions. No module,
path or fixture bypass is used. See compiler/mixed-variadics-and-interfaces.md.

Discovered legacy deviation: module parameter checking exempted system/library
modules, allowing unknown arguments to be silently ignored. Original library-root
regressions reproduced this. The exemption is removed; binding now rejects unknown,
excess and duplicate arguments, including modules without a parameter header.
Ordinary missing arguments previously escaped validation when unused; these now
reject at binding. Second-list program parameters still permit a later shared
binding. Loaded parameter declarations now retain the defining file's private
namespace for defaults, conversions and constraints while keeping module-wide
storage. Original default/explicit/invalid and late-binding regressions cover
these general fixes; no library-name exception or new public API is involved.
Bootstrap loading passes only reviewed Runtime_Support flags. Nondefault temporary
target storage allocation needs a private compiler/runtime mechanism instead of
the old unreviewed TEMPORARY_STORAGE_SIZE import argument; it diagnoses explicitly.
NO_OUTPUT workspaces retain option metadata without allocating a target runtime.
Both initial and late executable-workspace requests are checked; producer handoff
is pending.

Scope: current producer source and handoff documents, plus this task's atomic,
context, reflection, measured-report and formatting work. This is an active ledger, not a claim of
full compatibility or production integration. Existing detailed limits remain in
`docs/specs/stdlib/compiler-questions.md` and the compiler integration handoff.

| Location | Observable effect and rationale | Evidence/risk | Proper fix |
| --- | --- | --- | --- |
| sema/calls.rs intrinsic dispatch | Bootstrap atomic dispatch gap repaired through shared IR, with scalar/signature/alignment validation. | Four original regressions pass. Public accepted scalar set is an independent supported policy where reviewed pages are incomplete. | Review exact type-set/reference ordering; retain general validation. |
| interp/atomics.rs | Real host atomics replace non-atomic sequences. Mapped-access checks cannot retain an allocation another native thread frees. | Original simultaneous-host CAS regression now passes; caller owns allocation lifetime, as for native atomic pointers. | Continue enforcing lifetime/compatible access at calling API boundaries; no fake memory-safety claim. |
| interp/mod.rs cooperative polling | Polls after indivisible atomic operations on cooperative multi-thread hosts. | Preserves progress; can cost additional scheduling overhead versus polling only stalled operations. | Profile scheduler budgets before tuning; never weaken atomicity. |
| jaic-llvm/src/lib.rs | Atomic wasm programs automatically require +atomics; explicit -atomics errors. | Shared-memory linking previously failed and now passes contention. | Keep IR-derived feature requirements; thread-enabled linkage remains embedder configuration. |
| jaic-llvm/tests/cleanroom_atomics.rs | Native contention driver uses pthreads on Unix; WASM tests require node/wasm-ld and fail when tools are missing. Error-reporting imports throw if executed. | Actual native and shared-memory tests pass; no tool skips or successful error stubs. | Coordinator must run Windows native contention with its threading backend; full platform CI remains outstanding. |
| sema/lower.rs and stmt.rs | Context selection and caller-owned cleanup registration use runtime slots; movable boundaries preserve nested macro ownership. | Eight original core cases and native/WASM O0/O2 pass. Adds interpreter loads/stores and linear updates over live lexical boundaries. | Retain correct semantics; profile before optimizing storage/mark traversal. No module/path bypass. |
| sema/typeinfo.rs | Generic source and instance defaults now have real metadata/storage. Instance defaults resolve dependent arguments; shared sources retain symbolic null type/-1 offset where unbound. Per-instance default metadata adds read-only storage to preserve those evaluations. | Six original core and native/WASM O0/O2 tests pass. Dependent metadata encoding is an independent contract, not specified by the public record declarations. | Review the encoding; foundations should consume instance defaults for dependent default elision. |
| cleanroom_reflection tests | Scoped bootstrap includes only reviewed fields needed by the test. WASM supplies real byte-comparing memcmp for the backend's existing external C call. | Focused native/WASM relocation execution passes; this is not production bootstrap/runtime integration. Rust raw strings contain original Jai/C/JS inputs; rustfmt/clippy cover their Rust harnesses, not embedded Jai formatting. | Coordinator runs full bootstrap and production runtime gates; standalone owned Jai sources require real jaifmt/jailint. |
| tools/assemble-cleanroom-test-library.py | Test-only overlay reads new independent producers; no production integration. | Focused prior tests only; missing dependencies can block broader runs. | Coordinator integrates independent producers and runs full gates. |
| jaifmt source build | Prior missing-builder blocker resolved using new independent dependencies. All owned facades/internals and new standalone Jai fixtures are now formatted and linted. Generator normalizes its outputs. | Real source build, jaifmt --check, jailint -D warnings and regeneration idempotence pass. | Coordinator repeats on full integrated tree. |
| interp/fibers.rs and mod.rs | Native-only fiber structures, stack constants and state are gated to supported Unix/Windows x86_64/aarch64 hosts. Unsupported hosts retain the existing explicit diagnostic. | Removed eleven wasm32 dead-code warnings at their cause; native tests and actual wasm32 clippy -D warnings pass. No lint suppression or supported feature disabling. | Retain matching implementation/state capability gates when adding a native host. |
| sema/perf.rs and build.rs | Native reports use measured timings/counts. Actual wasm32 compiler hosts explicitly reject performance requests because their stopwatch lacks a monotonic clock. Anonymous run thunks may have null callee headers. | New interpreter/native performance fixture passes. No fake zero browser timings presented as measured support. | Provide a real browser host clock; review anonymous-callee representation. |
| code_export.rs / Program_Print | Reviewed backtick/defer-pop flags and block presence serialize correctly. Bare implicit-copy versus explicit-context public AST encoding is unspecified; push-context printing remains explicitly unsupported. Runtime lowering preserves the distinction. | Original real-prelude flags/lifetime case passes; no invented public field or semantically different printed source. | Review the bare-context representation, then implement faithful public AST printing/reconstruction. |
| compiler facades | Visitor macro bindings, static filter expression shape and selected diagnostic semantics remain unspecified; some printing forms return false. Debugger/alternate backend operations diagnose unavailable support. | Questions and facade docs; reduced functionality is explicit. | Reviewed contracts plus real implementations and regressions. |
| browser/LSP/legacy CLI integration | Fresh overlay browser run passes 19/28; seven LSP auto-import failures use incomplete local stdlib. Legacy executable-path CLI test requests unavailable System module. | Failure assertions retained; compiler-owned CLI arguments, LSP unit and focused native/WASM cases pass. | Coordinator/owners integrate new dependencies and review legacy API assumptions; no invented System facade or weakened assertions. |

## Continuation review scope

| Location | Observable effect and rationale | Evidence/risk | Proper fix |
| --- | --- | --- | --- |
| sema/asm.rs, calls.rs and scope.rs | Canonical __reg is a distinct SIMD operand marker; expanded parameters alias caller storage. Core-only no-prelude compilations use an intrinsic nominal marker. Scalar, memory, GPR, standalone-storage and runtime-ABI misuse diagnoses. | Original canonical-bootstrap and interpreter/native/WASM64 O0/O2 tests pass. Wider operand contracts and physical pinning are not claimed. | Review wider contracts; retain explicit unsupported diagnostics and source identity. |
| interp/probe.rs | Fault-safe own-process kernel transfers replace stale-cache userspace dereferences. Comparison snapshots allocate buffers and kernel copies cost syscalls. | Original native-thread protection-change test reproduced SIGBUS and now passes. Mach ABI checked against official installed headers. Linux/Windows runtime execution remains unverified here. | Run platform CI; optimize only with equivalent lifetime/fault guarantees. |
| sema/typeinfo.rs | Direct procedure fields hidden as pointers retain marker 8 and actual struct alignment. Plain aliases retain identity. Distinct procedure variant behavior is an open contract question. | Seven core reflection cases plus native/WASM64 O0/O2 relocation/marker execution pass. | Review variant reduction semantics before introducing a nominal-type rewrite. |
| sema/driver.rs and build.rs | Only reviewed runtime module arguments are supplied. Default target storage works; actual nondefault target allocation diagnoses the missing compiler/runtime contract. NO_OUTPUT metadata round-trips without target allocation. | Unchanged public workspace fixture passes both runner modes; original early/late request diagnostics pass. Earlier overbroad guard failure logs are retained in target. | Joint compiler/runtime implementation through private configuration/startup, without adding public module parameters. |
| jaic-cli plugin source generation | Private orchestration uses reviewed Compiler hooks, grouped options, failure cleanup and COMPLETE handling; no unreviewed public helper export. | Original check/native-child execution and existing order/repeated-plugin tests pass. Autorun itself still has a producer executable-path defect. | Producer must join/resolve paths; coordinator reruns real Autorun, WASI and full plugin integration. |
| tests/compiler-semantics and LLVM harnesses | Shared positive Jai fixtures are formatted/linted with complete verbose checks. Node provides real memcpy/memset; unexpected imports throw. Deliberately invalid VFS source strings remain Rust test inputs, not positive Jai lint roots. | Core, native and WASM64 execute checks; namespace fixture preserves type/alias/storage identity across loads. This is focused backend evidence. | Full runtime/corpus and platform validation remain coordinator gates. |
| tools/assemble-cleanroom-test-library.py | Optional NEW portable overlay protects foundation-owned modules/helpers; selected producers are copied only into this worker target. It is local staging, not a production merge. | Host facade tests pass. Cross-producer snapshots/Windows/WASI completeness are not inferred. | Coordinator integrates authoritative ownership snapshots and runs full platform gates. |

Atomic default ordering is not established by the reviewed public pages. This
implementation will use sequential consistency, consistent with its existing
CAS backend, and document that stronger implementation guarantee without
claiming it is the unspecified reference guarantee. No public ordering API is
invented. Existing explicit-order compiler intrinsics must reject invalid orders.
