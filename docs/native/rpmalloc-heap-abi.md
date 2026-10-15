# rpmalloc native storage and public heap separation

The reviewed contextual records are complete public-signature types, distinct
from the pinned native SDK's internal storage. The generator now parses all
seven native heap/span/cache/counter records from the complete official C
source with heap-disabled and heap-enabled configurations separately. It emits
a private storage module for the actual SDK build profile and retains both
field inventories in provenance. Unknown native types/members fail generation.

Both Mac CPU programs compare seven native sizes and every one of 66 field
offsets and widths against C probes compiled from that actual source. They
also inspect non-atomic fields of a real acquired SDK heap and exercise real
heap allocation/ownership/free/release. Plain scalar storage views provide no
atomic-operation API and must not be used to read concurrently changing atomic
members. Six desktop Jai source checks pass; native Linux/Windows ABI/runtime
execution remains unavailable here.

The SDK and reviewed rewrite Heap both occupy 65,552 bytes in this profile,
but native span_cache precedes span_free_deferred while the reviewed rewrite
places its full-span lists before caches. Their offsets differ. The reviewed
Span occupies 96 bytes; native span_t occupies 88, and their deferred-free-list
offsets also differ. These active assertions prevent treating equal heap sizes
as permission for a pointer cast. No public heap/span is passed to the SDK.

The native probe includes the pinned C source (now with the separately recorded
heap-pool page-granularity build fix, which changes no record ABI) with every external
SDK definition prefixed. That separately compiled probe SDK instance is never
initialized or used for allocations; only independently authored size/offset
and non-atomic field accessors execute. The production SDK retains its exact
native library symbols. The first header-only prefix inventory caused a real
duplicate-symbol link failure: the header omits rpmalloc_set_main_thread. A
complete source-definition scan now retains that export in both configurations
and checks every header export against source. The public set_main_thread
wrapper now calls this real production symbol, and private/public native tests
invoke it. This is a production forwarding fix, separate from probe repair.

A new test initially assumed equal Span sizes. Actual C evidence disproved
that oracle; the corrected assertion requires the observed separation while
keeping all native size/offset/width assertions active. The original link and
oracle failures remain indexed in durable reports. No public record was
expanded or reordered to satisfy the SDK.

Evidence: `.work/rpmalloc-native-storage-verification.json` contains two-CPU
execution, six source checks, strict scoped lint, production formatting and
regeneration. The standard native binding verifier discovers this private ABI
unit separately from public API programs. Generated storage/probes add no
public implementation credit. Proper remaining work is canonical heap/span
adapters with exact identity/lifetime/field behavior, not stale zero snapshots
or aliases of SDK opaque pointers; the reviewed questions document requests
the remaining live-metadata/handle contract.

The final scoped checkpoint-13 retains six missing-public-name failures and all
18 rpmalloc configuration failures. It has 36 passing source checks, 96 privacy
checks and ten native build/run checks (five programs, two private). Root owned
formatting and regeneration pass; scoped strict lint and 60 Python regressions
pass. The actual production dependency builder compiles the source probe too.
