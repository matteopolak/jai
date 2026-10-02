# Implementation readiness and unresolved rules

## Decision

The guide is ready for a fresh compiler implementer to begin a staged implementation of the language behavior directly demonstrated by the supplied corpus. It is not a complete grammar or a compatibility guarantee for every Jai program. A full-compatibility claim should wait until the unresolved rules below are checked against additional compiler evidence.

## Implementable core

The four feature guides provide a usable contract for an initial implementation of:

- declarations, primitive values, explicit casts, arrays, strings, structs, unions, enums, and compile-time type values;
- procedures, defaults, multiple results, conditions, loops, `defer`, operator overload declarations, context, and allocator-facing syntax;
- polymorphic procedures and structs, baked parameters, `#run`, `#if`, `#expand`, `#insert`, reflection, and `#modify` patterns;
- module imports, file/module/export scopes, `using`, module parameters, and the distinction between workspace/build behavior and runtime language behavior.

For each feature, use the syntax and behavior stated in its page as the supported contract. The Jai snippets are original illustrations of that contract; they are not exhaustive grammar productions.

## Keep these rules open

The current evidence does not settle the following cases. Avoid choosing a rule based on familiarity with C, Rust, or another language:

- complete token and expression grammar, including escape processing, operator precedence for uncommon combinations, and parse recovery;
- declaration order, shadowing, ambiguous name lookup, and all scope-transition corner cases;
- exact range endpoint behavior for empty and reversed ranges, plus less common iterable and pointer-iteration forms;
- evaluation order for side-effecting call arguments and all default/baked argument interactions;
- overload selection, polymorphic specialization identity/caching, and complete type-restriction grammar;
- exhaustive rules for implicit numeric conversions, overflow, enum conversions, union safety, and aggregate initialization;
- macro hygiene, backtick binding, expansion recursion and limits, and all `#insert` scope/location options;
- import search paths, cycles, visibility interactions, replacement precedence, and module-instance cache identity;
- the complete relationship among host execution, target compilation, workspace state, and compile-time side effects.

These are compatibility questions, not permission to silently accept arbitrary behavior. Prefer a clear diagnostic or a deliberately unsupported feature boundary until evidence resolves them.

## Suggested implementation sequence

1. Implement lexing, parsing, declaration collection, and typechecking for the core value and procedure forms.
2. Add arrays/views, aggregates, enums, control flow, and explicit lifetime-sensitive runtime operations.
3. Add compile-time types, static branches, polymorphic specialization, and baked arguments.
4. Add module/workspace integration and code generation features such as expansion and insertion, keeping build-time APIs separate from runtime semantics.
5. Use the full corpus as an acceptance suite and turn each observed mismatch into either a clarified rule or a documented unsupported edge.

The sequence is organizational guidance. It does not define a required internal architecture or imply that a feature is simpler than another for a particular implementation.
