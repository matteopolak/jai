# Compiler progress

Latest continuation (reviewed, awaiting commit): ordered mixed/baked variadics,
persistent continuation allocation, binding-time interfaces, strict module argument
validation, canonical SIMD operand forwarding, public-Compiler plugin lifecycle,
hidden-procedure reflection markers/alignment, and guarded compiler-memory copies.
Loaded-file constructors preserve type, alias and storage identity in original
interpreter and native/WASM64 O0/O2 tests; existing producer constructor behavior
also passes. No namespace/module-name exception was introduced.

Evidence: 263 selected core/backend unit/regression cases pass; 25 LSP unit tests
pass. Public compiler-owned runner: 25/25 in interpreter mode and 25/25 in native
mode, including preserved compile-rejection cases. Positive native cases execute
their built artifacts. CLI original lifecycle executes a real native child;
existing repeated-plugin/order cases and metadata/unsupported-size diagnostics
pass. Scoped Rust formatting/item spacing and core/backend/CLI/LSP clippy with
warnings denied pass after output-aware storage validation. Actual wasm32
compiler-host clippy passes. Positive Jai fixtures and all owned public/private
facades pass jaifmt --check and verbose jailint -D warnings without incomplete
compilation reports. Empty null-data views and mixed string packs also execute.

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
