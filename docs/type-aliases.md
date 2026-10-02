# Source type aliases

Transparent aliases preserve the canonical type of their target, including pointers and procedure signatures. A source callback result written as `void` means zero runtime results, so `#type () -> void #c_call` matches a C procedure with no result values.

```jai
marg_list :: *void;
IMP :: #type () -> void #c_call;
answer: int;
notify :: () -> void #c_call { answer = 42; }
main :: () -> int {
    callback: IMP = notify;
    callback();
    return answer;
}
```

## How it works

The parser recognizes pointer aliases with a definite builtin or anonymous nominal target, including repeated pointers such as `**void` and `**union { ... }`. Actual macOS source uses `FSEventStreamRef :: *struct {};`: the empty body is a real anonymous record, and repeated references to that alias share its canonical pointer target. Separate anonymous definition sites retain different nominal identities even when their layouts match. A pointer to a named declaration retains the ordinary address-expression syntax until semantic lookup determines whether its target denotes a type or storage. Module declaration identities and lexical bindings preserve that distinction across aliases and imports. Scalar constants and addresses of storage cannot become type aliases merely because their spelling resembles a type name.

Before canonical procedure interning, the shared result normalizer removes a sole result whose resolved type is the registry's `void` identity. Callback annotations, module type arguments, module and local headers, and generic result patterns all apply that rule. Source names, defaults, and result usage metadata remain attached to actual runtime results. Calling convention, context mode, arguments, and non-void results still participate in procedure type identity.

`void` cannot occupy a parameter or a slot in a multi-result runtime list. Ordinary pointer declarations continue to take storage addresses. Local declarative constants cannot capture runtime storage; their address expressions retain the appropriate scope or compile-time evaluation diagnostic and are never published as type aliases.

## How to change it

Keep definite syntax recognition in `jai-syntax/src/types.rs` narrow enough to preserve named address expressions. Extend ambiguous module aliases through `Nominals::is_type_alias`, which follows graph identities rather than display names. Local pointer alias classification uses the ordinary typed expression resolver so lexical shadowing has the same meaning as elsewhere.

Apply `procedure_values::signatures::normalize_results` before interning a structural procedure type or publishing result metadata. Generic result patterns compare against the same canonical builtin `void` identity through their concrete type resolver. Do not add a runtime placeholder for a void result. Update parser, semantic, and native source cases together when extending aliases.

## Configuration

There are no feature flags or environment variables. Source calling-convention and context annotations affect the resulting callback type, and module arguments determine which aliases are visible.

## Dependencies and validation

Aliases use `jai-syntax`, `jai-modules` declaration and instance identities, the lexical semantic bindings, and `jai-types` canonical structural type registry. Coverage lives in `jai-syntax/tests/type-aliases.rs`, `jai-syntax/src/anonymous_pointer_aliases.rs`, `jai-sema/tests/type-aliases.rs`, `jai-sema/tests/anonymous-pointer-aliases.rs`, and `jai-codegen/tests/type_aliases.rs`. The anonymous pointer alias slice has three passing semantic tests for canonical repeated/imported references, local union/enum targets, and distinct anonymous origins. The complete alias native suite has six passing tests, including two anonymous pointer alias cases. Native cases compile and execute only objects newly generated from independently authored source at both `O0` and `O2`, with VM and native exit `42` assertions.
