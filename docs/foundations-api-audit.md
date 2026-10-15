# Basic public surface audit

Reviewed input: `specs/stdlib/modules/basic.md`, including conditional
declarations and module parameters. Production implementation is the Basic
facade and `stdlib/internal/basic`; legacy tests and reference sources are not
API inputs. This is a declaration/signature audit, not proof of all behavior.

## Closed in the current batch

These entries have real implementations and behavior tests. The newest review
batch resolves their ordinary and edge contracts; remaining precise questions
are recorded separately. Full Basic completion is still in progress.

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
- Sequence output uses nested/default rendering (including quoted strings),
  byte output uses FormatInt base 16 and a final newline, and consumption copies
  bytes with negative/oversized failure preserving input. Field misses return
  null/zero; empty enum ranges return zero/zero. Slice resizing reallocates on
  shrink/growth, preserves live elements and runs requested initializers.
- IsScalar and variadic min/max/clamp #modify guards implement the reviewed
  integer/float/pointer/enum membership, excluding bool. remember_allocators
  writes the pointed-to allocator field; resizable owns the original slice
  storage and records the selected allocator only when requested.
- Both stack-trace packing overloads copy node storage and repair its links;
  string/print/log helpers render exact reviewed frame text and skip nodes with
  no metadata. Strings and their dynamic array use temporary storage; printing
  uses low-level runtime output without allocating or invoking the logger.
  Sampling hides its own helper frame and snapshots the caller head before
  allocations/calls can alter the active line number.
- Leak types preserve all reviewed field layouts. Real allocation/trace
  records implement baseline/exemptions, status-1 misuse termination, global
  segment scanning, reachability/interior pointers/cycle-safe ownership,
  grouping, trace trimming, descending byte summaries, owned cleanup and
  logging. Visualizer mode skips both scans and includes pre-baseline objects.
  Module-qualified matching remains explicitly unsupported pending metadata
  mapping review; diagnostic/reporting is not claimed fully complete there.

Original regressions exercise callback effects, nested context restoration,
default stdout/stderr routing, temporary message storage, numeric boundaries,
and reflection storage identity. The runner includes them in host/WASI and
unused-code checks alongside the formatter/configuration suite.

## Genuine outstanding owned gaps

These are reviewed public declarations, not invalid legacy conveniences.
Missing exports are not replaced with inert bodies.

| Responsibility | Outstanding declarations / contracts |
| --- | --- |
| Allocator capability | `get_capabilities`: capability/name behavior is specified, but the Allocator_Proc name-out ABI still needs an exact convention. |
| Debugger macro | `Preamble`: exact caller-scope effects are still absent from the supplied contract. |
| Leak reporting | No missing ordinary names besides Preamble. Module-qualified frame matching needs source/module identity mapping; current explicit diagnostics are not full support. |
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

The latest logging paragraph confirms the implemented contextual dispatch,
temporary lifetime, no extra verbosity filtering/newline/null-logger check,
and suppression of empty messages. Typed enum-array lifetime is also resolved.
Remaining review questions concern CAPS name-out ABI, Preamble, module-qualified
frame identity and exact leaf/root trimming boundaries. Conservative scanner
and ownership heuristics are implementation policy under the reviewed contract.

Name matching does not prove completeness: overload gaps and conditional
declarations are separately recorded. Full corpus and auto-import ranking CI
verification belong to coordinator integration.
