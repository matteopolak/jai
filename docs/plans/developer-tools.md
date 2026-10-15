# Developer tooling implementation plan

The reviewed module pages are the compatibility contract. User authorization to work autonomously overrides interactive skill review gates; no subagents or peer writes are permitted.

## Architecture

Keep canonical reflected records in each public module. Load independently organized implementation files from `stdlib/internal/developer-tools` in that module scope so helpers remain private and public record identities remain stable. Prefer direct reflected C ABI projection for Generate_C_Header and libclang-backed parsing for Bindings_Generator. A handwritten C parser would have unacceptable ABI and preprocessing limits; invoking textual Clang dumps would lose stable structured ownership. Native configuration changes outside owned files need coordinator integration.

## Ordered checkpoints

- [ ] Audit each public signature, overload, default, type shape and target condition into `docs/developer-tools-api.json`.
- [ ] Generate_C_Header: add a failing original reflected-record/header fixture; implement declarators, dependency ordering, procedure projection, diagnostics and output; compile emitted C and compare layout/native calling effects.
- [ ] Bindings_Generator: audit full libclang/native surface and unresolved defaults; implement independent declaration model, parsing, visitors and rendering; test original C headers and generated Jai round trips.
- [ ] Implement Performance_Report and Print_Vars on supported producer reflection APIs; retain measured report semantics and caller code expansion.
- [ ] Implement Rewrite and Check with original source-location/edit safety and diagnostic fixtures.
- [ ] Implement Codex, Iprof, Debug and Debug_Info with original serialized/malformed-data, timer and native debugging fixtures.
- [ ] For each checkpoint run actual source-built jaifmt, `--check`, jailint `-D warnings`, interpreter and native O0/O2 effects, plus applicable cross-target checks. Record source-only and staged evidence separately; commit stable owned paths only.

Unfinished APIs stay absent rather than acquiring fake success bodies. Contract ambiguity goes into precise reviewed-spec questions. Every staged dependency, workaround, performance tradeoff and failed gate is recorded in the worker deviations file.
