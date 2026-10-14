# Compiler progress

Current continuation checkpoint: mixed scalar/spread normalization and baked
packs retain all values. Dynamic packs use persistent continuation storage when
rewritten for yielding WASI procedures. Interface constraints validate unused
module replacements and procedure/struct type arguments. Verification: 170 core/
LLVM unit tests plus eight original focused cases pass, including actual native
and WASM64 execution at O0/O2. Scoped Rust formatting and core/backend all-target
clippy -D warnings pass. Register operands, CLI plugin orchestration and reviewed
independent reflection/probe fixes remain outstanding. Production integration
and corpus verification are coordinator gates.

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
or harness auth were read. No subagents, peer writes, reference execution or
publication occurred; Extensions is untouched. No agent-message tool is available,
so commentary and these durable documents provide milestone reporting.
