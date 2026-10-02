# Compile-time static data

## What it is

The VM materializes `jai-ir::StaticData` as immutable virtual allocations. These graphs represent compiler-owned constants with pointer edges, including forward references and cycles.

## How it works

`StaticDataBuilder` owns an append-only arena. Each successful publication shares the same immutable object prefix with earlier publications. Checked IR validates a publication against its type registry before execution; the VM's private execution helper relies on that proof.

The VM caches the initialized object count for each arena. On first use or an appended publication, it allocates placeholders for the new suffix, then fills and freezes those allocations. Reserving the entire suffix first permits references to objects initialized later. The cache advances only after every new object succeeds.

Repeated reads of an initialized publication look up the requested allocation and walk its address projections. They do not rescan, validate, or clone values from every object in the graph. A read through an older publication retains the newer initialized count, so using snapshots in either order cannot reinitialize an immutable object.

The initialized-prefix cache and object-pointer cache survive `VmState` transfer. Failed or pending transactions restore both caches and virtual memory; the abandoned allocation identities remain unavailable for reuse.

Top-level expression verification still performs bounded full-graph validation before beginning an execution transaction. This is the admission boundary, separate from the cached address reads inside a running procedure.

## How to change it

Materialization lives in `crates/jai-vm/src/execute/static_data.rs`. Its `static_address` helper owns suffix initialization; `static_projection` charges and checks each requested projection; `static_value` builds graph nodes. Add independent checked-IR fixtures in `crates/jai-vm/src/static_publication_regressions.rs` for cache growth, retries, lifetimes, or work accounting.

Keep both passes over the new suffix. Advancing the cached prefix before initialization completes would cause a retry to skip missing storage. Normalize ordinary strings before freezing static descriptors, while preserving the independent raw-byte backing used by the literal pool.

Changes to arena publication invariants belong in `crates/jai-ir/src/static_data.rs`. The VM cache assumes that one arena identity cannot replace a previously published object's value or reuse its index.

## Configuration

`StaticDataLimits` bounds graph construction, aggregate nodes, nesting, and address projections. VM `Limits` independently bounds fuel, allocation count, value cells, and evaluation depth. New allocation and initialization scans, value construction, and every requested address projection consume execution fuel. Cached prefix size does not add work to an individual address read inside a running procedure.

## Dependencies

This feature depends on `jai-ir` checked graph publications and address identities, `jai-types` type ownership and layouts, and `jai-vm` virtual memory, string normalization, execution transactions, and persistent state. No host pointer or native reference artifact is used.
