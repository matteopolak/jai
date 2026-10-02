# Runtime allocator alias repair: resolved and pending boundaries

Resolved by refreshed reviewed Runtime_Support/Basic contracts: the default
callback is the canonical Default_Allocator procedure entity; optimized x64
except iOS and Switch2 support CREATE_HEAP, fallback targets do not. The earlier
distinct-callback statement and proposed parallel heap engine are withdrawn.
The capability set has no MULTIPLE_HEAPS bit. Creation ignores incoming
allocator_data and returns an independent heap; no parent/child destruction
ordering or cross-heap free guarantee is established.

Resolved implementation cause: private internal/runtime/heap.jai was a
disconnected allocator with no CREATE_HEAP branch. Runtime_Support now exports
the canonical alias and no longer loads or retains that obsolete allocator.
Basic.create_heap/destroy_heap and Default_Allocator bodies are untouched.

Pending execution: original Windows x64 TOML runtime job after integration.
Mac x64 native/interpreter actual creation, owned resize/failure/destruction and
default memory-debugger report checks pass; Windows source proof is not native
execution. No native C provider input changed and no rpmalloc provider sits on
the repaired path.

Pending fixture integration: foundations owns allocator-caps.jai, which compares
the context default to fallback bits unconditionally. Its expected flags must
follow the now-reviewed canonical target variant. No all-heaps waiver or broad
fallback classification is justified. No edits to that fixture by this worker.

Initial independent test drafts used size-derived alignment and raw unsupported
ARM creation; neither is a valid public contract assumption. Final controls use
natural typed alignment and check CREATE_HEAP before requesting a heap.
All original failure receipts and source guard corrections are retained.
