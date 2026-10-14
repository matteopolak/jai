# Deep_Copy progress and verified graph behavior

Canonical public configuration, pointer-map records and mutable diagnostic
globals are loaded directly into the module. Private operations separate object
identity, recursive values, array storage and timing. A source address is entered
in the caller/local map before recursive traversal; existing map results are
reused, and local map metadata is released independently of the copied objects.
Allocation failures and conflicting preallocated mappings assert explicitly.

Verified supported cases are scalar roots, null/preallocated roots, owned default
string copies, caller string mapping, resizable scalar arrays, explicit reused
maps, and conditional debug globals. Resizable storage retains its source capacity
while adopting the active allocator. Fixed arrays and `Any` are explicitly
unsupported as required by the reviewed page, with actual failing-program tests.
Overlapping unions are also rejected because the contract supplies no active-arm
policy. Non-struct pointers retain their source identity; struct pointers are
followed only when the configuration allows it.

The compiler now populates `Type_Info_Struct.alignment` from completed struct
layout. The original reproducer `tests/portable-stdlib/type-info-alignment.jai`
reports eight, matching `align_of`; the focused compiler regression also covers
packed, explicitly aligned and generic structs. The unchanged graph assertions
in `tests/portable-stdlib/deep-copy-graph.jai` pass interpreter and native O0/O2:
cycles, shared pointers, shared maps, copied string/array ownership, scalar-pointer
identity, mutation independence, mapper callbacks and preallocated roots.
Both cases are now part of the ordinary portable runner. These results establish
the exercised graph behavior, not every unresolved Deep_Copy policy below.

Further unresolved contracts: whether default strings must be copied or borrowed,
scalar-pointer policy, shared array slices of different extents, empty-but-reserved
array capacity, diagnostic counters/units, overlapping unions, and a preallocated
root identical to the source. Current default strings are owned copies; identical
allocation origins are reused through the map, while interior/prefix aliasing is
unsupported. The caller frees each distinct owned copy once; mapper-returned
storage remains governed by the callback. A preallocated root equal to its source
is rejected. These choices are documented implementation policy, not additional
reference guarantees.

`helper_count` currently counts visited reflected values and `time_total`
accumulates real monotonic elapsed seconds. Their updates use a private CAS lock;
public external mutations need caller synchronization. Debug `indent` counts
active recursive visits, so concurrent debug output is not a per-thread trace.
Maps/source graphs must be synchronized by callers. There is no universal graph
deinitializer: the caller owns the resulting allocation graph.

POSIX timing uses the new independent binding's `clock_gettime`. Windows uses
the new binding's [QueryPerformanceCounter](https://learn.microsoft.com/en-us/windows/win32/api/profileapi/nf-profileapi-queryperformancecounter)
and [QueryPerformanceFrequency](https://learn.microsoft.com/en-us/windows/win32/api/profileapi/nf-profileapi-queryperformancefrequency),
checking both native results. Windows code is target-checked, not executed here.
Other platform timer backends remain explicitly unavailable. No reference compiler
or library bodies were consulted.
