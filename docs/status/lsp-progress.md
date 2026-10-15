# LSP progress

2026-10-15: resumed isolated ownership for the reported Basic `temp` / `exit(1)`
resolution issue. Read AGENTS, ownership and filtered worker inbox. Reviewed
`docs/specs/stdlib/modules/basic.md`: `temp` is an `Allocator` value and `exit`
takes `status: s32` on POSIX and Windows. A general qualified-value IDE identity
defect was reproduced and fixed; no Basic export or runtime behavior was changed.

Previous committed checkpoint: `e3ec426`, partial-edit recovery and actual custom
iteration keyword navigation; 226 targeted checks and the documented correctness
corpus sweeps passed. These earlier isolated dependencies are not final merged proof.

Candidate investigation: source-built a durable snapshot of the explicitly authorized
`integration-clean` candidate's compiler, lint dependency and production LSP,
using its independent production stdlib. Run original minimal documents through
native stdio diagnostics, completion, hover and definition, with incremental edits
and fresh server processes. No document or exit call was executed.

Evidence: `artifacts/lsp-basic-resolution/candidate-20261015/report.json`.
Unqualified `temp` and `exit(1)` passed all native stdio checks (11 phases across
two fresh servers). Qualified `Basic.temp` has correct typed hover/completion and
no resolution error, but definition returns an empty list in both fresh normal
and fresh damaged documents. This is a genuine IDE navigation defect, rather
than a missing public declaration. Original failing request evidence is preserved.

Compiler ownership coordination before edits: proposed minimal IDE-only change
to `crates/jaic/src/sema/{structs,ide}.rs`, retaining the entity chosen by actual
module-member lookup in the existing named-expression reference mechanism.
No parser, bootstrap, public exports, runtime or strict resolver behavior changed.
LSP owns this IDE association. The filtered inbox now confirms the integrator
also reproduced the navigation gap and is to consume this fix rather than duplicate
it. Coordinator/compiler review remains required on integration.

Implemented: actual module lookup entity is retained after operand resolution,
and consumed by the same IDE reference mechanism as an unqualified identifier.
Four original non-Basic regressions cover scalar/aggregate/global/type alias,
module alias, nested initializer, ordinary field/procedure, distinct same-named
module exports, file-private rejection, partial damage and restoration.

Fix checkpoint published: `cf7dd80` (two IDE compiler files and three original
regressions), with required follow-up `5214e9c`. Consume both commits.
The follow-up keys the pre-existing scratch entity association by exact source
span so failed expressions cannot supply unrelated definition targets. Its
independent regression was red before the change and is now green. The coordinated
overlap additionally includes `sema/expr.rs` at the identifier-recording assignment.
No language/runtime lookup behavior changed.

Completed final fresh-build evidence: `candidate-span-verified-20261015` under the investigation artifacts:
four freshly source-built production-candidate server processes, 38 versioned
phases, 68 hover + 68 definition + 76 completion requests, zero failed assertions
and no server stderr. Production runtime/canonical preload remain enabled.
Includes UTF-16 positions, partial `tem`/`exi` completion, local diagnostics,
argument edits, restore and reopen. No Jai program/exit call was executed.
The unpatched and patched runs share input fingerprint
`54e154044d20746ac1d12a98c485bbf966d2a09f7208e3efe6e263591f74ca27`;
effective patched fingerprint is
`329c43f0dccd0df227069bf0e81ce6fc23f7c99869c519ccbfd372afbfdd5bbe`.

Checks passed: local compiler library 146; selected local LSP suites 76;
freshly isolated patched current candidate compiler library 164 plus four
original regressions; scoped local and candidate
production LSP Clippy; Rust formatting; Python compilation; diff whitespace.
Native request proof is macOS only. These source-suite checks are separate from
the candidate-native proof, and neither is final merged acceptance.

Supplementary unpatched regressions initially hit shared-target artifact
interference (captured source exports PRELOAD_ENTRY, linked artifact did not).
No coverage was counted for that failed compile. Separate candidate target
subdirectories now avoid mixing copied workspaces with the older isolated worker.
A fresh unpatched target reproduces all three missing-definition regressions;
a fresh patched target again passes all four native server runs/38 phases.
Its unit suite runs 164 current compiler tests. The earlier shared-target run of
146 was the older cached unit artifact and is explicitly excluded from current
candidate verification; no failure evidence was removed.

Owned implementation and verification are complete; runner/status handoff is
being committed. Next: coordinator integrates both fix commits and reruns
`docs/tools/lsp-basic-resolution-verification.md` against
the final merged production source **without** a staged IDE patch. The user's
larger project/editor example remains unavailable; intermittent exit failure was
not reproduced and remains open for that context. No release/remote action.

No Basic/library implementation or public API changed. Final merged verification
remains required after all integration changes.
