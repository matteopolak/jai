# Baked argument syntax

## What it is

The source expression parser retains `#bake_arguments target(name=value)` as a canonical `ExpressionKind::BakeArguments(Box<BakedArgumentsSyntax>)`. The typed source carrier preserves partial application separately from an ordinary target invocation.

## How it works

Callback type annotations can declare defaults, for example `#type(value: int = 21) -> int`. Their canonical physical signature contains only types. The original annotation environment checks and retains the typed defaults separately, alongside names and result obligations. Baked wrappers project that checked policy onto the surviving source formals, so two views can share a real wrapper without losing their own names or defaults.

A runtime procedure parameter is still a runtime value even when its callback policy is known. Binding it with `#bake_arguments` requires a genuine constant recipe; callback policy alone does not establish a constant procedure identity.

The retained helper parses the first actual invocation, preserving its callee expression, original argument names and expressions, invocation span and full directive span. Named, qualified, indexed and parenthesized targets keep their real source ranges. A later invocation or binary operand belongs to the enclosing expression; the parser does not synthesize a smaller procedure, body or nominal identity.

The bounded quote visitor traverses both the original callee and bound arguments. Oversized payloads in either position fail the existing quota before quotation retention. The scalar evaluator explicitly reports that bake arguments require checked callable source preparation. Ordinary runtime wrapper construction and source default/callback transport belong to the paired [baked procedure arguments](baked-procedure-arguments.md) semantic activation; parser acceptance alone does not establish execution.

Procedure-type defaults apply to input parameters. An equals sign after an unparenthesized result type begins the enclosing variable initializer, for example `sample: (value: int) -> bool = null;`. The callback parser leaves that token for the declaration parser.

## How to change it

Update `baked_arguments.rs` with the expression dispatcher and AST consumer visitors. Preserve each original formal spelling and source expression until the real source procedure binder selects and checks it. Do not route a partial application through an ordinary call and lose the remaining source signature.

Two whole-source parser tests inspect the canonical node, named and indexed targets, retained procedure bodies and a subsequent invocation. The three retained helper tests exercise callee ranges and invalid forms, and the new quote test charges callee and argument payloads. These tests are pending the centralized coherent compiler gate. The complete unchanged Apollo_Time source is a required corpus restage target, with its original file identity/hash retained in the packet manifest.

## Configuration

The full source parser accepts this form; the scalar compatibility parser rejects it because it has no checked callable source environment. Existing quote node/depth/payload limits remain in force. No new environment variables or CLI flags are introduced.

## Dependencies

`jai-lexer`'s canonical `BakeArguments` token, the source expression and argument parser, `jai-source` spans/symbols, the bounded quote visitor and paired checked source callable preparation. Semantic wrapper production must preserve actual declaration/file identity, formal runtime-slot projection, ABI and context policy.

The borrowed source census walks the actual boxed callee and every baked argument before source adoption, retaining the argument vector capacity. Placement metadata uses the same place visitor, including member paths and index expressions. These children must stay exhaustive when the source AST changes.
