# Compiler progress

Fresh approved d30311a5 compiler-mac-repairs scope: classified all22 unresolved
compiler catalogue fixtures against reviewed contracts. Six contract migrations
pass interpreter/native ARM64 O0/O2: build-options-main-defaults,
compiler-build-file-and-literals, compiler-get-code-rerun, macro-code-variable-arg,
rules-scoping, using-only-import. Structural/value/type assertions replace
unestablished exact-print whitespace; debugger unavailability remains a required
negative CLI test. Custom-link arity migrated but normal runner now exposes missing
portable_crash native prerequisite; no pass claimed. Missing public Protocol
compare_alloc_and_free_traces remains a portable-owner dependency, not deleted.
Compiler-resolved-nodes now checks print success and exposes missing compound
printing. Next cohesive implementation: supported AST printing/reconstruction.
Classification/reasons/evidence: compiler/mac-catalogue-repairs.md. Own T7 target
only; local source/evidence retained. No routing/prerequisite/Default_Metaprogram/
Extensions changes, no profiles/benchmarks, no mutable initialized constants.

Forward enum dependency implementation committed and verified: 7ddabf5.
Original MASK/LAST reduction now passes host/WASM CLI source checks; interpreter
returns intended value5. Declaration collection/lazy entities replace sequential
enum evaluation, preserving selected source/reflection order and implicit normal/
flags sequencing. Independent core/IDE/reflection/invalid-program regressions and
actual native ARM64/WASM64 O0/O2 checks pass; actual wasm32 compiler-host runtime
also passes. Final full available core/backend run: 339 pass, zero fail, one
inherited corpus sweep ignored across 42 binaries (target/enum-dependencies-final-suite.log).
Scoped format/item spacing, strict positive Jai lint, core/LLVM all-target clippy
and actual wasm32 source clippy pass. Repeatable actual-wasm32 runner passes the
runtime fixture, original reduction and cycle/range/duplicate rejection controls.
No public API/library/peer-tree changes or integration optimizer/hook/recovery
feature overlap. Conservative structure/value dependency boundary is explicit in
compiler/enum-dependencies.md and compiler-deviations.md; exact review question
recorded. Native Windows/Linux and full Socket/stdlib remain coordinator gates.

Verified browser runtime split checkpoint: 457dc04. Implementation is test-only,
using the existing real sandbox provider; four focused cases, actual wasm32,
CLI guard, format/strict lint and clippy pass. Full local browser limitation remains
25/32 against the older staged library; no current-CI full-pass claim.
At that checkpoint the next mailbox reduction was independently reproduced:
forward enum MASK/LAST failed unknown LAST (target/forward-enum-producer-red.log).
The implementation above supersedes that earlier pending status.

Browser Thread failure triaged as unsupported public-module test coupling, not a
guard defect. Split the combined test into independent private SandboxHost
scheduler/file fixtures and strict public Thread rejection. Three real workers
cross a barrier, contend/yield while holding a mutex, perform thirty updates and
join actual callback results; files verify bytes/EOF/workspace source and per-play
isolation. Invalid joins/deadlocks remain errors. Four focused Rust playground
tests, actual wasm32 repeated execution/negative controls and CLI WASM guard
source checking pass; owned format/strict lint and host/wasm32 clippy pass.
Local staged baseline differs from current CI: original failure was File guard
before Thread; isolated Thread guard independently rejects. Full local browser
suite is 25/32, seven unchanged dependency/oracle/IDE failures retained and
classified, with no ignored tests or full-green claim. No runtime/core/guard/
LSP feature or peer-tree edit, no fetch/remote/publication. Concrete design,
commands and exact follow-ups: browser/sandbox-runtime-verification.md.

Verified checkpoints: babb2fd (raw pointer constants/typed bindings) and 2676b02
(invocation-relative jailint imports). Source, regressions and handoffs committed;
no publication. Platform Registry integration and the documented unsupported
32-bit program/fault-containment/lifetime cases remain separate gates.

Registry/raw-pointer checkpoint committed: babb2fd, with 332 available core/backend
passes and final scoped formatting/strict lint/clippy/wasm32 checks. Mailbox's next
relative-import lint defect also repaired: driver anchors configured import roots
to invocation cwd before RootedFs source rebasing, including missing roots to
prevent accidental source-local shadows. Original independent relative/absolute/
no-I controls, loaded fragments and invalid-body checks pass; all 39 jailint cases
pass with the configured independent prelude. Initial missing-prelude suite failure
retained; no assertions changed. Staged NEW producer source passes own jaic -check
and jailint -D warnings with identical relative -I arguments; source-check evidence
only. Rust format/item spacing and jailint all-target clippy pass. See
tools/jailint-targets.md; no peer writes or integration runtime/optimizer/LSP overlap.

Raw pointer/Registry blocker repaired generally in sema/convert.rs and consteval.rs:
nonzero integer pointer constants retain target-width scalar bits; opaque #run
results/fields need no invented bounds or pointee capture. Known globals still
relocate. Immutable positive HKEY-shaped aliases, globals/defaults/comparisons,
round trips and checked-cast failures pass original regressions. Five core/two
LLVM cases pass; actual native ARM64/WASM64 O0/O2 and wasm32 compiler-host execution
pass. Full available core/backend: 332 pass, zero fail, one inherited corpus sweep
ignored. Scoped Rust formatting/item spacing, Jai format/strict rebuilt-tool lint
and host core/LLVM all-target clippy pass. 32-bit program targets explicitly reject;
no 32-bit backend claim. Low-address accesses trap and unreadable view capture
diagnoses; existing arbitrary non-low interpreter faults remain a bounded runtime
gap, not claimed safe. No runtime/optimizer/assert-hook/LSP feature edits, peer
writes or publication. Exact evidence/limits: compiler/raw-pointer-constants.md.
Additional original baked-pointer regression repaired type loss in inferred
procedure/struct bindings; semantic instance keys now include canonical type and
value, retaining alias identity while separating equal-bit pointer/int arguments.
These changes do not touch optimizer or Compiler field/drop order.

Verified generic-pointer checkpoint: 6abf47a,
`fix(sema): canonicalize default generic pointees before binding`. Implementation,
original regressions and documentation are committed. Producer restored-fixture/
watcher integration remains the next gate; no publication.

Default generic pointer defect repaired: pointer construction now instantiates
all-default generic pointees through the same canonical binder/cache as ordinary
type positions. Type parameters validate actual type operands before binding,
including unused parameters. Nominal/pointer/explicit-specialization diagnostics
remain intact; constraint matching is unchanged. Seven independent core cases
and actual native ARM64/WASM64 O0/O2 execution pass. Full available core/backend:
325 pass, zero fail, one inherited corpus sweep ignored. Host core/LLVM clippy,
scoped Rust formatting/item spacing, standalone Jai format and rebuilt-tool
strict lint pass. Exact producer path supplied by user was absent, so
only the named description was read and an original reduction reproduced the
identical error. No alternate peer search/execution claim. Details and test-oracle
corrections: compiler/default-generic-pointers.md. Integration optimizer/assert-hook/
LSP features and peer checkouts remain untouched.

Stable instruction checkpoint: 75e8fd6, `feat(compiler): execute architectural x64
machine instructions`. All owned batch paths are committed; no publication.
The generic-pointer dependency below has now been independently reproduced and repaired.

Architectural x64 batch: real RDTSC/RDTSCP (including AUX), distinct RDRAND/RDSEED
single-attempt value/CF and flag/partial-write semantics, real LFENCE/SFENCE/MFENCE,
PAUSE and four prefetch hints now have typed IR/interpreter/LLVM support. Invalid
operand/target/signature and unavailable-host/feature diagnostics are explicit.
Generic counters use actual x64/ARM64 counters; WASM rejects missing capability.
Original red/green tests, eight O0/O2 ABI opcode objects, actual translated x64
native O0/O2 C oracle and six x64 interpreter tests pass. Full available core/backend
suite: 317 pass, zero fail, one inherited corpus sweep ignored. Host core/LLVM,
x64 Mac, Windows x64/ARM64, wasm32 core/browser clippy pass. Owned fixture format
and target-aware strict lint pass using rebuilt tools. Actual wasm32 ISA/target/
x64-child rejection and recovery pass. Real CPUID here
has TSC/RDTSCP but no RDRAND/RDSEED: RNG hardware execution remains pending capable
CI, not inferred from opcodes. Portable owns eight newly unblocked public macros;
no peer edits or integration Pool/optimizer/assert-hook/LSP feature changes.
Exact interface, commands, remaining ISA gaps and limits:
compiler/x86-machine-instructions.md. Generic-pointer original reduction requested
in compiler questions; private runtime adoption remains pending.

Target-aware jailint implemented: -os/-cpu/-target selects real compiler options across roots/imports/loads, bootstrap, workspaces and fix passes. Source/runtime/preload/import options and config provenance retained. --context supplies a real enclosing program's module arguments/source origin without granting private-import access. --manifest records actual context targets/completeness and unvisited files. Failed body checks remain fatal and are marked incomplete; context visits are not skipped as target coverage. All 38 jailint cases pass, including ten new independent target/privacy/parameter/config/parallel/fix/workspace/context regressions. Host/Windows all-target clippy checks are scoped separately. Source-check evidence only; full-platform stdlib runner adoption remains integration-owned. No assertion-hook/LSP overlap or peer writes. Handoff: tools/jailint-targets.md.

Narrow CI 7350b86 link repair: remove forced ucrt import from scheduler CRT entry; Rust's existing static/dynamic CRT selection now governs. Actual own static-library metadata red/green confirms the old libcmt + ucrt.lib mixture and passes x64/ARM64 in both CRT configurations after repair. KernelBase fix retained. Native gate now builds BOTH jaic and jailint, using existing target/CRT flags and workflow static LLVM; --build-only supports prompt CI link validation. Actual MSVC executable/runtime verification pending. Reviewed prefix casts include shifts and retain bottom-up operand typing; only narrow shift promotion remains unspecified. Details: compiler/windows-crt-linkage.md.

Windows SDK link repair committed as 049e997. Queued cast/shift reduction independently reproduces 0x8004007e in interpreter and native O0/O2. Explicit widening preserves all 256 byte inputs in interpreter/native/WASM O0/O2; checked-cast errors remain covered. General cause is prefix-cast grouping plus typed shift width. Current reviewed language pages leave that grammar/type interaction unspecified; exact two-part question recorded instead of changing precedence from a legacy parser oracle or promoting typed operands inward. No production FIONBIO semantic fix is claimed. New native SDK gate also includes the existing thread-description/error fixture. Details/evidence: compiler/cast-shift-widths.md.

Windows CI 9d87e76 found a genuine native linker defect: kernelbase.lib unavailable before executable creation on both CPUs. CompareObjectHandles now uses pinned runtime lookup through Kernel32 SDK APIs; missing capability diagnoses when live workers need alias discrimination. KernelBase is also a foreign-lookup fallback for documented Windows 10 1607 description exports. Six scheduler and six API/callback host cases pass; x64/ARM64 all-target clippy and x64 Rust object build pass. Native build/run gate tools/check_windows_thread_sdk.py added; actual Windows SDK linking/runtime awaits CI. Full 307-case checkpoint retained without redundant broad rerun. See compiler/windows-sdk-runtime-resolution.md. Next: queued cast/shift-width investigation.

Verified worker lifecycle/checkpoint: d424f00. Full available core/backend 307 pass; inherited corpus sweep ignored, native Windows execution pending CI. The commit includes source, original tests, fixture isolation, reviewed classifications and deviations. No publication.

Full available core/backend all-target suite: 307 pass, existing corpus_sweep ignored; no test-name filter and no native Windows runtime claim. Real Windows CRT entry returns Jai u32 results through native aliases; private joins, cancellation, adopted leases and early Compiler interpreter destruction remove parked-worker and owner-order lifetime bugs. Original red/green host cases, creation-option diagnostics, source checks/x64 O0/O2 PE construction, format/lint and host/Windows clippy pass; actual wasm32 smoke regressions pass. Native Windows CI remains required. See compiler/windows-thread-entry-lifecycle.md and compiler/full-suite-triage.md for exact gates/deviations. Updated constant-array oracle establishes no address guarantee; no storage change made. Integration reporting-hook/LSP feature repairs remain separate. Shared native callback ABI checks also reject invalid POSIX entries, with real typed-pointer join coverage and no zero fallback. The runtime test now uses private per-process library staging; concurrent CLI/LSP verification passes with shared candidate unchanged.

Checked-expression metadata verified: actual lowering retains per-instance result types, and export uses canonical descriptors without rechecking locals in global scope. Four original core cases, 299 selected core/backend cases, LSP 25/16, actual wasm32 repeated/negative-control messages, interpreter/native O0/O2 parent interception and scoped format/lint/clippy pass. See compiler/typed-expression-metadata.md. Constant-array .data copy cause is identified; its reviewed identity/lifetime/mutation contract remains explicitly unresolved, original failure retained. No fabricated success or shared-storage workaround added. Overlay 3aab9d1 and CPUID 44ed369 preserved.


Forward-overlay checkpoint 3aab9d1 is committed. CPUID now uses real host/native hardware queries with leaf/subleaf inputs and four zero-extended outputs. Original x64 interpreter and native O0/O2 comparisons pass; eight ABI objects preserve RBX, unsupported ARM/WASM paths diagnose. The 295-case selected core/backend run, scoped format/Jai lint and host/x64/Windows/WASM clippy pass. See compiler/cpuid.md. Windows runtime CI, portable runtime adoption, tooling identity/typed-descriptor reproducers and separate synthetic random/timestamp instruction gaps remain pending.

General forward-overlay batch verified: declaration/type dependencies and iterative offset graph preserve field/reflection order, real aliases, using/filter identity, privacy and cycle diagnostics. Core/native/WASM64 O0/O2, IDE/reflection, 5,000-link chain, LSP 25/16, CLI runtime/plugin and scoped format/lint/clippy pass. Public D3D/DXC staging now retains an independent ID3D11ModuleInstance dependency failure; reviewed D3D order still differs from native SDK layout. No full 40-config/native DXC pass is claimed. See compiler/forward-overlay-layout.md. CPUID semantics is fixed in the following batch; tooling result/data identity reproducers remain pending.

Windows thread handle implementation committed as f08f80b. Interpreter naming now uses real owned kernel handles in shared scheduler state, with native description/query/HRESULT behavior. Original registry red/green and full host scheduler/core/backend regressions pass. Explicit protected-close failure and teardown ownership are covered by Windows-target tests; x64/ARM64 clippy and source checks pass, plus x64 O0/O2 cross-linking. Actual Windows interpreter/native name/query execution remains required. Staged NEW producer sources are own copies only. See compiler/windows-thread-handles.md; portable runtime adoption remains pending.

Windows unwind implementation committed as 0d49463 (fix(llvm)). Verified: async ABI attributes and synthesis defaults retain O0/O2 entries for x64 MSVC/MinGW and ARM64. Original red O2 empty-table failure is retained. Six object/PE metadata cases and the SDK driver cross-build pass; native Windows execution remains required. Original core/backend and CLI regressions, owned formatting/lint and clippy pass. The staged producer O2 fault leaf is genuinely frameless: its unconditional metadata assertion needs review, while its middle frame now has an entry. See compiler/windows-unwind.md for exact evidence. Runtime protocol adoption remains pending.

Verified implementation checkpoint: 9bab736. Host/target constants now use compiler-binary host identity independently of output selection. Original 12-combination core test, native/WASM64 O0/O2 execution, staged foundations Preamble interpreter/native/WASI O0/O2, and actual wasm32 compiler host/cross-child checks pass. Child-workspace negative control also repaired browser parent false success. Core/backend and separate CLI runtime/plugin regressions, format and scoped clippy pass. Broader browser suite remains 21/29: eight dependency/legacy failures retained. Private runtime producer adoption remains pending. See compiler/host-target-constants.md for exact evidence and limits.

Linter batch committed as 0eeb90c; all 28 library/CLI/rule cases and clippy pass.
Runtime transport also catches a later cross-workspace root change: source-built
execution/emission drivers refresh target data after child compilation. Original
test failed before this repair; actual interpreter/native root allocation now
uses 131072 after the child's setter. No new public Jai helper or parameter is
introduced. Final verification is green: 275 distinct core/backend cases, 41 LSP,
28 jailint and three focused CLI cases; public contracts 25/25 in each mode.
Owned and staged runtime edits pass format/strict lint. Native/wasm32/Windows
x64/ARM64 clippy with warnings denied and scoped Rust checks pass. All runtime
source/tests/handoff work is included in this checkpoint's commit; producer
adoption and actual Windows/full-platform execution remain required.

Final tool follow-up: general jailint library-root context, configured lazy
bootstrap reuse, complete requested-file facts and unconditional incomplete-check
failure are implemented after original regressions failed. The NEW platform
producer fixes were reviewed; no peer write occurred. Alias-aware library rules
use exact public procedure/instance identity and preserve local shadows. Existing
rule expectations pass unchanged with explicit independent-library selection.
The candidate's three runtime edits now pass format and strict lint too.

LSP batch committed as 1b19b3f. Private runtime configuration is implemented:
settled workspace values update readonly target data and new interpreter entry
context allocation. Original core and actual native/WASM64 O0/O2 regressions pass,
including procedure-value getters and already-interpreted data refresh. Invalid
ABI/range and older-runtime diagnostics remain. Staged NEW runtime integration
executes real late-root 65536 allocations in interpreter/native O0/O2 and separate
native child allocations for 0/131072. Producer adoption remains pending; exact
edits and checks are in compiler/runtime-configuration.md. Owned helper/fixtures
pass rebuilt jaifmt --check and rebuilt verbose jailint -D warnings with no
incomplete compilation. Stale-tool/check-only failure evidence is retained.
An extra original Win32 callback ABI regression now rejects u64 results before
spawning (702fe6f); valid suspended/CRT cases still pass. The runtime batch is
verified and included in this checkpoint's commit.

Final executed evidence: 275 distinct selected core/backend cases pass (the
nested guarded-copy subprocess is not double-counted); LSP 25 library plus 16
auto-import cases pass; all three focused CLI cases pass. The public runner passes
25/25 cases in each interpreter/native mode, retaining required compile failures
and actually executing positive native artifacts. Core/backend/CLI/LSP all-target
clippy, wasm32 browser-host clippy and Windows x64/ARM64 core all-target clippy
pass with warnings denied. Scoped rustfmt/item spacing, jaifmt --check and rebuilt
verbose jailint -D warnings pass without incomplete compilation. Extensions is
unchanged. Logs are target/compiler-completeness-*.log and
target/compiler-runtime-config-*.log. No new peer writes, forbidden-source access,
reference execution, subagents or publication occurred in this continuation.

Remaining gates: portable adoption of private runtime config, actual Windows
thread/allocation execution, full integrated corpus/platform CI. Existing AST,
debugger/alternate backend and producer Autorun path limits remain explicit in
the handoff/deviations report. Existing host scratch resizing after late setters
is a narrow open question; finalized new entry contexts are verified.

Windows batch committed as 1a120b4. LSP alias documentation now resolves original
loaded overload/private-qualifier cases with public names/defaults intact. All
25 LSP library tests and 16 auto-import tests pass with the independent overlay;
all-target clippy and scoped formatting/item spacing pass. The Basic print and
ranking assertions remain unchanged. Test setup explicitly selects JAIC_STDLIB.
No peer LSP source was edited; this canonical change is ready for coordinator
overlap review with the separate LSP worker. Runtime storage propagation is next.
The staged exact NEW foundations alias probe also prints ok in interpreter and
actual native O2 execution. An additional original project-file alias test caught
and repaired resolution before the file has been loaded into the program.

Constant assignment batch committed as 2f36a1e. Windows scheduler follow-up now
passes original host tests for gated Win32/CRT startup, counts, timeout/resume,
native-thread identity lookup, explicit CRT termination, exit code and cleanup.
Core/atomic regressions, native/wasm32 clippy pass. x64/ARM64 Rust cross-checks
pass; ARM64 exposed a real unused x64-only import, now gated at its implementation.
Windows x64/ARM64 all-target clippy with warnings denied now passes; the cfg-only
needless return was repaired too. Actual Windows runtime
is not verified on this macOS host; the NEW producer repro is staged locally.

Current continuation: qualified constant aggregate assignment rejects through
module/type/alias qualifiers and mixed existing-target declarations. Macro caller
scope and mutable pointer writes remain supported. Original core regressions,
interpreter/native/WASM64 O0/O2 valid-mutation cases and two exact staged NEW MPEG
compile-rejection fixtures pass. Scoped rustfmt, core all-target clippy and
source-built jaifmt/jailint pass; formatter source build also exercises backtick
assignment. Initial stale-overlay/missing-Math failures are retained separately.
Next: private runtime configuration, suspended CRT threads, public alias docs.

Committed checkpoints 5d0bf33 and fea1090: ordered mixed/baked variadics,
persistent continuation allocation, binding-time interfaces, strict module argument
validation, canonical SIMD operand forwarding, public-Compiler plugin lifecycle,
hidden-procedure reflection markers/alignment, and guarded compiler-memory copies.
Loaded-file constructors preserve type, alias and storage identity in original
interpreter and native/WASM64 O0/O2 tests; existing producer constructor behavior
also passes. No namespace/module-name exception was introduced.

Lexical-binding checkpoint 02e3de0: loaded module parameter headers retain their
declaring file environment for defaults, annotations, explicit conversions and
interface constraints. Original tests cover private imports, canonical distinct
type identity and unused invalid replacements. Missing ordinary arguments now
reject even when unused; late binding of second-list program parameters remains
supported and tested. Broad checks pass and the implementation is committed.

Evidence: 265 selected core/backend unit/regression cases pass; 25 LSP unit tests
pass. Public compiler-owned runner: 25/25 in interpreter mode and 25/25 in native
mode, including preserved compile-rejection cases. Positive native cases execute
their built artifacts. CLI original lifecycle executes a real native child;
existing repeated-plugin/order cases and metadata/unsupported-size diagnostics
pass. Scoped Rust formatting/item spacing and core/backend/CLI/LSP clippy with
warnings denied pass after output-aware storage validation. Actual wasm32
compiler-host clippy passes. Positive Jai fixtures and all owned public/private
facades pass jaifmt --check and verbose jailint -D warnings without incomplete
compilation reports. Empty null-data views and mixed string packs also execute.

Follow-up commands: the selected `cargo test --locked -p jaic -p jaic-llvm`
library/focused targets, all-target clippy for core/backend/CLI/LSP, wasm32
jai-wasm clippy, source-built CLI build, scoped rustfmt/item spacing and
`git diff --check` pass. Public runner repeats all 25 selected cases in each
interpreter/native mode. CLI `cleanroom_plugins` passes with JAIC_STDLIB set to
the own-target independent overlay; its initial unconfigured discovery failure
is retained separately. Logs: target/compiler-lexical-binding-*.log. Embedded
original VFS snippets are Rust test inputs, not standalone Jai lint roots; no
new standalone Jai source was added by this lexical follow-up.

Remaining dependency gaps: actual nondefault target temporary-storage allocation
needs a private compiler/runtime mechanism (NO_OUTPUT option metadata works).
Autorun reaches its lifecycle but its producer path joining/PATH search still
fails to launch the built child. Runtime alternate-instance policy and selected
AST/visitor/backend contracts remain open. Production corpus/full CI stays with
coordinator. Filtered Windows/Fuzz feedback was read; no raw vendor logs were read.

Incident: one direct execution of a NEW producer MPEG fixture wrote/deleted its
source-relative test artifact under the producer target directory. This violated
no-peer-writes; no peer source was edited. It is disclosed in the deviations report.
The fixture was subsequently staged under this checkout for further execution.

Producer checkpoints: atomic lowering 1d8833b; caller-owned context cleanup
ec7e23e; generic defaults/speculative context initialization 5c3846c. The current
checkpoint adds measured performance reports, generated-source normalization,
owned Jai formatting and stronger atomic contention/publication regressions.

Implemented in this task: real interpreter/native/WASM bootstrap load, store,
exchange and CAS with scalar/signature/order/alignment checks; caller-block
context lifetime including conditional/nested macro cleanup and exit ordering;
source/instance generic defaults with shared source identity; reviewed run-report
records using actual timings/counters. Actual wasm32 compiler hosts explicitly
diagnose unavailable performance timing. Native-only fiber state now follows its
supported host capability gates, resolving wasm32 warnings without suppression.

Verification on source-built artifacts:
- Core/LLVM: 240 unit/focused integration tests pass. One pre-existing ignored
  test is not counted. Includes host CAS/exchange contention, native/shared-WASM
  contention and 30,000-round store/load publication handshakes.
- Public compiler-owned contract cases: 25 pass in interpreter and 25 native.
  Public-language suite: 11 pass. LSP library: 25 pass. CLI program arguments pass.
- Scoped Rust formatting and core/LLVM/LSP/browser clippy -D warnings pass.
  Actual wasm32 browser-crate cargo check and clippy -D warnings pass.
- Repository formatter/linter build from own sources with independent overlay.
  All owned public/private Jai and four new fixture directories pass repository
  jaifmt --check and jailint -D warnings. Generated records/registry regeneration
  is hash-idempotent through source-built formatter normalization.

Remaining integration limits: fresh-overlay browser suite 19/28; seven broad LSP
  auto-import failures use the incomplete local stdlib; a legacy CLI executable
  path test imports unavailable System. Assertions/failures remain intact.
Dependent-default metadata encoding and anonymous run callee representation are
explicit questions. Selected printer/visitor/debugger/backend gaps remain bounded
in the deviations ledger. No production integration, full corpus or release claim.

Handoff: docs/compiler-integration-handoff.md. Deviations:
docs/status/compiler-deviations.md. Next owner/coordinator steps: consume instance
default metadata for dependent Basic formatting, integrate the independent
portable/numerics/native/browser dependencies, and rerun full platform/corpus gates.
No quarantined integration/history, vendor source bodies, transcripts, credentials
or harness auth were read. No subagents, peer source edits, reference execution or publication occurred;
Extensions is untouched. The unintended producer-runtime artifact write is
recorded above and in the deviations report. No agent-message tool is available,
so commentary and these durable documents provide milestone reporting.
