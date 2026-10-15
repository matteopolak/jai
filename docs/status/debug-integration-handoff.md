# Debug isolated integration handoff

Ownership was explicitly reassigned to Debug's31 public function names after Debug_Info completed. The scope manifest and inventory are current. Prior Debug_Info commits remain preserved; this worker used only reviewed clean candidate `7467b49d` for the newer Debug spec and compared its independently authored Debug production paths. No other checkout, original source/history, reference compiler or external build cache was accessed.

Apply the conventional commits in order after the prior Debug_Info checkpoint:

- `b6d52ef6` — owned once-per-location breakpoint attempts, original SDK trap-count oracle, reassigned scope and precise contract questions.
- `d34c1a74` — Windows init/lifecycle/logger integration, canonical public ignored_asserts storage, and reviewed race correction with native-owned context snapshots on Unix and Windows.
- The following documentation checkpoint adds the combined runner/evidence and this handoff; no additional production behavior.

Production ownership is `stdlib/Debug/module.jai`, private `debug-native.jai`, `debug-lifecycle.jai`, `debug-assert-storage.jai` and `debug-native/*`. The façade now loads lifecycle for Windows too and loads canonical assertion storage. No Generator/model production file, compiler duplicate check or production Context addition is changed. Graphics configuration must use a shared unparameterized owner when its exact parameter shape is supplied. Keep peer generator-context ownership intact.

`python3 tools/check_developer_debug_public.py` exited0 on the final production tree at `d34c1a74`. It runs actual Mac traced/untraced interpreter/native O0/O2 breakpoint workflows; public lifecycle/table/output/probe/backtrace/default-assert/abort effects; original SDK context-ownership/concurrency/fatal callback native O0/O2; strict format/lint; original Windows SDK x64 DLL/executable O0/O2 and arm64 object builds/public checks; and the preserved20-fixture Debug_Info public SDK/parser suite. Local command results are in [machine evidence](../native/debug-public-evidence.json); Windows build/source/header hashes are in [Windows evidence](../native/developer-tools-windows-debug-evidence.json). Use the assigned T7 CARGO_TARGET_DIR; build the repository's own jaic/jailint first if needed. No reference binaries are used.

Native Windows/Linux execution remains pending. Cross-builds and target checks are explicitly not native evidence. Fatal/asynchronous foreign-thread callbacks run native only. Android is unavailable as a compiler CLI target; WASM detection type-checking passes. Detailed policies, context-pointee lifetimes and non-equivalence limits are in [the runtime documentation](../debug-public-runtime.md).

22 names have implementations; the coordinator's accepted classification remains2 complete/20 partial/9 missing when native/configuration evidence is distinguished. Every missing name has an exact mapped unresolved dependency in [the question ledger](../specs/questions/debug-impl.md): attachment launch (`attach_to_debugger`, `os_attach_to_debugger`, `break_assert`); graphics parameter/dependency (`interactive_assert`, `os_show_assert_dialog`); dump state/path/ownership and crash-thread policy (`get_written_minidump_filename`, `set_minidump_state`, `write_minidump`, `init_crash_handler_thread`). Assertion Boolean/response and handler restoration questions are resolved and are not blockers. Questions were notified in the local worker inbox because agent_message is unavailable.

All owned production/tests are committed. Supplied unrelated AGENTS/context/generator-spec/corpus edits and the coordinator's reassigned-scope input remain untouched. No remote push, tag/release operation or external integration checkout was used.
