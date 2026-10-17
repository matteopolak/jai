# Jai language guide

This guide summarizes behavior demonstrated by the supplied Jai tutorial and example corpus. It is a compatibility guide for `crates/jaic`; it does not claim that the current compiler implements every feature.

- [Core syntax, declarations, types and values](core-syntax-and-types.md)
- [Procedures, control flow, data structures and memory](procedures-control-and-memory.md)
- [Polymorphism, compile-time execution and code generation](polymorphism-and-metaprogramming.md)
- [Modules, workspaces and practical example patterns](modules-workspaces-and-examples.md)
- [Implementation readiness and unresolved rules](implementation-readiness.md)
- [Public-language contract regression fixtures](../../tests/compiler/language/README.md)

## Evidence boundary

The scope is the supplied tutorial and example corpus. Samples below are newly written illustrations of those patterns. The examples do not settle every edge case; where the corpus does not establish a rule, the relevant page calls that out rather than extrapolating.
