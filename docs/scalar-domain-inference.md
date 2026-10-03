# Scalar domain inference

## What it is

`jai-eval::DomainInference` separates scalar binding domains from scalar values. Source preparation can validate inactive conditional arms without evaluating their constant initializers or waiting for values that execution never uses.

## How it works

`ScalarDomain` distinguishes integer literals, fixed integer types, booleans, typed floats, and exact weak floats with an inferred default width. `Value::domain()` exports the corresponding fact from a genuine ready value. `DomainInference::infer` resolves every name through a domain-only callback and validates the same numeric common domains and operator categories as scalar constant binding. It retains checked syntax references and each child's inferred domain.

After inference succeeds, `evaluate_paths` or `evaluate_float_paths` requests values through a separate callback. `ifx`, `&&`, and `||` read only selected operands. Numeric conditionals still convert the selected expression to the common domain established by both arms. Arithmetic inside a selected arm keeps its original integer or float width before that conversion, including overflow checks. Missing `ifx` alternatives use the language's actual zero/default behavior.

Weak decimal expressions preserve direct contextual rounding. An inactive arm may determine the weak expression's default width; the selected exact expression retains that width in its immutable request identity. The canonical weak-float key encoding adds tag 28 for a default-width override while preserving existing encoding tags and existing simple-decimal bytes. A selected named value whose domain disagrees with its bound fact is rejected instead of silently changing the arithmetic type.

`infer_for_preparation` returns structured `ScalarInferenceError::RequiresTypedExecution` for a source form that needs checked typed execution, such as a call, `#run`, or storage cast. Genuine scalar binding errors remain `ScalarInferenceError::Diagnostic`. `infer` retains its diagnostic-only API. Preparation must wait on the actual referenced producer when typed execution is required; a transitive dependency classification must never force an inactive producer value. For example, `M :: ifx true then 42 else N; N : int : #run count();` obtains `N`'s domain from its annotation and computes `M` without executing `N`. Selecting `N` still waits for its genuine value.

Inference does not make unknown bindings valid. An unavailable domain still reports its normal source dependency, and incompatible inactive domains still fail. Domain availability and value readiness are distinct; a caller must obtain domains from genuine annotations, typed binding facts, or recursively inferred source declarations without running initializer arithmetic.

## How to change it

Extend `crates/jai-eval/src/domains.rs` when adding a new scalar syntax form. Keep domain checks consistent with `bind` and `bound_values::bind_binary`; value construction must continue to use the existing checked arithmetic and float implementations. Never manufacture zero-valued constants to stand in for unresolved binding facts.

Unsupported integer storage casts and `cast,trunc(bool)` reject before consulting operand bindings, matching the original scalar error order. Add readiness classification at the syntax branch that discovers it; never classify rendered diagnostic messages.

The focused regressions in `crates/jai-eval/tests/domain_inference.rs` cover inactive bindings, common-width joins, child overflow policy, short circuiting, invalid domains, selected fact/value mismatches, and exact weak-float identity. Any new bound float-key tag also needs a stable distinct canonical encoding in `floats/keys/encoding.rs`.

## Configuration

The value phase receives an explicit `CheckMode`; source constants use enabled integer overflow checks. Float materialization receives an explicit `FloatType`. No environment variable changes domain inference or arithmetic policy. Binding callbacks determine source identity and whether a domain or selected value is ready.

## Dependencies

The implementation uses `jai-syntax` expressions, source name paths and diagnostic spans, `jai-types` numeric domains, and the existing `jai-eval` integer/float binders. It has no host effects, external services, native libraries, or compiler execution dependencies.
