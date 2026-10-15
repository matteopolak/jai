# Debug_Info implementation plan

Goal: actual public DWARF4 and MSF reader workflows, with CodeView/PDB ABI gaps recorded precisely.

Design: bounded readers reuse verified line/MSF decoding. DWARF abbreviation and DIE parsing projects the canonical model; every failure releases partial owned allocations. Public results retain borrowed strings and allocate arrays. Missing CodeView base storage and PDB map layouts will not be inferred.

- [ ] Add original SDK-produced DWARF4 object fixtures and public parser assertions; observe missing-API failure.
- [ ] Implement bounded abbreviation/form/DIE traversal, canonical units/types/subprograms/declarations/blocks and line-table projection, filename helpers.
- [ ] Verify interpreter/native O0/O2, truncations, multi-unit reference origin and SDK metadata.
- [ ] Implement canonical MSF parsing/integrity and FPM lifecycle using documented policies; test real generated PDB streams and corruptions.
- [ ] Format, strict lint, update docs/status and commit verified batches.
- [ ] Account for every remaining API with an exact contract/dependency and route via worker-inbox when agent_message is unavailable.

No separate design approval requested: user authorizes choosing documented independent policies and continuing unblocked implementation.
