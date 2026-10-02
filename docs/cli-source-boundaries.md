# CLI source boundaries

## What it is

The CLI distinguishes syntax, pure semantic checks, compiler-recipe execution, artifact production, and separately measured runtime behavior. Compiler-owned source values and unresolved source demands must preserve that distinction instead of fabricating native storage or an application entry.

## How it works

| Command | Source effects and entry policy | Successful outcome |
| --- | --- | --- |
| `lex` / `parse` | Tokenization or syntax only | Counts for that stage |
| `check` | One retained session with compiler effects disabled; root application entry required | Checked application |
| `check-library` | Same pure policy; no application entry required | Checked library |
| `emit-llvm` / `emit-object` / `build` | Real compiler session and bounded workspace scheduler; typed output and source entry policy | Requested artifacts, or explicitly disabled/retired output |

The CLI has no `run` command. Runtime acceptance belongs to a harness that verifies the exact freshly built artifact and its declared behavior. Success of `NO_OUTPUT` work or a fully retired recipe produces no artifact; it cannot satisfy a report's successful build/run artifact contract. A recipe root may create a child application without its own `main`. Entry selection follows the root namespace's actual checked binding. Awaiting child inputs, an executable child without an entry, or an unresolved source demand yields failure instead of an empty success. Errors returned from the CLI produce exit code one; compiler crashes remain separate harness failures.

External globals preserve source declarations, canonical library identity, and the real linkage symbol. Unused declarations require no fabricated initializer. A compile-time read, write, or address request without a checked provider reports `has no checked compile-time data provider` at the originating `#run`. Native external-data linkage and export collisions are covered by the authored CLI fixtures in `foreign_libraries`; the reviewed VMA boundary separately rejects reached data with `reachable external data is outside the reviewed VMA virtual ABI`. The newly added external source fixtures require the coordinated integration gate before they establish CLI acceptance.

Captured `Code` remains source syntax in a compiler sidecar. Its unavailable names can stay deferred until insertion; it does not acquire a runtime cell or native procedure signature. Existing source-level quotation consumers are distinct from the staged executable Code-result query domain, which requires a retained VM plan/frame and real declaration insertion. Neither catalog reflection of a CODE descriptor nor parsing a Code return type establishes that query domain's production execution.

The frozen historical compiler `a19b48087e7a534920264dd670fc4bcb9e535831c574c4ae1f7d0871df592b6f` checks the authored deferred quote successfully. Its three authored invalid Code uses fail at their actual use sites with exit code one: runtime storage reports `IR value has no runtime representation`, null insertion reports `#code,null has no body or scope`, and statement-as-expression insertion reports `expression insertion requires exactly one quoted expression`. The same failed `emit-llvm` commands preserve existing output. Local evidence is `artifacts/cli-code-boundaries-a19b4808.json`. The four Rust CLI regressions in `source_boundaries.rs` are queued for the current integration gate; this historical observation does not establish the pending Code-result query domain or acceptance of the current edited compiler.

Source placeholders reserve a name, without a guessed type, global, procedure, or value. Their static and generated fillers must eventually supply real declarations. The fixtures under `tests/fixtures/source-boundaries` retain both ordinary body demand and early generated record/global/header demands. Those generated positive cases require real scheduler fulfillment; rejection is not their expected result. The production placeholder dispatch/preparation gate is still pending at this checkpoint. Its intended unmet-demand diagnostic is `unfilled #placeholder 'ANSWER' cannot supply this declaration`, with the original marker as a related source location.

`get_runtime_info` requires a certified, workspace-owned type-table checkpoint. Source schema and VM storage proofs are implemented; production source-frontier publication remains pending. A missing target layout or incomplete nominal definition retains the actual reflection dependency. An unavailable snapshot cannot become an empty successful table. Native `__runtime_info` data needs its genuine generated-table binding, independently of the compile-time null global-data-info contract.

## How to change it

Keep command policy in `source_check.rs` and `workspace_build`, entry selection in `jai-sema::select_entry`, and typed readiness in the source scheduler. Add a precise authored CLI regression only after all producer and consumer adapters are active. Verify ordinary failure exit code one, original source locations, and preservation of existing output; match the specific failing trust/readiness stage instead of any generic rejection.

The boundary fixture directory contains no supplied original source. Deferred quotes, runtime Code storage, null/statement insertion, static/generated placeholders, and Code-result declaration insertion have distinct files. Pending producer fixtures are prepared inputs, not passing tests. Keep their status explicit when adding them to an acceptance manifest or CLI test. See [source placeholders](source-placeholders.md), [reflection and Code values](reflection-and-code-values.md), [source external data](source-external-data.md), and [compiler runtime information](compiler-runtime-info.md) for their source contracts.

## Configuration

Source module/bootstrap and target choices use the existing [workspace artifact configuration](workspace-artifacts.md). Standalone authored fixtures use the compiler's existing standalone mode. They do not substitute an authored minimal schema for actual source Preload acceptance. Compiler effects stay disabled for pure checks; artifact commands use the same actual session throughout discovery and resolution. No setting grants access to original native inputs.

## Dependencies

The CLI's source configuration, semantic discovery/session adapters, workspace scheduler, checked IR, source diagnostic payloads, and native artifact planner. [Source-free corpus stage reports](corpus-stage-reports.md) preserve measured stage and negative-fixture evidence without executing these fixtures.
