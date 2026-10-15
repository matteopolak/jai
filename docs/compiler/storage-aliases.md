# Foreign storage type queries and filtered reexports

## Corrective review disposition

The live mutable alias interpretation in 784415f/c018dd5 is withdrawn. Those
commits remain intact for audit, but their mutable `Alias :: Module.variable`
behavior and positive mutation oracles are not compatibility evidence.

The completed independent contract review establishes `::` as immutable.
It does not establish whether initializing it from a mutable global rejects or
captures an immutable value. The corrective batch restores decls.rs, expr.rs and
lower.rs exactly to their pre-784415f source, including the prior constant
evaluator. It adds neither a snapshot rule nor an alias-specific rejection rule.
The place-provenance map and initializer shortcut are removed entirely.

A direct `type_of(Module.foreign_variable)` query only checks the declared type.
It must not load the variable. Documented using imports/reexports forward the
original declaration and preserve its canonical type, mutability and storage.
They are the supported mechanism for exposing the original variable.

Contract: docs/specs/jai/modules-workspaces-and-examples.md and
docs/language/declarations-and-constants.md. Initializer behavior beyond the
reviewed immutable-binding requirement remains unspecified.

## Production change and provenance

The only new production behavior is the approved independent integration-clean
57cb0b5191cba41133a2cf77ae5f207223204831 modules.rs patch. It registers exported
anonymous using imports in the module's exported_using_imports list, just as the
named form does. Existing lookup/filter logic then forwards the original entity.
No copied declarations, public namespace alias, module-name exception, type
guessing or constant semantics change is involved.

Only that exact approved commit's modules.rs diff was read from integration-clean;
no other peer sources/history, quarantined source or transcripts were inspected.
The patch is ported into this worker's own checkout; the peer tree was not changed.
The established module privacy/filter machinery remains responsible for access.

## Corrected independent tests

The preserved original C provider defines two actual variables and read/write
functions. Facade now uses an anonymous using,only import, and Forward uses an
anonymous using,except import. Original exported variable names remain unchanged.
C-backed mutation, address equality, record-field access, runtime parameter
defaults, generic types and independent explicit variable copies are checked
through these reexports. No test treats an initialized constant as mutable.

Core negative tests require assignment rejection for ordinary, typed and
module-qualified initialized constants, including record members. The first new
negative reproduced the erroneous acceptance before the correction
(target/storage-review-constant-red.log). Reexport tests separately reproduced
missing exported members before the approved registration patch
(target/storage-review-reexport-red.log).

Pure foreign type queries, reflected type identity and generic type defaults run
with SandboxHost native linking disabled and no foreign provider. A real read or
value computation still requires available foreign storage and diagnoses its
absence. Filters retain excluded declarations. All 45 existing module regressions
also pass, including privacy, reexport identity and constant aggregate rejection.

The corrected C provider executes in the interpreter and native macOS ARM64 at
O0/O2. The matching WASM64 test links actual C-defined data and executes at O0/O2.
The actual wasm32 compiler-host runner tests no-provider type/reflection/default
checking, immutable-binding rejection and unavailable-read diagnostics.

Strict jailint checks all facade bodies for macOS, Windows, Linux and WASM targets
without loading a provider; invalid unused bodies remain failures on every target.
This is source checking, not native Windows/Linux execution. Reflection's scoped
bootstrap records are test fixtures, not a production-prelude substitute.

## Commands and bounds

Fresh results: 51 core tests (45 existing module regressions and six corrected
storage/constant cases), one actual native/WASM LLVM execution test and all 40
jailint tests pass, with zero failures/ignores in this focused scope. Host and
wasm32 clippy, scoped Rust formatting/item spacing, Jai format/strict lint and C
formatting checks pass. No expanded profile, benchmark or duplicate build cache.

```sh
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo test --locked -p jaic --test cleanroom_modules --test cleanroom_storage_aliases
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm PATH=/opt/homebrew/opt/llvm/bin:$PATH CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo test --locked -p jaic -p jaic-llvm -p jailint --test cleanroom_storage_aliases
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm JAIC_STDLIB=$PWD/target/runtime-configuration-candidate/stdlib CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo test --locked -p jailint --all-targets --no-fail-fast
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo clippy --locked -p jaic -p jaic-llvm -p jailint --all-targets -- -D warnings
node tools/check_storage_aliases_wasm.mjs target/wasm32-unknown-unknown/debug/jai_wasm.wasm
target/jaifmt --check tests/compiler-semantics/storage-aliases
JAIC_STDLIB=$PWD/target/runtime-configuration-candidate/stdlib target/debug/jailint -v -D warnings -I tests/compiler-semantics/storage-aliases tests/compiler-semantics/storage-aliases
```

Actual scoped rustfmt/item spacing, Jai formatter/check/strict lint, C formatting
and clippy evidence is recorded in compiler-progress.md. The former 385-case
checkpoint is historical evidence for its then-current tests, not validation of
the withdrawn contract. This corrective batch has focused fresh evidence.

Native Windows/Linux execution and real integrated SDK resolver checking remain
coordinator gates. The prior full older-staged-prelude WASM CLI failure on
POSIX.FILE remains recorded in target/storage-aliases-wasm-cli-dependency.log;
no full-prelude WASM success or repaired production dependency is claimed.
No profiles, benchmarks, publications or history rewrites are part of this work.
