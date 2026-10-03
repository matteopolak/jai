# Source allocation origins

## What it is

`jai-source` retains the actual immutable allocation behind source spans. Equal paths, text, or compilation-local source IDs do not identify that allocation.

This packet restores the source producer and authored regressions. Formatting and literal-data reconstruction have been checked; compilation and test execution remain pending in the combined recovery assembly.

## How it works

`SourceTextSnapshot::new` creates a private `SourceAllocationId` with an immutable `Arc<str>`. Cloning a snapshot shares that owner. `append` records an immutable prefix link: spans wholly inside an original prefix keep its allocation and backing Arc, while appended or crossing spans belong to the newer allocation. Reconstructing an equal string creates a different owner.

`SourceMap::insert_snapshot` installs that existing owner into a compilation's source arena. `SourceRecord::span_owner` first checks the ordered byte range and UTF-8 boundaries. `span_owner_ref_with_work` admits work before accessing the record, checking its range, inspecting each prefix link, and exposing the final borrowed Arc. Callers can admit storage before cloning that Arc; the borrowed operation allocates nothing.

The selected `SourceProvider::retain_decoded_text` supplies the retained decoded snapshot. Its default creates a fresh observation. Native observation caches and generated-source overlays must override it when they can preserve a genuine earlier read or supplied snapshot. They must not infer identity from equal path and text. The loader must pass this returned snapshot to `insert_snapshot`; provider consumers are a separate paired recovery packet.

`SourceRecordKind::Embedded` preserves the original importing occurrence and a separate relative-resolution anchor. `path` remains a diagnostic label; `physical_path` returns `None` for embedded text. These fields describe source provenance and resolution. They do not grant an allocation witness.

## How to change it

Change the snapshot and span-owner implementation in `jai-source/src/locations.rs` and the provider contract in `provider.rs`. Preserve private allocation issuance, checked UTF-8 byte spans, and the exact append-prefix owner. Keep the provider registration in `lib.rs` paired with native and loader consumers.

Consumers that retain original procedure or insertion source must compare the span's allocation and actual Arc owner. Dense `SourceId` values are local arena lookup keys. A replacement source map can reuse those values without sharing any source allocation.

## Configuration

There are no environment variables or platform path lookups in the source-allocation producer. The caller supplies the work-admission callback. Owning source and VM preparation ledgers remain responsible for storage and work limits; this API does not create an independent allowance.

## Dependencies

The producer uses the Rust standard library. Native provider observation caches, generated-source overlays, and `jai-modules` loader registration consume its snapshot contract. Generated record insertion, durable field defaults, compiler Code admission, and fresh storage-capsule adoption remain separate recovery work; this packet does not claim those features are complete.
