# Foundations public surface audit

Reviewed inputs: Basic, String, Hash and File_Utilities pages under
`specs/stdlib/modules`, including conditional declarations and module parameters.
Production implementations are their facades and independently organized
private services; legacy tests and reference sources are not
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
  Module-qualified matching now uses exact procedure names plus case-sensitive
  source-path substrings. Root trimming consumes only the matching/null suffix;
  leaf trimming retains the first matching frame. Original tests cover repeated
  names, wrong-case paths, retained interior roots, empty traces, missing locations
  and report-owned node/group storage after tracked allocation cleanup.
- All reviewed visualization hook names now have the real version-2 channel
  implementation, with initialization/retry timing, deduplication, definition
  packets, live/alloc/free snapshots, queue-full retry and reader reconnection.
  macOS/Linux shared-memory transport is implemented, with macOS runtime tests
  and Linux unused-code cross-checks. Other producer transports are explicitly
  unavailable. The old textual snapshot path is removed.
- get_capabilities follows the exact zero-size/name-out/null-data convention
  and returns the allocator-owned name view. The owned temporary allocator
  supplies its real static name. Preamble has real native caller-scope flags,
  logger defers, allocator-family exclusions and first-use initialization;
  NEW compiler host/target metadata now makes the cross-compilation early
  return pass the genuine predicate and production WASI regression.
  The NEW portable runtime name-out fix is integrated read-only in selected
  staging and tested through the real default allocator, including borrowed
  storage identity. Pool's provider failure remains a positive failing gate.

Original regressions exercise callback effects, nested context restoration,
default stdout/stderr routing, temporary message storage, numeric boundaries,
and reflection storage identity. The runner includes them in host/WASI and
unused-code checks alongside the formatter/configuration suite.

## Genuine outstanding owned gaps

These are reviewed public declarations, not invalid legacy conveniences.
Missing exports are not replaced with inert bodies.

| Responsibility | Outstanding declarations / contracts |
| --- | --- |
| Debugger macro | No missing name or cross gap: NEW compiler host constants resolve the earlier failure, and the genuine WASI predicate/Preamble tests pass. Exact allocator-family matching is still a review question. |
| Wide integer conversions | to_s128/to_u128 exist, but their reviewed #modify source-kind and conversion policies are unspecified. The current cast-based bodies have no guard; precise questions are recorded rather than calling them exact signatures. |
| Division exercise | test_unsigned_division is genuinely missing. Inventory gives parameters/defaults but no random-callback/null policy or platform-condition detail beyond its Windows section and CPU.X64 label. Original public-call repro is retained. |
| Hash scalar FNV | fnv1a_hash has a byte overload but lacks the reviewed scalar u64 overload. The exact word-versus-byte operation remains unspecified; original public-call repro rejects. Scalar get_hash and Hash_Table integration are implemented/tested. |
| Leak reporting | Reviewed matching, trimming and report-owned lifetime are implemented. No module-ID metadata dependency remains. |
| Visualization | No missing names. Native macOS/Linux channel is real, executed on macOS and cross-checked for Linux. Windows/WASI shared-memory producers remain unavailable and are diagnosed explicitly. |

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
Remaining review questions concern wide conversions, scalar FNV, the division
exercise and exact allocator-family matching. Preamble requires
a real host/target compiler distinction, now provided by the NEW producer.
Conservative scanner
and ownership heuristics are implementation policy under the reviewed contract.

Name matching does not prove completeness: overload gaps and conditional
declarations are separately recorded. Full corpus and auto-import ranking CI
verification belong to coordinator integration.

The latest array review also found a real ownership bug in bulk append: an
input view into the destination could be invalidated mid-loop by growth.
The new path captures/rebases such views after a single reserve and copies
overlapping storage in the safe direction. Nonoverlapping copies retain memcpy.
Original moving/poisoning allocator tests cover full self-append, interior view
append, empty append and overlapping/self copy.

## Other owned facades

String and File_Utilities have all reviewed ordinary declaration names, including
conditional aliases; Hash has every reviewed name but the scalar overload gap
above. This audit checks overload bodies as well as facade aliases. String
signatures/defaults and observed reviewed quirks are covered by original token,
search/split/path/scan tests, including view identity and partial failure effects.
Its unspecified wildcard/scan conversion edges remain questions, not invented
compatibility claims. File_Utilities preserves Path/File_Visit_Info field order
and Unix aliases, uses real Unix/Windows filesystem backends, and returns actual
failures. Native filesystem execution is macOS; Windows behavior is cross-checked,
not executed. WASI supports portable path operations; native filesystem/channel
runtime coverage is not claimed. File visitation edge policies remain explicitly
documented while review is pending. Private aliases/helpers are not facade exports.

The driver positively checks the two unresolved public-call reproducers and
retains their failure in its overall result. They are not classified as expected
negative API tests or included in completed functionality counts.
