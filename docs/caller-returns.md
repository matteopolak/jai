# Caller returns

## What it is

A backtick `return` in a `#expand` body returns from the actual enclosing procedure. Its values resolve in the macro's defining scope and satisfy the caller's checked result signature.

## How it works

```jai
finish :: (value: int) #expand {
    result := value;
    defer result = 99;
    `return result;
}
answer :: () -> int #must {
    finish(42);
}
```

The supplied changelog at `reference/CHANGELOG.txt:7100` explicitly distinguishes a normal macro return from a backtick caller return. The recent supplied `Basic/Apollo_Time.jai:340` and SGPU `module.jai:661` use scalar and multiple-result caller returns; SGPU also places them inside runtime conditionals.

Parsing retains `CallerExport(Box<Statement>)` around the original `Return` or `ReturnValues`, including the separate outer and inner source ranges. Before entering a macro's defining environment, an invocation captures a typed `CallerReturnTarget` with the real procedure identity and source result signature. Lowering validates that identity and every result's type, name, default and usage policy against the still-active caller signature. It never substitutes a procedure identity or treats the marker as a caller-reference expression.

Operands retain the macro's lexical bindings and source checks. Callback contracts and generic callback bindings remain in the same semantic context, keyed by their actual procedure identities; they are not reconstructed from ABI types or looked up again in a shadowing scope. The existing return binder supplies named and defaulted results, rejects signature mismatches and preserves required-result contracts.

The checked result becomes the existing IR return transfer. Return expressions and macro runtime inputs run once before active cleanup bodies. Macro, nested-block and caller defers run in reverse registration order, retaining their registered pushed contexts. Aggregate results are captured before those cleanups can mutate their source storage. The enclosing block's termination state includes the escaped return, so a procedure ending with an unconditional invocation satisfies its return obligation.

Ordinary `break` and `continue` in macros use the actual active loop stack and existing cleanup lowering. The supplied Jai lexer explicitly excludes backticked loop-control keywords, so this feature continues to reject them. Normal macro returns and macros used as value expressions still require the separate expansion-result binding feature.

## How to change it

Edit `jai-syntax/src/caller_exports.rs` for retained caller-return grammar, and `jai-sema/src/metaprogram/exports.rs` for target capture and validation. `ExportFrame` owns the invocation target; the defining-scope reborrow retains the caller's real procedure, result, cleanup and semantic-policy state. Keep ordinary return handling in `cleanup.rs` as the shared binder instead of duplicating its type, lifetime or cleanup checks.

`jai-sema/tests/caller_returns.rs` checks runtime argument ordering, nested expansions, aggregate snapshots, named/defaulted results, aliases, required callback results, local-procedure boundaries, inserted macro code and pushed contexts. Shared authored fixtures also feed `jai-codegen/tests/caller_returns.rs`.

Public tests keep one bounded public upstream macro window: SGPU's scalar `return_if_error`, checked with authored dependencies. Its tracked fixture uses LF lines and one EOF newline; the adapter restores the original extra footer separator byte for byte. `jai-sema/tests/fixtures/supplied-caller-return-provenance.json` records the complete original source SHA, byte span, packed fixture SHA, restored macro SHA, and generated SGPU source before/after SHA equality. This fixture does not depend on the ignored `corpus/` tree or imply whole-module or project acceptance.

Apollo compatibility is an explicitly ignored test that reads `reference/modules/Basic/Apollo_Time.jai` at runtime and checks the unchanged local macro window. Run it with `cargo test -p jai-syntax --test caller-returns local_original_apollo_conversion_macro_parses_without_rewriting_its_caller_return -- --ignored --exact`. Explicit invocation fails clearly if the local input is unavailable. No reference-source bytes enter tracked fixtures. A separately named independently authored scalar macro test always runs in public clones. Keep authored proof and opt-in local original compatibility separate in acceptance reports.

The earlier combined main-workspace gate passed four syntax cases, including local original Apollo input, 19 source/VM cases, and the selected unchanged SGPU native test, which executes two own outputs at `-O0` and `-O2` with VM agreement. The immutable central evidence is `/private/tmp/jai-integration-language-bulk-20261002/proof.json`. Those gates read both local originals. The public-clone closure repair preserves the SGPU generated source bytes and Apollo's opt-in local extraction while removing compile-time reference dependencies. Its cached candidate compile and new authored syntax case are pending; the authored case does not extend original-source compatibility evidence. The earlier private 70 Rust tests and 30 native executions remain historical component evidence, not additional fresh acceptance. Ordinary generic macro inference and value-position expansion results remain separate.

## Configuration

No flag enables caller returns. `#expand`, the actual caller result declaration and active defer/context scopes determine the behavior. Native tests use the repository's pinned Rust toolchain, locked offline dependencies and a trusted installed LLVM 22.1 prefix; only freshly generated test programs execute.

## Dependencies

The feature uses retained syntax/source spans, invocation export frames, checked source signatures, callback policy storage, deferred cleanup IDs and the existing IR return transfers consumed by the VM and LLVM backend. It adds no external library and executes no supplied native artifact.
