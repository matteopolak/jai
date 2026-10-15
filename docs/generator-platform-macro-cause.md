# String-macro callback diagnostic reduction

Owner: stdlib-tools, independently produced callback-model materialization.
No compiler/reference implementation or unreviewed private source was used.

The existing combined gate at tests/developer-tools/bindings-macros.jai:43
requires a numeric-constant rejection diagnostic and unchanged output. Both
generator paths fail and preserve output. The callback path loses the reason.

An original unsaved C translation unit contains only a string macro and
`void probe(void) { (void)(ORIGINAL_STRING); }`. The official SDK parses it without
diagnostics. Its three nonvoid expression cursors are UnexposedExpr (pointer),
ParenExpr (constant array), and StringLiteral (constant array). Evaluating each
returns null with the installed SDK. The string cursor still spells `"value"`.
Original C O0/O2 oracles and direct Jai interpreter/native O0/O2 calls agree.
This is SDK behavior, not evidence of an FFI enum/layout error or a Jai compiler bug.

Exact independent cause in existing code:

1. `find_probe_expression` in binding-native-model.jai:190 returns the first
   nonvoid expression, the UnexposedExpr above.
2. `model_numeric_macro` evaluates it at line283. The `if !evaluated` branch at
   line287 sets model.failed and returns without logging the specific rejection.
3. `generate_callback_model` subsequently emits only the generic
   `Bindings_Generator: callback model materialization failed` at line882.
4. The independent C pipeline's numeric_macro handles a null evaluation result
   explicitly and reports `macro is not a supported numeric constant expression`.
   The same header without a visitor therefore satisfies the diagnostic gate.

The correction belongs to the callback-model owner: preserve the rejection reason
when evaluation returns null (and for unsupported evaluated kinds), rather than
changing the existing gate, claiming empty success or adding a compiler exception.
No owner implementation was changed by the platform worker.

Run `python3 tools/check_generator_platform_macro_cause.py` to verify the SDK facts
and reproduce the diagnostic failure. Its reduction exits1 in interpreter/Mac
O0/O2 until fixed; the workflow explicitly reports that unresolved failure rather
than labeling the combined gate green. Durable original sources are
tests/developer-tools/generator-platform-macro-cause.c/jai; structured evidence is
docs/native/generator-platform-macro-cause.json. The original combined gate remains
enabled and is neither weakened nor replaced by this reduction.
