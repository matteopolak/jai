# Debug_Info implementation plan

Goal: actual public DWARF4 and MSF reader workflows, with CodeView/PDB ABI gaps recorded precisely.

Design: bounded readers reuse verified line/MSF decoding. DWARF abbreviation and DIE parsing projects the canonical model; every failure releases partial owned allocations. Public results retain borrowed strings and allocate arrays. Missing CodeView base storage and PDB map layouts will not be inferred.

- [x] Add original SDK-produced DWARF4 object fixtures and public parser assertions; observe missing-API failure.
- [x] Implement bounded abbreviation/form/DIE traversal, canonical units/types/subprograms/declarations/blocks and line-table projection, filename helpers.
- [x] Verify interpreter/native O0/O2, truncations, multi-unit reference origin and SDK metadata.
- [x] Implement canonical MSF parsing/integrity and FPM lifecycle using documented policies; test real generated PDB streams and corruptions.
- [x] Format, strict lint, update docs/status and commit verified batches.
- [x] Account for every remaining API with an exact contract/dependency and route via worker-inbox when agent_message is unavailable.

No separate design approval requested: user authorizes choosing documented independent policies and continuing unblocked implementation.

CodeView type/PDB public workflows, lookups/descriptions/dumps and deep clipping were added after refreshed reviewed type-base/opaque-map contracts unblocked them. The final reviewed symbol contract resolves those dependencies. All four symbol/inline APIs are implemented with transactional C13 parsing, bounded inline state and ordered contained overlays. Original SDK symbol/annotation/source oracles, corrupt-reference/encoding/allocator tests and target-derived ABI checks are integrated into the combined Mac runner.
