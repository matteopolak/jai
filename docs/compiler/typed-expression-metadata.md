# Checked expression result metadata

The NEW developer-tools binary-result-type reproducer exited 1 because typed
local operands had descriptors but their binary result did not. The exporter
previously rechecked expressions in a top-level declaration scope. It deliberately
avoided expressions reading locals, since that scope cannot resolve them safely.
That also prevented result descriptors for ordinary checked local arithmetic.

Successful real expression lowering now retains its result TypeId by concrete
procedure instance and source span. TYPECHECKED body export uses those checked
results, including identifiers, operators, indexing, casts and calls, rather
than running expression checking again in an unrelated scope. Descriptor creation
uses the existing canonical type-record/own-descriptor machinery. Different generic
instances share syntax but keep separate maps/types. Failed lowering drops its
partial map; relowering starts a fresh map. Type-only probes and partial IDE sketch
recovery are not counted as real checked expression results. No public API,
module-name exception, fallback result type or weakened diagnostic is introduced.

## Evidence

- NEW producer files were read only at the explicitly authorized question/progress
  and original fixture paths, then copied into target/tooling-metadata/producer.
  binary-before.log retains the actual missing-descriptor failure; binary-after.log
  records successful real interpreter interception. Parent native O0/O2 compile/run
  also passes (producer-execution.log). Child output is NO_OUTPUT: this proves
  compile-time metadata behavior, not a native runtime reflection implementation.
- Own library-free Rust regression failed on the missing checked binary descriptor
  before implementation (typed-red.log). Four final cases pass: local arithmetic,
  comparison/index results, lexical shadowing, independent generic instances and
  invalid local expression rejection. Generic tests drain successive TYPECHECKED
  messages, where concrete instance bodies may arrive after their headers.
- Uninstantiated polymorphic templates remain syntax with no unique concrete result
  type; the regression explicitly counts the template and separately requires both
  u8/u16 concrete instance descriptors. It does not count the template as complete
  concrete reflection support.
- The owned public-message Jai fixture requires exactly one binary result and its
  canonical type_info(u8) pointer. Interpreter and actual native O0/O2 parent runs
  pass. The actual source-built wasm32 compiler runs it twice under Node, then a
  deliberately incorrect u16 expectation must fail with the original compiler
  report diagnostic. No unknown import replacement or fake descriptors are used.
- 299 selected core/backend cases pass in regressions.log; scoped metadata tests
  pass again after final review. LSP 25 library and 16 auto-import cases pass.
  Native Windows thread/backtrace execution remains pending CI, not proven by
  platform-gated tests on macOS.
- Scoped Rust rustfmt/item-spacing and owned Jai jaifmt --check pass. Rebuilt
  jailint --verbose -D warnings passes on the active owned public-message fixture.
  Host core/backend/CLI all-target clippy, Windows x64/ARM64 core all-target clippy and
  wasm32 browser clippy pass with warnings denied. Logs live in target/tooling-metadata.

```sh
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo build --locked -p jaic-cli --bin jaic -p jailint
CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo test --locked -p jaic --test cleanroom_typed_nodes
JAIC_STDLIB="$PWD/target/runtime-configuration-candidate/stdlib" target/debug/jaic -interp -no_workspace_output tests/compiler-semantics/typed-expression-message.jai
JAIC_STDLIB="$PWD/target/runtime-configuration-candidate/stdlib" target/debug/jailint --verbose -D warnings tests/compiler-semantics/typed-expression-message.jai
JAIC_STDLIB="$PWD/target/runtime-configuration-candidate/stdlib" CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo build --locked -p jai-wasm --target wasm32-unknown-unknown
node tools/check_typed_nodes_wasm.mjs target/wasm32-unknown-unknown/debug/jai_wasm.wasm
```

## Limits and deviations

Semantic snapshots add storage proportional to checked expressions and a hash-map
update per successful check. This retains results for API requests made after
lowering; no throughput/memory benchmark is claimed. Profile before adding more
context dimensions or choosing a more compact representation.

The public export tree still lacks a distinct node identity per macro expansion.
If one source span in a concrete procedure checks to incompatible types, the
snapshot marks it ambiguous and export clears the type instead of inheriting a
possibly wrong identifier/call descriptor. Unchecked/discarded syntax has no new
concrete-type guarantee. Full expansion-aware AST identity and precise contextual
conversion metadata require a larger reviewed AST contract/refactor; this batch
does not claim complete Compiler AST/debugger/alternate-backend support.

The first own test accidentally indexed a pointer-to-array as though it were an
array view and correctly got a return-type error. It was corrected to a pointer
to element before recording the meaningful red failure. A later test initially
looked only at the first TYPECHECKED message; it now drains all messages while
retaining strict assertions for every concrete binary result. Diagnostic logs are
retained; neither setup failure is counted as compiler red/green evidence.

## Constant-array address observation: not resolved by an unreviewed change

The explicitly named NEW developer-tools question/progress files say stable public
constant-array .data address identity is NOT established by the reviewed contract.
The staged original assertion still aborts in the interpreter; its failure is
retained in constant-address-before.log and is not counted as a passing behavior.

General cause: fixed-array .data in sema/structs.rs calls lower.rs::address_of.
A constant aggregate is materialized as read-only global bytes, then address_of
copies it into a procedure temporary to avoid exposing mutable aliases of those
bytes. Two evaluations therefore address different copies. The explicit unary
address operator uses a separate cached static aggregate path in sema/expr.rs.
This is a real difference, but replacing temporary copies with shared writable
storage would decide observable lifetime/mutability/sharing semantics absent from
the reviewed oracle. No pooling or module-specific workaround was added merely to
make the unresolved equality assertion pass.

A precise question is recorded in specs/stdlib/compiler-questions.md: specify the
storage lifetime, mutation and identity relationship of a named constant fixed
array, its aliases, .data, pointer/view conversion and explicit address operation,
including distinct equal-valued declarations. Once reviewed, implement one coherent
aggregate-storage mechanism and verify interpreter/native/WASM lifetime and alias
behavior. Public value/type identity tests remain valid; no blanket test exclusion
or passing full identity claim is made. Portable runtime adoption, native Windows
CI, CPUID-adjacent architectural gaps and other documented compiler limits remain.

Reviewed follow-up: core-syntax-and-types.md now explicitly confirms no canonical
constant-array address/lifetime/mutation promise. Classify the retained equality
assertion as an invalid compatibility oracle; use explicit mutable backing when
retaining writable pointers. There is no pending permission to pool writable
constant storage. Full suite/ownership follow-up: full-suite-triage.md.
