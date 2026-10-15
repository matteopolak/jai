# Complete library lint context

Jailint resolves nested modules against the longest configured import directory,
while keeping a loaded file in its actual containing module. A virtual import
wrapper in that directory supplies the correct library source origin without
writing source files or relaxing application import privacy.

Module checking strictly prepares bootstrap exports first. Lazy bootstrap imports
can have required parameters, so an already configured module is checked in its
real instance instead of being imported again with invented defaults. Requested
files, including loads outside the root directory, supply the lint-fact prefixes.
Compiler and IDE errors are retained and reported. Any incomplete check returns
failure, including ordinary non-verbose invocations.

Library-call rules recognize public aliases by exact exported procedure identity
and the explicit generic instance graph. They do not infer identity from a private
implementation directory or equal source spans. Local functions with the same
spelling remain separate. Import path matching uses path components.

These general repairs were reviewed against NEW platform producer code and tested
with original independent privacy, lazy-parameter, CLI failure, alias and shadowing
regressions. The existing rule findings/fixes are unchanged. Their test setup now
allows an explicit JAIC_STDLIB selection, like the compiler. With the independent
library selected, all 28 library/CLI/rule regression cases pass, as does all-target
clippy with warnings denied. The staged runtime's three edited roots and owned
runtime helper/fixtures pass strict checking without incomplete body reports.

```sh
JAIC_STDLIB="$PWD/target/runtime-configuration-candidate/stdlib" CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo test --locked -p jailint --lib --test cleanroom_library_roots --test cli --test rules
CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo clippy --locked -p jailint --all-targets -- -D warnings
```

Strict bootstrap preparation and public alias searches add checking work. A
cached identity graph is a future optimization if profiling warrants it. Other
NEW platform producer features were not all integrated by that scoped repair.
The subsequent [target-aware checking](jailint-targets.md) batch adds real target
selection, per-context manifests and original target source regressions. Actual
native Windows execution and full stdlib runner integration remain separate gates.
