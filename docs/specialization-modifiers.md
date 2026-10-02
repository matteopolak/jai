# Specialization modifiers

## What it is

`jai-sema::modifiers` executes a checked specialization modifier through the common compile-time VM and stages its updated type/baked bindings. Procedure `#modify` joins overload selection and the shared body scheduler; record adapters can supply the same checked source job with their actual declaration identity.

## How it works

Source examples in `how_to/170_modify.jai` infer polymorphic variables first, run the modifier, and then use the modified variables to determine the signature and deduplicate specializations. Examples include widening `T` to `s64`, introducing a result type `R`, clamping a baked array count, and rejecting a specialization with an explanation.

A `ModifierPlan` lists ordered type or typed baked-value slots. A temporary checked procedure returns acceptance (`bool`), explanation (`string`), then final slot values. The executor invokes `Vm::evaluate_call_validated`; it materializes all accepted results into an owned draft substitution and validates their registry identities and declared baked types. No binding updates are published before the complete result is validated and the VM transaction succeeds.

A false acceptance result becomes `Rejected { reason }` and rolls back VM memory/global changes. A pending dependency or VM error returns no substitution. Output type identities require an opaque `RuntimeTypeIdentity` proof returned by the VM decoder and validated against the current registry; address bits cannot be treated as identities. Modifier execution currently requires `NoEffects`, so external compiler/foreign effects cannot be silently treated as rollback-safe.

Procedure requests cache auxiliary work by the original declaration and initial substitution. The source adapter rewrites acceptance returns to include final binding slots, creates a checked auxiliary signature, and queues its owned source through the ordinary body compiler. Modifier dependencies inherit an isolated effects context. Once execution accepts, the matcher checks the original arguments against the final bindings and compares their actual conversion ranks with other candidates. Only the final substitution reserves the runtime specialization. An introduced result binding such as `$R` must receive a valid runtime type descriptor before acceptance.

The source-neutral `ModifierSource` builder accepts original parameter bindings, the original modifier block, and ordered typed slots. It manufactures no source declaration identity; `request_modifier_body` retains the real record or procedure declaration as the cache origin. Auxiliary jobs carry separate readiness and are removed from published runtime procedures, debug information, execution policies, and alignment sidecars.

Discarded baked formals retain their private specialization bindings but do not become mutable modifier slots. The auxiliary header keeps their checked `#discard` source metadata, which makes reads, addresses, assignments, and `type_of` queries fail in the modifier body. Only evaluated slots appear in the VM call and returned binding vector; omitting a discarded slot cannot shift the remaining parameter ordinals.

The record adapter retains the actual record declaration, defining file, original normalized formal bindings, and source wait sites in its intent table. Its internal `prepare_type` boundary distinguishes a ready canonical type, a pending modifier recipe, and a located source failure. Recursive aliases, type arguments, inferred formal defaults, namespace members, and annotation queries keep the pending recipe separate from diagnostic fallbacks. The existing one-shot entry point reports the unsupported execution boundary explicitly.

No record specialization is reserved while its modifier is pending. When a checked accepted substitution reaches this boundary, the binder resolves the formal parameters again in source order, coerces dependent baked values against the accepted types, and computes the final specialization key. Recursive references inside that accepted body's own definition reuse its actual reservation. The auxiliary-source builder and queue service are available to retained preparation; its early-session controller is still being connected, so production record `#modify` cannot yet complete through the public library preparation session. Unit preparation tests inject an accepted result to check this boundary and do not execute the source modifier.

A concrete modified-record annotation prepares its original argument application, including omitted defaults, and matches the resulting canonical type. This avoids comparing an input such as `Buffer(3)` against the final count after a clamp. Declared defaults are not copied onto a canonical record as final-value proofs: different initial applications can produce the same final type, and a non-idempotent modifier cannot be reapplied to accepted bindings. A pattern combining inferred arguments with omitted defaults requires a separate checked recipe and currently reports that boundary explicitly.

The queued record service runs separately from type resolution. It examines one bounded queue snapshot, requests the real auxiliary procedure, and records actual procedure or VM dependencies before retrying. Its retained preparation controller must supply a checked provider and compiler modifier policy; record modifiers currently have no implicit `Context` schema. Source fixtures cover aliases, globals, headers, late body applications, non-idempotent defaults, dependent baked values, and rejection reasons, but their execution proof is pending the controller integration.

## How to change it

Keep source-body lowering, definition-scope lookup, auxiliary job scheduling, and post-modifier signature/coercion validation in their respective compiler modules. Both procedure and record specializations must run the modifier before reserving the final specialization key. Cache pending modifier jobs by originating declaration and initial typed substitution; the accepted final substitution determines published specialization identity.

Published type descriptors and reflection identities remain immutable. Mutating a binding to another existing type does not mutate either type's schema. Mutable descriptor-field editing requires a separate validated draft metadata transaction and is not implemented by this executor. Unsupported modifiers must remain explicit errors rather than compile an unchanged template.

## Configuration

The executor receives the VM's configured execution limits and a maximum materialization depth. The plan preserves declaration binding order. Duplicate slots, result count/type mismatches, foreign type identities, and changes to a baked slot's declared value type fail explicitly.

## Dependencies

The foundation uses the existing typed substitutions in `jai-sema::polymorphism`, checked calls and constants in `jai-ir`, registry ownership in `jai-types`, and transactional execution/materialization in `jai-vm`. Source procedure/record binders and the compilation scheduler provide ready procedure bodies and canonical descriptor proofs.
