# Reviewed prefix casts and open narrow shift widths

The queued Windows control encoding issue remains reproduced. No Socket module
is imported and no peer source was edited. The only producer document read for
this scope was the authorized NEW docs/portable-verification.md; it contains
Socket verification status but no exact minimal-reproducer path. The local
fixture was independently authored from the filtered mailbox's expression/value.

For u8 group 0x66 and command 126, prefix_control_observation returns 0x8004007e
in the interpreter and native O0/O2. Explicitly converting group before shifting
produces 0x8004667e in all tested modes. The former loses the group byte.
Evidence: target/cast-shift-control-observation.log records the failing proposed
assertion; target/cast-shift-native-{o0,o2}-observation.log records actual values.
Neither observation is asserted as a compatibility oracle in the green tests.

The observed result comes from frontend grouping/type selection, not an LLVM-only
optimization defect. parser/expr.rs::parse_cast_value includes shifts and bitwise
operators inside a prefix cast. sema/expr.rs checks an ordinary typed cast operand
without propagating the destination type; a shift takes its typed left operand's
width. Thus cast(u32) group << 8 is currently cast(u32) (group << 8), shifting a
byte before widening. Parentheses around the cast explicitly widen first.
The refreshed reviewed language page now establishes this grouping and bottom-up
operand typing. Current parsing agrees with that contract and is not a compiler
defect. No precedence or inward type-propagation change is appropriate.

The reviewed core page leaves only numeric narrow-shift promotion unresolved:
does shifting a typed u8 preserve that width or promote the result? The question
document is narrowed to that rule. The correct SDK constant alone cannot choose
a Jai numeric rule; C integer promotions are separate. Explicit word operands in
the producer's private Socket encoder are appropriate. No compiler semantic fix
is claimed while the numeric rule remains unspecified. Prior observations and
failing proposed expectations remain evidence, not compatibility assertions.

## Executed supported behavior

tests/compiler-semantics/cast-shift-widths.jai tests explicitly parenthesized
widening, constant values and all 256 u8 inputs. It also exercises the supplied
compiler's existing comma-cast syntax as a comparison, without claiming that
syntax as newly reviewed public compatibility. Two original core tests pass,
including constant and actual runtime checked-cast rejection. A backend test
executes the same supported cases in native and WASM64 O0/O2. Log:
target/cast-shift-final-tests.log. These are scoped tests; the prior full suite's
307-pass result is not presented as a fresh full run with these added cases.

```sh
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm PATH=/opt/homebrew/opt/llvm/bin:$PATH JAIC_STDLIB="$PWD/target/runtime-configuration-candidate/stdlib" CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo test --locked -p jaic -p jaic-llvm --test cleanroom_cast_shifts
```

The standalone C observation driver links the backend's own program.o, executes
the valid checks and prints the unresolved numeric result without asserting it:

```sh
clang -std=c11 -Wall -Wextra -Werror tests/compiler-semantics/cast-shift-observation-driver.c target/cleanroom-execution/cast-shift-widths-false-false/program.o -o target/cast-shift-observation-o0
target/cast-shift-observation-o0
clang -std=c11 -Wall -Wextra -Werror tests/compiler-semantics/cast-shift-observation-driver.c target/cleanroom-execution/cast-shift-widths-false-true/program.o -o target/cast-shift-observation-o2
target/cast-shift-observation-o2
```

On Windows the driver additionally checks FIONBIO against the native Winsock2
SDK header. That conditional SDK assertion has not run on this macOS host.
[Microsoft ioctlsocket contract](https://learn.microsoft.com/en-us/windows/win32/api/winsock2/nf-winsock2-ioctlsocket).
The first manual link command used a nonexistent fixture.o name; it failed and
was corrected to the helper's actual program.o. No failed command is counted as
an execution pass. Jai formatter/check and strict lint, Rust formatting/spacing
and host core/backend all-target clippy pass for this scoped checkpoint. Exact
checked-cast diagnostic messages also pass in cast-shift-final-core-diagnostics.log.
