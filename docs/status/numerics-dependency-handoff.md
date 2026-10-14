# Current canonical dependency reproducers

No peer checkout was modified. Source-built compiler:
artifacts/current-target/debug/jaic. artifacts/canonical-current stages new
independent producers and owned numerics, with no fixtures or tool repairs.

`tests/numerics/window_type_reproducer.jai -check` fails on macOS:

```text
Window_Type/module.jai:8: module Objective_C has no exported member NSWindow
```

window-render imports root Objective_C; reviewed/new bindings define NSWindow in
Objective_C/AppKit. Update the canonical consumer and native window messaging
consumers in their owning checkout. Evidence: artifacts/window-type-reproducer.log.
This originally blocked canonical Simp/GetRect. The window-render owner corrected
the AppKit import while this pass was active; restaged source now passes this
reproducer (artifacts/window-type-reproducer-current.log). The failure evidence
is retained. No numerics facade workaround or invented NSWindow export was added.

## Foundation WASM formatting

tests/numerics/wasm_format_reproducer.jai imports only Basic and formats 1.25.
With the correctly ownership-filtered canonical foundation it builds, but actual
WASI execution fails before main:

```text
wasm link error: missing imports env.localeconv, env.snprintf, env.strtod
```

Build with -os wasm -O2 and run through tools/wasi_run.mjs. Evidence:
artifacts/wasm-format-reproducer-build-current.log and
artifacts/wasm-format-reproducer-current.log. The earlier pre-filter staging log
used a stale Basic snapshot and failed differently; it is preserved as initial
investigation evidence, not current production behavior. Foundation/compiler
must implement portable formatting/parsing or supported host bindings. No fake
host functions, missing assertions, or alternate formatter were substituted.

## Direct binary32 intrinsics

tests/numerics/intrinsic_f32_reproducer.jai is a language-only intrinsic test.
Current -interp fails on sqrt(float32(9)) == 3; -check succeeds. Evidence:
artifacts/f32-intrinsic-current.log and artifacts/f32-intrinsic-check.log.
Math's promotion/narrowing wrappers remain necessary pending the compiler's
general intrinsic return/argument-width fix; no symbol/module special cases are
requested. Native behavior will be checked independently.

## Cross-target dependency gates

tests/numerics/simp_target_reproducer.jai with -check -no_dce -os windows reaches
the producer's explicit unsupported filename-font/File branch. The same general
full check on macOS x64 reaches missing POSIX.itimerval. Default UI imports on
WASM reach Window_Type's explicit unsupported-target assertion. See current
canonical suite logs; these are failures, not skipped supported configurations.
Window/input-pump behavior and canonical native backend fixes remain owner work.
