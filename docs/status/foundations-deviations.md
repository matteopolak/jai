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
- **Assertion configuration** — `internal/basic/builder.jai` conditionally
  uses module-visible ENABLE_ASSERT, otherwise omits ensured_count. Basic's
  assertions remain enabled; the reviewed discard variant is not implemented.
  Specs do not state the module/program parameter signature, default or
  propagation. The pending builder-assert-configuration fixture proves a root
  constant does not configure imports. Risk: layout/configuration mismatch.
  Proper fix: review that declaration, propagate it through the private module
  and select the discard overload and conditional layout together. Assertion
  message argument formatting is implemented separately and tested.
- **Generic type-name defaults** — `format-type-names.jai` diagnoses attempts
  to omit matching defaults for an instantiated generic instead of ignoring
  the option. The NEW compiler emits specified_parameters but the generic
  template descriptor contains no parameters/default storage. Original pending
  formatter-parameter-defaults fixture fails its parameter-count assertion.
  Proper fix belongs to the compiler worker: emit complete parameter default
  metadata and storage, then implement reviewed equality/elision spelling.
- **Unsettled rendering details** — the focused questions document lists the
  cursor prose/example contradiction, unknown-enum marker, nonnull procedure
  spelling, corrupt-value strings, may_be_uninitialized, generic type spelling
  and type_to_string lifetime. Current code follows cursor prose; uses a
  descriptive numeric enum marker, pointer output for procedures, temp storage
  for type_to_string, and assertions for invalid reflected representations.
  These are independently chosen behavior, not established exact compatibility.
  No special recovery is claimed for may_be_uninitialized. Proper fix needs
  precise reviewed contracts and original regressions for the resolved cases.
- **Native float dependency/performance** — `format-float.jai` uses public C
  snprintf/localeconv and existing strtod parsing. Shortest conversion searches
  up to 9/17 significant precisions, with allocations per candidate. Precision
  is limited to native signed-int range, and libc rounding/locale is observable.
  Risk: allocation cost, target libc differences and concurrent locale changes.
  Host real runtime tests pass; cross-checking proves types only. Long-term:
  an independent exact conversion algorithm with reviewed tie/form selection,
  fewer allocations and no global locale dependency. ABI sources are documented
  in foundations-native-abi.md; this is not a reference implementation dependency.
- **Remaining reviewed exports** — scalar fnv1a_hash's word-versus-byte operation
  and sequence/byte/log helper details remain questions; no fake exports were
  added. Basic's wider profiler/debugger/leak helpers are outside the completed
  core subset. String scan/wildcard corner contracts remain in focused questions;
  u64 scan does not support values above signed-s64 range. Risk: incomplete API
  coverage. Proper fix requires reviewed semantics and real implementations.
- **Filesystem/runtime targets** — real Windows implementations are checked
  with unused code on x64/arm64 but never executed here. File_ID_INFO availability
  is required for safe Windows traversal/copy cycle detection; failure propagates.
  Wasm is type-checked only. Native filesystem tests run on macOS arm64.
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

Latest evidence: seventeen formatter/core cases passed interpreter/native O0/O2;
unchanged real jaifmt CLI passed check/rewrite/recursion/pruning/stdin/idempotence;
six unused-code targets passed, macOS x64 failed as recorded. Real jaifmt
format/check and warnings-denied source-built jailint passed over Basic's facade,
changed formatter/scalar sources, builder, integer128/parsing, the Windows
filesystem source and changed positive tests, including the
assertion-message regression. Pending default-metadata reproduction is formatted
but deliberately remains a failing compiler handoff, not a runtime-suite pass.
