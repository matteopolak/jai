# Portable stdlib progress

## Replacement integration current checkpoint

Sixth-refresh source checkpoint d9aa140: seven producer merges plus safe editor
CI fix, latest Windows contracts and general private-interface/startup fixes.
Workspace 631/68 pass/fail (59 suites), foundations 27 host/21 WASI plus strict
rejections pass; macOS x64 timeval remains. Portable 101 ordinary cases pass, with
target verification failure retained. Four platform contracts and arguments pass
host interpreter/O0/O2; private Process source checks require no staging. Real
GL SDK checks pass except unavailable debug callback capability. Window 145 pass/
four failures, numerics 126/143. Quality 663 format/check pass; 38/155 gates fail.
Seventh approved snapshots are available and are being integrated. All previous
checkpoint paragraphs below are historical, not current-tree certification.

Fifth refresh source checkpoint 33f0c42: approved c8d1f5d portable, a11c0c8 foundations and eb5d83d
platform-io are merged, together with reviewed CI candidate 159ca65. Latest
general integration fix 2fff11c supplies the real private WASI file ABI; the
POSIX guard and Extensions are intact. All ten fuzz regression targets pass;
unchanged File contracts pass host interpreter/native O0/O2 and Wasm interpreter/
real WASI O0/O2. Portable production 96/96 plus faults/SMTP/channels/startup passes
without the removed implicit sibling compiler overlay. The overlay discovery is
fully disclosed in integration-deviations.md. Foundations 26 host/21 WASI cases
pass O0/O2; macOS x64 timeval and unused-interface validation still fail gates.
All 45 public contracts pass interpreter/native. Verbose scoped File lint and
format/check, workspace clippy warnings denied and Rust formatting pass.

Coordinator-filtered real Windows x64/arm64 File and signed-wheel native checks
pass; overall CI fails other runtime/platform/module checks. No full Windows
rendering or Focus claim. Full LSP sweep finishes 558 files/14,835 edits/2,600,590
assertions with one startup recovery failure. Twelve affected sources pass 317
edits/33,577 assertions; three Socket sources pass 81 edits/5,698 assertions.
Workspace 619 passed/68 failed/one inherited ignored; original stdlib 479 cases:
interpreter 270/209 and native 263/208 plus eight compile-time-only. Quality scope: 607 files
format/check passes, 34/152 gates fail (61 incomplete compilations, zero ordinary
findings). Actual wasm32 formatter passes 24 golden cases, broader engine fails
unsupported Thread. Windows editor/font source support now includes the real File
import, with both CPUs -no_dce green; final affected checks run against this head.
Exact results are in tools/cleanroom-integration.md. Inventory is 102/135 facades, 33 missing plus one
supporting table; no module is certified exhaustively complete.

The paragraphs below retain previous checkpoint evidence, superseded where the
current fifth-refresh report states a new result.

All eight initial producers plus approved refreshed compiler 890329b, portable
8a0d40c, foundations 44cca8b, bindings a565ab0, numerics 4acc846 and window 7fc1d6a
are merged. Stable source fixes include fault-safe probes, strict module parameters,
typed array preservation, binary32 intrinsics, reflected alignment/callback markers,
scratch context initialization and canonical alias completion. No peer writes,
subagents, reference binaries, corpus vendor reads, push or publication occurred.

Current production evidence: 45 reviewed contract cases pass interpreter/native;
11 language cases pass; portable 92/92 plus faults/rejections/SMTP/channels/parent/
startup pass. Foundations 24 host/19 WASI cases pass O0/O2, six unused-code targets
pass and macOS x64 fails POSIX.timeval. Numerics 107/123. Fourteen macOS window
cases pass interpreter/O0/O2, including real windows/events/clipboard/fonts and
actual GL upload/readback/shaders. Windows File-dependent checks still fail.
SDL WM-info and AppKit native tests pass; RWops/UserEvent mismatch asserts fail.

Full workspace: 612 passed/73 failed/one inherited ignored, 55 suites and 14 failed
targets. Original stdlib sweep: 479 cases, interpreter 269/210 pass/fail; native
262/209 plus eight compile-time-only. These failures remain. Source-stable quality
scope 587 files: formatter/check pass, 33/148 checks fail; combined lint one finding
and 56 incomplete compilations/396 programs. Rust formatting and native/browser
clippy warnings denied pass. Full bindings/compiler/lexer/SDL3 regeneration passes.

Broad prior partial edits: 537 files/14,257 edits/2,563,157 assertions, one startup
recovery failure; focused retry retains it. Latest refreshed 558-file sweep is
running. Native Windows/macOS x64/Linux/device and full opaque public corpus/Focus
remain coordinator gates. See cleanroom-integration.md, integration-requests.md,
integration-deviations.md and legacy-contract-audit.md for exact commands/reasons.
Platform-io now owns Windows File completion; no duplicated implementation begun.

Role: independent portable/high-level stdlib worker. No subagents, publication,
reference binaries or prior implementations used. Extensions and corpus preserved.

Latest committed checkpoint: `c8d1f5d`, Unix Autorun lifecycle. Earlier
checkpoints cover foundations, Unix process/thread/files/system, codecs,
allocators, Soa, Xar, command/text parsing and reviewed protocol schemas; consult
[module ledger](../portable-stdlib-ledger.md) for exact partial/remaining scope.

Previously verified checkpoint: POSIX native crash diagnostics and runtime startup
flag integration. Native C builds with `-Wall -Wextra -Werror`. Actual protected
memory faults and raised SIGSEGV terminate with preserved signals and a native
stack in interpreter/native execution. Four worker threads independently initialize
and clean up stacks. Build_Options ON/OFF workspace tests pass native execution.
All 175 owned Jai files pass repo jaifmt --check and jailint -D warnings. The
expanded regression passes 58 interpreter/native cases, ten SMTP scenarios,
four parent-lifetime scenarios, four expected faults in both execution modes,
Xar reverse rejection, startup ON/OFF and selected Linux/Windows target checks.

Previously verified checkpoint: classic Zip_File_Directory parsing and ownership,
including malformed second-record cleanup under a counting allocator. The full
focused run now passes 59 interpreter/native cases and six expected faults in
both modes, retaining the SMTP, parent-lifetime, startup and target checks above.
All 181 owned Jai files pass jaifmt --check and jailint -D warnings. The ZIP field
and extension contract gaps are documented, not asserted as established behavior.

Previously verified checkpoint: CAS-based Atomics arithmetic/bitwise operations and
the exact alias declarations. The three alias intrinsics lack source-compiler
lowering; the original pending reproducer and handoff are documented. Full focused
regression passes 61 interpreter/native cases, seven expected faults in both
modes, two compile-time rejections, all prior SMTP/startup/parent checks and selected
Linux/Windows checks. All 188 owned Jai files pass format/lint. Four-worker tests
verify prior-value uniqueness, bit claims and zero-reaching decrement behavior.

Previously verified checkpoint: partial Deep_Copy scalar/string/resizable-array
operations, callback/preallocated/reused-map cases and conditional debug globals.
General graph support is blocked by reflected struct alignment 0 (versus 8),
reproduced in interpreter/native with retained assertions. It is not counted as
completed graph functionality. Full focused regression passes 63 cases in both
modes, nine expected faults in both modes, two compile-time rejections and prior
SMTP/startup/parent/target checks. All 197 owned Jai files pass format/lint.

Previously verified checkpoint: Unix BuildCpp C/C++ compile/link/archive/object and
macOS universal outputs. Native executable and dynamically loaded function return
the expected results; stale archive members disappear on rebuild; missing tool,
invalid C and wrong-target objects report real errors after cleanup. Full focused
regression passes 64 interpreter/native cases, nine runtime faults in both modes,
five compile-time rejections, and prior SMTP/startup/parent/target checks. All
203 owned Jai files pass format/lint. The runner requires zero C-helper intermediate
directories and preserves previous output after failed compilation.

Previously verified checkpoint: Treemap stable nodes, weights/sort, hierarchy,
callback borders, cached squarified geometry and shared-boundary growth fix.
Full regression passes 65 interpreter/native cases, ten runtime faults in both
modes, five compile-time rejections and prior integration checks. All 209 owned
Jai files pass format/lint; delegated Math is copied only into the integration
root. Meow is blocked by the canonical register macro compiler reproducer;
no replacement public type/hash routine was invented.

Previously verified checkpoint: Unix Shared_Memory_Channel SPSC transport, ownership,
real wrap/full/corruption/max-packet behavior and captured allocator cleanup.
Full regression passes 66 interpreter/native cases, ten runtime faults in both
modes, five compile-time rejections, four interprocess pairings with 2,048 packets
each, and prior SMTP/startup/parent/target checks. All 215 owned Jai files pass
format/lint; Linux x64/arm64 channel code is separately compile-checked. Wire
details and Windows/Linux-execution gaps remain explicit. Two early failed runs
left unjournaled PID-named objects; no global deletion was attempted. Subsequent
tests journal and check cleanup of only their recorded resources.

Current verified checkpoint: Unix Autorun helpers and real COMPLETE lifecycle,
including native child argument forwarding, repeated direct execution, NO_OUTPUT
skip and real runtime launch/exit failure logs. Full regression passes 67 cases
in both modes plus prior faults/rejections/SMTP/IPC/startup/parent/target checks.
All 220 owned Jai files pass format/lint. Compiler mixed-spread loss and CLI use
of a non-oracle helper are retained as pending reproducers; no convenience export
or surrogate callback module parameter was added.

New verified increment ready for checkpoint: MPEG canonical buffers, checked
bit/VLC/start-code/file helpers, all reviewed immutable tables, six pixel aliases
and integer IDCT. Full focused regression passes 70 interpreter/native cases,
11 expected runtime faults in both modes, five compile-time rejections, ten SMTP
scenarios, four 2,048-packet process pairings and prior startup/parent checks.
Linux and selected Windows checks pass; Windows MPEG is explicitly excluded after
an observed failure at the existing File Unix guard. All 230 owned Jai files pass
source-built jaifmt --check and jailint -D warnings; table regeneration is byte
idempotent. New sequence-header tests are in development and not part of these
passes. Continue header/frame storage, demux and audio/video decoding.

Known workarounds and incomplete behavior are recorded in
[deviations](stdlib-deviations.md), [gaps](../portable-stdlib-gaps.md) and the
module ledger. Next: finish regression/checkpoint, then continue remaining owned
portable modules using reviewed specifications. Full corpus/release integration
remains the coordinator's responsibility.

## Replacement integration checkpoint

All eight manifest snapshots merged in separate commits, ending at `6822bc1`.
Combined compiler/LSP/jailint source build and unchanged jaifmt O2 build against
production `stdlib` exited zero. Workspace tests and direct audit are in progress;
no full integration pass is claimed. See [integration evidence](../tools/cleanroom-integration.md).
# Replacement integration checkpoint: compiler widths and reflection

Latest replacement integration update: compiler 890329b and portable 8a0d40c are
merged (413518b, 04d4611), retaining independent context/marker/width/probe fixes.
Production generic metadata now unblocks all 24 foundation host cases and all 19
WASI cases at O0/O2; six unused-code target profiles pass, macOS x64 still fails
POSIX.timeval. Strict lint remains failing on host-inapplicable Windows roots,
and those exit-zero incomplete compilations are now rejected explicitly.
All 45 reviewed contract cases pass interpreter and native. Real shared channels
transfer 2,048 byte-checked packets in each of four interpreted/native process
pairings. Corrected Mail import passes ten real SMTP/MIME cases. Original runtime
configuration fixture is retained as an explicit rejection case; its temporary
storage assertions separately pass with the configured runtime in interpreter/
native O0/O2. This is supported integration evidence, not release completion.
Committed bindings still lack AppKit and safe SDL2 mismatched-record marshalling;
full original corpus remains coordinator-only. Basic.log is reviewed and missing,
correcting the earlier integration classification. No publication/CI dispatch.

Role: replacement integration worker. Approved refreshed compiler/portable/
numerics/window snapshots merged. Durable compiler fixes: `16b66d8` floating
intrinsic widths and `2d839cd` reflected struct alignment/graph regression.
Original binary32, alignment and Deep_Copy graph tests pass interpreter/native
O0/O2 against production; workspace clippy warnings denied passes. Numerics
production suite now 40/83, preserving missing-AppKit/platform/Wasm failures.
Windows signed-wheel public regression passes x64 all-code typechecking; native
CI remains required. Reviewed contracts/regenerated POSIX shapes committed in
`7a89c1d`; next macOS x64 failure is timeval shape selection, not itimerval.
Broader refreshed workspace/portable/quality checks are running. Coordinator
requests and deviations remain in the integration documents; no push or CI
dispatch performed.

