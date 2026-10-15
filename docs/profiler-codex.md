# Iprof and Codex initial checkpoint

Superseded by [active workflow progress](profiler-codex-workflows.md). This
records the earlier 4fe1e621 checkpoint; its missing-contract statements and
function counts are historical checkpoint status, not the current audit.

This worker owns only Iprof/Codex and their corresponding private sources,
original fixtures and documentation. Neither module is complete. The original
41/14 pending function-name ledger becomes **39 Iprof / 13 Codex** after the
runtime traversal, report-mode setter and helper cleanup added here. Counts
combine overloaded names and are not a behavioral completeness measure.

## What changed and how

Codex now exposes Header_Record, Module_Record, File_Record, Procedure_Record,
Revision_Control_Type and Codex_Help with reviewed members and alignment.
Loaded private files define these records in the canonical Codex module scope:
there are no duplicate wrapper types. Apollo_Time is Basic's type,
optimization/procedure/module tags are Compiler's types, OS is the prelude tag,
and relative strings are Relative_Pointers.Relative_String(s16). This type
identity does not decide the unresolved file encoding.

deinit releases only the three allocated pointer-index arrays and clears the
helper. It never releases borrowed serialized memory or record/string targets.
It uses the current allocator, which must be the allocator of those arrays.
Empty/repeated cleanup makes no allocator calls. The original allocator fixture
observes exactly three non-null frees and preserves caller memory.

Iprof now exposes Zone_Info, Graph_Scaling, GraphLocation, the reviewed
NUM_THROWAWAY_UPDATES/INT_ZERO_THRESHHOLD/FRAME_TIME_INITIAL constants and the
previously absent mutable state declarations with their specified initializers.
Identical configured imports share actual storage; distinct parameterized
imports keep independent storage. set_report_mode writes that canonical
displayed_quantity storage. Frame aggregation and rendering remain pending;
exported state is not counted as those behaviors.

traverse invokes a real callback once per recorded profiling node. It snapshots
the persistent node pointers using the runtime's captured allocator, releases
the snapshot on return, and does not expose or visit the synthetic root. A
callback may record additional zones and replace the hash table without
invalidating this snapshot. Before runtime initialization the set is empty.
This is an independent iteration design; no particular order, multithread
safety or reference-specific mutation convention is claimed. The precise
contract request remains open.

The original traversal regression records actual timed zones, forces a hash
resize from its callback, verifies the initial snapshot, then observes all
202 genuine nodes in a subsequent traversal. No fabricated report or timing
sample is used.

## Configuration, dependencies and verification

The module parameters and existing clock/client setup are preserved. Native
profiling uses the existing monotonic POSIX/performance-counter backend.
Compiler interception and liveness mechanisms remain available; this checkpoint
does not claim a completed Iprof instrumentation plugin.

Build jaic-cli and jailint from this checkout. On Mac/Linux build the existing
private crash-runtime dependency with:

```sh
python3 tools/build_portable_runtime.py
cargo build -p jaic-cli -p jailint --offline
python3 tools/check_profiler_codex.py
```

The runner accepts --jaic/--jailint for a separate worker-owned Cargo target
directory. Initial compilation encountered a full workspace volume; this run
used /Volumes/T7/jai-profiler-codex-build for Cargo output. Jai outputs remain in
this worktree's target because compiler execution disallows external output.
No shared dependency manifest or peer implementation was modified.

The runner builds unchanged jaifmt/main.jai, checks format idempotence and runs
jailint -D warnings on all scoped implementation files and the listed tests.
It runs original and existing independent tests in interpreter and native Mac
O0/O2, actually executes the 16 generated manual/graphics/history client
configurations, and source-checks canonical records/traversal on Windows and
Linux x64. Windows/Linux checks are **not native execution evidence**.
Client generation precedes lint because lint consumes its generated source;
there is no exclusion or suppressed warning. Native Windows/Linux remain
integration requirements. Codex external-consumer wire interoperability remains
unverified because the reviewed encoding facts are not present in this snapshot.

## Per-public-API audit

Existing supported Iprof behavior: zone_begin, zone_end, Stack_Push,
init_runtime, count_recursion_depth, clear(History_Scalar), get_value,
set_smoothing, Prepend_To_Main/prepend_main/TO_INSERT client setup,
log_text_report and save_csv_report. New supported functions: traverse and
set_report_mode. Existing explicit-depth/unbalanced/private-runtime rejection
fixtures are preserved. The new runner does not claim to replace full
coordinator release verification.

Actual missing Iprof function names:

- Automatic_Zone, Automatic_Zone_Guarded, Prof_init_highlevel
- get_plugin, before_intercept, add_source, message, finish, shutdown,
  add_hook, init, log_help
- update (both public overloads), create_report, eternity_set
- hash, insert_node, createStackNode, init_zone_hash
- clear_stack, sum_times, update_history, propagate_stack, propagate_to_zone,
  propagate_expanded, compute_heat, report_compare_slot, report_expand_compare
- set_cursor_screen_coordinates, draw, draw_graph, graph_select_sample,
  get_current_graph_scaling, move_cursor, set_cursor, select, select_parent,
  set_frame, move_frame

Config and HELP_STRING remain absent. SPEEDSTEP_DETECTION_RATIO has no reviewed
value in the current module page and remains absent. No zero calibration
threshold or inert graphics callbacks were added. All reviewed mutable-storage
declarations other than that unresolved calibration setting are present.

Existing Codex behavior: get_file_and_module, is_global_ident, canonical Math
alias, Metrics and the straight-line/call/global/loop-depth subset of
collect_metrics. New supported function: deinit; new complete public record
shapes are listed above.

Actual missing Codex function names:

- make_help, dump_file, put (both overloads), get (both overloads),
  put_short_string, get_short_string
- get_plugin, message, finish, shutdown, communication_proc, init, log_help

Codex HELP_STRING is absent. Conditional metric weights and recognized Basic
allocation/free calls still explicitly reject rather than fabricate counts.
These are real remaining behavior gaps even though collect_metrics exists.

## Contract synchronization and integration

[Precise questions](specs/stdlib/profiler-codex-questions.md) separate missing
observable facts from available general compiler mechanisms. The current
module pages do not contain the actual v2 magic/layout or instrumentation
option grammar that the shared questions document calls resolved. Integration
should synchronize those reviewed facts, then implement a real reader/writer
and compiler-event plugin against them. No alternate implementation, old
source, reference execution, fake callback or tool-only library is used here.
