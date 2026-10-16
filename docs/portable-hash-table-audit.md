# Hash_Table public behavior audit

The reviewed ambient-binding contract is now implemented by `Walk_Table` and
verified against the actual shared library. Its earlier compiler named-while
value-export blocker is resolved in current shared Rust: the full public fixture
passes interpreter and native Mac ARM64 O0/O2 without caller shadow variables,
private exports or dropped assertions. Table's zero-load-factor policy remains
an explicit contract question in specs/stdlib/hash-table-questions.md.

Run `python3 -B tools/check_portable_hash_table.py` with the worker's source-built
shared compiler, formatter and `CARGO_TARGET_DIR`. The runner uses the actual
shared stdlib and unique output directories, with no staging composition or peer
checkout. Current receipt:
`artifacts/local-verification-stdlib/cargo-target/hash-table-shared-au4y6k1x/results.json`.
All 38 checks pass: six actual interpreter/native executions, four builds, twelve
source checks, twelve complete strict owned lint contexts and four format gates.
Native Linux/Windows and Mac X64 execution remain pending. Earlier staged
receipts remain historical evidence rather than current shared conformance.

The full `table-walk.jai` fixture checks caller-visible hash/index bindings,
tombstones, named-loop condition values, labelled continue/break, repeated macro
expansion and terminal probe state. Its original failure remains preserved; the
current pass follows the general compiler fix, without another production edit
to make the fixture special.

The new reviewed-spec fixture tests default initialization/empty lookup and miss
booleans without reading uninitialized returned values; distinct duplicate
entries and first-selected-pointer replacement; all-match copies/counts and
removal preserving probe chains; find-or-add initialization by caller;200/400-key
growth/removal/rehash, capacity retention/release and explicit expansion; default
and forced-collision hashes with configured30/90 thresholds; true/false tombstone
reuse with observable slots_filled; forward/reverse/pointer iteration without a
fixed slot-order assumption; actual custom/default string equality; collision
counters conditional fields; canonical Table name, hash sentinels, next-power
values1..4096; and the deprecated-but-reviewed init allocation behavior.

A forwarding counting allocator uses the real parent allocation procedure.
Changing context.allocator after initial insertion does not change table storage
ownership: growth and deinit use the captured owner, every allocation is released,
and the later allocator receives no storage requests. This is allocation
accounting, not a fake allocator returning fabricated memory or success.

Separate test correction: the first fixture reused a local declaration name;
the compiler properly rejected it. Renaming the test variable made the public
behavior test valid; no production change or assertion reduction. Original
diagnostic is target/hash-table-contract-fixture-diagnostic.log.
The existing table behavior matrix required no further production behavior fix;
the separately reviewed Walk_Table body is added in this checkpoint.
