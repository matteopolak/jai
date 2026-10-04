# jaic lambdas, `#insert` procedures and `#caller_code`

## What it is

Three related language features in the `jaic` semantic analyzer: lambda expressions (`(x) => x + 1`), `#insert -> string { ... }` / `#insert -> Code { ... }` blocks (including `#insert,scope()`), and `#caller_code` as a parameter default.

## How it works

**Lambdas** (`sema/lambda.rs`). The parser keeps `ExprKind::Lambda`. Sema desugars it with `lambda_lit` into an ordinary `ProcLit`: untyped parameters get the polymorphic type `$__lambda_<name>`, an expression body becomes `return <expr>;`, and the header is tagged with `ProcFlags::lambda` (`Expr` or `Block`). A lambda is then just a (possibly polymorphic) procedure:

- `lam :: (x) => x + 1;` registers the lambda like a procedure literal (`decls.rs`), so it is polymorphic and can be called, baked and overloaded.
- Where an expected procedure type exists (`check_lambda`: typed parameter, declaration type), the polymorphic procedure is instantiated with the expected parameter types plus the constant `__lambda_return` (the expected result type).
- For a generic callee (`map :: (a: [] $T, f: (T) -> $R)`) lambda arguments are deferred (`is_deferred`) and handled last in `infer_bindings`: the parameter types of the procedure-type pattern are evaluated with the bindings found so far, the lambda is instantiated, and its signature is matched against the pattern to bind `$R` (`infer_lambda_bindings`).
- The result type of an `Expr` lambda without `__lambda_return` is the type of the body expression, found by checking it once in a scratch context (`lambda_return_type`, called from `build_signature`). `Block` lambdas default to no result.
- `#this` inside a lambda is the lambda's own procedure instance (recursion).

The parser turns `(a, b) =>` parameters, which parse like unnamed procedure-type parameters, into named untyped parameters, and reads a parameter type written `f: (T)` as a one-parameter procedure type.

**`#insert` procedures** (`sema/consteval.rs`). `eval_insert_operand` recognises an `#insert` operand that is a parameterless procedure literal with a result, wraps it in a call and runs it like `#run` (so it has a context and can use the String_Builder, `print_to_builder`, ...). The string or Code result is inserted by the existing machinery. `read_value` reads `Code` values back from compile-time memory. `#insert,scope() code;` resolves the inserted Code in the insertion scope instead of the scope where the `#code` was written; `#insert,scope(other_code)` uses another Code's scope.

Supporting changes: a macro parameter whose argument is a constant is recorded in `Compiler::local_consts`, so the compile-time procedure can read it (`entity_operand`); `local.CONSTANT` of an enclosing procedure's local (`u.fields` for a struct parameter) resolves from the type alone (`enclosing_local_constant`); polymorphic struct arguments are converted to the declared parameter type (`[] T` from a fixed array); `$types: ..Type` baked variadic parameters bind a constant `[] T` view (`baked_pack`); `$c: Code` takes the argument expression unevaluated and `c.type` is its type.

**`#caller_code`**. As a parameter default it has type `Code` (`build_signature`). `check_call` records calls to procedures that use it in `Compiler::calls_in_flight`; evaluating the default produces a `Code` of the whole call expression, scoped at the call site.

## How to change it

- Lambda instance caching is the ordinary procedure instance cache keyed by the binding values (`instantiate`), so extra per-instance information must be passed as a binding like `__lambda_return`.
- Lambda parameters are never captured; only constants and globals are visible, as for any anonymous procedure.
- A lambda passed to a `$F`-typed (non-procedure-type) parameter stays an uninstantiated polymorphic procedure and is not supported.
- `$$` parameters (`proc2 :: ($$a: int)`) are not implemented; they are treated like `$`.
- Block-bodied lambdas whose procedure-type pattern has an unbound `$R` result are treated as returning nothing.

## Configuration

None.

## Dependencies

`sema/procs.rs` (procedure signatures and instantiation), `sema/calls.rs` (inference), `sema/consteval.rs` (compile-time execution), the Preload `Source_Code_Location`/`Code` types, and `stdlib/Basic` for the String_Builder used by typical insert procedures. `%N` in `print` formats is now one-based, as in the reference module.
