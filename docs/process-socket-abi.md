# Typed Process socket ABI

## What it is

The socket portion of `process_source_machine` implements the inspected ordinary POSIX `Process` wrapper's Unix stream socketpair and SCM_RIGHTS exchange over typed private memory and a shared virtual ledger. It never opens native sockets or loads a foreign library.

## How it works

The closed Process ABI proof contains the exact source `SOCK`, `IPPROTO`, `MSG`, `SHUT`, `msghdr`, `cmsghdr` and `iovec` TypeIds. The source binder obtains `cmsghdr` from the selected generated Socket file and `iovec` from the selected POSIX base file. Before decoding buffers, the adapter validates their complete field types/order and ordinary struct layout against the inspected little-endian LP64 target.

| Profile | `msghdr` bytes | `cmsghdr` bytes/alignment | iov count | control length | `SOL_SOCKET` | `MSG_CTRUNC` |
| --- | --- | --- | --- | --- | --- | --- |
| macOS arm64/x64 | 48 | 12 / 4 | `s32` | `u32` | `0xffff` | `0x20` |
| Linux arm64/x64 | 56 | 16 / 8 | `u64` | `u64` | `1` | `0x8` |

`socketpair` accepts the actual `AF_UNIX = 1`, nominal `STREAM = 1` and nominal protocol zero, and writes two new process-local `s32` slots into `[2] s32`. `shutdown` implements nominal `WR = 1`; the shared description forces EOF even while inherited aliases remain open. Other socket kinds, addresses, shutdown directions and nonzero message input flags reject explicitly.

`sendmsg` decodes typed iovecs, gathers only their declared byte ranges, and rejects serialization of pointer/procedure/address relocation tags. It parses aligned ancillary headers and accepts only `SCM_RIGHTS = 1` with whole `s32` descriptor entries. Plain slot values must resolve in the sender's current virtual process; address-derived numbers cannot become descriptor authority. Queued rights retain shared open descriptions independently of the sender's later closes.

`recvmsg` suspends on the actual ledger event without consuming bytes or changing source storage. On receipt, rights arrive with the first stream byte and transfer once across partial reads. Scatter writes initialize only bytes received. The receiver gets newly installed local slots. A short ancillary buffer installs only fitting descriptors, closes discarded references, sets the inspected `MSG_CTRUNC`, and reports the actual returned control extent; it never substitutes sender slot numbers. The generic ledger's direct truncated-capacity API retains its explicit rejection behavior.

Receives stage all payload, control-header, descriptor and output-header writes in a private same-lineage memory candidate. Before copying, the adapter charges the snapshot work and admits two memory copies, two conservative shared-world retentions and branch metadata against the actual value-cell limit. It publishes memory and world together only after all writes succeed. Admission also includes prospective full-root byte-image materialization, bounded by the actual cached writable header/control/iovec root extents and cells. A final check admits the actual old and candidate memory retentions before publication. Readonly/lifetime/provenance/type failures and fuel/retention exhaustion remain VM errors. Only the existing recoverable descriptor errors update nominal errno.

## How to change it

Keep the canonical source TypeIds and target layout gate together. New ancillary forms need their own source receipt, complete buffer validation and typed transport representation. New message flags must define stream/control consumption and pending behavior; accepting a flag numerically without its semantics would change the source protocol.

The ten authored socket adapter tests exercise both inspected layouts, three pipe handles with the child/parent ACK exchange, scatter/gather, partial byte initialization, one-shot rights transfer, truncation cleanup, inherited shutdown, pending calls, readonly destinations, late fuel rollback and transient retention rejection. All ten passed in the full `jai-vm` gate, which passed 518/518 tests, including the new 920-byte uninitialized receive-root materialization regression. These Rust adapter tests do not establish unchanged Jai `Process` wrapper execution; that additionally requires the central availability map, genuine continuation scheduler and remaining foreign/source operations.

## Configuration

`ProcessLimits` bounds total transfer bytes, descriptor/right counts and queued transport. The descriptor limit also bounds iovec metadata count. VM value-cell and fuel limits admit temporary candidates before copying. The only supported send/receive input flags are zero. No environment variables, native socket access or source name-based capabilities are introduced.

## Dependencies

[Process ABI proofs](process-abi-bindings.md), [the typed source adapter](process-source-adapter.md), [the shared virtual ledger](virtual-process-protocol.md), checked target memory, private memory snapshot accounting and the central source continuation scheduler. The reference POSIX/Socket declarations are inspected as static source only.
