# Independently implemented compiler facades

Public ABI declarations are generated from the reviewed
`docs/specs/stdlib/modules/compiler.md` by
`tools/generate-compiler-records.py`. The emitted declarations live in
`stdlib/Compiler/contract-records.jai`, preserving public type names, member order,
enum backing types/values and defaults. Pure helper algorithms live under
`stdlib/internal/compiler-api`; public aliases retain their parameter names and
defaults. Bootstrap types are imported from the single prelude, not redefined.

## Implemented and exercised

- `Compiler`: optimization presets, common-field copying, allocated integer and
  string literal nodes, source-location/file helpers and operator spellings.
  The documented AST/message/build-option shapes are present except the run-report
  aggregate and its containing performance message, whose reviewed nested record
  shape is incomplete.
- `Code_Visit`: direct child collection, breadth/depth traversal and explicit
  pre/post events through `get_values`. Headers include argument nodes and do not
  descend into bodies. Parent/member/overload backreferences are omitted.
  Traversal skips revisited pointers to terminate on caller-mutated cyclic graphs.
  Private algorithms live under `internal/code-visit`; `Dumb_Value` retains its
  public canonical name in the facade.
- `Program_Print`: byte-preserving quoted string literals, integers, booleans,
  selected aggregate literals, unary/binary expressions, calls, declarations,
  procedure headers/bodies, blocks, returns, casts, simple conditionals/loops and
  selected directives. Unsupported kinds return `false`; float literals and
  compound declarations currently do so. Expression nesting is limited to 512.
  Public `print_procedure_bodies` storage is passed to private algorithms.

Program_Print plugin collection groups typechecked declarations by source filename
and its finish path writes `pp_<basename>.txt` using the public File API, checking
write failure. An original plugin fixture now verifies emitted declaration text
through the independent File/POSIX implementations and removes its test output.
Helpers whose detailed behavior is not established by the
reviewed page remain compatibility questions, not evidence from legacy tests.

## Remaining scope

Workspace creation/destruction, option storage/forwarding, build source addition,
diagnostics/version/import helpers, type-table access and code-node materialization
are now implemented over the Rust bridge. Original metaprograms exercise option
round trips, compiling added source, discarding a workspace, inspecting AST nodes
and reconstructing Code with an explicit scope source. Record materialization
reports missing records/plans and malformed field shapes, and rolls back failed
cache entries instead of returning zeroed successes. Interception now constructs
FILE/IMPORT/TYPECHECKED/PHASE/COMPLETE, failed-import and debug messages from actual
compiler events. Category/note filters apply to typechecked records. Original
fixtures verify completion and an edited procedure whose replacement body is
executed by a later compile-time assertion. Unknown body records are errors.

`add_build_string` supports non-null Code in its running workspace, retaining its
lexical scope. FILE messages select the original file scope (including private
names); IMPORT messages select the module. Scoped text retains known lexical file
provenance for relative loads. Compiler API guards report ordinary compile errors,
and invalid workspace IDs are validated against the Rust registry instead of
creating default records. [Compiler-managed global data](compiler-global-data.md)
now supports copied registrations, validated segment handles, alignment, live
compile-time snapshots and relocated target runtime records. Remaining diagnostic APIs and performance
message ABI are pending. The [independent runtime Jai_Lexer](runtime-jai-lexer.md) is implemented
and passes its token/EOF, edge and malformed-input fixtures in interpreter and
native execution. `Code_Visit.visit_pre_and_postorder` is not exported yet:
its macro caller bindings are unspecified in the reviewed page. It has no fake
implementation; explicit event traversal is available through `get_values`.
See [questions](../specs/stdlib/compiler-questions.md).

## Focused test overlay

Read new independent foundation sources into a test-only overlay in this checkout:

```sh
python3 tools/assemble-cleanroom-test-library.py --foundation /absolute/path/to/new/stdlib
TMPDIR="$PWD/target" python3 tests/stdlib-contract/run.py \
  --jaic "$PWD/target/debug/jaic" --stdlib-root "$PWD/target/cleanroom-test-stdlib" \
  --case compiler-optimization-options --case compiler-records-and-helpers \
  --case code-visit-binary-child-order --case code-visit-orders-and-header-boundary \
  --case program-print-string-escaping --case program-print-nodes-and-unsupported-status
```

`--mode native` compiles and executes the same cases with the source-built LLVM
backend. This overlay does not write another worker's checkout or integrate a
release. All six initial focused cases passed in both the interpreter and native
LLVM execution on 2026-10-14. The two added workspace/code cases also pass in the
interpreter.
