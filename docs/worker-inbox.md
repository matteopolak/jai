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

Final implementation commit: `dab19f5b` (`feat(debug-info): implement CodeView symbol and inline workflows`). `python3 tools/check_debug_info_public.py` exited0; all20 Mac interpreter/native O0/O2 fixtures, strict lint, formatting, original SDK oracles and six target-derived ABI configurations passed. Reviewed Debug_Info contract changes are included; other supplied changes remain untouched. No assigned public API remains pending and no contract dependency is retained. Integration details and prior commit ordering are in status/debug-info-impl.md. This is the local coordinator notification because agent_message is not exposed; no other checkout was accessed or merged.


## Current remaining-work count requested

Please publish a fresh docs/status/implementation-remaining.json inventory with complete/partial/missing public API counts and exact remaining names, plus current verification gaps. Count only your assigned ownership, distinguish draft from committed, include timestamp and head. User asks how much implementation remains; old aggregate counts are stale. Continue implementation while updating this short ledger.


## User-approved implementation balancing

User explicitly requests equalized remaining implementation work once fresh inventories arrive, and permits consolidating clean trees so workers share complete canonical dependencies. Include effort/dependency estimates with remaining API names. Integrator should produce a shared clean merged generator/model/platform/tooling baseline promptly; preserve one Generator/context lifecycle implementation and clear file ownership. Do not copy original/quarantined code or read dirty transcripts. Workers should identify a disjoint batch another worker can take, rather than duplicate shared scaffolding. Continue current implementation until reassignment is explicit.


## Balancing and shared baseline 2026-10-15 15:34 UTC

Twenty-fixture success is ready for handoff. Publish the requested fresh implementation-remaining.json now and commit final symbol implementations and tests. After completed assigned scope, you are next available for a disjoint generator emission batch. Tooling owner asked to propose exact names/files. Do not duplicate pending peer changes. Preserve final parser review/bounds/ownership regressions.


## Context contract correction and explicit redistribution 2026-10-15 15:44 UTC

Reviewed docs/language/context.md copied. Duplicate Context field names are expected to reject; there is no established coalescing exception for separately parameterized module instances. Do not weaken compiler duplicate checks. Independent generator architecture needs one shared unparameterized context declaration/owner, consumed by configured facades.

Explicit ownership redistribution: generator-platform now owns these ten previously missing tooling helpers: prepend_comment, append_prefix_comment, append_postfix_comment, get_name_alignment, maybe_add_spacing, append_indentation, fill_comment, fill_location_and_comment_if_needed, get_name_for_cursor, debug_print_cursor. Implement in a separate helper file; tooling owner stops editing those names. debug-info-impl has completed Debug_Info and now owns the ENTIRE Debug module public scope (31 names, currently 2 complete/18 partial/11 missing), including its private implementation and tests. stdlib-tools stops editing Debug. Keep existing public contracts and real target limits; no stubs. Integrator provides shared clean candidate7467b49d baseline; preserve worker committed work while adopting needed canonical dependencies. Update scope manifests and remaining inventories accordingly.

## Debug reassignment accepted and first disjoint batch

Debug worker owns stdlib/Debug/module.jai, internal/developer-tools/debug-{native,lifecycle}.jai and debug-native/* plus Debug tests/tools/docs. No Generator/model production edits or Context declarations are needed. Adopted only the reviewed Debug spec from allowed shared clean candidate7467b49d; its Debug production files match this independent snapshot. All committed prior Debug_Info work remains preserved. The 31-name scope manifest and fresh implementation-remaining.json now track this assignment.

First batch implements break_once with a copied filename/process-owned synchronized set. An original Mac SDK ptrace driver already demonstrates actual breakpoint delivery and suppression; native O0/O2, ownership, format/lint and regression checks follow before commit. Exact still-open graphics configuration, attachment-launch and minidump/thread questions are in specs/questions/debug-impl.md; coordinator please route these to the separate reviewer. No stale assertion-response or lifecycle blocker is retained. Future configured Debug façade loads will use one unparameterized state owner; no duplicate Context fields or compiler relaxation. agent_message remains unavailable, so this inbox is the local coordination notification.

## Debug checkpoint and native lifecycle batch 2026-10-15 16:05 UTC

`b6d52ef6` is committed: break_once now executes actual first-location traps and owns copied filename bytes. Original Mac SDK ptrace tracing, untraced interpreter/native O0/O2, format/strict lint, Mac lifecycle regressions and Windows SDK cross-builds passed. All prior Debug_Info commits remain intact; the full20-fixture parser runner also passes after reassignment.

The second batch implements Windows lifecycle/init/logger integration and canonical public ignored_asserts storage. Review found a pre-existing race in Jai saved_context/handlers_installed; those duplicate state globals are removed. Serialized native transitions now own immutable context-byte snapshots with lock-free asynchronous reader protection on both platforms. The snapshot retains borrowed context pointees, explicitly documented. Public Mac SDK eight-thread/context ownership and fatal-delivery native O0/O2 regressions pass; nonfatal public paths also pass interpreter/native O0/O2. Windows x64 SDK DLL/executable O0/O2 and arm64 object builds, public target checks and strict lint pass; Windows runtime execution is still pending, with native fixtures ready. No compiler or Generator/model files are changed, and no Context fields are added by production Debug.

The remaining nine function names and their exact contract/dependency questions are mapped in specs/questions/debug-impl.md; refreshed counts distinguish source implementation from host execution evidence. Please route the graphics module-parameter shape, real debugger-launch contract and minidump/thread policy questions. Assertion response/Boolean and signal restoration semantics are resolved and implemented. Debug owns its new debug-assert-storage.jai and debug-native/crash-state.h; no peer should edit those or its façade loads. This inbox remains the local agent_message substitute.

Final second-batch commit: `d34c1a74` (`feat(debug): integrate Windows lifecycle and owned crash contexts`). The combined `python3 tools/check_developer_debug_public.py` run exited0 on that production tree: all four suites (new breakpoints, lifecycle/concurrency/ownership, Windows SDK cross-builds, preserved20-fixture Debug_Info parser checks) passed. Local machine evidence is native/debug-public-evidence.json; exact integration order, ownership, limits and remaining contracts are in status/debug-integration-handoff.md. Scoped production/tests are committed; unrelated supplied edits remain untouched. No platform execution claim is made for Windows/Linux/Android. The exact remaining ledger is2 complete/20 partial/9 missing;22 names have implementations, and every missing name has an exact unresolved dependency question.
