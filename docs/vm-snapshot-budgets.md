# VM snapshot budgets

## What it is

Rollback checkpoints and serial process branches retain one bounded source job. Their admission counts the backing that actually exists, including sparse collection capacity, before copying it.

## How it works

`resumable/checkpoint.rs` measures Memory, FILE state, heap ownership, globals, static and literal maps, contexts, captures and owned frames. It admits simultaneous live and rollback owners plus the root controller. General rollback accepts live FILE capabilities and retains their authorized `HostPath`, buffer capacity, cursor and tokens. The closed-FILE restriction belongs to fork separately.

Memory and unfinished machine copies retain cached shape bounds; conservative factors cover semantic values, byte images, initialization masks and clone bookkeeping. Outer table and vector capacities count even when empty. String and aggregate values count spare backing, and pointer metadata counts retained projection capacity. Fresh pointer projections reserve only the next entry, avoiding geometric growth for an otherwise immutable path.

The process scheduler reserves the complete rollback owner and all parked owners. Before each source action it refreshes the live ancillary reservation and the active machine's current shape, then reduces the existing VM and Memory quotas. A stopped fork adds both private storage and machine owners, the shared resident world, a candidate world, result destinations, descriptor-copy scratch and one queue entry to a combined admission. The pure descriptor forecast creates no PID. Copies and the actual fork occur only after admission and fuel charging.

Validated publication uses the same full retained root. Its constant-time getter combines cached rollback and parked storage, refreshed ancillary state, the active native or compiler controller, live Memory and bindings, the shared process world and one pinned source origin. Ordinary transactions measure before their first snapshot and refresh before invoking a validator. Completed machine results keep the already-admitted operand payload cache instead of performing a fresh unmetered value walk. Nested action vectors and variadic snapshot tables include their actual capacity.

Immutable materialization debits a shared pending fuel counter, including work completed before an error. Mutable VM actions and finalization flush that debit into execution statistics. Retrying publication therefore cannot reuse already-spent traversal fuel. Selected borrowed values share one narrowed output budget; the caller must reserve simultaneous native and portable conversion owners against the full retained root.

Parked branches use checked FIFO ordinals in a `BTreeMap`; overflow precedes readiness inspection or ownership changes. A failed quota gate retains the stopped call, frames, captures and existing queue. Root publication requires real termination and reaping of children. Cancellation and publication rejection restore the one outer checkpoint.

The authored tests run rewritten VM code only. They exercise a pipe made before fork, a blocked parent read, an actual child write and `_exit`, a parent wait and result 42, inherited global/frame isolation, one compiler-effect cursor, external readiness, queue order and pre-copy budget failures. These are separate from supplied Process library source acceptance and native execution.

## How to change it

Update the checkpoint, branch clone and ownership-swap initializers together whenever VM state gains a retained field. Add its actual backing and clone work to the same preflight; a count derived only from configured maxima or logical length cannot cover sparse capacity.

Update the cached machine action charge when an action gains owned payload or collection backing. Keep immutable callback work in the common fuel meter, outside rollback snapshots, so a rejected or suspended publication cannot refund traversal work. A private copy can shrink spare capacity, so assert equal source progress and a non-growing footprint instead of equal collection capacity. Result preparation can reserve an operand slot; rejected commits must preserve the prepared owner measured after that reservation. Retiring source execution drops collection backing and skips language cleanup.

Keep pure process calls outside compiler leaf journals. An external dependency parks the whole source job with the same source origin and effect cursor. Do not replay the expression or create an independent child transaction.

## Configuration

`Limits::value_cells` bounds simultaneous live, rollback, parked and temporary owners. `Limits::fuel` covers borrowed inspection before nested walks and actual clone work before copies. Evaluation and stack limits still apply. The scheduler temporarily reduces existing cell quotas and restores the configured quota on every outcome; it does not raise them.

Focused checks use the pinned toolchain with `CARGO_INCREMENTAL=0`, `RUSTC_WRAPPER=`, `--offline --locked -j1`. Frozen component receipts identify the exact source hashes and staged changes; a private prototype pass is not a live workspace gate.

## Dependencies

The budget layer uses Memory snapshot bounds, FILE/token tables, the virtual heap and process ledger, expression bindings, checked continuation plans and standard-library collections. It opens no native library and executes no supplied binary or object.
