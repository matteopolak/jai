# Compiler runtime information

The source `get_runtime_info(w)` contract returns a `Runtime_Info` value containing a type-descriptor pointer table and a global-data-info pointer. Its source catalog and checked VM snapshot reader are implemented. Complete source execution still requires the semantic snapshot factory/provider, and native execution requires the fallback body's explicit program-data binding.

## How it works

The original source fallback reads a typed `__runtime_info` declaration marked `#elsewhere`. This is external program data, not an ordinary zero-initialized local. Parsing the marker alone cannot authorize a read, and its spelling cannot substitute for a checked program-data receipt. Library-bound external data additionally retains the library identity and any explicit symbol override.

Compile-time data must come from the same reflection graph and immutable descriptor storage used by runtime Type values. The source `type_table` field is `[]*Type_Info` using the actually adopted header identity. `global_data_info` is null at compile time according to the source contract. Native execution needs the real emitted program table and global-data metadata; a compile-time null cannot stand in for its native contents.

A snapshot needs a sealed reflection-visible type frontier. Enumerating every internal registry entry is insufficient: descriptor-schema and table-backing types are compiler storage, and interning a new `[N]*Type_Info` array on each call would otherwise grow the next table indefinitely. The snapshot must certify membership, source metadata, selected layout, and actual descriptor addresses. Incomplete or unsupported metadata must retain its real readiness/error state rather than disappearing from the table.

Snapshots belong to a metadata checkpoint and workspace. A per-procedure cache would become stale as semantic binding discovers more types. Ready VM providers can supply a certified checkpoint after argument/source binding; existing static-data publication reconstructs it in that VM's memory. Foreign-workspace tables require a genuine host snapshot and checked identity rebinding, since arena TypeIds and pointers cannot cross graph rebuilds.

The core storage proof is implemented in `jai-types::RuntimeInfoSchema` and
`jai-ir::RuntimeInfoSnapshot`. The schema retains the adopted source record and
field identities, the canonical runtime Type header, and the exact
`Global_Data_Info` / `Global_Data_Segment_Info` field types. It checks the segment
enum's `u16` representation and values `0, 1, 2, 3, 5`. Layout uses the selected
target: the ordinary source `Runtime_Info` has size 24 and field offsets `[0, 16]`
on LP64, versus size 16 and offsets `[0, 12]` on the tested ILP32 policy.

`RuntimeInfoSnapshot::new_compile_time` validates an immutable `StaticData`
publication and checks every table row against the supplied sealed ordered type
set. Rows must point to exact canonical descriptor headers, including the
correct header projection for concrete descriptors, and retain the same schema
and target policy. Missing, reordered, duplicate, unbound, or wrong-target rows
fail. The global-data pointer must be a genuine typed null. This proof certifies
storage and membership; the semantic source catalog separately certifies which
types are eligible. Native segment publication remains a separate boundary.

The full `revalidate` API audits the immutable closure. Normal VM consumers use
`validate_owner` for fixed schema/arena and target checks, then enter static
storage through the VM's metered admission path. A snapshot is not a receipt
for execution fuel, and repeatedly traversing its table outside that path would
hide verification work.

The VM `SourceRuntimeInfo` adapter accepts the source's signed workspace argument,
including `-1` for the executing workspace. Its provider supplies a workspace-owned
`RuntimeInfoSnapshot`, a genuine pending dependency, or an unavailable result. The
adapter requires the exact selected source schema and target, admits the immutable
graph with normal VM fuel/layout bounds, and loads the actual record value. It
rejects foreign-workspace requests until a real cross-workspace snapshot service
can rebind their identities. Missing snapshots never become empty successful
tables. Independently authored tests exercise actual registered descriptor
addresses, null compile-time global data, immutable storage, pending/missing
states, workspace mismatches, and admission fuel exhaustion.

The source bridge is privately staged in `compile_time/runtime_info.rs` while
shared producer registration is coordinated. A drive retains an opaque checkpoint
and a transient demand token for its workspace. Concurrent drives have separate
lifetimes, even when they share a checkpoint. Servicing clones the exact receipt,
drops the immutable provider/registry borrow, and calls the mutable source factory;
publication checks the original allocation, ordered frontier, schema, target, and
canonical arena. A pending factory retains the request. Completion or cancellation
retires it without reusing the nonce. These tokens are not source replay identities.
The staged source bridge is not yet production provider wiring.

The private service helper accepts the original demand key after the VM provider
borrow ends. It invokes the factory with that retained checkpoint and propagates
real reflection prerequisites. Factory failure leaves the demand available for
cancellation or an explicit retry; it cannot publish a later catalog in its place.
Initial preparation carries the actual called workspace and source schema. An
incomplete frontier returns its real definition dependencies without issuing a
token. Once complete, the drive can retain the sealed checkpoint; another schema
cannot select it, even in the same process or canonical registry.

Native fallback admission is also privately staged. The proof starts with the
origin- and ABI-verified compiler binding and the genuinely checked fallback body.
It accepts only the direct returned load of an external global declared inside
that same source procedure, with `Program` linkage and the exact source schema.
The retained `GlobalId`, local external declaration identity, and symbol select
the eventual definition. A matching symbol spelling, owned zero initializer, or
another procedure's external does not authorize it. This role proof does not yet
publish native table storage or global-data segments.

The six private role fixtures passed an isolated `rustc` test run against the
exact previously measured own-crate dependency snapshot. The source, dependency
fingerprints, command, executable hashes, and exit logs are recorded in
`artifacts/native-runtime-info-role-private-proof.json`. This verifies the
unregistered role helper; it is not source/native RuntimeInfo acceptance.

## How to change it

Coordinate the compiler source schema/catalog with the reflection snapshot builder, canonical type-frontier proof, ReadyProcedures provider, and VM static-data reader. Extend the existing opaque snapshot contract rather than passing an unchecked pointer and TypeId. Its proof must establish the actual table's descriptor membership, not just the record's shape.

The pure source-storage checks live in `crates/jai-types/src/runtime_info.rs`;
immutable table/address checks live in `crates/jai-ir/src/runtime_info.rs`.
Their tests exercise target layouts, nominal ownership, pending definitions,
ordered slice views, concrete header projections, and null global data. Extend
the source shape proof when the authoritative declarations change, and preserve
the distinction between source catalog registrations and implementation storage
types when changing table construction.

External declarations need distinct syntax and IR storage identities retaining source type, Program or Library binding, and symbol override. The native emitter must attach a real generated-data receipt or an explicitly selected foreign-data declaration. Preserve the genuine checked fallback body; do not rewrite an ordinary identifier to a compiler table or manufacture a successful empty global.

Native publication must use the actual emitted owned-global addresses and target
byte extents for its segment rows. External declarations supply no owned byte
range. Build the native `global_data_info` object from those real ranges and use
its actual address in the emitted `Runtime_Info`; the certified compile-time
snapshot's null pointer is not a native initializer.

## Configuration

Configured module/bootstrap identities determine the selected Runtime_Info and Type_Info schemas. Explicit target layout and byte order govern descriptor storage. Normal reflection, VM fuel/memory, and workspace readiness limits apply. No configuration authorizes supplied native compiler/library/object execution.

## Dependencies

This boundary spans source declarations, compiler catalog binding, source/reflection metadata, canonical type registries, certified static storage, VM ready providers, workspace snapshots, and native data emission. It adds no external dependency.
