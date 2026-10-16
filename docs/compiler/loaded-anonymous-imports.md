# Anonymous imports in loaded files

Reviewed independent controls establish that a top-level anonymous `#import`
after `#scope_file` in a loaded file is visible to its loading file. The same
control with a named import alias or an ordinary file-private constant remains
private. Without the import, dependency names remain unknown. The coordinator
ran the official Jai 0.2.030 controls; this worker read filtered observations
and safe foundations-authored test inputs, never reference code or executables.

The old compiler placed every top-level import in the active declaration scope.
That made the anonymous import accessible only from the loaded file. The fix
attaches anonymous imports declared directly in module scope to the containing
module's import environment. It retains the original file context for relative
source paths and module parameters, and keeps filters and existing export rules.
Named imports, ordinary declarations and contextual/body imports use their
existing paths. No File exports, Basic aliases or application exceptions change.

The change is confined to the anonymous branch of `declare_stmt` in
`crates/jaic/src/sema/modules.rs`. The old anonymous-private-load negative in
`cleanroom_modules` contradicted the reviewed control; it now tests a named
private import instead. Both the separate new tests and the full existing
module suite check that named declaration privacy remains enforced.

Safe independent foundations controls are copied into
`tests/producer-requests/import-scope/`. They verify actual File path resolution
in the interpreter, compile-time argument selection (`-check - test`), actual
native O0/O2 executables, both named private aliases and a private constant.
An additional missing-import negative verifies Basic alone supplies no File API.
Core virtual-file tests use unrelated module/type names, retain relative paths
and private import-parameter evaluation, preserve filters and reject unintended
re-export through a separately imported module.

Before the fix the core anonymous-load positive failed with unknown `answer`;
named/private/absent-import controls already passed. Afterward the focused
controls pass. Source tools and all native/test scratch files use the assigned
compiler-plugin-evaluation T7 namespace. No supplied reference binaries run.

Validation: 261 core/selected compiler tests pass (including eight new scope
controls and 52 existing module tests), plus three focused CLI tests covering
interpreter, compile-time, privacy negatives and native O0/O2. Warnings-denied
clippy covers all targets of jaic, jaic-cli and jailint. Source-built Jai format,
Rust format and strict lint of both explicit positive contexts pass. Negative
fixtures intentionally fail compilation and are not reported as lint-clean;
automatic lint context discovery also finds those negative consumers.

Focused commands (with CARGO_TARGET_DIR on T7 and CARGO_BUILD_JOBS=2):

```sh
cargo test --locked -j 2 -p jaic --test cleanroom_loaded_import_scope --test cleanroom_modules
cargo test --locked -j 2 -p jaic-cli --test cleanroom_loaded_import_scope
jailint -D warnings --context tests/producer-requests/import-scope/anonymous-load.jai tests/producer-requests/import-scope/anonymous-load.jai tests/producer-requests/import-scope/anonymous-file.jai
jailint -D warnings --context tests/producer-requests/import-scope/anonymous-compile-time.jai tests/producer-requests/import-scope/anonymous-compile-time.jai tests/producer-requests/import-scope/anonymous-file.jai
```

The full Uniform 146-case oracle and combined 400-case gate remain coordinator
tasks. This repair does not certify those applications or change source path
rules in Minimal. Conditional/generated/contextual imports are explicitly
outside the newly established plain top-level import boundary; see
[open scope questions](../specs/questions/loaded-import-scope.md).
