# Type-instantiation flag reconstruction

The reviewed Compiler record ABI assigns `VARARGS=0x1`, `RESIZABLE=0x2`,
`TYPE_OF_PROCEDURE=0x4`, `TYPE_DIRECTIVE=0x8`,
`TYPE_DIRECTIVE_DISTINCT=0x10`, `TYPE_DIRECTIVE_ISA=0x20`, and `ARRAY_VIEW=0x40`.
These values are independent of the Rust AST enums.

The exporter incorrectly used `0x10` for growable arrays, which the public printer
correctly rendered as a distinct view. Plain/distinct/isa type directives also
used incorrect bit positions. Variadic marking replaced existing flags rather
than combining them, losing array/directive syntax on variadic parameters.

The exporter now uses named constants for the reviewed values, marks procedure
type syntax, and combines VARARGS with existing flags. Fixed arrays retain their
dimension expression without a growable/view flag. The printer continues to use
the public symbolic flags; there is no module workaround or private remapping.

## Regression evidence

`cleanroom_code_flags.rs` parses independent syntax and checks exact exported
numeric flags for growable, fixed, slice, plain, distinct, isa and procedure types,
including combined growable/variadic flags. It failed with `16 != 2` before the
repair. `code-roundtrip-array-flags.jai` checks actual append/free behavior,
fixed-to-slice storage access, distinct type identity, isa/plain values and
variadic arrays. Public edits turn a slice into a growable array, change a fixed
array's length and turn a distinct directive into a plain canonical type. Stale
export-only type results do not override these edits.

The exact copied producer input/modifier reproduces the old distinct-array
overload failure. Its unchanged-body modification now completes and an added
compile-time call executes the modified procedure. Optional test-only source
constants select native child output and O0/O2; the default NO_OUTPUT workflow
and required completion assertions remain intact.

Actual ARM64 O0/O2 executions pass for both the reconstructed type/edit program
and the modified producer child. Native child tests use the documented crash
backtrace OFF option because that archive is a separately owned prerequisite;
assertions remain enabled. Optimized WASI reconstruction execution passes too.
Scoped core/layout/reflection/modules/interception/CLI and library-root/overload
lint regressions, strict lint, formatting and clippy pass. Evidence is retained
under `artifacts/compiler-mac-repairs/array-flags-*`.

Full modules-enabled profiler replay remains with foundations/integration. This
checkpoint does not implement new type syntax, define arbitrary invalid flag
combinations or expand copied-body ownership. The independent deferred-call
checkpoint overlaps compiler export code; integration must retain both owners'
changes and regression tests when reconciling it.
