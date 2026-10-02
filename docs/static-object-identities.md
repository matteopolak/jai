# Static object identities

## What it is

`StaticObjectId` identifies an immutable compiler-owned storage reservation. A discarded reservation must never identify a later object, even when the builder reuses its physical slot for the same nominal type.

## How it works

The prepared implementation keeps the existing graph arena and physical index, adding a checked monotonically increasing reservation identity. Rollback truncates unpublished objects without resetting that counter. Object definition and published graph lookup compare the full identity before accessing a slot; typed equality and hash keys include the reservation identity.

Published prefixes retain their original objects and `Arc` ownership across later successful publications. Rejected stale relocations do not publish a suffix or invalidate earlier snapshots. Counter exhaustion returns the typed `ReservationExhausted` error before allocating a reservation; it cannot wrap to an earlier handle.

The implementation and three regressions are now integrated in the live storage module through Driver's narrow opaque-ID window. The private prototype at `artifacts/component-checkpoints/static-object-generations-20261002T140845Z` reproduces the original stale-definition bug with an expected failing regression, then passes all 276 IR tests and strict all-targets Clippy with the same implementation. `validation.json` separates that baseline failure from prototype acceptance and records source/executable hashes. Driver's full-workspace production check and fresh CLI checkpoint are the next integration gates; they are not implied by the component pass.

## How to change it

Keep physical indices for layout and indexing, but use the complete `StaticObjectId` for ownership checks and caches. Never reset reservation identities during rollback. Any new byte-view or descriptor receipt must retain and revalidate the full object identity; nominal type equality alone does not establish reservation lifetime.

If introducing another object-resolution path, check both the arena and the selected slot's complete ID. Preserve validation before publication and preserve iterative disposal of rejected values. Tests cover same-typed slot reuse, stale relocation rejection, stable published prefixes and exhaustion without mutation.

## Configuration

The reservation counter uses checked `u64` arithmetic. Existing `StaticDataLimits` still bound object count, value nodes, projection depth and retained snapshot references. Reservation identity is process-local metadata, separate from target addresses and pointer width. No new environment variables or CLI flags are required.

## Dependencies

The `jai-ir` static-storage builder and graph, canonical type proofs from `jai-types`, and consumers in the VM, LLVM backend and semantic reflection. The prototype component contains `jai-source`, `jai-types` and `jai-ir` with no external crates.
