# Cast dialects and modifiers

## What it is

Explicit and contextual casts share a typed policy while accepting prefix and
comma-operand source forms. `trunc` retains its own identity rather than becoming
an alias for `no_check`. `force` and `FORCE` retain separate equal-size and smaller-prefix storage policies.

## How it works

```jai
small := cast,trunc(u8) 256;          // 0
mask := cast(u32, -32, trunc);       // 0xffffffe0
small: u8 = xx,trunc 298;             // 42
pointer := cast(*u32, cast(*u8, base) + 16);
value := cast(*u32).* (cast(*u8, base) + 16);
queue := (index + 1).(Gpu_Queue);      // checked postfix enum cast
small := (298).(u8, trunc);           // 42
bits := cast,force(u32) float_value;  // equal-size representation
first := cast,FORCE(u8) word;         // selected target byte prefix
```

The parser resolves a target and one operand into the existing cast node. A
prefix cast binds to its following operand; a comma-operand cast explicitly
encloses that operand. Postfix `.(Type[, modifier])` casts the preceding value
and permits ordinary member, index, and dereference continuation. The operand
resolves and executes once in written order.
Contextual `xx` still requires a destination supplied by its enclosing expression.

`CastModifiers` rejects duplicate or conflicting policies, including modifiers
split between the prefix and a function-style trailing argument. The typed
source mode maps to the supplied Compiler module's separate flags:
`no_check` is `NO_BOUNDS_CHECK` (`0x8`), `trunc` is `TRUNCATE` (`0x10`),
`force` is `FORCE` (`0x80`), and `FORCE` is `VERY_FORCE` (`0x100`).
The representation contract is documented in [Cast modifiers](cast-modifiers.md).
The AST keeps this distinction for quoted syntax and downstream consumers;
this does not claim support for all `Code_Cast` reflection fields.

Storage casts use a target-bound proof and an actual byte image or native scratch allocation. They preserve distinct type identities and execute their source once. Pure overload previews check the selected layout; baked storage constants currently require a VM materialization recipe and report that missing capability. See [Storage bitcasts](storage-bitcasts.md).

Integer truncation retains the destination's low bits. Enum and distinct integer
results retain their nominal identity. Runtime, pure constant evaluation,
declaration defaults, and overload previews use the same domain policy.
Checked casts retain range checks. Pointer conversion uses the existing selected
target width, address view, and VM provenance rules. A native nonzero pointer
sentinel can compile, but the VM rejects an unknown address. Native pointer
declaration defaults retain their original integer and mode in a sealed
target-normalized constant; see [Native pointer constants](native-pointer-constants.md).
Explicit null pointer defaults use the declaration's exact canonical pointer
target; contextual null pointer defaults obtain that target from the declaration.

The supplied `Ico_File.jai` casts size 256 to `u8` zero with `trunc`;
`Text_File_Handler/examples/example.jai` casts a negative character difference
to unsigned bits; POSIX bindings cast `-1` to pointer sentinels. These are static
source evidence. No original compiler executable is run. The reference sources
do not establish float or Boolean `trunc` corner cases, so these domains reject
the modifier explicitly. Existing checked float-to-integer casts truncate toward
zero with finite/range checks; unchecked float-to-integer conversion remains
unsupported.

## How to change it

Extend `jai-types/src/cast_modifiers.rs`, `jai-syntax/src/casts.rs`, and the common
semantic cast dispatcher together. Keep source modifier identity separate from
execution details. Update pure overload feasibility and baked constants whenever
adding a domain. Float conversion policy also requires the evaluator, VM, native
guard, and IR verifier to agree; accepting an unchecked LLVM conversion alone
would permit poison for out-of-range inputs.

The source-to-native cases live in `jai-codegen/tests/cast_dialects.rs`; parser,
pure evaluator, and semantic negative tests cover invalid policies separately.
`cast_policy_ir.rs` independently verifies VM and native integer truncation at
Clang `-O0` and `-O2`, without depending on source semantic adapters.

## Configuration

Source modifiers select conversion policy. Target layout controls pointer width.
The shared native test helper uses `JAI_RS_CLANG` or `LLVM_SYS_221_PREFIX` as
documented in [Native test tools](native-test-tools.md). No cast-specific
environment variables are required.

## Dependencies

This feature uses canonical `jai-types` identities and modifier metadata,
`jai-syntax`, pure evaluation, semantic defaults and overload selection, typed
IR validation, VM address provenance, and LLVM lowering. Primary source evidence
also includes `reference/CHANGELOG.txt` (cast syntax and inconsistent modifiers),
`reference/modules/Compiler/Compiler.jai`, and the separate flag handling in
`reference/modules/Program_Print/module.jai`.

The original Hash_Table cast statement now parses its modifier and target, then
reaches the separate unsupported legacy backtick-capture operand. The static
source probe records this boundary explicitly; it does not claim full Hash_Table
acceptance.
