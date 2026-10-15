# Enum dependency resolution

The original producer reduction declares `MASK :: FIRST | LAST` before
`LAST :: 4`. Its expectation follows the reviewed Socket inventory and explicit
enum-expression contract. The sequential evaluator rejected `LAST` as unknown.
Original failure evidence remains locally in `target/forward-enum-original-red.log`
and `target/enum-dependencies-red.log`.

`sema/enums.rs` separates declaration collection from value evaluation. Each
active lexical list first registers its direct members as lazy entities. Explicit
expressions use the ordinary constant evaluator and entity dependency states,
including qualified and contextual member lookup. Implicit members depend on the
immediately preceding selected declaration, regardless of value evaluation order.
Normal numbering increments; flags numbering doubles the preceding value,
restarting at one after zero. Explicit composite/alias values preserve the
existing sequencing behavior.

Selected conditional branches and generated insert lists contribute in source
order. Inactive names neither collide nor enter the namespace. The ordered entity
list supplies reflection names/values; evaluating a later member first does not
move it. The self-type binding is private to the expression scope and is not an
enum member. In-progress scopes are removed on success and failure. Namespace
duplicate checks replace quadratic scans; values use ordinary entity caching.
No placeholder values, public API changes or module-name exceptions are involved.

Cycles retain the ordinary circular-dependency diagnostic. Unknown names,
nonconstant expressions, duplicates and backing-type range failures remain
errors. IDE facts preserve declaration spans and constant classification. The
minimal IDE edits only handle the new entity variant, without recovery/cache
changes owned by integration.

## Structural dependency boundary

Conditions and insert expressions can use direct forward explicit values and
implicit values whose predecessor is structurally known. Syntactically empty
conditional branches do not interrupt numbering. A condition/insert cannot obtain
an implicit value whose predecessor depends on completing that same expansion.
This reports a declaration-order dependency; it does not guess a branch or seek
a fixed point. Names from not-yet-selected branches are not published to evaluate
their own selection. More elaborate provably empty generated structures may
therefore remain unsupported; the exact extension contract is recorded in
compiler-questions.md. The compiler previously rejected these dependencies as
unknown names. Value evaluation shares the compiler's recursive constant evaluator
and existing deep-nesting limits.

## Verification

Original core tests cover forward/qualified/contextual references, normal/flags
sequencing, explicit aliases/zero/composites, selected/generated members, ordered
reflection, IDE definitions, interpreter execution and duplicate/cycle/unknown/
range errors. Reflection uses a scoped independent bootstrap record with only
the fields under test, not a full production-prelude ABI claim.

`tests/compiler-semantics/enum-dependencies.jai` checks runtime values, record
defaults, alias identity and bit operations. The LLVM harness executes it on
native macOS ARM64 and WASM64/Node at O0/O2. Actual wasm32 compiler host execution
through the playground also returns zero. Windows/Linux native execution and
full Socket/stdlib integration remain coordinator gates.

```sh
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo build --locked -p jaic-cli --bin jaic -p jailint --bin jailint
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm PATH=/opt/homebrew/opt/llvm/bin:$PATH CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo test --locked -p jaic -p jaic-llvm --test cleanroom_enum_dependencies
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm PATH=/opt/homebrew/opt/llvm/bin:$PATH JAIC_STDLIB=$PWD/target/runtime-configuration-candidate/stdlib CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo test --locked -p jaic -p jaic-llvm --all-targets --no-fail-fast
target/jaifmt --check tests/compiler-semantics/enum-dependencies.jai
JAIC_STDLIB=$PWD/target/runtime-configuration-candidate/stdlib target/debug/jailint -v -D warnings tests/compiler-semantics/enum-dependencies.jai
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo clippy --locked -p jaic -p jaic-llvm --all-targets -- -D warnings
JAIC_STDLIB=$PWD/target/runtime-configuration-candidate/stdlib CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo build --locked -p jai-wasm --target wasm32-unknown-unknown
node tools/check_enum_dependencies_wasm.mjs target/wasm32-unknown-unknown/debug/jai_wasm.wasm
```

The staged original reduction passes CLI host and WASM source checking. Its
interpreter returns **5**, the intended `main` value. Scoped Rust formatting/item
spacing and strict clippy pass; the positive Jai fixture passes actual jaifmt/check
and rebuilt jailint strict body checking. Invalid inline programs are negative
Rust fixtures, not positive lint roots. Exact suite totals/checkpoint are in
compiler-progress.md. No full-corpus or native Windows execution is claimed.
