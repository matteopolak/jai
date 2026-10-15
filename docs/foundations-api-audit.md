# Foundations public surface audit

Reviewed inputs: Basic, String, Hash and File_Utilities pages under
`specs/stdlib/modules`, including conditional declarations and module parameters.
Production implementations are their facades and independently organized
private services; legacy tests and reference sources are not
API inputs. This is a declaration/signature audit, not proof of all behavior.

## Closed in the current batch

These entries have real implementations and behavior tests. The newest review
batch resolves their ordinary and edge contracts; remaining precise questions
are recorded separately. No reviewed declaration or overload is missing from
the owned core scope; portable ownership and remaining behavior questions are
kept separate from that export audit.

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
  storage identity. Refreshed NEW Pool now also passes its original null-data
  CAPS call; the positive provider gate remains active.
- Scalar fnv1a_hash performs one whole-u64 XOR/multiply, while its byte overload
  applies that shared step per byte. Vectors verify wrapping, explicit/default
  seeds, named arguments and the deliberate scalar/byte distinction.
- to_s128 and to_u128 now have the exact reviewed #modify guards. Signed
  conversion uses signed-64 sign extension even for high-bit unsigned inputs;
  unsigned conversion accepts only the four built-in unsigned types. Thirteen
  compile-time regressions reject unsupported kinds; signed division uses its
  own private bit conversions instead of widening these public contracts.
- test_unsigned_division is public on CPU.X64 for every OS. Its independently
  chosen deterministic checks always print and verify real divisions; positive
  iterations consume exactly three callback operands. Original tests verify
  zero/negative iteration behavior and an independent Python integer oracle
  checks every printed result in interpreter and native x64 O0/O2 execution.

Original regressions exercise callback effects, nested context restoration,
default stdout/stderr routing, temporary message storage, numeric boundaries,
and reflection storage identity. The runner includes them in host/WASI and
unused-code checks alongside the formatter/configuration suite.

## Owned export audit result and dependencies

All reviewed owned core names and overloads now have real implementations.
This does not claim complete native platform coverage or settle unspecified
formatting/parser policies. No missing export is replaced with an inert body.

| Responsibility | Outstanding declarations / contracts |
| --- | --- |
| Debugger macro | No missing name or cross gap: NEW compiler host constants resolve the earlier failure, and the genuine WASI predicate/Preamble tests pass. Exact allocator-family matching is still a review question. |
| Wide integer conversions | Resolved, implemented and tested with exact guards and casts. |
| Division exercise | Resolved, public for all x64 OS targets, executed in interpreter/native O0/O2 with callback-count and independent arithmetic checks. |
| Hash scalar FNV | Resolved whole-value scalar overload, shared byte step, vectors and real Hash_Table integration. |
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
Remaining review questions concern unspecified rendering/parser/filesystem edges
and exact allocator-family matching. Preamble requires
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

String, Hash and File_Utilities have all reviewed ordinary declaration names and
overloads, including conditional aliases. This audit checks overload bodies as
well as facade aliases. String
signatures/defaults and observed reviewed quirks are covered by original token,
search/split/path/scan tests, including view identity and partial failure effects.
Its unspecified wildcard/scan conversion edges remain questions, not invented
compatibility claims. File_Utilities preserves Path/File_Visit_Info field order
and Unix aliases, uses real Unix/Windows filesystem backends, and returns actual
failures. Native filesystem execution is macOS; Windows behavior is cross-checked,
not executed. WASI supports portable path operations; native filesystem/channel
runtime coverage is not claimed. File visitation edge policies remain explicitly
documented while review is pending. Private aliases/helpers are not facade exports.

The driver retains the original public-call reproducers as positive API checks;
both now pass. The Pool CAPS integration gate also passes after safe producer
refresh. Complete lint and WASI unused-File dependency remain explicit failures,
not weakened gates or fabricated ABI support.
