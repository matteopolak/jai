# Reflection publication

## What it is

Reflection publication combines a reached source run's staged record policies with its VM and host transaction. The owned VM transport and semantic adapter are staged privately; their source registration and per-run journal hooks must activate together before `compiler_set_type_info_flags` is supported by this path.

## How it works

One source job owns its policy journal throughout suspension. Each checked update retains its actual call or declaration provenance for diagnostics. The job's exact `SourceOrigin`, including workspace, path, body, source range and specialization envelope, identifies publication independently of any callee declaration. Two `#run` sites invoking the same callee cannot substitute for each other.

The private VM constructor admits one owned provider-definition and context receipt before execution. Its bounded walk debits each borrowed node and payload before inspection, then reserves verification and copy work. Persistent state, continuations and prepared publications move that receipt. It contributes once to the common resident quota, alongside the retained source origin; rollback and process branches do not clone it. Restored providers validate the exact old prefix and admit any append before allocating new global slots. Rejected extension returns the original cache and persistent state.

The ordinary evaluator or completed continuation validates the result while real VM storage and the ready provider remain available. It checks escaping sequence storage, closed host files and quiescent virtual processes, releases temporary storage and flushes source publication work before detaching. The transport owns the exact values, validated semantic payload, original rollback checkpoint, persistent state, effect handler and source origin. It retains no provider or type-view reference.

After releasing the source provider borrow, `commit_reflection_publication` validates the retained run and journal owner independently. It prepares one exclusive guard over the canonical type registry and descriptor-policy metadata. Preparation performs every policy check and allocation before the host commit. A successful `finish(true)` is followed only by infallible guarded application and consumption of the already validated source payload.

A rejected host commit restores the original VM checkpoint and drops the guards without changing record policies or the descriptor epoch. Failed source validation or guard preparation cancels the same staged host transaction. Explicit cancellation returns restored persistent state and its exact handler. Dropping a prepared transport cancels its owned handler; it does not leave a transaction active. Source work and fuel are never refunded by rollback.

Accepted setters also update a typed journal overlay. A reached read retains an immutable snapshot keyed by the exact journal owner and revision, so later setters and cancellation cannot rewrite an earlier RuntimeInfo demand. Overlay snapshots use isolated descriptor materialization even when their policies equal the canonical registry; they never reuse a committed cache entry by assuming epoch equality. The canonical registry remains unchanged until whole-run publication. Direct type-info queries still need an execution-demanded source/VM adapter; static prebinding alone cannot provide this ordering.

Earlier published descriptor graphs remain immutable. Applying a nonempty policy batch advances the descriptor epoch and clears current reuse caches while retaining previously published static objects and their `Arc` closures.

## How to change it

The private VM implementation is staged as `execute/resumable/publication.rs` and `publication_ordinary.rs`, with paired state/effect transfer and exports. Preserve the `SessionRoot` compiler/native distinction. A compiler quotation remains a source payload and cannot become a fabricated runtime `Code` value.

The semantic adapter is `crates/jai-sema/src/compile_time/reflection_publication.rs`; `reflection_journal.rs` owns staged typed policies and provenance. `reflection/policy_revision.rs` prepares the type and descriptor guards. Activate these helpers with the actual source callback, run-cache ownership, cancellation hooks and compiler API registration. The effect service must not reenter the exclusively borrowed type or metadata owners during finalization.

The initial six private VM tests passed before the metadata audit fix, including actual release of a borrowed type provider before exclusive policy preparation, host rejection, suspension and exact-origin cancellation, dropped publication, accounting rejection and ordinary/resumable parity. Additional metadata ownership, transfer-debit, rejected-append and overlay tests are staged but have not run yet. The semantic adapter's source-origin and combined guard tests are also staged; full source activation remains unverified. Keep private helper evidence separate from main workspace checks.

## Configuration

VM `Limits` govern rollback owners, persistent metadata, source-origin storage, fuel and publication work. Policy journals allow at most 1,048,576 checked calls and 16,384 distinct record targets. Descriptor revisions are bounded to 65,536 epochs. An unchanged or canceled policy batch does not advance the epoch.

## Dependencies

The flow uses `jai-vm` transactions, `jai-ir` checked source identities, `jai-source` retained records, `jai-types` prepared record-policy guards and semantic reflection storage. The compiler effect service supplies atomic host finalization. Arena-local type identities remain in typed source journals and never enter driver replay requests.
