# Retained source identity

## What it is

`SourceProcedureIdentity` retains an actual source allocation, exact span, strong text owner and path independently of debug policy. `SourceProcedureKey` is a closed copy key derived from that checked identity; it grants no native execution or linking authority.

## How it works

The constructor verifies the current source record and asks `SourceRecord::span_owner` for its genuine owner. A retained snapshot append can preserve the original prefix owner across new graph source IDs. Equal replacement text produces another allocation and cannot match. `matches_identity` supports this exact retained-owner rebasing; `same_source_identity` preserves the existing same-arena role predicate.

## How to change it

Keep the strong source owner and allocation witness together. Change the source snapshot producer and constructor together if span ownership changes. Do not add constructors from dense IDs, paths or hashes. Native library consumers must also check their actual immutable row, target, options and module environment.

## Configuration

There are no flags. Snapshots must be retained by the selected provider or generated-input journal. The default provider's equal decoded text is a fresh observation.

## Dependencies

This checkpoint requires the source-allocation foundation and its actual `SourceAllocationId` and `SourceRecord::span_owner` implementation. The native role getter is preserved. The added regressions are source-only and have not been executed in this recovery lane.
