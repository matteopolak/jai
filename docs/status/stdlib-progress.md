# Portable stdlib progress

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
