# Hash_Table public behavior audit

Twenty-one reviewed API rows now have specific independent behavior evidence.
Table remains partial for its unprovided zero-load-factor policy; Walk_Table is
missing because its ambient-binding contract is absent. Exact questions are in
specs/stdlib/hash-table-questions.md. No missing macro was replaced with a stub
and no old private exports were introduced.

Run `python3 -B tools/check_portable_hash_table.py` with assigned own compiler
89560db9. It composes current Hash_Table and NEW foundations Hash read-only into
target, uses the real allocator, and passes interpreter/native Mac O0/O2, Linux/
Windows both-CPU source checks and whole owned strict lint. Evidence:
target/hash-table-contract-final.log. Owned Jai format/--check passes. Native
Linux/Windows and independent coordinator test review remain pending.

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
This audit required no production behavior fix in the supported matrix.
