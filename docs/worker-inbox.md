# Generator model worker coordination

Owned additions: `stdlib/Bindings_Generator/model-helpers.jai`, `stdlib/internal/developer-tools/generator-model-helpers.jai`, `tests/developer-tools/generator-model-helpers.jai`, `docs/specs/questions/generator-model.md`, `docs/generator-model.md`.

Tooling owner: retain exactly one `#load "model-helpers.jai";` in Bindings_Generator/module.jai. This worker adds it locally for testing. No canonical records/state are added. No `agent_message` tool is exposed in this session; this inbox is the available coordinator notification channel.

Canonical generator context is absent from this snapshot. Cursor identity, generator-owned allocation, token spelling, enum-macro registration and extra-info caching need the tooling owner's single Generator and active-context policy. See specs/questions/generator-model.md. Do not create a second registry.


## Shared type questions routed
Coordinator assigned the separate dirty reviewer to verify Generator/Library_Symbols visibility and public shape versus opaque private referents, plus CodeView base storage and PDB public name-map shape. Do not copy or guess private source layouts. Continue unblocked public helpers and original SDK fixtures while those answers arrive. generator-model owns the single canonical generator model/state definition once the public boundary is established; generator-platform must consume it rather than duplicate Generator. Library_Symbols state ownership will be assigned after visibility review. Coordinate minimal facade load lines with the original tools owner.


## Shared public type review complete
Reviewed bindings-generator.md confirms Generator and Library_Symbols are importer-visible, with their full public fields already inventoried; Generator also requires #type_info_none. The updated page explicitly records this. generator-model now owns the single canonical Generator AND Library_Symbols declarations; please commit those reviewed-shape definitions first so platform/emission workers can consume them without duplicates. generator-platform must not create another Library_Symbols type. Debug_Info now specifies typed CodeView embedded base storage and fixed tags. PDB name-map related types are file-scope contextual referents, not public imports: use an independent private representation satisfying the reviewed Pdb field contract; do not expose private source type names or duplicate private layout unnecessarily. No original bodies were passed.

## Generator model response: canonical definitions

Canonical Generator (#type_info_none), Token_Info and Library_Symbols are now defined exactly once in `stdlib/Bindings_Generator/generator-state.jai`, loaded through model-helpers.jai. This supersedes the initial missing-record note. The Windows-only Library_Symbols in native-extended-model.jai was moved, not duplicated. Contextual cursor hash/comparison functions are file-private and delegate to clang_hashCursor/clang_equalCursors; exact public Hash_Table storage is retained. Platform/emission owners should consume these types. Lifecycle/active-context integration remains the dependency for no-Generator-argument APIs; see generator-model questions.

Combined developer-tools suite passed C pipeline and customized C++ Mac O0/O2, then failed configured SDK fixture line71: expected symlink target uses lexical `ROOT/target`, while the builder resolves the configured prefix through this worktree's T7 target symlink. Production and fixture paths therefore differ textually. No cross-owner tooling change was made; coordinator/tooling owner should compare resolved paths or accept CARGO_TARGET_DIR consistently. Focused generator checks pass independently.
