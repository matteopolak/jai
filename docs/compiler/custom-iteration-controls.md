# Custom iteration control state

An inserted custom-for body uses the expansion's innermost loop for control
operations. The synthetic caller-visible loop frame previously copied jump and
defer targets but discarded array removal state. An independent wrapper forwarding
to an array expansion reproduced `remove is only valid inside a for loop over an
array` despite the actual enclosing loop being removable.

`insert_for_body` now forwards the same innermost loop's optional removal state.
This includes the actual container, index slot, element type and reverse direction.
It does not search outward for an arbitrary removable array. Numeric loops retain
no removal capability, and explicit insertion replacements retain their existing
precedence. No public API or library dispatch rules change.

The original regression removes even values through a nested forwarded custom
body, checks every visit/index and the resulting unordered contents, then repeats
in reverse. The numeric-range negative keeps its required diagnostic. Interpreter,
actual native ARM64 O0/O2 and WASI O2 executions pass. Scoped core/layout/reflection,
CLI and rejected-overload lint regressions pass, as do strict lint and clippy.
Evidence is retained in `artifacts/compiler-mac-repairs/custom-*.log` and
`custom-native.json`.

The separate sanitized `unknown identifier operator-` diagnostic has not been
reproduced. Independent coverage now checks unary/binary dispatch, direct calls,
overload selection into procedure values and qualified imported operators.
Interpreter and actual native ARM64 O0/O2 executions pass. No speculative compiler
change was made for that group. A sanitized minimal failing reduction is needed
before assigning its cause. Older corpus cases were not read or replayed here.
