# Insertion admission

Insertion admission proves that captured Code can register declarations in the retained source graph before its producer commits compiler effects. Its sealed receipt owns the exact source payload and is valid only for the request generation and discovery frontier that accepted it.

## How it works

`GraphDiscovery::admit_insertion(&self, request, &code)` first checks the live discovery session, pending request, source provenance, captures, and expansion ancestry. It then clones the actual retained `Builder` and runs the same `append_insertion` path used by publication. This exercises declaration registration, duplicate binding checks, callable overloads and aliases, placeholders, file-private destinations, and nested expansion ancestors. An envelope check through `ModuleGraph::validate_insertion_code` alone cannot prove registration will succeed.

The private fork preserves every allocator counter and typed store session, including allocated identities that do not appear in the visible graph. Source records retain their `SourceId` and share their immutable `Arc<str>` text. The fork includes pending work and namespace maps; it does not rebuild a graph from visible IDs, reread sources, advance dependencies, stage a live response, or publish declarations. It is dropped after the append attempt.

Successful admission returns an opaque `InsertionAdmission` containing the actual admitted `Arc<DeclarationInsertionCode>`, request identity, request generation, and discovery revision. The AST is not compared through a partial fingerprint: the receipt itself retains the complete admitted syntax, original source spans, capture environment, and policies. Mutating a separate public copy of the Code response cannot change its publication.

The source producer invokes admission while its VM effect transaction remains open. An admission error must finish that transaction with rollback. After the semantic graph borrow retires, the driver calls `prepare_insertion_admitted(request, admission)` and then `commit_insertion(transaction)`. Preparation stages the sealed payload and consumes the request generation. Commit checks the admission revision again before running the shared append path on the live builder.

Every mutable discovery entry point retires older admissions: advancement, condition and case selections, parameter and using responses, retained using requests, specialization discovery, and insertion append. This conservative revision also changes for attempted mutations that fail or repeat an existing decision. A stale preparation returns `StaleAdmission`; a stale commit cancels its staged receipt and returns the same error. The driver publishes an admitted insertion before applying other discovery responses from that semantic frontier. Failed or stale outcomes must discard their private effect journals.

Cloning an admission is safe for semantic result caches. Staging, cancellation, and publication prevent its generation from being replayed; another source request or discovery session cannot consume it. `prepare_insertion` remains the lower-level transport staging API for callers that do not commit source effects. It does not provide admission, so effectful source production must use the admitted path.

## How to change it

Keep the admission helper in `jai-modules/src/loader/insertion_admission.rs` and declaration registration in the existing loader append path. When adding a builder or graph field, preserve its real identities and request sessions in `Clone`; immutable source text should remain shared. Avoid a separate simplified collision checker or an allocator reconstructed from maximum visible IDs.

Any new mutable `GraphDiscovery` API must call `invalidate_insertion_admissions` before changing discovery state. Request staging and cancellation instead invalidate the bound request generation. Do not expose mutable access to the sealed payload or silently publish an admission against a newer frontier. Retry by evaluating/admitting against the current immutable frontier with a fresh effect transaction.

The focused tests in `loader/insertion_admission/tests.rs` cover real duplicate registration before publication, unchanged live state and allocation on rejection, exact sealed captures and original source records, invisible allocated scope counters, cloned receipt replay, placeholder-induced staleness, using bindings that change the namespace without adding graph objects, stale commit cancellation, nested private collisions, and queued imports without provider calls. Driver tests must separately prove that a Code producer which mutates a workspace and writes output rolls back those effects when admission rejects its declaration.

## Configuration

No environment variable enables admission. Request generations and discovery revisions use checked monotonic `u64` counters. Existing insertion limits remain 128 ancestry levels and 100,000 original file items per response; the semantic capture factory can impose stricter limits.

## Dependencies

Admission uses `jai-modules` retained builder state, canonical bindings, placeholder and overload stores; `jai-source` identities and shared immutable source records; and `jai-syntax` original AST values. The semantic Code completion callback and driver scheduler connect this proof to the VM effect transaction and private compiler journals.
