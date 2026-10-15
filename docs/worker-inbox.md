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
