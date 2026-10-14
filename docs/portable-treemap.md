# Treemap weights and geometry

Canonical public records and callback types are loaded directly into the facade;
private traversal and rectangle algorithms live under `internal/visualization`.
Math remains delegated: integration uses only the numerics worker's new Vector2
and finite-value checks. No Math implementation is duplicated here.

Nodes occupy stable Bucket_Array slots. Names are copied, parent links are
validated, and every insertion marks weights dirty. Weight recomputation visits
descendants first, sums non-leaf weights and sorts children descending using the
existing comparison-based sort. Locator-to-index mapping spans bucket boundaries.
There is no additional public node-removal or deinitialization convenience.

Display recomputation requires clean tree weights. It sizes node storage once,
sets the root to the complete outer rectangle, and partitions the remaining
rectangle into rows selected by a squarified aspect-ratio score. Normalized
weights avoid overflowing absolute area/weight intermediates. Each row uses
shared edges, and subsequent rows derive remaining dimensions from the fixed
outer boundary. This removed measurable accumulated float drift: the 1,025-node
growth test initially produced area 7999.997306 rather than 8000; the same unchanged
area assertion now passes. Layout remains float geometry, not exact real arithmetic.

Border callbacks receive candidate outer geometry, the node and its parent's
Display_Node. The stored border widths inset the rectangle used for descendants;
the outer node rectangle remains unchanged. Negative/oversized borders and
non-finite dimensions/weights assert. The current built-in border policy is zero
width. That default, coordinate orientation and helper range convention are
not specified by the oracle and need review: currently coordinates increase east/
north, and flush_nodes uses the half-open child range [unsized_cursor, child_index).

Display caching follows dirty/force/outer-size state, also detecting node-count
changes. After changing weights with unchanged node count, callers must mark
the display dirty or force it after recomputing the tree; no hidden revision
registry is introduced. Whether the intended contract requires further automatic
weight-change invalidation remains unresolved.

Verified cases cover copied names, canonical metadata, non-leaf weights, descending
order, non-overlap, proportional areas, root/child borders and callback parent
identity, caching/force, nested layout, and stable indexing through more than one
1,024-slot bucket. Caller cleanup releases names/child arrays, display storage and
bucket storage explicitly. A failing program requires dirty-tree display rejection.
Zero-weight behavior is best effort and not claimed as a compatibility guarantee.
Very deep trees still use recursive traversal; extreme-depth stack requirements
and exact equal-weight order/aspect selection are not established.
