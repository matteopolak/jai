# Reassigned generator emission contracts: resolved

The 2026-10-15 16:14 reviewed behavior batch in
`../stdlib/modules/bindings-generator.md` resolves the prior questions for all ten
assigned names, including both alignment/spacing overloads and conditional cursor
names. The implementation follows that review and replaces the provisional
formatting, classification, alignment and root-debug policies.

There are no remaining contract blockers for this assigned scope. The shared
active-options dependency is implemented by the single unparameterized context
owner and coordinated in `../../worker-inbox.md`; tooling/model owners consume
`context.generator_options` and private `gp_current_options()` rather than adding
another slot. Canonical data records are unchanged.

Unspecified edge and ownership choices are documented in
`../../generator-emission.md`. They are independent policies, not new questions
or claims of reference equivalence. Native runtime evidence is Mac only.

## Separate core emission scope

# Generator emission refinements requested

The shared canonical context/options dependency is described in docs/developer-tools-context-protocol.md. Please supply its implementation through the canonical model owner; stateful public emission must consume real supplied options rather than default/mock state.

For raw_tokens_string_from_cursor, is any exact whitespace/comment preservation required, or is lexically equivalent token spelling sufficient? The independent implementation will copy libclang spellings, discard comment tokens and separate every retained token by a space, preserving token boundaries; no original formatting compatibility is claimed. The returned string will be caller-allocator owned and independent of the translation unit.

Please refine get_type_name/type_has_name for scalar hardcoded names, unnamed nominal records, arrays, and conflicting CType category fields; size_from_number_flags for absent/multiple width bits and CHAR-only flags; and try_find_struct_in_type traversal through pointer/array/typedef/enum/declaration categories. Signatures alone do not establish those edge policies. Supported standard-format and represented-model work continues meanwhile.

For append_cpp_wrapper, confirm how existing_declarations is used and how visible parent paths are encoded into one C-linkage symbol. The global-name bridge contract is clear; no invented parent-name escaping or silent ignored custom argument callback is proposed.

maybe_convert_expression_zero_to_null now uses the reviewed limited integer-zero predicate and a pointer/typedef target, excluding reference, float, scalar and nonzero inputs. It allocates a distinct canonical null Literal to avoid corrupting shared source expressions, retaining location/raw spelling; the signature printer uses a temporary declaration and frees this temporary allocation. Is any different public allocation/storage identity required? No historical allocation identity is claimed.

Integration correction: shared current state lives in internal/developer-tools/generator-session; active options remain an opaque actual supplied pointer. The typed normalized protocol is still a proposal, not an implemented public Context field. The ten comment/spacing helper questions and other core emission questions have distinct scope.
