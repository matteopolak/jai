# Scalar source retention

## What it is

`Value` and `WeakFloatKey` expose borrowed metadata visitors for compiler source ownership. The metered weak-float encoder exports exact semantic records without copying decimal signatures or treating a cached hash as identity.

## How it works

The caller supplies `FnMut(work, bytes)` from its current root budget. Visitors charge before following each expression, key, box or shared allocation. Only actual Arc pointers deduplicate a DAG within one traversal; separate roots receive conservative full charges. Inline enclosing scalar slots belong to the caller. Real Arc payloads, decimal String capacities and temporary traversal backing belong to the visitor.

`canonical_bytes_with_work` and `canonical_bytes` share one encoder. The version-one output remains unchanged. Borrowed node signatures and fixed three-child IDs replace owned signature copies. Each lookup, exact decimal comparison and output write is charged before work; Vec growth is admitted with both old and requested new backing live.

## How to change it

Extend the exhaustive expression and key matches when adding a scalar operation. Keep diagnostic spans outside semantic encoding. Adding owned caches requires a real capacity visitor; an O(1) fingerprint does not measure that backing. Temporary allocation failures return `Allocation`, arithmetic or unexpected reservation capacity returns `CapacityOverflow`, and caller denial remains `Admission(E)`.

## Configuration

The caller chooses node and byte limits for encoding and supplies cumulative work/metadata admission. The visitor itself introduces no separate quota. The existing maximum three children is the closed weak-float key grammar.

## Dependencies

The implementation uses the existing `jai-eval` expression/key owners, `jai-syntax::DecimalLiteral` spelling capacity, and `jai-types` scalar metadata. Compiler forest integration must visit independently retained values and keys. Packet validation is formatting and apply checks only; authored tests have not been run.
