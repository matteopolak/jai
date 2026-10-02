# Aggregate storage snapshots

## What it is

A VM aggregate snapshot retains its target-layout bytes, initialized-byte mask, and virtual-address provenance. Its decoded semantic cache is optional, so a placed record can be copied without pretending every overlapping or skipped field contains a value.

## How it works

`ByteImage::read_preserving_with_limit` uses a storage-only carrier when the by-value type graph contains placement metadata. It checks the root extent and metadata budget before extracting the image. The carrier's `decoded_semantic()` returns `None`; `Value::semantic()` returns that carrier itself when no decoded cache exists. No zero-valued placeholder is created.

Field and array-element reads decode their actual byte subrange. A partially initialized array viewed through an opaque parent keeps its own mask, so a written byte can be read while an unwritten byte still reports `Uninitialized`. Whole copies and stores retain the complete image and relocations. Existing decoded snapshots, including union active-member inspection, keep their semantic cache. Ordinary aggregate root loads retain their existing initialization checks.

Validation checks the nominal arena and ready root; construction binds the carrier extent to the selected target layout. Cell accounting charges image bytes and provenance metadata without recursively inspecting an opaque carrier. Sequence indexing derives the element and count from the canonical type registry, prepares its decoded-shape bound, and charges that work before reading it. Escape checks inspect every image address origin even when no semantic cache is available.

Constant publication remains conservative. Initialization holes are rejected. A storage-only carrier also requires an explicit storage publication receipt, even if every byte becomes initialized; converting it to a field tree could discard alias bytes or provenance. This checkpoint does not introduce a sparse constant receipt or change ordinary zero-backed `RecordBuild` construction.

Two focused tests passed using genuine placement definitions. One copies a Worker-shaped record with initialized info, a written far padding byte, an undefined padding range, and a defined slice. The other copies a pointer overlay through real VM memory and verifies the same data-pointer identity and undefined tail. Native byte-backed record size/offset/stride parity is tested separately. Source placement parsing and full sparse initialization remain separate acceptance checkpoints.

## How to change it

Keep carrier invariants in `stored_aggregate.rs`, byte-range extraction in `byte_memory/partial_snapshots.rs`, and live-allocation validation in `memory`. Use `decoded_semantic()` only for optional inspection. Never recurse through `Value::semantic()` when it may return the original opaque carrier. Decode observed fields through the image and derive sequence shape from the registry.

Update publication, materialization, escape checks, and cell/work accounting together when adding a new carrier form. Preserve complete pointer/procedure relocations; numeric bytes cannot manufacture a virtual handle. Extend tests for unknown masks, bounded extraction, selected initialized reads, and pointer identity before allowing broader construction or publication.

## Configuration

The image retains its explicit `ByteTarget` policy and endianness. VM value-cell, fuel, and evaluation-depth limits bound extraction and reads. No environment variable or source flag is added.

## Dependencies

The snapshots use `jai-vm` byte memory, virtual handles, work accounting, and `jai-types` canonical identities and target layouts. Native storage uses `jai-codegen`'s byte-backed placed record representation. No new crate or supplied native artifact is required.
