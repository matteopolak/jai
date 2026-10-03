# Constant capture admission

## What it is

Constant capture admission reserves the actual VM owners that coexist while a selected compiler result is converted to portable source constants. It keeps capture work inside the same value-cell and fuel limits as the running source transaction.

## How it works

Ordinary transactions measure rollback storage before cloning it, then reserve the resident ancillary state and pinned source origin. The VM narrows its allocation quota while retaining the original configured limit for publication checks. Immediately before the validation callback, it refreshes the ancillary measurement because execution may have grown literal pools, file state, or other persistent storage.

Compiler controllers retain their frame, selected native values, rollback owners, and parked process state while validation runs. Publication therefore uses the complete retained-root accounting supplied by the controller. Borrowed selected values and their portable replacements must share one cumulative output budget across all slots; materializing each slot independently would reset that budget.

Immutable validation callbacks accumulate charged work in the VM's publication meter. Mutable execution charges and transaction completion flush that meter into statistics. Failed validation consumes its work as well, so retrying a pending publication cannot recreate fuel credit. Source origins are common retained facts, rather than duplicated branch snapshot payloads.

The owned nonempty slice carrier remains privately staged. These accounting hooks do not register a slice IR variant or make ordinary string-to-slice casts constant.

## How to change it

Update `jai-vm/src/execute.rs` for ordinary transaction entry, callback refresh, cleanup, and constructors. Keep the original-limit field paired with every quota reduction and restore it on both success and failure. The resumable checkpoint, process scheduler, and compiler controller own complete root accounting; new retained pools must join those paths before publication can use them.

Use `materialize_borrowed_values` for a complete selected forest while its VM frame is live. Preserve VM incomplete-type errors through compiler quotation finishing so suspension retains the actual frame. Portable source diagnostics can remain separate from VM readiness errors.

## Configuration

`Limits::value_cells`, `Limits::fuel`, and `Limits::evaluation_depth` bound capture and execution together. Publication reads the original configured cell limit during a narrowed ordinary transaction. The transaction fields and pending publication work are internal accounting state and have no environment-variable configuration.

## Dependencies

This flow depends on VM memory quota enforcement, resumable checkpoint and branch accounting, the compiler-only Code controller, source-run origins, compiler quotation capture, and the existing typed constant conversion rules. It does not use the supplied original compiler or native objects.
