# Literal precision through semantic constants

The shared lexer precision calculation follows the reviewed fractional-digit
heuristic. Eight significant fractional digits default to float64; more than
eight require float64. Trailing fractional zeros do not count. Normal binary
exponents outside float32's range also require float64. The reviewed bit-pattern
spellings carry their documented width defaults.

Semantic float constants retain that metadata alongside their canonical f64
value. Untyped aliases, negation, arithmetic folding and module arguments preserve
it. Numeric conversions and overload selection reject implicit float32 narrowing
of a required float64 literal. Exactly-eight-digit defaults can still adapt to an
explicit float32 context. Explicit casts clear the lexical requirement and perform
the requested rounding. Typed constants and values read from executed code retain
their actual types rather than lexical constraints.

Typed module parameters convert the original provided constant through the same
conversion mechanism; they no longer reconstruct a literal AST that loses its
precision or source type. Constant equality and hashing include retained metadata
because untyped constants with different requirements have different observable
conversion behavior.

Original regressions in `cleanroom_literals.rs` and `cleanroom_modules.rs` cover
direct assignment, aliases, negation/folding, overload choice, explicit rounding,
contextual defaults and module parameter conversion. These are focused coverage,
not an exhaustive numeric conformance claim. Alternate floating formats and the
full expression space remain subject to broader coordinator verification.
