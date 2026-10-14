# Basic public surface audit

Reviewed input: `specs/stdlib/modules/basic.md`, including conditional
declarations and module parameters. Production implementation is the Basic
facade and `stdlib/internal/basic`; legacy tests and reference sources are not
API inputs. This is a declaration/signature audit, not proof of all behavior.

## Closed in the current batch

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

Original regressions exercise callback effects, nested context restoration,
default stdout/stderr routing, temporary message storage, numeric boundaries,
and reflection storage identity. The runner includes them in host/WASI and
unused-code checks alongside the formatter/configuration suite.

## Genuine outstanding owned gaps

These are reviewed public declarations, not invalid legacy conveniences.
Missing exports are not replaced with inert bodies.

| Responsibility | Outstanding declarations / contracts |
| --- | --- |
| Builder output helpers | `print_sequence_to_builder`, `print_bytes`, `consume_u8_and_length`; sequence separators, byte interpretation/output and consume semantics need review. |
| Reflection | `get_field`, `IsScalar`, `enum_highest_value`, `enum_range`, `enum_range_given_info`; using-member lookup/miss behavior, scalar membership, empty/unsigned enum ranges need review. |
| Allocation/arrays | `get_capabilities`, `remember_allocators`, `resizable`; allocator name protocol and traversal/ownership rules need review. Slice-pointer `array_resize` is absent although the resizable-array overload exists. |
| Scalar overloads | Variadic `min`/`max` are absent; two-argument overloads exist. Preserve the reviewed `#modify` contract and supported kinds when implemented. |
| Stack traces | Both `pack_stack_trace` overloads, `print_stack_trace`, `log_stack_trace`, `get_stack_trace_strings`; frame order, text and storage lifetime need review. |
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
