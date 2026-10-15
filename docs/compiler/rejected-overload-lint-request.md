# Compiler/linter owner request: rejected generic candidates become audit roots

## Compiler disposition 2026-10-15

Resolved in the compiler-owned tree; design and measured limits are in
[rejected-overload-audit.md](rejected-overload-audit.md). Staged reductions pass
strict lint (unused Basic import removed only from the staged Http reduction).
The production Http client context now fails on unknown atomic_compare_exchange,
which is a separate dependency and remains assigned outside this repair.

This is a general compiler defect, reduced independently without Http, Json,
private Basic APIs, native libraries or source/path exceptions. It blocks the
exact production Http client warnings-denied context. Please repair in the
compiler-owned checkout and provide an approved sanitized checkpoint for this
worker to verify; this worker does not edit compiler crates.

## Reproducers and actual results

`tests/extensions/rejected-overload-lint-repro.jai` defines nominal App/Client
types, a runtime generic Client overload requiring an integer payload, and an
App overload taking a baked handler. Main selects the App overload and asserts
the handler really ran. Normal source checking and interpreted execution exit0.
The warnings-denied audit exits1 with:

```
#assert failed: rejected Client candidate was checked
```

```sh
JAIC_STDLIB="$PWD/stdlib" artifacts/T7/debug/jaic -check tests/extensions/rejected-overload-lint-repro.jai
JAIC_STDLIB="$PWD/stdlib" artifacts/T7/debug/jaic -interp tests/extensions/rejected-overload-lint-repro.jai
JAIC_STDLIB="$PWD/stdlib" artifacts/T7/debug/jailint -D warnings --context tests/extensions/rejected-overload-lint-repro.jai tests/extensions/rejected-overload-lint-repro.jai
```

`tests/extensions/http-client-overload-lint-repro.jai` retains the real public
Http route registration. Normal checking accepts `Http.post(*app,"/",handler)`;
lint of the production client source tries to encode that handler as a Client
POST JSON payload and exits1. The exact original context remains red too:

```sh
JAIC_STDLIB="$PWD/stdlib" artifacts/T7/debug/jailint -D warnings --context stdlib/Extensions/Http/tests/client.jai stdlib/Extensions/Http/client.jai
```

It reports `Json: (*Request) -> Response: cannot encode a procedure`. The failure
is not a Json serializer requirement to encode procedures, an invalid client
test, or an ownership/atomic problem. The selected overload takes App and a
handler, and actual native tests exercise it successfully. A Json fallback or
extra public guard to hide the rejected candidate would mask the compiler defect.

## Supplied-source diagnosis

`sema/calls.rs::match_candidate` infers bindings and instantiates a generic
candidate before coercing all runtime parameters. A candidate rejected for its
first parameter can therefore retain a concrete procedure instance.
`sema/ide.rs::ide_check_all` then treats non-polymorphic instances in NotNeeded
state from requested source files as audit roots. The independent reduction
demonstrates that such a rejected instance reaches body checking and its
compile-time assertion/generator. This is distinct from stand-in editor
polymorph sketches; the earlier handoff's "generic sketch" label was imprecise.

The general repair needs valid audit roots/instantiation provenance or properly
transactional candidate handling. Do not disable unreferenced concrete procedure
checking, discard genuine selected-instance errors, suppress generators, or
special-case Http/Json/files. Rejected candidates may share an instance later
selected by another call; that selected instance must still check. Preserve
overload diagnostics, baked parameters, procedure-value arguments, inferred
bindings, defaults and #modify validation. No implementation prescription here
is a substitute for compiler-owner tests and review.

Original failure evidence is retained locally in
`artifacts/http-client-lint-resume-red.txt` and
`artifacts/rejected-overload-lint-red.txt`. These are this worker's own fresh
compiler outputs, not vendor or historical logs. The target directory remains
isolated local `artifacts/T7`.
