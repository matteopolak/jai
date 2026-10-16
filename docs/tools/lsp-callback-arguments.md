# Callback parameter completion from checked callable headers

This batch requires approved compiler metadata 41233d85 through integrated
ba0d992c, including its constant-extraction correction. Do not stack both full
patches. Mandatory cf7dd80/5214e9c identity, c706319d query safety and 6162ba1b
stored-key handoffs remain prerequisites.

## Selection and editing

Compiler::ide_call_target_at uses the existing original-source callee AST capture
and normal check_expr_no_emit. It returns selected direct procedures and, when
present, the checked Operand::Callable's actual declaration-bound header and type.
That annotation comes from the compiler's selected entity/member accessors and
checked value provenance. No headers are reconstructed from tokens, initializer
text, equal structural types or offsets. Existing ide_callee_at retains the
direct-procedure view, transparently unwrapping annotations.

jailsp consumes the bound header for declared locals/parameters, inferred aliases,
struct/pointer/promoted/generic fields and factory results. Names/defaults come
from that header; structural types provide parameter types/variadic shape only.
Missing/inconsistent provenance supplies no invented signature. Private module
members still fail the ordinary resolver. Direct and indirect calls share context,
slot filtering, conservative scalar compatibility, UTF-16 word replacement and
separator handling. Ordinary expression/member completion remains.

Only sema/ide_meta.rs changes in compiler ownership; overlap was recorded before
implementation. Parser and integration/main IDE scanner are unchanged. No strict
CLI grammar, bootstrap, stdlib or Extensions changes.

## Exact owned files

- crates/jaic/src/sema/ide_meta.rs: checked call-target IDE result; original-body
  guard and direct-query compatibility retained.
- crates/jai-language-server/src/named_arguments.rs: bound value signatures and
  shared conservative scalar compatibility.
- crates/jai-language-server/tests/callback_arguments.rs: eight original tests.
- crates/jai-language-server/tests/named_arguments.rs: three historical
  unavailable-state assertions now require the correct selected-header name.
  Equal-shaped no-leak checks remain.
- tools/lsp_named_arguments.py: callback requests, imported/private cases,
  accepted edit, fresh server and UTF-16 receiver changes.
- docs/tools/lsp-callback-arguments.md, docs/README.md,
  docs/tools/lsp-named-arguments.md, docs/tools/lsp-callee-context.md,
  docs/status/lsp-progress.md and docs/status/lsp-deviations.md.

## Checks and preserved failures

Receipts: assigned T7 scratch/callback-parameters-20261016.

- callback-red.log: six initial feature tests fail before implementation.
  native-red.log and transport capture reproduce missing callback completion.
- callback-green-types.log: four pass/two fail. Blank middle slot first=1, ,
  third=true means context override; the named-argument fixture now types se.
  Factory inline named-return parentheses were not its callback-result type;
  an explicit Callback type alias retains the intended result-header test.
  These are test-oracle corrections, not production workarounds.
- callback-corrected-fixtures.log exposed the third historical unsupported-state
  assertion. All eight new fixtures and 11 named tests now pass, covering
  independent equal-shaped fields, declaration vs initializer, aliases,
  defaults/parameters, both-side filtering, grouped/nested/unclosed calls,
  promoted pointers, generics, factories, variadics and erased/unresolved negatives.
- lsp-final.log: 169 LSP tests pass with explicit assigned T7 TMPDIR.
- compiler-final.log: 165 compiler units pass (nested subprocess results excluded).
  Additional metadata dependency gate is NOT green: 15/17 pass; two fail below.
- clippy-final.log: warnings-denied compiler/LSP library, jailsp and tests pass.
  Scoped rustfmt and Python syntax pass. Intentionally incomplete embedded
  protocol documents are not jaifmt/jailint formatting evidence.
- native-green/: 34 phases/two fresh servers/54 feature requests (40 completion,
  seven hover, seven definition). Production Basic, callback accepted edits,
  imported/private signatures, nested/grouped/generic/promoted/factory cases,
  UTF-16 receiver changes after non-BMP text and fresh-server restoration pass.
- uri-alias-final/: four phases/two servers/40 requests pass again.
  uri-reserved-final/: four phases/two servers/24 requests pass again.
  Same-binary total: 42 phases/six servers/118 native macOS feature requests.
  No Jai exit program was executed.

Effective source/test fingerprint:
d7c99eb9d2cec9da1312395389f5cda5006c05112e55cb9ca42394272e7a844c.
Source-built jailsp SHA-256:
5aec4cf850bde120452d59f884943eea6e070d6308d7d75456c68c0eb6d98eba.
final-source-hashes.json records staged sources. Authorized visible clean
dependencies were patched narrowly with mandatory owned prerequisites and the
exact SHA-verified ba0d992c; independent auto-import producer changes remain.

## Open compiler dependency and merged verification

This patched capture is NOT proof of exact merged shared 0152853c. Its existing
structs.rs::struct_arg_value directly matches an annotated constant procedure;
the exported ba0d992c correction unwraps const_value_of_operand. Two valid tests
fail with expected a constant, found constant proc... :
procedure_constant_from_run_binds_typed_struct_argument_without_losing_identity;
same_shaped_field_declarations_keep_names_defaults_and_alias_provenance.
No assertion was skipped, rewritten or counted as passing. Compiler/coordinator
must transport exact shared sources/hashes into the owned namespace or supply a
reviewed general transparent-annotation extraction prerequisite.

Original minimal reduction:

~~~jai
Callback :: (enabled: bool) -> bool;
echo :: (enabled: bool) -> bool { return enabled; }
factory :: () -> Callback { return echo; }
Container :: struct(handler: Callback) { storage: int; }
Chosen :: Container(#run factory());
main :: () {}
~~~

Compiler production logic outside the owned IDE query is unchanged here.
Final merged callback/URI acceptance requires that prerequisite, focused/native
reruns on exact shared sources, actual native Windows requests and full corpus.
The separate root compiler gate can proceed without waiting for unrelated audit.

Genuinely erased headers (computed type values/array element types without
selected provenance) remain unavailable. A negative test prevents borrowing an
equal-shaped field's names. Operand-sensitive incomplete conversions remain
conservative; no complete inference or benchmark claim. No remote/release action.

The later coordinator receipt explicitly authorizes frozen-0152853c read-only
source access. This process still receives Operation not permitted for its
structs.rs, ide_meta.rs and LSP session.rs. No alternate access is attempted.
Exact source/hash transport into owned T7 current-0152853c-input is requested
in the progress file; the next-resume sandbox exception does not apply here.

The complete valid named-argument callback case was also rerun after adding an
assertion that the declared header wins over the initializer even when the call
already typechecks. callback-complete-named.log passes all eight callback tests;
clippy-complete-call.log passes the same warnings-denied scope. The failing
compiler dependency helper does not enable IDE mode, so those constant-binding
failures cannot be attributed to the owned IDE-only query.
