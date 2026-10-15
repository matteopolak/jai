# Developer tooling implementation plan

The reviewed module pages are the compatibility contract. User authorization to work autonomously overrides interactive skill review gates; no subagents or peer writes are permitted.

## Architecture

Keep canonical reflected records in each public module. Load independently organized implementation files from `stdlib/internal/developer-tools` in that module scope so helpers remain private and public record identities remain stable. Prefer direct reflected C ABI projection for Generate_C_Header and libclang-backed parsing for Bindings_Generator. A handwritten C parser would have unacceptable ABI and preprocessing limits; invoking textual Clang dumps would lose stable structured ownership. Native configuration changes outside owned files need coordinator integration.

## Ordered checkpoints

- [x] Audit each public signature, overload, default, type shape and target condition into `docs/developer-tools-api.json` (1,630 reviewed variants; implementation status is separate from ABI certification).
- [ ] Generate_C_Header: add a failing original reflected-record/header fixture; implement declarators, dependency ordering, procedure projection, diagnostics and output; compile emitted C and compare layout/native calling effects.
- [ ] Bindings_Generator: audit full libclang/native surface and unresolved defaults; implement independent declaration model, parsing, visitors and rendering; test original C headers and generated Jai round trips.
- [ ] Implement Performance_Report and Print_Vars on supported producer reflection APIs; retain measured report semantics and caller code expansion.
- [ ] Implement Rewrite and Check with original source-location/edit safety and diagnostic fixtures.
- [ ] Implement Codex, Iprof, Debug and Debug_Info with original serialized/malformed-data, timer and native debugging fixtures.
- [ ] For each checkpoint run actual source-built jaifmt, `--check`, jailint `-D warnings`, interpreter and native O0/O2 effects, plus applicable cross-target checks. Record source-only and staged evidence separately; commit stable owned paths only.

Unfinished APIs stay absent rather than acquiring fake success bodies. Contract ambiguity goes into precise reviewed-spec questions. Every staged dependency, workaround, performance tradeoff and failed gate is recorded in the worker deviations file.

Current checkpoints provide real supported paths across all ten owned modules; see status for exact limits. Reviewed refinement has been applied to binding constants/defaults/literal conversion and C-header enum/support/procedure projection. Full module scope is still open. Next work is public declaration-tree traversal/mutation and broader C parsing/options, followed by remaining debugger/debug-info, profiler runtime and Codex/checker mechanisms after precise contracts are supplied.

Declaration traversal/mutation, numeric macro grouping, C++ fragments/global bridge workflows, native token/build-system workflows and the broad direct native ABI surface are implemented with separate evidence. Canonical MSF read helpers, DWARF model/interval queries and CodeView string/checksum queries now supplement staged byte parsing. Continue broader C/C++ generation/options and remaining public helpers, then refine debugger/debug-info/profiler/Codex/Check paths as precise contracts arrive. Full completion boxes remain open; source-only native reexports are not counted as direct invocation effects.

## DWARF line decoder dependency

The next debug-format dependency is a real bounded DWARF4 line-program byte decoder, tested through staged owned source with original x86/x64/arm64 C sections and official SDK row oracles. Retain raw encoded directory/file IDs until reviewed public indexing/path conventions are precise. Keep canonical Line_Program_Header identity in Debug_Info. Distinguish this private dependency from public compilation-unit/DIE parsing; do not mark either public parser implemented until it returns the reviewed fully populated records.

## Measured manual profiler core

Automatic instrumentation can now use verified source phases: collect actual body metadata, add a generated setup helper at TYPECHECKED_ALL_WE_CAN, mark its typed header live with compiler_make_procedure_live, and apply statement edits before waiting for final completion. Original O0/O2 children prove this sequence. Preserve a pristine entry body while replacing setup prefixes across additional compilation waves; generated zone storage must be stable before runtime initialization. Implement actual runtime final reporting from measured nodes, without substituting empty create_report/update implementations. This is an implementation route, not completed plugin evidence.

Implement init_runtime, Stack_Push, zone_begin and zone_end using existing canonical POSIX/Windows clock APIs. Retain reviewed zone/node/global types and explicit manual initialization. A private independently designed map keys nodes by zone and parent identity, preserves node pointers through growth and uses persistent default-allocator storage. Bound active nesting by MAX_DEPTH. Verify real elapsed/self/hierarchical ticks, recursion and call counts, node identity across different parents/cache reuse/growth, and explicit unbalanced-depth failures in interpreter/native O0/O2. Keep Windows source checks separate from host execution. Do not expose placeholder update/create_report/instrumentation paths; history calibration/aggregation details and public hash/helper policies remain precise follow-up work.
