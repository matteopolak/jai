# Typed Process descriptor flags

## What it is

The process source adapter implements the four inspected `fcntl` commands used by the ordinary POSIX `Process` wrapper: `F_GETFD`, `F_SETFD`, `F_GETFL` and `F_SETFL`. They inspect and update real virtual descriptor state without calling native `fcntl` or granting arbitrary C variadic execution.

## How it works

Only an exact sealed `ProcessAbiProcedure` bound to the selected source library, signature and target can enter this route. `validate_process_arguments(args, types, target)` checks that proof and then the closed argument protocol: two portable `s32` arguments for getters, three for setters. The setter tail is the actual promoted C `int`; pointer values, address-derived integers, wider integers, nominal wrappers and boxed `Any` values cannot supply flags. Ordinary nonvariadic process operations retain their complete signature checks. The central VM bridge now applies its configured value validation to the fixed prefix and this sealed validator to the complete actual argument list; it does not mistake a valid setter's third operand for a signature-count error.

All inspected profiles use command values `1`, `2`, `3`, `4` respectively and `FD_CLOEXEC = 1`. `F_GETFD` returns the actual process-local slot's close-on-exec bit. `F_SETFD` accepts zero or that bit and updates only the selected slot. A duplicated slot starts without close-on-exec; fork inherits existing slot flags independently; a received SCM_RIGHTS descriptor starts without close-on-exec.

`F_GETFL` combines the actual open description's access mode (`0` read-only, `1` write-only, `2` read/write) with its nonblocking flag. Pipe ends retain their separate modes; sockets retain read/write mode after `shutdown(WR)`. `O_NONBLOCK` is `4` on the inspected macOS profiles and `0x800` on Linux. This narrow `F_SETFL` accepts the retained access mode plus optional `O_NONBLOCK`, matching the wrapper's nested getter/OR/setter pattern. It rejects other flags or a changed access mode. Nonblocking belongs to the shared open description, so changes propagate through duplicate, fork and SCM_RIGHTS aliases.

The adapter charges world retention, prospective candidate cloning and errno work before mutations. Before cloning, setters also admit the actual private memory retention, both world retentions, branch metadata and the validated scalar operands against the value-cell limit. They publish a candidate world only after validation succeeds. An invalid descriptor returns actual source `s32 -1` and writes nominal `EBADF = 9`; resolving it precedes flag restrictions so a failed nested getter followed by a setter still reports the bad descriptor. Successful calls preserve errno. Unsupported commands/flags, malformed tails, provenance violations and fuel/retention exhaustion remain explicit VM/boundary errors.

## How to change it

Extend the private `process_source_machine/flags.rs` protocol and exact proof validation together. New commands require inspected target values and real ledger behavior; accepting a generic C tail or returning a guessed flag value would bypass the source contract. Extend `DescriptorAccess` only with an actual new open-description kind, keeping access mode immutable and distinct from status flags.

The six authored flag tests cover both target nonblocking encodings, actual pipe/socket modes, nested getter/setter calls, per-slot versus shared alias behavior, bad descriptors, preserved errno, malformed C tails, unsupported flags, proof target mismatch, fuel rejection and preclone retention admission. All six passed in the earlier full `jai-vm` gate, which passed 518/518 tests. A standalone focused flag run was not performed. The three registered `central_fcntl` tests passed in the later coordinated 557-test VM gate. The authored `process_fcntl` driver `#run` fixture remains queued. Neither helper nor authored bridge fixtures establish unchanged `Process` wrapper execution.

## Configuration

The exact bound `BuildTarget` selects inspected macOS/Linux little-endian LP64 profiles. `ProcessLimits` and VM `Limits` retain their existing descriptor, memory and fuel bounds. This route adds no environment variables, native handles, executable grants or host launch capabilities.

## Dependencies

[Process ABI proofs](process-abi-bindings.md), [typed source process memory](process-source-adapter.md), [the virtual process ledger](virtual-process-protocol.md), and the central VM's proof-gated foreign-call bridge. Constant/signature evidence comes from the statically inspected selected `POSIX/bindings/*/stdio.jai` and the nested setters in `Process/posix.jai`; no supplied native artifact is executed or loaded.
