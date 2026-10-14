# Owned compiler facade formatting

The formatter was built from repository sources using the new independent
foundation/bindings overlay under target/cleanroom-test-stdlib. No reference or
quarantined library source was used. The prior Basic builder-print blocker is
resolved by the independent foundation. A speculative-context initialization
fault found during this build was fixed generally and has an original regression.

Commands executed with LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm,
CARGO_TARGET_DIR=target, RUSTC_WRAPPER= and JAIC_STDLIB pointing to that overlay:

```sh
cargo build --locked -p jaic-cli --bin jaic
target/debug/jaic jaifmt/main.jai -O2 -exe target/jaifmt
cargo build --locked -p jailint
compiler_owned_jai=(stdlib/Compiler stdlib/Jai_Lexer stdlib/Code_Visit stdlib/Program_Print
  stdlib/internal/compiler-api stdlib/internal/jai-lexer stdlib/internal/code-visit
  stdlib/internal/program-print tests/stdlib-contract/compiler-context
  tests/stdlib-contract/generic-default-reflection tests/stdlib-contract/bootstrap-atomics
  tests/stdlib-contract/compiler-performance)
python3 tools/dev.py fmt --check --lang jai "${compiler_owned_jai[@]}"
python3 tools/dev.py lint --lang jai "${compiler_owned_jai[@]}"
```

The scoped paths are stdlib/Compiler, stdlib/Jai_Lexer, stdlib/Code_Visit,
stdlib/Program_Print, stdlib/internal/compiler-api, stdlib/internal/jai-lexer,
stdlib/internal/code-visit, stdlib/internal/program-print, and the new contract
fixtures compiler-context, generic-default-reflection, bootstrap-atomics and
compiler-performance. Repository config applies. Owned files were formatted;
jaifmt --check and jailint -D warnings pass. Extensions was not modified.

tools/generate-compiler-records.py now normalizes both generated outputs through
the source-built target/jaifmt before writing them. Regeneration preserves their
hashes and the generated files pass formatter checks. Declaration grouping is
independent; member layouts/enum values remain reviewed ABI order.

Modified Rust files pass scoped rustfmt plus rust_item_spacing checks. Core,
LLVM, LSP and browser crates pass clippy with warnings denied. Original Rust
test harnesses embed Jai/C/JS programs; their raw strings are not standalone
Jai formatting inputs. Real-prelude standalone Jai fixtures provide separate
formatted/linted coverage. The overlay is test staging, not production integration.

Actual wasm32 verification also passes: cargo check --locked -p jai-wasm --target wasm32-unknown-unknown and cargo clippy --locked -p jai-wasm --target wasm32-unknown-unknown --lib -- -D warnings. Native-only fiber state is gated at its real host capability; no lint rule or assertion was disabled.
