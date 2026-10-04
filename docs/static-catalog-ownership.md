# Static catalog ownership

## What it is

Static catalog admission bounds the complete retained allocation of checked immutable descriptor storage. The footprint and VM ownership helpers are staged privately; their common VM lifecycle and graph publisher pairing are not active source support yet.

## How it works

A checked static object seals its retained byte footprint before publication. The footprint includes aggregate and string spare capacity, boxed children, address paths, descriptor names and notes, member and layout arrays, object allocations and Arc headers. An empty string with a 4096-byte backing therefore still costs at least 4096 bytes. Each published catalog separately accounts for its table allocation and object-reference slots.

One union scan charges every exact catalog table once and every genuine shared object once. Cloning a catalog into another Arc creates a new table while sharing immutable object payloads. Pointer equality of the catalog Arc identifies the table; the sealed static object identity identifies shared payloads. The scan debits comparisons and receipt traversal before inspection. It checks its complete current allowance even when a candidate is already present.

The retained VM receipt uses Weak table identities. It keeps no historical catalog payload alive, prevents allocation-address reuse while a controller is taken out of the VM, and records the actual receipt-vector capacities. A seeded temporary scan includes the old receipt backing throughout admission. Receipt growth reserves both old and replacement buffers before allocation or copying. Refresh also reserves allocation headers kept alive only by departing Weak entries until the old receipt is retired.

The process owner is pairing scans with the actual provider, live VM, ordinary rollback, continuation checkpoint, parked branches, source procedures, native plans and compiler controller roots. Admission must precede lowering or another Arc clone, including an unselected branch or inactive cached callee. A publisher may credit existing payload only when a fresh scan matches the complete retained table and object union; equal byte counts alone are insufficient.

A local metadata or rollback receipt can use a checked subset of the common union. Its coverage proof compares genuine table identities and sealed object facts, then charges local receipt storage and copy overlap while the shared payload remains accounted by the common owner. An unregistered replacement table fails before another Weak is retained. Metadata append preparation allocates and admits its suffix and replacement backing before application; application only moves the already owned values.

Source Code, captures and completed actions can outlive a VM. Their source-job or cache owner uses one cumulative allowance across its full retained forest and candidate, with the same table and object deduplication. Transfer does not create a fresh per-output allowance. Cancellation and retirement rebuild the receipt from actual remaining roots, preserving consumed inspection work.

## How to change it

The private IR implementation is `static_data/retained_bytes.rs` and `static_catalog_ownership.rs`. Extend the footprint visitor whenever a static value can own another allocation. Preserve both logical length and actual capacity, and retain the separately sealed validation-work receipt.

The private VM wrapper is `execute/catalog_ownership.rs`; `execute/provider_metadata.rs` supplies borrowed provider-root enumeration. The process owner's root visitors and lifecycle hooks must stay paired with pre-clone admission, taken-controller receipt seeding and restored-root refresh. New Slice owners must enumerate every backing slot and captured envelope rather than charge an Arc reference alone.

The frozen helper bundle is private and uncompiled. Regression cases cover empty large-capacity strings, distinct shared tables, cumulative independent catalogs, rejected candidates, shrinking allowances, receipt-copy overlap, exact prefix credit and Weak-only retirement. Run these with the coherent IR/VM assembly before claiming source activation.

## Configuration

The private `StaticDataLimits.retained_bytes` default is 64 MiB and bounds cumulative builder payload plus published table storage. VM admission uses the configured `Limits.value_cells`, conservatively counting one retained catalog byte as one value cell; fuel and inspection work remain separate. Source retention derives its cumulative catalog-byte allowance from `compile_time_limits.value_cells` using the same convention.

## Dependencies

The helpers rely on `jai-ir` sealed static objects, descriptor bindings and validation receipts, `jai-types` nominal identities, and the actual VM and source retention owners. They require no external service, program-global registry substitute or serialized arena-local type identifier.
