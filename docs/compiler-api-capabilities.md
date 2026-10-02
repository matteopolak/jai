# Compiler API capabilities

The Compiler source catalog distinguishes checked API declarations from the
services needed to execute them. A declaration name, `#compiler` tag, or matching
pointer type alone cannot grant AST, workspace, reflection, or native authority.

## How it works

`artifacts/compiler-api-contracts.json` records the statically inspected Compiler
source hash, declaration lines, explicit tags, and implementation classification.
It retains header hashes rather than copying source bodies. The current inventory
contains 36 declarations: 13 active bindings, one active RuntimeInfo binding whose
source provider is pending, and 22 private contracts. Active bindings still have
the subsets and limitations documented in
[source compiler intrinsics](source-compiler-intrinsics.md).

The private `pending_capabilities.rs` inventory parses each remaining tag once
into an enum and records source argument order, defaults, results, and required
capability. It is not registered in the production binder. Unknown tags retain
the existing located declaration error; known private contracts do not currently
gain execution capability through this inventory.

| Source operation | Required proof or service |
| --- | --- |
| `compiler_get_nodes`, `compiler_get_code`, `get_root_type` | Immutable checked Code/node snapshot, canonical scope ownership, and a compiler-only source call domain |
| `compiler_modify_procedure`, `compiler_make_procedure_live` | Checked procedure body/header ownership and real semantic mutation or liveness scheduling |
| `compiler_get_struct_location`, `get_type` | Actual workspace-owned descriptor identity and retained defining source |
| `compiler_set_type_info_flags` | A same-registry atomic reflection transaction, committed with source effects and descriptor revision handling |
| `add_build_string_scoped_by_message` | A genuine message receipt identifying a live file/module scope in the target workspace |
| `remap_import`, `provide_import` | Graph discovery/import jobs with checked module and failed-import identities |
| `compiler_custom_link_command_is_complete` | Completion of an actual selected link job |
| `add_global_data`, `add_data_segment` | Real target data-segment publication and layout receipts |
| Unresolved/untyped diagnostic APIs | Actual pending declaration/identifier jobs and source notes |
| Search paths, during-compile options, command line, base path | Typed configured session state with real downstream consumers |
| Memory/developer debug APIs | An explicitly implemented debugger service |

Compile-only `Code` parameters and results stay in source metadata. They cannot
be inserted into a runtime `ProcedureType`, converted to an invented pointer,
or replaced by a successful unit result. The scoped-string overload keeps its
explicit tag and four source slots: string, workspace, message, caller location.
The ordinary Code-scoped overload has a distinct contract.

Admission and use are separate steps. Future admission must prove the selected
module identity and exact canonical signature/schema. Execution must then
receive a checked capability, return its genuine readiness dependency, or report
a located unsupported-use diagnostic. A provider must not manufacture bodies,
AST rows, callbacks, successful link completion, or data-segment storage.

## How to change it

Add a typed enum contract and independently authored argument/result tests before
widening the active catalog. Coordinate source headers, compiler-only slots,
provider dispatch, transactional source/driver state, and native fallback bodies
as one change. Remove a private classification only after actual source execution
and required downstream behavior have been verified.

A private VM `compiler_get_type.rs` reader is also staged. It checks the actual
canonical header schema, prepares pointer layout under fuel, and reverses only a
registered immutable descriptor identity. Nulls, matching header bytes without a
descriptor receipt, foreign arenas, and exhausted fuel must fail. Its five VM
fixtures await coordinated registration; no production `get_type` support is
claimed by this helper.

The staged contract tests cover Code source slots/results, explicit overload tags,
source order/caller-location defaults, unknown names, and link completion authority.
They can run in an isolated own-source `rustc --test` wrapper; they do not verify
production declaration admission or host execution.

## Configuration

Selected graph module/bootstrap identities authorize the source binding catalog.
The target, workspace, source checkpoint, and actual session services determine
capability availability. This inventory adds no permissive configuration or host
execution authority.

## Dependencies

The active binder relies on syntax metadata, canonical type/schema proofs, the
checked VM, source readiness scheduling, CompilerSession, and native job receipts.
The private inventory uses only Rust metadata and adds no external dependency.
