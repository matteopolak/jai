# Foundations deviations and remaining limits

Review scope: owned Basic builder/formatter, String utilities, scalar Hash,
File_Utilities, focused tests and unchanged repository jaifmt integration.
This is a deviations inventory, not a claim of completed production integration.

- **Active style storage** — `internal/basic/format-support.jai` uses a caller
  `context.print_style` extension when present, otherwise a call-local default.
  Reviewed specs declare the style and behavior but no storage hook. No public
  setter/global or prelude field was invented. Tests exercise both paths. Risk:
  the eventual reviewed hook can differ; resolve its exact declaration and
  integrate that hook while preserving reflected type identity.
- **Memory debugger interface** — reviewed Basic now gives five parameters.
  The facade/private module propagate MEMORY_DEBUGGER=false, ENABLE_ASSERT=true,
  VISUALIZE_MEMORY_DEBUGGER=true and TEMP_ALLOCATOR_OVERWRITE_MEMORY=false.
  ENABLE_ASSERT controls both Buffer layout and the discard assert declaration;
  temp stamping executes when enabled. MEMORY_DEBUGGER=true diagnoses missing
  reviewed Memory_Debugger_Interface shape. The typed REPLACEMENT_INTERFACE
  parameter cannot be declared faithfully without that shape and remains absent;
  no fake interface or accepted-but-ignored replacement parameter was added.
  Proper fix: review interface fields/procedures, implement real debugging and
  declare the exact fifth parameter. VISUALIZE has no effect while debugging
  is disabled, as reviewed. Configuration tests verify default/on type identity,
  on/off Buffer sizes and ensured counters, and zero discarded side effects.
  Latest synchronized review now supplies the four-hook defining shape. The
  unsupported guard is a temporary checkpoint only; exact replacement parameter
  and real enabled notification routing are the next implementation batch.
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
  rationals to binary64, including subnormals. Shortest searches 9/17 significant
  precisions and reparses candidates; repeated allocations and integer work are
  deliberate performance costs, not reduced precision. Long inputs use dynamic
  limbs with no fixture-specific limits; extreme exponents classify before
  building enormous powers. Future optimization may reuse buffers/cached powers
  or compute shortest intervals directly while preserving these results.
  Basic-only and real float-formatting WASI binaries have no env imports and
  execute successfully. All 19 supported production WASI cases now pass O0/O2,
  including exact parser/shortest property/configuration/temporary-stamp cases.
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
  The compile-rejection fixture basic-memory-debugger is formatted/checked and
  required to produce the explicit unsupported-interface diagnostic. It cannot
  pass compiler-backed lint because its purpose is a compile-time rejection;
  it is kept outside the positive lint inventory, like the API rejection cases.

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
