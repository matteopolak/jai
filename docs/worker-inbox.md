# Debug_Info worker coordination

Exclusive ownership: stdlib/Debug_Info, its private dwarf/codeview/msf parsers, related tests and Debug_Info documentation. No other module edits planned.

2026-10-15: Implement public DWARF4 compilation-unit and MSF read workflows. Pending contracts are in specs/questions/debug-info-impl.md. No agent_message tool is exposed in this session; this inbox is the available local routing evidence for coordinator review. No other worktrees or external caches inspected.


## Shared type questions routed
Coordinator assigned the separate dirty reviewer to verify Generator/Library_Symbols visibility and public shape versus opaque private referents, plus CodeView base storage and PDB public name-map shape. Do not copy or guess private source layouts. Continue unblocked public helpers and original SDK fixtures while those answers arrive. generator-model owns the single canonical generator model/state definition once the public boundary is established; generator-platform must consume it rather than duplicate Generator. Library_Symbols state ownership will be assigned after visibility review. Coordinate minimal facade load lines with the original tools owner.


## Shared public type review complete
Reviewed bindings-generator.md confirms Generator and Library_Symbols are importer-visible, with their full public fields already inventoried; Generator also requires #type_info_none. The updated page explicitly records this. generator-model now owns the single canonical Generator AND Library_Symbols declarations; please commit those reviewed-shape definitions first so platform/emission workers can consume them without duplicates. generator-platform must not create another Library_Symbols type. Debug_Info now specifies typed CodeView embedded base storage and fixed tags. PDB name-map related types are file-scope contextual referents, not public imports: use an independent private representation satisfying the reviewed Pdb field contract; do not expose private source type names or duplicate private layout unnecessarily. No original bodies were passed.

## Debug_Info checkpoint and narrow remaining ABI question

3ec74dd4 implements public DWARF4 compilation-unit and MSF workflows; Mac interpreter/native O0/O2 plus original SDK oracles pass. CodeView type/PDB workflows now in progress using refreshed reviewed type-base paragraph and independent contextual PDB map storage. Remaining symbol ABI precision: refreshed spec explicitly adds base to Compile/Compile3, but Procedure/Inline_Site/Regrel/Data/etc still list no base and lack the common-prefix paragraph supplied for type records. Please confirm the same using base: Codeview_Symbol leading storage and fixed tags for every returned typed symbol, especially Procedure and Inline_Site. This blocks public symbol/inline parsing without guessing storage; basic is_procedure uses the already reviewed base. No agent_message tool is available; coordinator please route this local question.

## Debug_Info verified integration handoff

Commits3ec74dd4 and822da42b are ready for coordinator integration. The second commit adds the public CodeView type/PDB/TPI/IPI workflows, lookup/description/dump helpers and deep line clipping. Twenty-one formerly missing public names (22 overloads) now have implementations and real invocation evidence. `python3 tools/check_debug_info_public.py` passes all18 Debug_Info fixtures in Mac interpreter/native O0/O2 with SDK oracles, formatter and strict lint. Four symbol/inline functions remain blocked only by the precise typed symbol storage question above; each is listed in specs/questions/debug-info-impl.md. No other worktree/integration source was accessed. See status/debug-info-impl.md for exact APIs, commits, limits and test scope. No agent_message tool is available, so this inbox is the local notification for routing the remaining ABI question.


## Final model and typed symbol contract batch 2026-10-15 15:04 UTC

Reviewed debug-info refreshed. Generator pending model table now covers cursor registration/redeclarations, type/template/child-consumption, implicit this, literal/expression/macro/null semantics, token lifetime/equality, parenthesis start convention, member bit offsets, bool default omission, ObjC behavior. Repeated create_function returns null while preserving canonical record. Debug_Info typed procedure/inline leading base storage/discriminants and decoder behavior now specified. ABI determines later offsets; source does not promise deep-copy independence or zero-length annotation success. Implement remaining assigned APIs now; do not retain resolved contract blockers.

## Final symbol/inline implementation ready

All four APIs from the final contract batch are implemented. The public C13 workflow returns reviewed compiler/procedure/inline roots and source tables; annotations decode to owned bounded ranges; overlays split containing regions and apply ordered children. Target-derived Jai ABI is used throughout. Nonzero scope references, compressed operands, input bounds and allocation cleanup have native-object/synthetic regressions. The combined runner now includes20 fixtures, four additional x64/arm64 O0/O2 original inline objects with SDK field/graph/annotation/source oracles, and Windows/Linux/Mac x64/arm64 ABI checks. No stale contract blocker remains. Projection/encoding limits are explicit in debug-info-public-parsers.md and specs/questions/debug-info-impl.md. The source permits aliasing views; independent ownership in this implementation is not asserted as reference equivalence. Final commit/test evidence follows in the integration checkpoint.


## Current remaining-work count requested

Please publish a fresh docs/status/implementation-remaining.json inventory with complete/partial/missing public API counts and exact remaining names, plus current verification gaps. Count only your assigned ownership, distinguish draft from committed, include timestamp and head. User asks how much implementation remains; old aggregate counts are stale. Continue implementation while updating this short ledger.


## User-approved implementation balancing

User explicitly requests equalized remaining implementation work once fresh inventories arrive, and permits consolidating clean trees so workers share complete canonical dependencies. Include effort/dependency estimates with remaining API names. Integrator should produce a shared clean merged generator/model/platform/tooling baseline promptly; preserve one Generator/context lifecycle implementation and clear file ownership. Do not copy original/quarantined code or read dirty transcripts. Workers should identify a disjoint batch another worker can take, rather than duplicate shared scaffolding. Continue current implementation until reassignment is explicit.


## Balancing and shared baseline 2026-10-15 15:34 UTC

Twenty-fixture success is ready for handoff. Publish the requested fresh implementation-remaining.json now and commit final symbol implementations and tests. After completed assigned scope, you are next available for a disjoint generator emission batch. Tooling owner asked to propose exact names/files. Do not duplicate pending peer changes. Preserve final parser review/bounds/ownership regressions.
