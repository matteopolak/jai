# LSP progress

2026-10-16 named-parameter feature checkpoint ready for integration review:
implemented one owned completion source plus narrow merge hook. Direct resolved
procedures, associated methods, aliases/imports, overload union/dedup, defaults,
variadics, positional/named filtering before/after cursor and accepted edit syntax
are covered. Expression/member completion remains effective, including same-label
expression alternatives. No compiler/bootstrap/stdlib/Extensions file changed.
Known scalar expression facts now filter incompatible unselected overloads via
the compiler's conversion API. Missing/operand-sensitive facts stay unknown;
compiler-owner incomplete-call compatibility API is the proper follow-up.
Compiler-owner callback-metadata prerequisite below remains explicitly open;
indirect callback completion is unavailable rather than exposing another signature.

Verified source-built integration-clean dependency snapshot (normalized input
54e154044d20746ac1d12a98c485bbf966d2a09f7208e3efe6e263591f74ca27), with
cf7dd80 + 5214e9c applied only in assigned T7 scratch. Final input audit found no
shared-source drift. 55 focused tests pass: 25 library units, ten new API cases,
20 existing partial-edit/custom-for cases; binary test target has zero tests.
Scoped rustfmt, Clippy -D warnings and Python syntax checks pass. Native proof:
18 document phases, two fresh servers, 32 feature requests (20 completion, six
hover, six definition), six accepted-edit checks and two UTF-16 callee edits.
Production Basic and original private-import fixtures included; no Jai program
or exit call executed. All failures/receipts remain under assigned T7
`scratch/named-arguments-20261016/`; no active internal target/capture paths.

Handoff details/reproduction/limits: docs/tools/lsp-named-arguments.md, linked
from docs/README.md. Final merged compiler/stdlib/LSP native/corpus verification
is mandatory; this is candidate proof. No release/version/push/remote actions.
Filtered inbox now confirms compiler ownership of the callback metadata repair
after its current typed-binding work. Stable direct named-completion handoff comes
first, then the authorized Windows URI/path repair immediately in a separate
commit. This named-parameter batch does not claim native Windows verification.

Requested compiler API contract: an IDE query at a resolved callee expression
must return its actual declaration/value-bound parameter names, types (when known),
default presence, variadic/baked flags and argument placement rule, with provenance
for the selected entity/field/value. No global structural TypeId name lookup.
Unknown dynamic targets need no invented names. Reuse that same metadata for strict
indirect call argument ordering/defaults. Optional operand-aware partial-call
compatibility should distinguish known rejection from unresolved input, allowing
LSP to filter candidates without reimplementing quotation/conversion/binder rules.

2026-10-16 compiler-owner prerequisite request: named-completion audit independently
reproduced procedure-value metadata identity leakage. Minimal original source:
`Holder :: struct { callback: (public_option := false) -> int; }`
`Other :: struct { callback: (private_option := false) -> int; }`
`main :: () { h: Holder; other: Other; h.callback(); }`.
The candidate's TypeId-keyed `proc_type_params` record for `h.callback` contains
`private_option`, not its declared name. Red evidence is preserved on T7 at
`scratch/named-arguments-20261016/metadata-audit.log` under the assigned LSP root.
Please adopt a declaration/value-bound callable-metadata architecture before
enabling named completion for indirect procedure values. LSP will not expose the
unsafe shared record. Direct procedure/method headers are independent and safe.
No compiler file changes are proposed/applied in this new feature batch; earlier
navigation prerequisites are applied only to the staged dependency snapshot.

2026-10-16 named argument completion: starting additional narrow owned LSP work.
Design/sequence: `docs/plans/lsp-named-arguments.md`. Preserve Basic navigation
handoffs cf7dd80/5214e9c. Current shared candidate still needs those prerequisites;
use an explicit safe source snapshot plus the owned prerequisite patch for checks,
and request their adoption via this filtered handoff rather than stale compiler
dependencies. Do not duplicate the compiler owner's corpus/scanner work.
All new target/capture/scratch paths are under the assigned T7 lsp namespace;
there are no active internal builds/captures for this batch.

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

Owned implementation and verification are complete. Runner/status handoff is
committed as `379d3fb`; implementation commits are `cf7dd80` and `5214e9c`.
Next: coordinator integrates both fix commits and reruns
`docs/tools/lsp-basic-resolution-verification.md` against
the final merged production source **without** a staged IDE patch. The user's
larger project/editor example remains unavailable; intermittent exit failure was
not reproduced and remains open for that context. No release/remote action.

No Basic/library implementation or public API changed. Final merged verification
remains required after all integration changes.
