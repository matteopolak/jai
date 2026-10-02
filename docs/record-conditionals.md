# Record conditionals and assertions

## What it is

Record bodies retain `#if` branches and `#assert` expressions as ordered source members. Local record definitions select active members with the typed compile-time evaluator; inactive members never bind names, reserve local nominal identities, or schedule runs.

## How it works

The local record namespace is active before selection. Unconditional declarations register first, allowing guards to refer to forward constants. A successful guard splices only its chosen members into the same namespace without creating a lexical scope. A worklist retries an unresolved guard when another selection introduces declarations; if no selection progresses, the original diagnostic is returned. Chosen declarations keep their original AST spans and owned local identities instead of receiving positions from a synthetic statement list.

Guards use `Resolver::compile_time_condition`, which binds a typed condition and evaluates it in the checked VM with compiler effects disabled. Explicit `#run` operands retain the normal procedure-readiness protocol. Active field names count as runtime names even before field layout is available, so a field cannot accidentally expose a same-spelled outer constant as its guard value. The source's lexical arithmetic checking policy is retained.

Record `#if selector == { case label; ... }` tables use the shared canonical case selector. Only the selected original members enter the namespace, including explicit `#through` bodies and a selected default arm. Labels retain normal type and duplicate validation, and `#complete` retains the shared coverage check. Case selectors retry readiness alongside ordinary guards; an inactive case never registers fields, assertions, or nested declarations.

Anonymous aggregates and named `using` fields contribute runtime guard names from their completed canonical child shapes, following actual `using` promotion paths. Child definitions retain their source identity while waiting for parent constants. Until a pending child supplies its real field names, name-dependent outer controls wait; literal controls can still introduce forward constants. If no work progresses, the original child diagnostic is returned. This conservative readiness rule never shadows a name using a field from an inactive child branch; a future dependency refinement can permit additional named guards that are provably independent of the pending child.

Active assertions keep their original source nodes during selection. They execute after the selected field shape, methods, and field defaults are ready, before the record namespace is published. This allows an assertion to query its own completed layout. A false assertion reports the original condition span; assertions in inactive branches are never evaluated. Assertions accept an optional message in `#assert condition "message";` or `#assert(condition, message);`. Active messages use the same typed pure evaluator as statement assertions and must produce a compile-time string, including when the condition is true. Named message constants resolve in the record's actual definition environment.

```jai
main :: () -> int {
    Record :: struct {
        #assert size_of(Record) == 8;
        #if CHOICE { value: int = 42; }
        else { value: MissingType; }
        #if true { CHOICE :: true; }
    }
    record: Record;
    return record.value;
}
```

Local selection covers named records, inline records, nested record namespaces, and records inside concrete procedure specializations. The module/template selector lives separately in `modules/aggregates/parameterized/expansion.rs`; it reads definition bindings and formal substitutions before reserving the resulting shape. Its assertion phase and supported constant operands must be checked separately when extending module or template records.

## How to change it

Change syntax in `jai-syntax/src/record_conditionals.rs` and local selection in `jai-sema/src/local_declarations/record_conditions.rs`. `namespaces.rs` owns the record frame, shape/default/body phases, assertion scheduling, and final namespace publication. `register_local_record_declarations` accepts original members, registers only direct declarations, and retains an existing source identity during retries.

`record_conditions/promoted_fields.rs` stages child readiness and walks physical metadata. Keep this separate from syntactic branch inspection: scanning every child branch and declaring all names would incorrectly reject guards that use an outer constant when the same-spelled child field is inactive.

Preserve source order when selecting fields and declarations. Do not register either branch before its guard resolves, or execute an assertion before the record state it queries is complete. Keep guards on the shared typed/pure evaluator rather than treating unresolved names as false. The iterative semantic selector independently bounds selected traversal to depth 128 and 65,536 visits/members, matching the module expansion budget and protecting transformed AST inputs. Semantic selection does not visit inactive members.

Source parsing independently permits at most 64 nested record `#if` controls. The next `#if` reports a diagnostic at its own source span before recursively parsing either branch, including inactive branches. This parser budget prevents deeply nested input from overflowing a normal 2 MiB Rust thread stack; semantic traversal retains its separate budget for transformed or generated ASTs. The depth counter unwinds between sibling branches and is not a limit on the total number of record conditionals.

Independent source fixtures live in `jai-sema/tests/local-record-conditions.rs`. The native fixtures in `jai-codegen/tests/local_declarations.rs` compare VM results with new LLVM objects and bounded native execution. They use no supplied compiler or native libraries.

## Configuration

`ResolveOptions.compile_time_limits` bounds guard evaluation and explicit runs. Graph target facts and the resolver's layout policy govern size queries. Lexical `#no_aoc` and `#no_abc` keep their normal source scope. No environment variable enables record selection.

`MAX_RECORD_CONDITIONAL_DEPTH` in `jai-syntax/src/record_conditionals.rs` sets the source parser nesting budget. Change it only with the explicit 2 MiB thread regression that covers the accepted boundary and excessive nesting; raising the thread stack size is not the parser's fallback.

## Dependencies

The feature uses the ordered `jai-syntax` record AST, owned local declaration registry, canonical type registry, shared compile-time condition evaluator, readiness cache, and checked Rust VM. Native verification uses the LLVM library backend and independently installed host Clang. See [local declarations](local-declarations.md), [compile-time conditionals](compile-time-conditionals.md), and [scoped safety checks](safety-checks.md).
