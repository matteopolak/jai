# Private VM fork snapshots

## What it is

The private Memory helper creates an isolated deep snapshot for an internal VM
branch or an atomic multi-output receive. The resumable Session scheduler uses
it to retain genuine parent and child continuations under one source transaction.

## How it works

`Memory::snapshot_work_cost()` reads only cached cell totals, hash-table
capacities and tree lengths. It charges three times retained Memory cells plus
allocation, handle, reflection, pool and layout table capacities, virtual-region
entries and a fixed operation cell. An allocation can retain both a semantic
value and a byte image while its cell charge is their maximum. The factor of
three covers cloning the semantic storage, the image bytes and metadata, and its
initialization mask. Sparse tables still contribute work after their entries are
released. Arithmetic overflow reports a structured fuel error.

`fork_private_branch(available_work)` rejects insufficient work before copying
anything. The caller must first admit the combined retained state of all branches
and charge the reported work. Mutable allocation values, images, masks, pointer
provenance, procedure-token ledgers and pool state are copied. Complete immutable
layout roots remain shared through `Arc`. The source Memory is never modified.

The child retains the source's provenance lineage, allocation high-water counter
and virtual-address high-water counter. Existing handles therefore refer to the
same inherited identities in either isolated state. Later writes and releases
affect only their branch. Future identities can coincide across sibling states;
this helper does not provide safe handle exchange between those states. Pointer,
address-integer, procedure-address and aggregate provenance must be rejected by
every branch transport. Memory has no public `Clone` implementation.

The private continuation foundation in `execute/resumable/machine/fork.rs` copies unfinished machine progress separately from Memory. `fork_work_cost()` reads cached task, operand, and plan charges plus outer vector and procedure-plan table capacities; it charges three times payload cells, those capacities, and one operation cell. Completed results and retired source branches are rejected before copying. `fork_private(available_work)` checks that bound before any clone. Mutable strings, integer provenance, projected pointers, SIMD register buffers, and variadic byte snapshots remain owned by their copied task or operand; frozen plans are shared through `Arc`. `retained_cells()` supplies the complete conservative unfinished-machine footprint, including sparse outer backing. A copy can shrink spare capacity while preserving every cached payload and source operation.

Binding scope tokens are copied exactly, so they must be paired with the matching private `BindingEnvironment` copy. Ending a copied scope removes only that branch's captures. Copy-isolation tests and source scheduling tests exercise separate boundaries.

The machine's private process boundary dispatches pure Process ABI calls before opening an effect-journal leaf. Genuine process readiness retains the original typed invocation with its call charge recorded and journal retry disabled. A sealed fork, exit or exec receipt becomes a boxed stop task above the caller's remaining tasks; repeatedly driving that stop does not repeat the call. Fork-result preparation validates an actual virtual-world parent/child pair and reserves the receiving operand before commit. Each result enters the saved signature and scalar-or-results continuation, with a private serial preventing stale injection. `_exit` discards old source tasks directly, suppressing source cleanups and returns. Reviewed exec invocation and completion remain a separate integration boundary; an unbound replacement cannot produce a scalar success result.

`process_scheduler.rs` runs branches serially. A parent receives the actual virtual child PID and the child receives zero at their saved call destinations. Private Memory, heap, frames, captures, context, temporaries and global/static/literal maps remain isolated; the descriptor/process world and effect cursor stay shared. A process wait can run a ready sibling. Compiler, host and other external waits park the entire source job, retaining every queued branch and the original source origin. Live FILE handles reject fork, and FILE operations after a split remain unsupported until shared open descriptions are modeled.

The complete rollback checkpoint and parked state reduce both the active VM and Memory cell quota before every source action. The observer refreshes live ancillary backing and dynamic machine growth, then restores the configured quota before fork or ownership swaps. The initial checkpoint admits globals, static/literal caches, FILE state, heap and process ownership as well as Memory. General rollback may copy live FILE buffers, paths, cursors and tokens; fork's closed-FILE rule remains separate. The Memory bound deliberately covers semantic storage, images, masks and sparse tables conservatively. Only the original root can publish values, after source validation and process quiescence/reaping. Cancellation rolls back the one outer transaction and discards all private branches.

The FIFO queue uses checked ordinals in a `BTreeMap`. The scheduler validates ordinal, borrowed descriptor metadata, simultaneous owners and all remaining clone/result fuel before copying or minting a child PID. Readiness admission and swaps precede queue removal. A failed check preserves the actual stopped call and existing private owners. The authored pipe fixture realizes inherited globals in source before fork; the child changes its private global/frame storage, writes one byte and exits, and the parent reads, reaps and returns 42 under one effect transaction.

## How to change it

The helper and independent fixtures live in
`crates/jai-vm/src/memory/fork.rs` and `memory/fork/tests.rs`. Update the explicit
clone initializer and the work formula whenever Memory gains a ledger or dynamic
state. `RootLayoutCache::table_capacity()` exposes only bounded clone accounting;
its retained layout facts remain private and validated.

Machine copy fixtures live in `execute/resumable/machine/fork/tests.rs`. Update cached task admission whenever an action gains owned payloads; the fork bound relies on those complete charges. New action, goal, operand, loop, or pack state must preserve its exact progress and metadata when copied. Do not expose a public machine or continuation `Clone` API.

Process stops and result admission live in `execute/resumable/machine/process_control.rs`. Preserve the real receipt, exact call-result destination and three-cell stop charge when changing the protocol. Prepare both branches against the staged actual virtual-world fork before publishing it. Keep terminal source disposal separate from ordinary `unwind`, `cleanup` and `finish_call`; those methods execute language cleanup and return behavior.

Branch ownership and swaps live in `execute/resumable/branches.rs`; serial control and readiness live in `process_scheduler.rs`. Update both cached retention and cloning work when adding a private ledger. Preserve upfront fuel and combined retention checks. Do not substitute a new public Memory identity
without rebasing all inherited provenance, and do not expose same-lineage branch
values through a shared heap or message payload.

## Configuration

The parent Memory's `Limits` and `ByteTarget` are copied unchanged. The caller
supplies actual remaining work and separately enforces aggregate branch limits.
There are no environment variables or host-address assumptions.

## Dependencies

The helper uses existing Memory allocation, pool, reflection, code-receipt and
layout-cache modules plus standard-library collections, cells and `Arc`. It
performs no external effects and introduces no dependencies.
