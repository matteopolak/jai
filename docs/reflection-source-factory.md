# Source reflection factory

## What it is

The canonical source factory builds descriptor storage and `Runtime_Info.type_table` from checked source types in the selected semantic arena. Its immutable checkpoints preserve the source frontier independently of helper types interned while descriptors are emitted.

## How it works

The parsed `#type_info_none` attribute is applied after the real record's shape is
bound in the canonical registry. Module records, generic and inline records, and
local records use the same policy producer. Their physical field types, defaults,
and layout remain available; reflection omits their members and publishes the
NoTypeInfo textual flag. This declaration-time policy is independent of reached
compiler setters, whose Run journal and publication adapter remain required.


`FileScope` supplies actual checked declaration, parameter, and constant type facts with their original source spans. The catalog validates those facts, adds language builtins, closes genuine type dependencies, and creates an owner-bound ordered checkpoint. Incomplete definitions and missing target layout remain explicit prerequisites.

The factory consumes that checkpoint with source metadata and the adopted source `Type_Info` schema. It materializes checked descriptor bindings, creates the ordered table and zero global-data template, and validates the complete `RuntimeInfoSnapshot`. The VM segment producer later replaces the zero global-data field using its actual installed storage inventory and atomic Memory sealing phase.

The descriptor graph publishes `NoTypeInfo`, `ProceduresAreVoidPointers` and `NoSizeComplaint` as the canonical source textual bits `8`, `16` and `32`, preserving all other metadata bits. It reads the actual checked policy view; numeric compiler-policy bit positions are a separate representation.

Changing committed record policies retires current descriptor caches and increments the checked policy epoch. Published old objects remain immutable in the builder and in retained snapshots. Static storage admits multiple genuine descriptor objects for one represented type while checking every object's exact identity, schema, layout and payload. A `RuntimeInfoSnapshot` still requires one ordered row per represented type.

## How to change it

Change `reflection/catalog.rs` for source admission and dependency closure, `modules/reflection_catalog.rs` for genuine checked fact producers, and `reflection/runtime_info.rs` for snapshot storage. Keep the source checkpoint separate from the descriptor builder and preserve actual nominal schema identities. Do not use the interner's latest type set as a substitute for an earlier demand.

The finish-time role adapter passes source metadata to the snapshot factory and attaches the checked publication only after the final `Library` validates. The recovered factory foundation does not itself activate reached `#run` callbacks, read-your-writes policy journals, final acknowledged Bound receipts, or native current-header frontiers; those consumer pairings remain separate required packets.

## Configuration

The selected source `Preload` owns schema identities. `CheckOptions.effective_layout()` supplies target layout; missing layout remains pending. Catalog constants bound visible types, dependency visits and cumulative checkpoint rows. `StaticDataLimits` additionally bounds retained payload bytes, descriptor work and publication references.

## Dependencies

This factory depends on source `ModuleGraph`/`FileScope` facts, `TypeRegistry`, the selected reflection schema, `ReflectionGraph`, the immutable `StaticData` footprint/validation foundation, and `RuntimeInfoSnapshot`. Source finish also requires checked native RuntimeInfo role attachment. VM global-data publication requires its separate actual installed-root inventory and Memory sealer.
