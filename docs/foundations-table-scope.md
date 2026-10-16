# Canonical Table order and anonymous import scope

This follow-up preserves the prior Hash/Math production fixes unchanged. The
only new production edit is declaration order inside
stdlib/internal/collections/hash-table.jai. The compiler owner owns the separate
anonymous-import scope repair. No File export, algorithm, original application,
reflection filter, compiler or peer implementation is changed by this worker.

## Settled public facts and before/after

The coordinator's sanitized official-observations.json establishes runtime
Table(string,int) members in this order:
count, allocated, slots_filled, allocator, Entry, entries, hash_function,
compare_function, SIZE_MIN. Mixed procedure/field/nested-type declarations
also reflect in declaration order; constants retain negative byte offsets.

An original current-type-info reduction showed callbacks first, followed by
count/allocated/slots_filled/allocator/Entry/entries/SIZE_MIN. Runtime size was56,
alignment8, and data offsets were0,8,16,24,40. Moving only static callback
declarations after the data declarations produces the exact official default
sequence and preserves those size/alignment/offset values. Callback bodies,
generic parameters/defaults, field declarations and all table algorithms are
byte-for-byte unchanged apart from the relocation.

The original table-order fixture checks full names, offsets, constant flags,
negative constant offsets, direct field addresses, nested Entry metadata,
canonical generic identity, mixed-declaration inclusion and the collision-count
configuration. table-callbacks checks forward-referenced custom callbacks,
function identity and actual callback effects across growth, lookup, removal
and reset. Existing unchanged hash-table-contract covers duplicates, allocator
ownership, string keys, tombstones, resets, capacity/load factors and collision
counters. Prior Hash/Math fixtures remain unchanged.

The default official order is directly established. The optional collision
fields retain their existing relative data declaration/layout order and sit
after entries before the callback constants in this implementation. Their
layout is tested; no separate official enabled-counter order is claimed.

## Actual unchanged TOML consumer

All admitted sjorsdonkers--toml-jai source hashes were verified against ACCESS
before replaying examples/custom_handlers.jai. A fresh own Cargo target built
the current shared typed compiler, avoiding the reported stale-target issue.
The unchanged application now passes interpreter and native Mac ARM64 O0/O2,
including its reflection-based entries access and complex-key custom callbacks.

The application intentionally checks invalid magic bytes, an invalid fixed-array
length and a superfluous key. The runner matches its exact stdout/stderr and exit0
on all three modes; errors are not ignored or reclassified without matching.
Every original application assertion remains intact. No application index5
special case or copied serializer was introduced.

## Anonymous imports: old negative premise superseded

Official execution establishes that a loaded anonymous #import File remains
visible to its consumer even if it follows #scope_file. Named File::#import File
at the same scope remains private. Basic without File still rejects
get_absolute_path. The actual uniform '- test' workflow ran146 passing tests;
the earlier no-default-executable receipt was a successful metaprogram workflow,
not proof that tests did not run.

The old54 receipt is preserved as historical Hash/Math evidence. Its anonymous
private-import negative premise is invalid and must not be carried forward.
The original corpus-api runner now expects those cases to succeed; its historical
filenames are retained for source/adoption continuity, not as negative contracts.

New independent fixtures in foundations-table-scope separate:
- anonymous-load and anonymous-compile-time: required positives;
- named-private-negative and other-named-private-negative: required negatives;
- constant-private-negative: an ordinary named declaration stays private;
- retained public anonymous import and no-File controls.

Fresh compiler captures still fail both anonymous positives with unknown
get_absolute_path, while all named/constant privacy controls reject correctly.
The compiler owner has exact paths/commands in the inbox. Only top-level
anonymous imports crossing #load are settled; local block scope and broad named
visibility changes are not inferred. File's public body/export needs no change.

## Verification and integration boundary

Run:
```sh
CARGO_TARGET_DIR=/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/foundations/table-order-fresh-target cargo build --locked --offline -p jaic-cli -p jailint
python3 -B tests/portable-stdlib/foundations-table-scope/verify.py
```

Stable receipt: foundations/table-scope-proof-z0ohl92q/results.json on assigned
T7. It records46 commands: table_complete=true, two required anonymous scope
failures, overall complete=false/exit1. Table/Hash/Math/TOML account for21 actual
interpreter/native runtime executions; the public import control adds one more.
Unchanged source-built jaifmt and warnings-denied Hash_Table module/fixture lint
pass. Watched production hashes match before/after. Native optional crash
backtrace is disabled; assertions stay enabled, and no ABI8 assets are touched.

The first suite capture rejected intentional application stderr because the
runner initially required it empty. That capture stays failed; the rerun uses
the exact original negative diagnostics rather than blanket stderr acceptance.
The callback fixture initially expected equality during duplicate-permitting
table_add; it now checks equality during lookup, where it is required. No table
algorithm or callback assertion was removed.

Exact integration hashes and disjoint dependency requests are in
[status](status/foundations-table-scope.json). The sole integrator should adopt
the Table source and original fixtures narrowly, preserve prior Hash/Math hashes,
and consume the compiler owner's general scope fix before replaying uniform.
No Git/index/remote operations, broad400 sweep or native-platform expansion
were performed by this worker.
