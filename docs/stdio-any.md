# Any values at the standard output boundary

The native stdio fixture checks that a boxed value can be read by generated
code and sent through the trusted host's actual POSIX `write` ABI. It captures
stdout and stderr separately and checks their exact bytes and the process exit
status.

The ordinary send procedure also carries a user note under `#no_debug`; the
fixture checks that checked source metadata retains the note independently of
native output and debug suppression.

## How it works

The independently authored source boxes a mutable `s32`, changes the original
slot to 42, and reads it through the descriptor. It creates a three-byte string
view containing `42\n`, sends it to file descriptor 1, then sends `Any\n` to
file descriptor 2. The source loop advances by the actual signed return count
and fails on zero or negative progress.

Call matching describes pointer offsets before comparing the argument against
the foreign parameter. It keeps `text.data + written` as the data pointer type
without evaluating either operand. The same pure helper checks matching-pointer
differences and rejects offsets whose full range cannot fit the existing signed
64-bit offset contract. The selected call then lowers the normal pointer
operation once, in source order.

The declaration uses C calling convention with `s32` file descriptor, pointer
buffer, unsigned 64-bit count, and signed 64-bit result on the selected Unix
LP64 host. LLVM is emitted by this compiler; the installed trusted Clang links
the fresh executable against the system runtime. No supplied object or library
is loaded. The fixture has a five-second execution deadline.

The ordinary VM deliberately diagnoses the unbound foreign call. A native
result must not be reported as VM host-I/O support. This fixture establishes a
real native boundary required by `Runtime_Support.jai:311`; it does not replace
or establish acceptance of the unchanged Basic formatter, allocator, or runtime
initialization source.

## How to change it

Extend `jai-codegen/tests/stdio_any.rs` with source-level observable outputs,
using fresh source and artifacts. Keep the pointer/length relationship and C
widths explicit. Validate partial writes and failures separately if adding a
controlled I/O provider; do not replace real calls with success-returning stubs.
Additional platforms need their actual output APIs and ABI contracts.

If changing pointer operators, keep the pure call description in
`jai-sema/src/polymorphism/integration/pointer_arguments.rs` consistent with
`jai-sema/src/pointers.rs`. The description must not reserve runtime storage,
lower IR, or execute compile-time operand expressions while selecting a call.

## Configuration

Run `cargo test -p jai-codegen --test stdio_any` on Unix. `JAI_RS_CLANG` selects
the trusted Clang executable, with the existing Homebrew LLVM default on macOS
and `clang` elsewhere. The fixture's layout is LP64; Windows output remains a
separate contract.

## Dependencies

Source graph loading, semantic Any conversion, canonical reflection, checked
IR, LLVM foreign ABI lowering, the trusted system C runtime, and process pipes.
The VM's explicit foreign-call rejection remains independent of native I/O.
