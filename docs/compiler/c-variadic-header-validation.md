# C variadic header validation

Compiler checkpoint89572473 rejects a C variadic parameter followed by another
runtime parameter before matching/lowering. This applies to foreign declarations,
`#c_call`, `#cpp_method`, generic/imported procedures and explicit procedure types.
Baked parameters do not participate in C ABI ordering. Ordinary Jai variadics
with named/default tails remain supported.

The previous invalid header could reach Jai pack lowering with a scalar type and
panic. Matching/lowering now verifies the required array-view pack representation
and returns an ordinary diagnostic. No fabricated type, panic catcher, relaxed
ABI, module exception or recovery-as-execution rule is introduced.

Combined checks pass5 core diagnostic tests,13 independent IDE audit regressions
and2 actual native C variadic call/aggregate tests. Rustfmt and full-workspace
clippy with warnings denied pass. This fixes the independently reduced ordinary
panic class; it does not establish whole original-corpus acceptance or resolve
the separately suspended memory-boundary investigation. Its suspended fixture
was not imported or executed by integration.
