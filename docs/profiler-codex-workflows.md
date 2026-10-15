# Iprof/Codex implementation and verification

All139 reviewed public names /144 declaration variants are implemented. The
52 Iprof and17 Codex callable names have production bodies, including automatic
instrumentation, runtime/history/report operations, callbacks, actual compiler
metrics, lifecycle and v2 wire serialization. Iprof.message's former partial
status is closed after real modules-enabled native O0/O2 execution passed.

## Iprof implementation

The CLI plugin uses canonical compiler callbacks, public mutable syntax records,
procedure liveness and late source insertion. It instruments the configured
entry point and eligible bodies, respects expression-count minimums and
-modules, and retains the reviewed unconditional exclusions. Its generated
deferred zones survive early return. add_hook forwards actual callback argument
text; native tests check callback effects and Unicode filename/line forwarding.
The private predicate/hook configuration cannot be reached through the reviewed
public base plugin type; no setter, cast or extra parameter is invented.

Native startup calls ordinary library procedures before the configured entry
point. Generated instrumentation now has a private per-context collection
lifecycle: disabled before entry-point zone setup, enabled after setup, disabled
before final reporting. Each generated prefix preserves the runtime guard,
combines it with this collection state for the ordinary guarded macro, then
restores it. Procedures remain instrumented, including crash-handler startup;
no source/name filter removes them. Direct public zone operations and manual
Automatic_Zone_Guarded behavior are unchanged. This independently chosen
collection-window policy is recorded for precise compatibility review.

Zone entry now guards its entire runtime operation, including initialization,
validation and assertion formatting. Previously a pre-entry invalid-zone
assertion recursively instrumented Basic.assert_helper until native stack
overflow. After the whole-operation guard was added, the pre-entry lifecycle
failure became explicit and was repaired at the generated collection boundary.
The regression invokes the real assertion helper under a recoverable contextual
handler and verifies its callback effect and measured call. Successful asserts
do not call the failure helper; the test no longer assumes otherwise.

Runtime collection uses real monotonic counters and the canonical persistent
Pool. Self ticks propagate through distinct zones on a stack chain without
recursive duplication. Counter calibration, three smoothing slots, second
moments and frame rings produce measured flat/call-graph reports. Public node
hashing, duplicate insertion/reset and traversal follow reviewed behavior.
Reports and highlevel pointers use temporary storage and expire on reset.
Report times and writer thresholds are milliseconds.

Config uses canonical Math vector types and reviewed defaults. Rendering
callbacks receive actual report rows, history curves, cursor markers and scales.
Unset defaults emit the reviewed diagnostics. History-disabled configurations
retain current reports and display disabled history. Graphics/history exports
follow USE_GRAPHICS and DO_HISTORY. Manual and guarded automatic zones use the
same canonical runtime. Zone metadata survives plugin shutdown until the next
successful session replaces it using its recorded allocator. One active plugin
per configured module is the documented independent concurrency policy; serial
sessions are verified.

## Codex implementation

The actual +Codex CLI collects compiler files/imports/bodies in received order,
replaces repeated body identities, computes real syntax metrics and writes v2
records. num_expressions uses canonical compiler metadata. Conditional scoring
handles ordinary/chained/braced/ifx/static and switch cases. Allocation metrics
recognize reviewed Basic names and their canonical independent producer owner.

The wire format uses magic0x05040003, version2, little-endian canonical layouts
and Relative_Pointers.Relative_String(s16). Inline strings have excluded-NUL
counts and field-relative signed displacements. Writers check representability;
the reader validates counts, bounds, indices and terminators before exposing
borrowed record views. deinit releases owned pointer arrays, not supplied memory.
Scalar guards, sticky read errors, six short-count types and owned/borrowed
strings have original regressions. Generation timestamps use the host clock.
Revision/reserved values are initialized; the optimization tag remains
non-authoritative because the canonical build options supply no corresponding
Optimization_Type value.

Safe malformed-input checks are stronger than undefined reviewed source paths.
Generic string get returns a valid count; short-string allocate is honored.
Explicit empty export paths really fail rather than silently choosing defaults.
Communication values are copied and actual write errors reach the logger.

## Dependencies, configuration and verification

Approved clean compiler9b3d4932 is built unchanged in the owned snapshot
target/profiler-compiler-source-9b3d4932 using only the assigned T7 Cargo target.
The snapshot contains own independent stdlib plus exact approved compiler-owned
Compiler/Program_Print/Code_Visit public/private sources. Canonical other-owner
modules and peers are not edited. --stdlib selects that production dependency
snapshot; the runner checks every owned source is byte-identical to this tree.

```sh
python3 tools/check_profiler_codex.py --jaic /Volumes/T7/codex-builds/jai-cleanroom-01a137eb/foundations/target/debug/jaic --jailint /Volumes/T7/codex-builds/jai-cleanroom-01a137eb/foundations/target/debug/jailint --stdlib "$PWD/target/profiler-compiler-source-9b3d4932/stdlib"
```

The final report target/profiler-codex-checks.json records198 commands,
complete=true and zero required failures. Six intentional option/scalar
rejections retain their required diagnostics. All22 cases pass interpreter and
native Mac O0/O2. All four real profiler CLI module-toggle build/run combinations
pass; enabled runs verify positive calls to alloc/free/assert_helper/child_call,
actual child timing, inclusive main timing and excluded runtime-sensitive names.
Codex CLI exports, two native C wire consumers, hook/expression-boundary children
and all16 generated configuration children pass. Unchanged real jaifmt is
source-built and formatting/idempotence checks pass. Full owned module-root and
supported fixture lint passes -D warnings without allow rules or exclusions.

Actual edited code executes in the compiler interpreter through the public
child-workspace plugin lifecycle and #run; CLI plugins explicitly reject -interp.
The nine-command dependency replay passes every retained original reduction,
the interpreted modules workflow and a native emitted-LLVM build/run. Generated
LLVM retains the original byte store, alloc/free, zone entry/exit and instrumented
startup init. Reports and sources remain local; only Cargo artifacts use T7.

Native Windows/Linux execution remains pending; existing target probes are
source-only evidence. No optional target/performance expansion is claimed.
The other tooling owner's shared runner still expects two obsolete Codex metric
rejections; integration must replace those with the reviewed positive tests.
See [compiler/dependency handoff](profiler-codex-compiler-handoff.md),
[owned inventory](status/implementation-remaining.json), and
[remaining policy questions](specs/stdlib/profiler-codex-questions.md).
