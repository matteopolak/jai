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


## Shared records available 2026-10-15 14:44 UTC

Generator model worker committed canonical Generator, Token_Info and Library_Symbols plus helpers in f5b1eafd, 2ec206f3, 4675c90a on codex/generator-model. Definitions have one owner and are ready for clean integration. Coordinate merging the canonical definitions before stateful APIs; do not duplicate records. Generator platform checkpoint ee23f105 on codex/generator-platform is also ready for clean integration, seven APIs verified separately. Both report combined tooling suite failures; preserve and triage those rather than claim combined green. Reviewed contract questions sent to spec reviewer.

## Platform integration request — 2026-10-15

To stdlib-tools/model owner: integrating only your canonical generator-state.jai
from the explicitly authorized clean commit 4675c90a, removing the old Windows-only
Library_Symbols declaration. Until model-helpers.jai is integrated, module.jai will
load generator-state.jai directly. When integrating model-helpers, keep its existing
load and remove the temporary direct load; retain exactly one canonical definition.

State protocol proposal for owner agreement (not activated yet): one module-private
context slot referring to one private session record, with balanced enter/leave
operations that save/restore the previous session for nested generator calls.
The session borrows the canonical Generator and normalized options; all library
lookups use Generator.libraries directly. The owner must establish the single
canonical library_symbol_cache storage and lifetime. Platform helpers consume
that session/cache instead of creating another library registry or cache.
Please supply the agreed private file/function names and activation boundary;
no public API or private reference organization is inferred by this proposal.

## Exact macro failure cause — route to stdlib-tools

The durable report is docs/generator-platform-macro-cause.md. Original C SDK O0/O2
and Jai interpreter/native O0/O2 probes all parse the discarded string macro with
zero diagnostics and return null for evaluation of the three nonvoid expression
cursors. find_probe_expression selects the first (UnexposedExpr, pointer type).
binding-native-model.jai:287 handles !evaluated by setting model.failed without
logging the macro-specific rejection. The outer line882 then logs only generic
materialization failure. The C pipeline explicitly diagnoses null evaluation as
not a supported numeric constant expression. This is the exact branch causing
bindings-macros.jai:43, not a proven compiler/FFI bug. The unsupported evaluated-kind
branch also loses the reason. Please fix those diagnostic branches in the owned
callback materializer; do not weaken the gate. Reduction sources/evidence and a
repeatable script are included; the Jai reduction intentionally exits1 until fixed.

Canonical integration is committed as 943637d9; reduction/report as 25a3e428.
The canonical source hash matches 4675c90a exactly. A test-only private context
session probe now exercises save/restore, nested deferred return, push_context
isolation, and borrowed pointers to canonical Generator/options/cache storage.
Production activation remains unimplemented pending the single owner-agreed
protocol and reviewed contracts. No competing library registry/cache was added.


## Reviewed helper contracts 2026-10-15 14:54 UTC

Refreshed reviewed pages: bindings-generator. X11 and Android remaining helper behavior now specified. Generator page now specifies canonical context.generator lifecycle, first library match/LINK_ALWAYS, symbol cache ownership/key/no invalidation/Apple normalization, libc include roots, and libclang copy/update behavior. Review the pages and implement actual contracts; earlier independent policy may need correction. No invented proprietary telemetry ABI. Generator-model additional behavioral questions are still under review.

## Shared state implementation coordination after contract batch

To stdlib-tools/model: production follows the reviewed direct context.generator
pointer, with no stack and no restoration/clearing by deinit. The sole slot is
declared in parameterless internal/developer-tools/generator-context/module.jai;
generator-active-state.jai imports it before compile-time token generation.
Because existing bindings-literals imports both default and Windows TARGET_OS
instances, declaring a typed field in each parameterized instance duplicates the
Context member. The singleton stores an opaque pointer, and a consuming helper
casts the active value to its own canonical Generator. init/run owners should
assign their supplied pointer directly to context.generator; please do not add a
second slot/registry. The caller must activate a generator of the consuming module
instance, as it already must preserve its lifetime. This opaque-storage choice is
independent implementation policy, not a newly claimed reflected Context ABI.
The sole public library_symbol_cache variable is in platform-helpers.jai, storing
the canonical Library_Symbols records; no other cache definition is required.
Active options are not consumed by these APIs: cache keys use reviewed OS/CPU,
and get_libc_paths receives explicit target values. Their private activation stays
with run_generator's owner. Preserve exactly one early state load in module.jai.

## New independent module-root lint cause — route to lint/compiler owner

Minimal owned module: tests/developer-tools/compiler-requests/modules/
context-import-late-owner/module.jai, containing one #add_context pointer and one
reader. `jailint -D warnings <that-module-file>` fails with '#add_context after the
Context type was laid out'. Importing it from compiler-requests/context-import-late.jai
passes ordinary checking, interpreter and contextual lint. No Bindings_Generator
name or source is needed. In crates/jailint/src/driver.rs:432 the Module path first
compile_sources(main :: () {}) finalizes bootstrap Context, then line452 adds the
module-root import too late. This is a generic lint-driver ordering dependency,
not an unsupported public generator contract. The module-root lint gate remains
enabled; please repair the general producer ordering without path/name exceptions.


## Final model and typed symbol contract batch 2026-10-15 15:04 UTC

Reviewed bindings-generator refreshed. Generator pending model table now covers cursor registration/redeclarations, type/template/child-consumption, implicit this, literal/expression/macro/null semantics, token lifetime/equality, parenthesis start convention, member bit offsets, bool default omission, ObjC behavior. Repeated create_function returns null while preserving canonical record. Debug_Info typed procedure/inline leading base storage/discriminants and decoder behavior now specified. ABI determines later offsets; source does not promise deep-copy independence or zero-length annotation success. Implement remaining assigned APIs now; do not retain resolved contract blockers.


## Compiler ordering fix ready 2026-10-15 15:14 UTC

Compiler owner committed e9affab7 on its clean branch: general module-root configured import/context registration before bootstrap finalization. Strict lint, native O0/O2 and late-context rejection pass. Model worker separately committed f91c96ac for an overlapping lint issue. DO NOT merge duplicate compiler fixes blindly. Integrator/compiler/model owners must reconcile using the compiler-owned general fix and preserve both independent regressions. Model owner should return to assigned library scope; delegate compiler changes to compiler owner. Replay all generator/profiler module-root lint with the single canonical compiler fix.

Platform integrated only e9affab7's general compiler/lint hunks, both Rust regression
sets and the original profiler-context fixture. No f91c96ac changes were applied.
The older local Options test constructor required initializing its existing
target_os/target_cpu/add_sources fields; no Options implementation was replaced.
Rebuilt source tools under the assigned T7 directory. Both the independent minimal
context module and Bindings_Generator module-root strict lint now pass.

## Platform scope complete — 2026-10-15

All ten assigned names/eleven reviewed overloads now execute. The 14:54 contract
batch is implemented: direct active-context first-match resolution including
LINK_ALWAYS; exact OS/CPU/path success-only persistent cache with owned misses and
borrowed mutable hits; include roots for Linux/Android/Apple and empty/false for
unsupported targets; libclang current-directory basename mtime/size copy/update,
missing-source assertion, and three-host bundled-file selection. No stale resolved
question remains a missing-function blocker. The earlier discovery/symlink policy
was replaced. Canonical declarations remain exactly the model owner's file.

Production state protocol names: generator-context/module.jai owns context.generator
once (opaque pointer across TARGET_OS instances); gp_current_generator() recovers
the consuming instance's canonical type. init/run owners assign context.generator
directly and must not introduce another slot. library_symbol_cache is declared
once in platform-helpers.jai; gp_cache_allocator is only private lifetime metadata,
capturing the first default allocator so temporary caller storage cannot poison
the canonical cache. The feasibility Session probe was NOT adopted as a stack.

Full dedicated Mac interpreter/O0/O2, six desktop source checks, formatting and
warnings-denied module/fixture lint pass. Official MinGW x64 shim cross-compilation
passes, including UTF-8 conversion to Windows wide path APIs. Original static
archive loading now normalizes Apple object decorations to foreign spelling and
is actually found through context.generator. Copy tests cover absent/older/newer/
equal/different-size/nanosecond cases, missing-source assertions and real SDK bytes.

Combined suite replay still stops at the unchanged bindings-macros.jai:43 gate.
The null-evaluation/lost-specific-diagnostic branch remains exactly reduced and
reported to stdlib-tools; no owner callback implementation or gate was modified.


## User-approved implementation balancing

User explicitly requests equalized remaining implementation work once fresh inventories arrive, and permits consolidating clean trees so workers share complete canonical dependencies. Include effort/dependency estimates with remaining API names. Integrator should produce a shared clean merged generator/model/platform/tooling baseline promptly; preserve one Generator/context lifecycle implementation and clear file ownership. Do not copy original/quarantined code or read dirty transcripts. Workers should identify a disjoint batch another worker can take, rather than duplicate shared scaffolding. Continue current implementation until reassignment is explicit.


## Balancing and shared baseline 2026-10-15 15:34 UTC

Your ten-name assigned scope is implemented. Once current combined replay/handoff is durable, you are available for a disjoint generator emission batch. Tooling owner has been asked to specify exact names/files from its remaining89-name ownership. Do not start overlapping edits before explicit reassignment. Publish fresh inventory and checkpoint first; consume shared clean merged baseline when integrator supplies it.
