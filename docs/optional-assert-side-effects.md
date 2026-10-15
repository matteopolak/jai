# Essential operations in optional assertions

This finite audit found 47 current callsites where a necessary operation is an
argument to optional `Basic.assert`. They are configuration-dependent defects:
the normal enabled default still executes the operation. The ASN1/Socket owner
made no peer production changes. Exact expressions, current file/line, file
hash, owner, public contract and verification limits are recorded in
[the scoped audit](status/optional-assert-side-effects.json).

`internal/basic/scalar.jai:10` declares every disabled assertion argument with
`#discard`. An operation inside the condition or message therefore need not run.
The safe general pattern is to execute required work, retain its result, and
then assert or handle failure using that result. Owners should retain their
public error policy; merely moving an operation does not define recovery when
it fails. Assertions on already-computed values are not instances of this bug.

This is a snapshot audit at the report recorded head, not a live count of
remaining defects. Later MPEG, text/keymap and other owner fixes must be reconciled
with per-callsite status and loaded-default regression receipts before closure.

## Reproduced public failures

A fresh compiler was built from this shared tree into the ASN1/Socket T7 scratch
directory `optional-assert-rmskhn9f`. The sanctioned test configuration copies
current clean stdlib and changes only `Basic/module.jai`'s **default**
`ENABLE_ASSERT := true` to `false`. The reproduction imports unparameterized
Basic, GetRect and Keymap, so the default instance used by those modules is
actually disabled. A counter increment inside `Basic.assert` executes once in
the enabled configuration and zero times in the disabled configuration in all
three execution modes. No separately parameterized caller instance is used as
proof. Production's default remains enabled.

| Public API | Enabled default | Disabled default | Actual execution |
| --- | --- | --- | --- |
| `GetRect.append_text` after `set_text("a")`, appending `"b"` | `"ab"` | `"a"` | Interpreter, Mac ARM64 native O0/O2 |
| `Keymap.save_to_file(*Keymap, ...)` | File created | No file | Mac ARM64 native O0/O2 |
| `Keymap.save_to_file(*Keymap_Set, ...)` | File created | No file | Mac ARM64 native O0/O2 |

The interpreter control and text result are verified; interpreter host-file
presence is not established by this experiment. Native file checks use separate
fresh working directories. `reproduce.py`, `reproduction-receipt.json`, source
copy hashes, exact configuration diff and before/after Basic hashes, build logs
and each command's outputs are retained under:

`/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/portable-asn1-socket/shared-target/optional-assert-rmskhn9f`

The script checks that only copied `Basic/module.jai` changed. All generated
programs, copied sources and files are in worker scratch; no production default
or immutable fixture was changed. Reproduction requires source-building
`jaic-cli` into that script directory's `compiler` target and running the script
in a fresh scratch directory. It uses current shared sources, not old overlays.

## Owner routing

The original portable owner owns these remaining portable API bodies. These are
source-confirmed required effects, with runtime confirmation limited to the
three public APIs above. Windows, Linux, font/native GUI and device regressions
remain the responsible owner's platform gates. File lines below identify the
captured current snapshot; check hashes before applying a repair in the shared
tree.

| Current clean file under `stdlib/internal/` | Lines | Required effect omitted |
| --- | --- | --- |
| `numerics/ui_text.jai` | 193 | Insert/sanitize/copy text and update its extent |
| `input/keymap-text.jai` | 171, 177 | Write each serialized keymap file |
| `clipboard/win32.jai` | 63, 64, 71, 123, 124, 163, 167, 177 | Open, clear, transfer, close clipboard; release untransferred memory |
| `clipboard/cocoa.jai` | 113, 138 | Initialize AppKit; clear pasteboard |
| `system/windows.jai` | 124, 228, 232, 273 | Write non-x64 raw counter; close handle, free local memory, close registry key |
| `platform-io/windows-process.jai` | 299, 326, 400 | Close process/pipe handles, collect partial process, reset OVERLAPPED event |
| `rendering/font-features.jai` | 30 | Fill allocated GSUB table before parsing |
| `rendering/dynamic-fonts.jai` | 81, 252 | Select face pixel size before metrics/rasterization |
| `rendering/gl-textures.jai` | 44 | Perform fallback texture allocation/upload |
| `rendering/gl-pixel-read.jai` | 114 | Unmap mapped pixel-pack buffer |
| `rendering/window-contexts.jai` | 108, 147, 148, 180, 181, 260, 270, 271, 299, 388, 389, 390, 398 | Select/restore context, swap/vsync, fill retirement bounds/pixel format, install format, release native resources |
| `window/cocoa.jai` | 6, 14 | Load AppKit and set activation policy |
| `window/lifecycle.jai` | 32 | Install native close-notification method |
| `input/cocoa-events.jai` | 68 | Install native input-notification method |
| `window/win32-create.jai` | 30 | Release brush on cleanup |
| `input/windows-devices/module.jai` | 49, 62, 63 | Roll back/unregister HID and Xbox device notifications |
| `developer-tools/debug-dumps.jai` | 14 | Set automatic minidump state |

Tools/model retain generator ownership. The inspected generator assertions
contain pointer/type/count preconditions and `gp_valid_text`, which only checks
string count and membership. No essential generator mutation was identified.
Native ABI/logger ownership remains with bindings; this report routes repairs
to the portable callers, not to the foreign bindings themselves.

## Distinctions and previously repaired cases

The discovery scan initially listed 987 internal assertion lines. Search hits
were prioritized by call expressions and required state transitions, then
reviewed through their callees and surrounding statements. This is not a
blanket regex defect list or an exhaustive transitive purity proof. Generated
native declaration bodies, Extensions, self-tests and compile-time `#assert`
are outside these optional-runtime-assert defect claims.

* ZIP directory `read_u32(bytes)` only reads four indexed bytes and combines
  them; it does not advance a cursor. Its assertion is a pure signature check.
* MPEG `buffer_has` can load data and set `has_ended`; it is effectful, but the
  following `buffer_read` performs its own availability check. Loss of essential
  loading for supported complete input is not established by those guards.
  Callback timing/retries on truncated input may differ. These four guards are
  distinguished from the prior asserted writes and cursor-consuming reads.
* SDL `EventState(-1)` queries follow the independent `EventState(0)` setters.
  The required polling configuration already executes outside the assertion.
* GL `glGetError` consumes diagnostic state. The report records 27 such
  diagnostic callsites separately; they are neither pure nor omitted rendering
  operations. The actual draw/upload/delete work executes separately.
* Windows process `WaitForSingleObject(process, 0)` is a diagnostic zero-time
  process query. The separate infinite collection wait is essential and routed.
* Deep_Copy currently calls `H.table_add` outside assertions. FileWatcher
  currently computes its unlock CAS into `released` before asserting. The prior
  reported patterns are absent in these inspected current bodies.
* MPEG's owner changed `program.jai` during this audit: packet writes and pack
  reads now execute independently; `read_pack_field` logs/asserts on the result
  and returns false on failure. The old scan is retained as historical discovery
  evidence; current source no longer contains those asserted operations. MPEG's
  owner owns its enabled/disabled runtime regression.

## ASN1/Socket result and remaining gates

All eight runtime assertion callsites in the owned ASN1/Socket surface were
inspected. Descriptor bounds, CMSG extents and Winsock pointer/count checks are
pure predicates. ASN.1 `wire_failure` logs before `assert(false)`. Reads,
cursor/descriptor mutations, allocations and cleanup occur independently. No
confirmed owned instance requires a production fix.

The previously acknowledged 54 runtime, 100 host and 34 source gates remain
separate evidence. This audit grants no additional platform completion. The
Android target remains compiler-blocked; six Android rows stay partial. Native
Windows/Linux/Android and broad GUI suites were not run. The integration owner
alone stages and commits; this audit changed only its scoped report,
documentation and append-only shared handoff entries.
