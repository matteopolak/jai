# Owned constant slices

## What it is

`jai-ir/src/constant_slices.rs` is an **unregistered private prototype** for retaining a typed slice and its real backing across compile-time publication. It does not add a public `ConstantKind` variant or make ordinary string-to-slice casts compile-time constants.

## How it works

A view retains its canonical slice type, start, count, and optional shared backing. Backing stores the actual element type and full capacity, including explicit fully uninitialized tail slots. A descriptor does not read its elements: visible uninitialized slots are retained, and later reads must consult the real image mask. Literal backing is read-only and preserves its actual fixed-array or string storage class. Captured backing preserves its actual read-only or mutable policy. Mutable snapshots describe reconstruction; their known element bytes must not become folded element constants.

All views of a captured allocation share one identity within the publication batch. Equal contents in different captured allocations remain distinct. Canonical replay uses the retained source-run envelope, publication occurrence, and deterministic backing discovery ordinal. The transient session identity is only a cache key and never enters replay bytes. A retained recipe keeps its publication receipt; a new mutation snapshot requires a new certified publication version.

An empty literal has null data. An empty captured subview may have nonnull data, including a one-past pointer, and retains its real backing. Factories check exact element identities, range, preserved initialization state, descriptor count, bounded constant shape, and the selected target's full backing extent before admitting a view. Backing factories preflight semantic node/depth budgets before retaining shared storage; target extent is checked at the view boundary before publication or hydration. Checked clones share an `Arc`; rejected deep constants are disposed iteratively.

The sparse prototype represents complete semantic elements and wholly uninitialized elements. Partial element images, inactive union bytes, heterogeneous byte views, and arbitrary raw zero-stride captures still need exact storage proof. Zero-stride logical capacity must come from the actual producer, never division of a byte extent. These are outstanding implementation capabilities, not final language restrictions.

Cyclic nested views require an ID-based publication graph. The planned boundary performs a bounded allocation discovery pass, reserves all graph nodes, validates typed references and masked storage, then defines and publishes them atomically. VM hydration and native emission must likewise reserve all backing allocations/globals before installing references. An `Arc` tree alone cannot prove or represent those cycles.

## How to change it

Coordinate the capsule with VM publication/hydration, LLVM globals, source constant capture/defaults, specialization keys, and replay serialization before registering the module or adding an IR variant. VM source extraction must certify real live storage, full capacity, aliases, access, mutation version, and lifetime before invoking a backing factory. The prototype's byte-envelope constructor alone is not a source certification API.

Runtime consumers must precharge extraction, type/layout closure, image mask/relocation encoding, retained recipe work, and pool cloning. A cached constant-node count does not bound decoding a wide zero-initialized aggregate. Use prepared VM layouts during warm execution; `selected_extent` is an admission check, not a warm execution cache.

The shared [constant capture admission](constant-capture-admission.md) hooks reserve ordinary rollback and ancillary owners and carry immutable publication work into the VM fuel meter. Slice-specific backing pools, certified storage extraction, and the slice IR schema remain held for their coordinated integration window.

Production integration remains held by the driver until all enum consumers and serialization paths are coherent. The eleven private tests pass in a standalone proof compiled with warnings denied. The [proof receipt](../artifacts/constant-slice-private-proof.json) records the exact trusted rewrite artifacts, before/after stability, source hashes, and private verification/disposal adapters used. This verifies the factory boundary; it is not production source, VM hydration, or native acceptance.

## Configuration

`ConstantSliceLimits` defaults to 1,048,576 element slots, 1,048,576 value nodes, depth 128, 1,048,576 owned payload bytes, and 1,048,576 publication envelope bytes. Cached `work()` includes constant nodes plus owned string byte payloads. Shared publication envelope encoding and external type/image closure work are charged separately at their actual consumer boundaries. Actual native extent uses the selected `LayoutPolicy` and canonical element stride. Source-run and VM budgets must additionally bound extraction and reconstruction; these limits do not replace those budgets.

## Dependencies

The prototype uses `jai-types` canonical type identities and target layout, existing typed IR constant verification, iterative rejected-value disposal, and `Arc` ownership. Consumers depend on source-run lexical replay facts, genuine VM memory images and origins, immutable literal pools, and selected-target LLVM storage adapters. It never imports supplied original compiler binaries or native objects.
