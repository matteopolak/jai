# Foundations deviations and remaining limits

Review scope: owned Basic builder/formatter, String utilities, scalar Hash,
File_Utilities, focused tests and unchanged repository jaifmt integration.
This is a deviations inventory, not a claim of completed production integration.

- **Logging policy review** — `internal/basic/logging.jai` now implements all
  four reviewed signatures and real contextual dispatch. The synchronized
  reviewed page lists declarations and contextual types but does not specify
  a log-level filter, newline policy, null logger or failure handling. Current
  dispatch forwards flags unchanged (ERROR is added for log_error), adds no
  newline and uses tprint lifetime. Tests prove actual metadata, section/data
  identity, nested routing, temporary backing and default stdout/stderr effects.
  Risk: a later explicit policy may require filtering or a different lifetime;
  focused questions request those exact decisions. No fake logger or missing
  function substitute was introduced.
- **Reflection allocation/lifetime** — `internal/basic/reflection.jai` aliases
  reflected enum name/s64 buffers; enum-typed arrays use temporary copies to
  preserve element width and high bits rather than casting an s64 slice.
  The declaration does not state typed-array lifetime. Current tests prove
  width/value and canonical view identity; review must confirm lifetime.
  Integer range/clamping cover all supported integer widths, with no platform
  fallback or numeric approximation.
- **Public-surface gaps** — the explicit `foundations-api-audit.md` inventories
  remaining owned declarations and overload gaps, including leak reporting,
  stack traces, output helpers and reflection/array helpers. These are real
  unimplemented APIs, not dismissed legacy expectations. Existing live-object
  debugging is not counted as full leak reporting. Time/native facade gaps
  are recorded for portable ownership; no peer changes were made.

- **Active style storage** — `internal/basic/format-support.jai` uses a caller
  `context.print_style` extension when present, otherwise a call-local default.
  Reviewed specs declare the style and behavior but no storage hook. No public
  setter/global or prelude field was invented. Tests exercise both paths. Risk:
  the eventual reviewed hook can differ; resolve its exact declaration and
  integrate that hook while preserving reflected type identity.
- **Memory debugger scope/performance** — all five exact reviewed parameters
  now propagate, including the constrained replacement type and canonical
  sentinel interface. The reviewed default interface's four inline no-op hooks
  are normative contract declarations, not substitute debugger functionality.
  The sentinel selects real live allocation/heap ownership tracking;
  replacements retain canonical type/storage identity. Core alloc/realloc/free,
  arrays, builder buffers and temporary backing pages route actual callbacks.
  Failed resize retains the old live object and emits no false free/alloc event.
  A synchronized linked registry detects ownership mismatches and duplicate
  live registration. Lookup is linear in live objects; metadata is reclaimed
  on free/heap destruction. Metadata uses raw default-allocator calls
  to prevent recursive instrumentation. External/raw allocations are not
  automatically instrumented, and unknown frees are allowed because another
  Basic configuration may have allocated them. Temporary bump objects are
  excluded from default tracking; their physical backing pages are tracked.
  Longer-term improvements: indexed metadata and runtime/implicit-allocation
  instrumentation coordinated with compiler/runtime ownership. No exact
  full-process leak-scanning support is claimed. A retired-address tombstone
  design was removed after an original deterministic allocator-reuse regression
  exposed false rejection across Basic configurations; that regression passes.
- **Memory visualization transport** — VISUALIZE controls actual per-frame
  block/byte counters and the reviewed frame-update hook publishes a textual
  snapshot through context.logger without allocating its own formatted string.
  False suppresses that work/output; replacements own their implementation.
  This is independently designed text visualization, not an implemented native
  GUI/remote visualizer protocol. Reviewed specs do not define that transport;
  precise expected transport is a focused question. Tests prove real counts,
  flag effects and callback-scoped message lifetime. The old unsupported-debugger
  guard and its negative fixture are removed after hook review/implementation.
- **Resolved module interface constraint validation** — the earlier compiler stripped
  polymorphic module-parameter types without validating their interface member
  contract when unused. Correct provided interfaces worked and missing members
  failed when invoked, but invalid unused replacements were accepted. Minimal
  independent pending/module-interface-constraint with its helper module proves
  this without Basic. Proper general compiler fix is binding-time structural
  constraint validation, not library-specific name checks or weaker signatures.
  Source declares the exact interface constraint; no workaround was introduced.
  Resolved through NEW producer validation: the unused replacement now rejects
  at binding time with its missing member, and valid interfaces still pass.
  A second discovered bypass accepted unknown system-module parameters and
  arguments to headerless modules. NEW producer exact-argument validation now
  rejects both, with no provenance exemption. Required independent rejection
  gates preserve these regressions; no local compiler patch was made.
- **Temporary stamping cost** — `temporary.jai` stamps rolled-back bytes with
  SET_STORAGE_MARK_STAMP, reset initial storage with RESET_STORAGE_STAMP and
  overflow payloads before free with FREE_PAGE_STAMP. When later pages are
  dropped, stamping the retained page extends to its capacity because public
  page records carry no earlier occupancy. This touches unused managed tail
  bytes too, preserves every live byte before the mark, and can cost additional
  bandwidth with the debugging option on. Tests inspect retained bytes and
  overflow payloads before the allocator releases them. A private occupancy
  side table could reduce that work without changing public record layout.
- **Generic type names** — NEW compiler metadata now supplies instance-local
  declared defaults evaluated with preceding actual bindings. Default elision
  is implemented using reflected values, including value comparisons rather
  than string-pointer/padding identity. Required parameters remain, true includes
  defaults, and descriptions carry names. Original dependent/default/string
  tests pass; the formerly pending metadata reproducer is promoted to the suite.
  Empty parameter lists use `Name()` and name/value separators use ` = `;
  exact punctuation beyond the source-like reviewed description remains a
  focused question. No reduced default-filtering path remains.
- **Unsettled rendering details** — the focused questions document lists the
  cursor prose/example contradiction, unknown-enum marker, nonnull procedure
  spelling, corrupt-value strings, may_be_uninitialized, generic type spelling
  and generic description punctuation. Current code follows cursor prose; uses a
  descriptive numeric enum marker, pointer output for procedures, temp storage
  for type_to_string, and assertions for invalid reflected representations.
  These are independently chosen behavior, not established exact compatibility.
  No special recovery is claimed for may_be_uninitialized. Proper fix needs
  precise reviewed contracts and original regressions for the resolved cases.
  Decimal argument indices saturate at signed-s64 maximum on overflow, whose
  behavior is expressly unspecified; this guards arithmetic and indexing.
- **Portable numeric performance** — `numeric-conversion.jai` replaces all
  snprintf/localeconv/strtod imports with original arbitrary-precision integer
  conversion. Finite floats expand exactly as integers times powers of five,
  decimal precision rounds ties to even, and parsing rounds exact decimal/hex
  rationals directly to binary32/binary64, including subnormals. Direct target
  rounding fixes rare double-rounding errors near binary32 halfway/overflow
  boundaries, covered by original exact decimal/hex regressions. Shortest searches 9/17 significant
  precisions and reparses candidates; repeated allocations and integer work are
  deliberate performance costs, not reduced precision. Long inputs use dynamic
  limbs with no fixture-specific limits; extreme exponents classify before
  building enormous powers. Future optimization may reuse buffers/cached powers
  or compute shortest intervals directly while preserving these results.
  Basic-only and real float-formatting WASI binaries have no env imports and
  execute successfully. All 19 supported production WASI cases now pass O0/O2,
  including exact parser/shortest property/configuration/temporary-stamp cases.
  A nearest-decimal-only shortest search was found insufficient at exact normal
  powers of two, whose lower/upper rounding radii differ. It was replaced by
  nearest/ceiling candidate selection at each precision for that entire IEEE
  boundary class, not individual fixtures. Original witnesses first failed and
  now pass. An independent exact-rational sweep validates all 2300 normal power
  intervals and minimum significant digits; native/WASI O0/O2 audit is underway.
  Audit evidence: native O0/O2 each verified all 2300 intervals. Initial WASI
  launch did not execute because the test script omitted .wasm while the compiler
  appended that suffix. The script now names its actual artifact explicitly;
  no implementation fallback, fake imports or dropped cases are involved.
  Final audit exits zero: all 2300 intervals/minimum precisions pass native O0,
  native O2, WASI O0 and WASI O2. The test driver calls real production APIs;
  Python Fraction is an independent exact-mathematics verifier, not another
  Jai implementation or a formatter substitute.
- **Latest compiler context regression** — refreshed producer compiler enables
  generic default reflection but panics in FnCtx.current_context building
  unchanged real jaifmt and running scoped jailint. Scratch contexts set context
  directly without setting context_slot; overload ifx probes reach emit_call.
  Original pending/context-overload-probe reproduces without any library import.
  Proper general compiler fix: initialize context storage consistently for
  scratch/lambda/struct contexts. No producer Rust or peer write is made here.
  Previously source-built unchanged real jaifmt formats/checks current owned
  code, but latest compiler build/lint success is not claimed until retried.
  Resolved on refresh: producer uses set_context at every identified creation
  site. Minimal reproduction now passes, unchanged real jaifmt builds at O2,
  actual CLI/check passes, and scoped source-built jailint -D warnings passes.
  Earlier panic evidence remains above; no local workaround was necessary.
- **Remaining reviewed exports** — scalar fnv1a_hash's word-versus-byte operation
  and sequence/byte/log helper details remain questions; no fake exports were
  added. Basic's wider profiler/debugger/leak helpers are outside the completed
  core subset. String scan/wildcard corner contracts remain in focused questions;
  u64 scan does not support values above signed-s64 range. Risk: incomplete API
  coverage. Proper fix requires reviewed semantics and real implementations.
- **Filesystem/runtime targets** — real Windows implementations are checked
  with unused code on x64/arm64 but never executed here. File_ID_INFO availability
  is required for safe Windows traversal/copy cycle detection; failure propagates.
  Wasm numeric/configuration execution is now being tested, not inferred from
  type checks. Native filesystem tests run on macOS arm64.
  Platform limitations are documented, not counted as runtime passes. Proper
  fix: target-native filesystem/process/tool verification with supported peers.
- **Integration dependencies** — own durable target/foundation-integration
  copies NEW compiler sources and NEW POSIX/Windows bindings read-only; no peer
  checkout is modified. Real jaifmt sources are unchanged, no substitutes or
  legacy library fallback. Expanded macOS x64 cross-check fails on the peer
  POSIX undeclared ipc_perm. The runner preserves failure and continues other
  targets. Proper fix belongs to bindings ownership, followed by full rerun.
- **Verification exclusions** — negative API-rejection and pending semantic
  reproducers are checked explicitly, not included as passing runtime programs.
  Unix File-dependent cases are not requested on Windows/wasm; Windows has its
  own executable fixture requiring a Windows host. Wasm process exit is excluded
  because no Basic.exit export is reviewed there. No lint suppression or test
  assertion weakening was added. Coordinator owns full corpus/release checks.
  The former unsupported-debugger compile-rejection fixture was retired when
  the interface contract and real implementation became available. Current
  invalid replacement/private-import fixtures are formatted/checked and must
  fail compilation; they remain outside positive compiler-backed lint, like
  other compile-rejection cases. The unused-interface reproducer is also a
  mandatory rejection gate and currently fails because the compiler accepts it.

Prior checkpoint evidence: seventeen formatter/core cases and four formatter-assertion
cases passed interpreter/native O0/O2;
unchanged real jaifmt CLI passed check/rewrite/recursion/pruning/stdin/idempotence;
six unused-code targets passed, macOS x64 failed as recorded. Real jaifmt
format/check and warnings-denied source-built jailint passed over Basic's facade,
changed formatter/scalar sources, builder, integer128/parsing, the Windows
filesystem source and changed positive tests, including the
assertion-message regression. The earlier default-metadata failure is now
resolved and the reproducer promoted to the active suite.
The four formatter rejection programs compile successfully and were also
formatted/checked and linted with warnings denied; their assertions execute
in the focused runner. The final assertion fixture uses ordinary assertions
after restoring the default callback and passes the Wasm unused-code check.
The durable focused runner accepts `--jailint` and uses an explicit owned
source inventory for real jaifmt --check and jailint -D warnings. Both checks
pass together with the host execution suite. Historical macOS x64 failures
remain recorded; refreshed NEW binding coverage is checked separately before
claiming that target resolved.

Current evidence: all 24 host cases pass interpreter/native O0/O2; five runtime
rejection cases assert in each mode; all 19 supported production WASI cases
pass O0/O2 with non-WASI imports rejected. Real unchanged jaifmt rebuilt from
production APIs passes CLI and exact owned --check, and source-built jailint
-D warnings passes. The root-constant/configuration distinction additionally
passes interpreter/native/WASI O0/O2 after its final test strengthening.
Fresh unused-code checks pass six targets; macOS x64 still fails overall.
NEW bindings remove the earlier ipc_perm blocker but p_realtimer references
missing itimerval at declarations.jai:3422. No local binding patch or target
exclusion was added. The existing POSIX minimal reproduction continues to
cover this ownership blocker; proper shape/fix belongs to bindings review.

Latest debugger/direct-binary32 batch: all 26 host cases and all 21 supported
production WASI cases pass O0/O2 (host interpreter too), including exact
binary32 halfway/subnormal/overflow vectors. Five runtime assertions, real
unchanged jaifmt build/CLI/check and scoped warnings-denied lint pass. A general
unused-interface rejection gate is retained and fails on current compiler;
overall success is not claimed. Six-target unused-code checks of all newly
affected cases pass. Metadata is live-only after the address-reuse regression;
no tombstone workaround remains.

Follow-up: interface and exact module-argument rejection gates are resolved by
NEW producer compiler sources and checked directly. A shared private native-path
validator now rejects embedded NUL before Unix filesystem/cwd calls, preventing
valid-prefix operations and destination corruption. The original real-file
regression failed before the fix and now passes in the interpreter. Windows
already rejected NUL; its converter now shares the validator. Pure byte path
utilities still preserve their inputs; only native operations reject an
unrepresentable path. Final scope passes: 27 interpreter/native O0/O2 cases,
21 production WASI O0/O2 cases, five runtime assertions, all API/interface/
unknown-parameter rejection gates, real jaifmt build/CLI/check and warnings-denied
jailint. Six targets pass affected unused-code checks; macOS x64 remains blocked
by the peer POSIX itimerval declaration. Both earlier general compiler gates
now pass through producer fixes; overall host/WASI runner exits zero.
