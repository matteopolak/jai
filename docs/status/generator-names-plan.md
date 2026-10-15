# Generator naming implementation plan

Scope: eight names in `docs/implementation-scope.json`, baseline 7467b49d.
Use only this independent checkout and reviewed public specifications.

Architecture: public procedures in `stdlib/Bindings_Generator/naming-helpers.jai`,
private byte helpers in `stdlib/internal/developer-tools/generator-names-private.jai`.
Reuse canonical records/constants. Request facade integration through
`docs/worker-inbox.md`; fixtures load the new helper explicitly until integrated.

- [x] Inventory signatures and reviewed behavior; report exact contract gaps.
- [x] Add original selector fixture and demonstrate missing-name failure.
- [x] Implement the reviewed selector subset without modifying caller bytes.
- [x] Build compiler/linter with assigned T7 target and two jobs.
- [x] Format with source-built jaifmt; deny lint warnings in the fixture context.
- [x] Execute interpreter and Mac arm64 native O0/O2; source-check other targets.
- [x] Implement remaining mappings from the reviewed naming addendum.
- [x] Publish exact per-name committed/draft status and verification.
- [x] Commit scoped deliverables with a Conventional Commit.

Signature-only inventories cannot establish exact generated identifiers. Missing
public transformation rules are true contract gaps, rather than private
architecture choices. Existing review questions also flag this distinction.
The latest reviewed addendum resolves these gaps. All eight names are now
implemented and publicly loaded; documented ownership/edge policies cover only
cases expressly left unspecified. Fixtures exercise the integrated public API.
