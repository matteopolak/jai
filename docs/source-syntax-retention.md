# Source syntax retention

## What it is

The borrowed metadata visitor measures allocations owned by original syntax and portable type recipes. It is used by the source forest reservation before compiler output copies are made.

## How it works

Each vector, box, string, and byte buffer is admitted before its contents are traversed. The visitor includes original defaults, nested quotations, record members, conditional branches, imported arguments, and source ABI policy. An independently cloned declaration is a separate root and retains its own allocation. Inline rows belong to their enclosing container, so the visitor reports descendants rather than counting an inline root twice.

The visitor accepts `(work, bytes)` callbacks. Rejection stops traversal immediately. Nesting beyond 128 returns `SourceMetadataError::ExcessiveNesting`; it does not convert readiness into a diagnostic or resolve types.

## How to change it

Extend the exhaustive matches when adding syntax variants. Expose an entry point for each actual owner rather than wrapping a declaration in a synthetic file. Keep vector capacity and string capacity in the measurement, including unused slots. Source records and shared graph or catalog payloads are admitted by their owning visitors and the common union, not by this syntax walker.

## Configuration

`MAX_SOURCE_METADATA_DEPTH` is 128. The caller supplies the cumulative work and retained byte limits; this component does not create a new allowance.

## Dependencies

`jai-syntax` supplies the original AST. `jai-modules` supplies `ModuleType` and bound arguments. The semantic source forest supplies the shared meter and ownership reservation. The authored tests have not been executed in this source-only packet.
