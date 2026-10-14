# Basic public surface audit

Reviewed input: `specs/stdlib/modules/basic.md`, including conditional
declarations and module parameters. Production implementation is the Basic
facade and `stdlib/internal/basic`; legacy tests and reference sources are not
API inputs. This is a declaration/signature audit, not proof of all behavior.

## Closed in the current batch

These entries have real implementations and behavior tests. Unresolved exact
edge/presentation policies are retained below and in the questions document;
this does not declare full Basic compatibility complete.

- `log` and `log_error`: both format-first and section-first overloads, exact
  parameter names/defaults, contextual source identifier and logger data,
  caller or explicit location, flag bits/user flags, original section pointer,
  and temporary formatted messages. Error overloads add ERROR while retaining
  other bits. Public aliases preserve the entire overload sets.
- `get_integer_range` and `clamp_to_another_integer_type`: supported integer
  widths, signed minima/unsigned maxima, and saturating cross-sign changes.
- `enum_names`, `enum_values_as_s64`, `enum_values_as_enum`: reflected order and
  values. Name and s64 views alias canonical reflection storage; typed values
  need width-correct materialization and currently use temporary storage.
- Builder sequence output, byte output and prefix consumption now execute
  through shared rendering/native output; field lookup follows using members,
  enum ranges inspect actual reflected values, and slice array resizing grows
  real storage while preserving live elements and running initializers.
- Both stack-trace packing overloads copy node storage and repair its links;
  string/print/log helpers render actual frame metadata and contextual logging.
  Sampling hides its own helper frame and snapshots the caller head before
  allocations/calls can alter the active line number.

Original regressions exercise callback effects, nested context restoration,
default stdout/stderr routing, temporary message storage, numeric boundaries,
and reflection storage identity. The runner includes them in host/WASI and
unused-code checks alongside the formatter/configuration suite.

## Genuine outstanding owned gaps

These are reviewed public declarations, not invalid legacy conveniences.
Missing exports are not replaced with inert bodies.

| Responsibility | Outstanding declarations / contracts |
| --- | --- |
| Reflection | `IsScalar`; type membership needs review. Field/range helpers now exist, with exact miss/empty/unsigned policies awaiting confirmation. |
| Allocation/arrays | `get_capabilities`, `remember_allocators`, `resizable`; allocator name protocol and traversal/ownership rules need review. Both array_resize overloads now execute. |
| Scalar overloads | Variadic `min`/`max` are absent; two-argument overloads exist. Preserve the reviewed `#modify` contract and supported kinds when implemented. |
| Stack traces | No missing names; exact text, helper-frame inclusion and returned storage lifetime still need confirmation. Current implementation has real owned nodes/strings and preserves linked-frame order. |
| Leak reporting | `Procedure_To_Elide`, `Leak_Report_Options`, `Leak_Report`, `Leak_Summary`, `Group_Info`, `Preamble`, bookkeeping/table/frame helpers, baseline/exemption/ownership helpers, `report_memory_leaks`, `make_leak_report`, `log_leak_report`, report `deinit`. Baseline/exemption effects are now specified; full report/table/pool/trace integration is not implemented. Live-allocation checking is distinct from leak scanning. |
| Visualization | `vis_init`, `maybe_add_string`, `vis_update_if_it_has_been_long_enough`, `vis_update`, `vis_fini`; per-frame textual snapshots do not supply these missing APIs or establish the native visualization protocol. |

## Preserved portable responsibility

Time/calendar/native-runtime work belongs to the portable worker. The facade
currently lacks `ConvertToApollo`, calendar string helpers, `to_apollo`, current
consensus/monotonic time, FILETIME/timespec conversions, calendar conversions,
and `seconds_since_init`. Platform-native declarations also require conditional
audit there (`store_in_integer`, IID/LPVOID, Darwin types/symbol lookup and
`noErr`). Existing Apollo/argument/runtime additions were preserved; no peer
checkout was modified.

## Review needed for implemented behavior

The logging declarations and contextual types define the dispatch surface,
but the synchronized Basic page has no logging-specific behavioral paragraph.
Current logging forwards all flags and does not impose an extra
`context.log_level` filter, append a newline, or replace the contextual logger.
Message storage is temporary, matching `tprint`. Review should explicitly
confirm these choices, null-logger behavior and failure behavior. Typed enum
array lifetime also needs explicit confirmation. See the focused questions.

Name matching does not prove completeness: overload gaps and conditional
declarations are separately recorded. Full corpus and auto-import ranking CI
verification belong to coordinator integration.
