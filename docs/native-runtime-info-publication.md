# Native runtime-info publication

## What it is

Native runtime-info publication defines the exact program external returned by a catalog-selected `get_runtime_info` fallback. It reuses the certified type-descriptor table and builds `Global_Data_Info` from actual LLVM-owned globals. The implementation is staged until its shared IR/source registration window completes; source and native acceptance are not yet claimed.

## How it works

`NativeRuntimeInfoPublication` retains the checked fallback `ProcedureId`, actual `GlobalId`, local external declaration, source identity, and immutable reflection snapshot. The final library rechecks the canonical `(s64) -> Runtime_Info` ABI, one cleanup-free returned external load, same-procedure local ownership, exact source span and schema. Native data declarations retain a receipt from that exact `GlobalId` and checked declaration to the actual LLVM global; publication consumes that receipt. An owned zero, file external, library external, unrelated procedure external or extra executed read cannot supply this role. Symbol spelling does not select the provider.

Before source target selection, the exact role instead retains an explicit
`TargetLayout` prerequisite. An unrelated source import does not force native
descriptor allocation. Native reachability must demand a genuine ready snapshot;
a pending role reports its prerequisite and leaves the external uninitialized.

LLVM publishes after all procedure bodies and the entry bridge have emitted their lazy static objects. `prepare_tables` first admits the selected snapshot descriptors; the native Type-equality ledger can then publish its real lookup table before runtime-info measures owned ranges. The static emitter relocates the certified table to the same descriptor globals used by native `type_info`. Native publication replaces only the compile-time global-data null with an actual owned metadata address.

Each segment row contains the address and selected-target ABI byte extent of one owned global. Mutable zero storage uses `BSS`, mutable initialized storage uses `DATA`, and immutable storage uses `RDATA`. The metadata objects and segment arrays reserve their storage before calculating ranges, so they describe their own real bytes too. Foreign and unresolved program declarations have no owned range and are excluded. These rows describe owned allocations, without assuming that linker section coalescing makes them contiguous.

## How to change it

Update `jai-ir/src/native_runtime_info.rs` when changing role validation and `jai-codegen/src/runtime_info.rs` when changing native ownership or metadata construction. Keep publication after lazy static emission and the native Type-equality lookup table. Adding a later emitter that creates globals after runtime-info publication would omit those ranges and requires moving or splitting publication.

The source binder must start from the origin- and ABI-verified compiler capability; an arbitrary matching source name is insufficient. The reflection owner supplies the sealed source-visible frontier and current target snapshot before freezing types. Attach the role to the final immutable library only after checking the exact retained fallback.

The staged authored-source acceptance fixture compares concrete struct, pointer and signed-integer descriptor identities in a source `#run` and generated native `-O0` / `-O2` programs. It also checks actual addresses and byte extents for initialized mutable storage, zero storage and the immutable catalog metadata, including their respective segment tags. It retains an unresolved foreign declaration without inventing owned storage and rejects invalid fallback forms.

## Configuration

The selected native target governs descriptor layout, record storage and global extents. `GLOBAL_DATA_VERSION = 1` is this implementation's owned metadata format revision, not an assertion about a supplied compiler binary's version. Compiler module origins and source schema adoption authorize the fallback. The independently authored legacy protocol lives under `stdlib/legacy/Compiler`; select `stdlib/legacy` as an explicit import root to authorize that actual graph origin. The default maintained `Compiler` protocol has a different descriptor schema and does not supply this role. There is no symbol-name override that independently grants it.

## Dependencies

This boundary uses the checked IR, source compiler catalog, sealed reflection snapshots, canonical type registry, static descriptor emitter, aggregate record storage and LLVM target data. Acceptance links only freshly authored compiler output with trusted host tools and system libraries.
