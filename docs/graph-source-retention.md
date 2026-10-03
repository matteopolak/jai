# Graph source retention

## What it is

`ModuleGraph::visit_retained_source_storage` lends the original immutable source forest to a caller's cumulative budget. It measures genuine graph containers and exposes actual source, syntax, scalar, capture and portable type owners before copying compiler output.

## How it works

The caller supplies separate work, metadata and owner callbacks. Capacity bounds include Vec slots and conservative hash bucket/control storage. Published syntax is independent from the original parsed file, so declarations, run/insert/context directives and insertion code trees all reach their own syntax callbacks. Parameter scalars use `GraphSyntaxStorage::ScalarValue`; the visitor never clones a capture to model them.

`SourceRecord::visit_retained_metadata` borrows each real append-prefix snapshot. Its text callback receives the authentic allocation witness and retained Arc under the live source guard. Path capacities and prefix snapshot/control allocations are metadata; text payload/control accounting and exact owner dedup belong to that callback. `Symbols` counts both real spelling stores, including independent map key Strings.

## How to change it

Add a callback or capacity visit for each new owned graph field. Preserve exhaustive scalar matches and original owner borrowing. Equal paths, IDs or bytes never confer sharing credit. The visitor covers the original graph and committed publications; private Builder worklists and insertion append plans need their own separate census.

## Configuration

There is no separate graph quota. The caller's existing budget admits each traversal and metadata bound. Saturating arithmetic produces a conservative denial-sized quantity on overflow. Callbacks can reject before owner projection or subsequent traversal.

## Dependencies

This uses the genuine `jai-source` snapshot/allocation producer, `jai-modules` graph and publication stores, and borrowed `jai-syntax`/`jai-eval` metadata visitors at the caller. The packet has formatting and exact-base apply checks; authored fixtures are not executed.
