# Compiler progress

Active task: general bootstrap atomics, caller-scope deferred context in macros,
and generic-default reflection. Base producer checkpoint: `1e5d732`.

Investigation: bootstrap load/store/exchange names are absent from intrinsic
dispatch. Existing ordered IR operations exist, but scalar/alignment validation
is incomplete and interpreter operations use cooperative load/store sequences.
The portable worker's independent context reproducer is available and reviewed.
Reviewed Basic default-elision semantics require generic default metadata.

Atomic milestone: five original core tests and four LLVM/runtime tests pass.
Native O0/O2 and WASM64 preserve signed/unsigned, float/NaN payload, bool and
pointer values. Native pthread and shared-memory WASM worker tests validate
120,000 updates plus the sum of prior values. The host-interpreter CAS test
failed with 53,537/80,000 before repair and passes with real host atomics.
WASM atomics now select +atomics from IR; explicitly disabling it is an error.

Next: finish atomic lint/checkpoint, then fix caller-scope context lifetime and
generic reflection. No production integration or full corpus claim is made.

Verification: 151 core unit, five atomic, 35 module, three layout, five literal,
18 LLVM unit, and four LLVM/backend tests pass. Scoped rustfmt and core/backend
clippy with warnings denied pass. This task adds Rust tests containing original
Jai/C/JS programs, not new stdlib Jai files. Native CLI rebuild is in progress.
No quarantined integration sources/history, vendor sources, or transcripts read.
No agent-message tool is available; commentary and this file provide milestones.

Verification for this task has not yet run. Prior verification is recorded in
`docs/compiler-integration-handoff.md`; it is not production integration.
