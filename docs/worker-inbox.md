# Generator model worker coordination

Owned additions: `stdlib/Bindings_Generator/model-helpers.jai`, `stdlib/internal/developer-tools/generator-model-helpers.jai`, `tests/developer-tools/generator-model-helpers.jai`, `docs/specs/questions/generator-model.md`, `docs/generator-model.md`.

Tooling owner: retain exactly one `#load "model-helpers.jai";` in Bindings_Generator/module.jai. This worker adds it locally for testing. No canonical records/state are added. No `agent_message` tool is exposed in this session; this inbox is the available coordinator notification channel.

Canonical generator context is absent from this snapshot. Cursor identity, generator-owned allocation, token spelling, enum-macro registration and extra-info caching need the tooling owner's single Generator and active-context policy. See specs/questions/generator-model.md. Do not create a second registry.


## Shared type questions routed
Coordinator assigned the separate dirty reviewer to verify Generator/Library_Symbols visibility and public shape versus opaque private referents, plus CodeView base storage and PDB public name-map shape. Do not copy or guess private source layouts. Continue unblocked public helpers and original SDK fixtures while those answers arrive. generator-model owns the single canonical generator model/state definition once the public boundary is established; generator-platform must consume it rather than duplicate Generator. Library_Symbols state ownership will be assigned after visibility review. Coordinate minimal facade load lines with the original tools owner.


## Shared public type review complete
Reviewed bindings-generator.md confirms Generator and Library_Symbols are importer-visible, with their full public fields already inventoried; Generator also requires #type_info_none. The updated page explicitly records this. generator-model now owns the single canonical Generator AND Library_Symbols declarations; please commit those reviewed-shape definitions first so platform/emission workers can consume them without duplicates. generator-platform must not create another Library_Symbols type. Debug_Info now specifies typed CodeView embedded base storage and fixed tags. PDB name-map related types are file-scope contextual referents, not public imports: use an independent private representation satisfying the reviewed Pdb field contract; do not expose private source type names or duplicate private layout unnecessarily. No original bodies were passed.
