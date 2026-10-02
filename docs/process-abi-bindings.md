# Process ABI binding proofs

## What it is

`jai_vm::process_abi` validates a closed catalog of actual source foreign declarations for virtual POSIX process operations. An explicit provider capability dispatches supported operations over VM memory and a virtual descriptor ledger.

## How it works

The trusted source binder supplies one `ProcessAuthority` per canonical source library declaration, an exact `BuildTarget`, actual nominal type identities and `(ProcedureId, ProcessAbiOperation, TypeId)` catalog entries. The last identity is the complete checked source signature. `bind` accepts only that declaration, the exact canonical library metadata, the operation's inspected foreign symbol and that signature. Equal names or width-compatible types do not grant authority. All fields of `ProcessAbiProcedure` are private; consumers access them through getters and revalidate against the current target and type registry.

The initial catalog covers `fork`, `pipe`, `close`, `read`, `write`, `dup2`, `waitpid`, `execvp`, `_exit`, the target errno accessor, `getpid`, `getppid`, `socketpair`, `sendmsg`, `recvmsg`, `shutdown` and `fcntl`. Checked source signatures retain C calling convention, no implicit context, exact parameter/result counts, pointer depth, fixed-array descriptor outputs and nominal socket/error types. `fcntl` alone requires C ellipsis with two fixed `s32` parameters and an `s32` result; the normalized C source pack is absent from the fixed parameter list. A future adapter must separately restrict its supported commands and validate the actual variable arguments.

`OS_Error_Code` must be the actual source IsA `s32` nominal. Socket bindings require the actual `SOCK`, `IPPROTO` and `SHUT` enums with `u32` representations, `MSG` with `s32` representation and the actual ready `msghdr`, `cmsghdr` and `iovec` struct identities. The source binder obtains both message headers from the selected generated Socket receipt and `iovec` from the selected POSIX base receipt. The canonical source receipt and immutable type definitions retain their full source layouts; this helper never substitutes homemade header layouts. macOS and Linux message count/ancillary fields differ, so a memory adapter must use the selected target's checked source layout. Base, stdio and Socket can declare separate libc identities; they require separate authorities even though all name the system library `libc`.

macOS foreign errno access uses symbol `__error`; Linux uses `__errno_location`. Both return a pointer to the actual error nominal. `_exit(s32) -> void` has an empty checked result list because sema normalizes the sole source `void` result. The ordinary `Basic.exit` body expands a syscall/assembly path on these targets. It cannot acquire the `_exit` proof through its spelling. A successful virtual `fork` requires two genuine source continuations; successful virtual `exec` replaces the child continuation and must never be represented as a fabricated scalar success.

The Rust API is a trusted embedding boundary. The source binder must first seal canonical paths and immutable source bytes, graph identity, the library table, exact declarations, nominal origins, type registry and target. Calling `from_verified_source` alone does not authenticate arbitrary Rust input. No source ABI availability hook is conferred by this helper.

The source receipt implementation in `jai-sema/src/modules/process_abi_bindings.rs` selects the configured POSIX entry and the selected target's base/stdio files from that exact module instance. Socket bindings additionally retain the configured Socket entry and its generated target file. Every receipt stores the actual file identity, canonical path and shared immutable graph text; the context also retains the typed compilation-unit identity. Binding checks the same unit, graph text identity and target, then resolves nominal declarations and the canonical library declaration inside each selected header.

An explicit `ResolveOptions.process_abi` context now connects that checked map to source provider snapshots. Providers recheck the actual procedure ID and signature before publishing `ProcedureAvailability::ProcessAbi`; VM dispatch revalidates the proof against its current target and types. Scalar pipe/read/write/close/dup/PID/errno/wait adapters operate on the VM's typed ledger and transaction state. Merely constructing a receipt grants no executable or native library authority. Fork, exit and exec helpers emit sealed controls; the root VM still rejects those controls until the genuine branch scheduler is connected. Ordinary `Process` source acceptance therefore remains incomplete.

The VM's `ProcedureAvailability::ProcessAbi` route checks the requested procedure identity, full signature and selected byte target before creating its process ledger. `pipe`, `read`, `write`, `close`, `dup2`, `waitpid`, PID queries and errno access use the typed memory adapter. Persistent process state is cloned only after its cached work charge is admitted; failed execution restores it with VM memory. Publication requires closed descriptors and a quiescent process world. Descriptor reads that would block return a typed process dependency.

Fork, exit and exec helpers produce sealed control tokens. The synchronous route rejects these until an actual branch scheduler consumes them. Socket operations and `fcntl` also remain unavailable at this dispatch boundary. A catalog proof alone cannot produce a fabricated fork result or scalar exec success.

## How to change it

Add an operation only after inspecting the selected source declaration and its target ABI. Extend `ProcessAbiOperation`, its symbol check and complete signature validation together. Add self-authored proof tests rejecting alternate origins, declarations, libraries, targets, nominal types, widths, calling conventions, context modes, pointer shapes and pack modes. Tests use Rust-created types/prototypes and do not execute the supplied compiler or source scripts.

Extend the configured source receipt catalog in `modules/process_abi_bindings.rs` alongside the proof helper. Preserve exact module-instance membership when selecting loaded files; a matching path in another import instance is insufficient. A local `chdir` prototype inside ordinary `Process.create_process` requires its checked lexical declaration receipt rather than the top-level header catalog. Do not grant it by a matching symbol or wrapper name.

Keep the source binder separate from execution. The [virtual process ledger](virtual-process-protocol.md) models descriptor state, but source compatibility additionally requires explicit VM continuation frames, branch memory mapping, cooperative IPC scheduling, bounded source argv extraction, an exact installed-program catalog, typed launch-failure observations and virtual errno storage. Preserve policy/budget rejection as a boundary failure. Do not convert it into C errno or invoke unsupported native fallbacks.

## Configuration

Only inspected little-endian LP64 macOS/Linux targets with `Arm64` or `X86_64` architecture are accepted. The complete supplied target must match again at binding and proof validation. Unsupported operating systems, architectures, byte order and layout reject. No host program or filesystem capability is enabled by the proof catalog; explicit driver policy remains necessary.

## Dependencies

`jai-ir` supplies checked procedure/library identities and canonical foreign metadata. `jai-types` supplies immutable nominal definitions, procedure signatures and target facts. The eventual embedding source binder supplies authenticated graph/source receipts; the virtual process scheduler and [host provider](compile-time-host-io.md) supply execution and explicitly authorized installed-program observations. No original native compiler, linker, library or object is a dependency.
