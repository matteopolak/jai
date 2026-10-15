# Generator platform ownership and integration

2026-10-15: generator-platform owns only the ten names in implementation-scope.json.
New public helper: stdlib/Bindings_Generator/platform-helpers.jai.
New private internals: stdlib/internal/developer-tools/generator-platform.jai.
Tooling owner: preserve exactly one `#load "platform-helpers.jai";` in module.jai;
this isolated checkpoint adds that line for execution tests.
No canonical Generator, context slot, Library_Symbols or library_symbol_cache will
be created by this worker. Questions: specs/questions/generator-platform.md.
No agent_message tool is exposed; this file is the local coordinator notification.

Shared runner integration: tools/check_developer_tools.py imports and runs
check_generator_platform immediately after the existing source-built binding
setup. The dedicated runner builds only this worker's native helper and original
fixtures. Preserve this single call when combining tooling-owner edits.

Combined Mac run on 2026-10-15 stopped at bindings-macros.jai:43 after binding,
platform, custom C++, configured SDK, Debug lifecycle, native ABI and profiler SDK
stages passed. The identical assertion failure reproduces with platform-helpers
#load removed, then restored. Original reduced public-API probe retained locally
at target/generator-platform-macro-diagnostic.jai: string macro + visitor logs
`Bindings_Generator: callback model materialization failed`, while the existing
fixture expects `not a supported numeric constant expression`. generate_bindings
returns false and preserves the destination. Tooling owner must route/fix the
diagnostic/materialization dependency; this worker has not edited those names.

Inventory integration: tools/audit_developer_tools.py now recognizes the seven
implemented assigned names with their documented policy/effect limits and links
the three remaining names to exact generator-platform questions. Updated only
the eight assigned inventory statuses and derived remaining matrix; unrelated
stale inventory metadata was preserved for the tooling owner to reconcile.


## Shared public type review complete
Reviewed bindings-generator.md confirms Generator and Library_Symbols are importer-visible, with their full public fields already inventoried; Generator also requires #type_info_none. The updated page explicitly records this. generator-model now owns the single canonical Generator AND Library_Symbols declarations; please commit those reviewed-shape definitions first so platform/emission workers can consume them without duplicates. generator-platform must not create another Library_Symbols type. Debug_Info now specifies typed CodeView embedded base storage and fixed tags. PDB name-map related types are file-scope contextual referents, not public imports: use an independent private representation satisfying the reviewed Pdb field contract; do not expose private source type names or duplicate private layout unnecessarily. No original bodies were passed.
