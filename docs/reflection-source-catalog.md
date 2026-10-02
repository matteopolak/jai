# Reflection source catalog

## What it is

The source catalog records the canonical types eligible for a compiler runtime-info table. Its private implementation and tests are staged while the snapshot factory and checked source registration hooks are being integrated; `get_runtime_info` still requires those hooks before complete source execution.

## How it works

Language builtins form the initial frontier. A checked source annotation, declaration, or expression can promote a canonical type and its semantic dependencies. A type first interned for implementation storage can later become source-visible when genuine source names it; promotion retains the same type identity.

Descriptor records, backing arrays, and runtime storage headers do not enter the frontier merely because reflection materialization interns them. The factory must seal an opaque `CatalogCheckpoint` before creating that storage. Ready nominal fields extend an already registered source root, while an unrelated registry entry remains absent.

Admission uses a bounded private transaction. Invalid source ranges, foreign type arenas, dependency limits, and exhausted generations cannot publish partial rows. Checkpoints share an immutable array when membership has not changed. New arrays consume a cumulative row budget so repeated growing snapshots cannot retain an unbounded number of references.

A runtime-info request receives a checkpoint only after every admitted nominal definition is ready. Completing a reserved record can reveal additional field types, so the factory revisits that root before issuing the request. It retains genuine definition dependencies while waiting. An already issued checkpoint keeps its exact ordered rows when later source types become visible.

Source preparation can register a batch of checked facts in one admission transaction. Repeated expressions using an already admitted type validate the actual registry identity and source span without copying the frontier. Checkpoint allocation also charges retained pending-definition references; readiness changes cannot bypass the cumulative metadata budget by reusing the row array.

Dependency closure checks pending capacity before appending procedure results or enum representation edges. A rejected batch cannot grow the work stack beyond the ceiling before reporting its resource failure.

## How to change it

`crates/jai-sema/src/reflection/catalog.rs` owns eligibility, closure, admission, and checkpoint reuse. Register actual checked source facts at their semantic boundary; never enumerate every registry entry to manufacture a source frontier. Preserve source promotion when extending physical storage for `Type` or `Any`.

The staged `modules/reflection_catalog.rs` adapter reads ready original declarations, checked signatures, declared global types, module type parameters, and canonical constants in source discovery order. It walks nested constant values without evaluating their AST. Runtime `Type` cells promote their certified represented type. `reflection/source_facts.rs` batches these header facts and records successful source expression and annotation types; a weak literal adds no guessed concrete type. Register these adapters with the factory and source preparation hooks together.

The runtime-info materializer must consume the sealed checkpoint, preserve its ordered membership, and construct the existing `RuntimeInfoSnapshot` proof. That core proof checks canonical descriptor addresses, source schema, and target layout; the semantic catalog supplies the source-visibility boundary. Tests cover implementation-only interning, later source promotion, incomplete nominal readiness, immutable snapshots, invalid source/arena admission, and cumulative publication limits.

## Configuration

There are no environment variables or source flags. Internal ceilings are 65,536 visible types, 1,048,576 dependency edges per closure, and 1,048,576 type references across newly allocated row and pending-definition checkpoint arrays. Reusing an unchanged checkpoint does not consume another allocation. Changes to these ceilings require corresponding resource tests.

## Dependencies

The catalog relies on `jai-source` records and exact UTF-8 spans, the compilation's canonical `jai-types` registry, reflection graph construction, checked static descriptor storage, and the opaque `jai-ir::RuntimeInfoSnapshot` contract. It introduces no external service or library.
