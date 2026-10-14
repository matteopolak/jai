# Public alias signature documentation

The NEW compiler producer's unchanged `jai-language-server/tests/auto_import.rs`
now passes the Basic/Math logging ranking test against production Basic and NEW
numerics Math. No library/test substitute was used. The full test file passes
12/13; `offers_stdlib_names_with_the_import` fails because the Basic `print`
candidate's documentation lacks `print :: (`. Basic correctly exports the
canonical `print :: Impl.print` overload alias; replacing it with wrappers to
satisfy a textual indexing test would damage callable identity and signatures.

Original general reproducer (no module-name dependence):

- `tests/portable-stdlib/pending/alias-signature-facade/module.jai` exports
  `measure :: Impl.measure` from another independently written module.
- `alias-signature-helper/module.jai` defines `(count: int = 7) -> int` and
  `(text: string) -> int` overloads.
- `alias-signature-probe.jai` tests both overloads, named arguments and defaults.

For completion, put the helper/facade folders under a project's `modules/` and
open `main :: () { meas }` with the cursor following `meas`. The auto-import
candidate should expose both callable signatures (with the public alias name),
their parameter names/defaults and the ordinary facade import edit. Current
token-only indexing retains the alias expression instead of a callable header.
Proper fix: reusable alias/overload signature resolution across module imports
and loads, retaining visibility/cycle guards; no Basic/path/symbol special case.
Compiler/LSP ownership should implement and test that mechanism. No Rust or peer
checkout is changed here, and the failing assertion remains unchanged.

The probe passes interpreter, native O0/O2 and production WASI O0/O2 execution
with `ok` output and empty stderr. All three original Jai files pass unchanged
repository jaifmt --check and source-built jailint -D warnings. These execution
passes establish overload/default behavior, not a successful documentation test.

Staging initially lacked Math and had older LSP source; its ranking test found
one candidate. Refreshing NEW producer Rust and copying NEW numerics Math plus
its own private math sources read-only resolved that staging dependency. This
is not counted as a production integration repair; production core APIs supply
the new Basic.log export, and the unchanged ranking test now passes locally.

Commands (own durable staging, source-built tools):

```sh
CARGO_TARGET_DIR=$PWD/target/peer-compiler cargo test --offline --manifest-path target/foundation-integration/Cargo.toml -p jai-language-server --test auto_import ranks_after_names_in_scope_and_common_modules_first -- --exact
CARGO_TARGET_DIR=$PWD/target/peer-compiler cargo test --offline --manifest-path target/foundation-integration/Cargo.toml -p jai-language-server --test auto_import
JAIC_STDLIB=$PWD/target/foundation-integration/stdlib target/peer-compiler/debug/jaic -interp -I tests/portable-stdlib/pending tests/portable-stdlib/pending/alias-signature-probe.jai
```
