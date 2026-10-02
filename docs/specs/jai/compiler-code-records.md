# Compiler code records and editing

## What it is

The public `Compiler` records are a mutable, user-facing syntax graph used to inspect `Code`, construct changed `Code`, and modify intercepted procedure bodies. This page specifies the reviewed public shape and observable behavior; it does not prescribe the compiler's internal representation or a source-text conversion strategy.

Evidence is the supplied 0.2.030 public `Compiler` declarations, the `630_compiler_get_nodes` lesson, `Preload.For_Flags`, and public `Program_Print` and Iprof usage. Printer support illustrates representable syntax but is not proof that the printer implements every compiler import feature. No reference binary was executed for this review.

## How it works

### Graph conversion and edits

The official public discriminator is `Code_Node.kind`, not a separate `tag` field. A bare `Code_Node` defaults to `.UNINITIALIZED` (`0`), but the `Code_Ident` declaration explicitly overrides its inherited `kind` default to `.IDENT` (`3`). Consequently ordinary default initialization of a `Code_Ident`, including the default initialized form of `Basic.New(Code_Ident)`, produces an identifier discriminator without a caller assignment to `kind`. This promise comes from that record's explicit initializer and ordinary struct-default semantics, not from an assumption that every derived type infers its tag. The same reviewed declarations explicitly initialize the kinds of records such as procedure calls and if nodes.

The distinction matters for a caller that constructs a default-initialized identifier and only assigns `name`: it is already an `.IDENT` node when passed through `*Code_Node`. Requiring an extra explicit discriminator assignment in that case loses declared default behavior. In contrast, a bare base node, uninitialized allocation, raw zeroed memory, an explicit discriminator overwrite, or casting unrelated storage to `*Code_Ident` does not acquire the derived record's initializer merely from its pointer type. The reviewed contract does not require `compiler_get_code` to guess identifier semantics from `name` when the actual discriminator remains `.UNINITIALIZED`.

The completed coordinator declaration audit additionally confirms inherited
discriminator initializers for `Code_Binary_Operator` (`.BINARY_OPERATOR`),
`Code_For` (`.FOR`), and `Code_Procedure_Body` (`.PROCEDURE_BODY`). Along with
`Code_Ident`, `Code_If` and `Code_Procedure_Call`, these initializers are now included
in the member inventory so regeneration preserves them. This list does not infer
defaults for every record from its name. Other explicit default overrides already
present in the reviewed inventory remain authoritative; any further missing
initializer needs declaration review rather than a compiler tag heuristic.

`compiler_get_nodes(code)` returns a root pointer and a flattened array of expressions at all levels. The lesson explicitly promises a fresh user-level AST on every call, allowing destructive edits without modifying another returned copy. Its example changes literal payloads through the flattened array; those edits are visible through the root's existing links.

`compiler_get_code(node, code_to_copy_scope_from = #code,null)` produces `Code` from the supplied graph, including edits reachable from the chosen root. The optional argument is publicly exposed as a scope donor. The reviewed declaration and lesson do not completely settle binding precedence with a null donor, conflicting resolved identifiers, or insertion scopes. They also do not promise source formatting, comments, byte-for-byte spelling, record pointer equality after conversion, or a fixed traversal order in the flattened array.

`compiler_modify_procedure(w, body)` submits a procedure body for the selected workspace. Public Iprof usage replaces `body.block.statements` with a new slice containing newly allocated syntax records and retained original statements. A compatible implementation must accept this mixed graph and preserve the semantics of retained statements while applying the submitted edits. Merely round-tripping an unchanged statement must not change its meaning or make an otherwise supported procedure uneditable.

### Syntax-bearing public fields

The complete member inventory remains in [Compiler](../stdlib/modules/compiler.md). The following fields resolve common ambiguity in editing and reimporting records:

| Construct | Public representation and required distinction |
| --- | --- |
| Floating literal | `Code_Literal.value_type = .NUMBER`; `value_flags.FLOAT` distinguishes its `_float64` union payload from integer payloads. `DEFAULTS_TO_FLOAT64` and `REQUIRES_FLOAT64` are additional public flags. These are not a separate literal kind. Preserve numeric value and applicable type semantics when changing an enclosing statement. Exact decimal spelling is not promised. |
| Integer literal | The same `.NUMBER` variant uses `_s64` or `_u64`, with `MINUS_SIGN`, `HEX`, `BINARY`, and `IS_A_NUMBER` flags. Union alternatives share storage; they are not independent simultaneously meaningful values. |
| Enum definition | `Code_Enum` exposes `internal_type_inst`, `internal_type`, `external_type`, `block`, `notes`, `marked_as_complete`, `marked_as_specified`, and `is_flags`. Member declarations use the block/declaration graph. There is no public enum-member-expression node kind. |
| Enum member expression | Explicit qualification and contextual dot notation are ordinary expression syntax, distinct from an enum definition. Preserve qualification/contextual lookup when reimporting, including a contextual member in a call argument. `Code_Ident` exposes `name`, `resolved_declaration`, and flags including `IS_RHS_OF_DOT_DEREFERENCE`; the reviewed source does not establish one mandatory exported graph shape for every enum-member spelling. Do not invent an enum-member public record. |
| Index expression | `Code_Binary_Operator` with `operator_type = Operator_Type.ARRAY_SUBSCRIPT` (`500`), `left` as the indexed expression, and `right` as the subscript. It means an expression such as `items[slot]`; `[]` is not an infix source operator. There is no public `INDEX` node kind. |
| Range or collection loop | `Code_For.iteration_expression`, optional `iteration_expression_right`, and `block` distinguish collection iteration from a range with two endpoints. Preserve both endpoints and loop body semantics. |
| Loop variables | `ident_it` and `ident_it_index` are syntax identifiers used to create `ident_decl` and `index_decl`; the latter declaration pointers are null until typechecking. Preserve explicit names, identifier flags, and binding roles. |
| Loop modifiers | `want_replacement_for_expansion`, `want_pointer_expression`, `want_reverse_expression`, and `for_flags` are public. `For_Flags` has `POINTER = 0x1`, `REVERSE = 0x2`. `macro_expansion_procedure_call` is explicitly ignored on import. Conditional modifier expressions are representable even though public `Program_Print` marks their printing incomplete. |
| If/switch | `Code_If` exposes `condition`, `then_block`, `else_block`, `if_flags` (`IS_SWITCH_STATEMENT`, `IS_IFX`, `IS_STATIC`, `MARKED_AS_COMPLETE`), `static_if_flags`, and `static_if_accepted_case`. The accepted-case pointer is only set for a typechecked static if. Preserve branch and switch semantics; evaluation metadata is not additional source syntax. |
| Case | `Code_Case` exposes one `condition: *Code_Node`, `then_block`, `owning_if`, and `marked_as_fallthrough`. Public printing treats a null condition as the default case and preserves explicit fallthrough. There is no public `labels` array. |
| Array type | `Code_Type_Instantiation.array_element_type`, `array_dimension`, and `inst_flags` distinguish fixed, view, and resizable types. A null dimension without `RESIZABLE` denotes a view. Preserve the element-type graph and dimension expression; do not substitute a generic untyped placeholder. |
| Pointer/type directive | `pointer_to`, `type_directive_target`, `type_valued_expression`, `must_implement`, and relevant `inst_flags` carry type syntax. `result: *Type_Info` is explicitly export-only and ignored on import. |
| Array literal | `Code_Literal.value_type = .ARRAY` selects `array_literal_info`, whose fields are `element_type`, `alignment`, `array_members`, and `array_literal_flags.WAS_UNTYPED`. This is separate from an array type. |

The public graph also provides `Code_Comma_Separated_Arguments.arguments`, with each element containing `node` and `modifier`. That aggregate's existence alone does not prove it is the exported representation of comma-separated case labels. The reviewed case lesson demonstrates one constant value per case, default cases, and explicit `#through`; it does not settle comma-separated labels or whether several labels can share a body pointer. If additional accepted syntax has several labels, preserving its behavior is a compatibility objective, but its precise exported grouping needs further public evidence or an explicitly authorized behavioral probe. Neither an invented public field nor an asserted grouping rule follows from this review.

### Procedure identity and body ownership

`Code_Procedure_Header.body_or_null` initially may be null. When compilation of that procedure body finishes, the compiler updates the retained header's pointer asynchronously. Public comments explicitly describe retaining headers obtained through messages or call browsing and checking the same header later for its body. Consumers must use synchronization when reading that pointer.

`Code_Procedure_Body` exposes `header`, `block`, and `body_flags.ALREADY_MODIFIED`. That flag reports prior modification/resubmission. Body ownership must track the actual workspace procedure represented by this relationship. A display name is insufficient to distinguish overloaded or unnamed procedures. The public declarations impose no nonempty-name precondition on modification and provide no rule that inline struct-member bodies are ineligible merely because their exported header has an empty name. Once such a body is exported as an editable workspace body, preserving its canonical header/body relationship is necessary for modification to target the correct procedure.

This does not establish universal pointer equality among independently requested AST copies, headers from different workspaces, or all polymorphic instances. The fresh-copy promise applies to `compiler_get_nodes`; retained intercepted headers have the separate body-publication behavior described above.

### Copies and compiler-owned metadata

New records and replacement statement arrays are demonstrated inputs. Public syntax fields must remain authoritative for edits; unchanged input records may retain compiler-owned identity or semantic information. The public contract does not require implementation-private identity fields to become Jai-visible members.

The reviewed evidence does not define arbitrary shallow/deep copying of entire intercepted procedure bodies, transfer to a different workspace, fabrication of a procedure by copying a header, or persistence of hidden metadata when allocating a new record and copying its public fields. It also does not define import precedence for stale resolved links or `serial` values on caller-created copies. These cases must not be presented as established compatibility promises.

A private association with original records is an implementation option, not a prescribed algorithm. It must not erase supported public-field edits or make unchanged retained children invalid. For caller-created records, reconstruct what the public syntax specifies; do not infer that copying a numeric serial transfers procedure ownership. Original source-text passthrough is neither required nor a substitute for applying edits.

## How to change it

Update the [Compiler member inventory](../stdlib/modules/compiler.md) when the public schema changes. Extend this page only with reviewed public declarations, explicit public usage, or authorized observed behavior. Keep unproven import/copy/grouping cases visibly unresolved. A public printer limitation must not silently become a compiler API restriction.

Useful independent contract cases combine an enclosing edit with a retained floating literal, contextual enum member, indexed assignment, named range loop, switch/default/fallthrough, array type, or inline member procedure. Separate those from experiments about arbitrary copied-body ownership and multiple-label grouping, whose exact contracts remain unresolved here.

## Configuration

These contracts are versioned against the supplied 0.2.030 public API. Workspace selection, interception flags, syntax flags, and the optional scope donor affect the operations. There is no public configuration selecting a serialization format or requiring textual source reconstruction.

## Dependencies

`Compiler` supplies the records and compiler-provided operations. `Preload` supplies `Code`, `Workspace`, type descriptors, and `For_Flags`. Compile-time execution and insertion consume generated `Code`; workspace interception supplies procedure bodies. `Program_Print` and Iprof supply public usage evidence, not required internal implementations.
