# Checked LLVM operations

## What it is

`jai-llvm` supplies checked wrappers for pointer indexing, comparison and debug record insertion that Inkwell does not expose through suitable safe APIs. The rest of the compiler retains the workspace's `unsafe_code = "forbid"` policy.

## How it works

`gep` checks that the builder is positioned, every operand and type belongs to the same LLVM context, the element has a storage size, and each aggregate selector is valid. Struct selectors must be constant `i32` indices within the declared fields. Array indices may be dynamic or negative. The wrapper emits ordinary GEP without an `inbounds` promise; language bounds, pointer validity, and lifetime rules remain semantic/runtime responsibilities. See LLVM's [GEP definition](https://llvm.org/docs/LangRef.html#getelementptr-instruction).

`const_gep` applies the same path validation to constant pointer operands and indices. It preserves global relocations in static data without requiring a positioned builder. Runtime instructions are rejected as constant-address inputs.

`compare_pointers` checks equal pointer types and address spaces in the positioned builder's context before producing a scalar comparison. It preserves pointer operands instead of converting them through host-sized integers. See LLVM's [comparison definition](https://llvm.org/docs/LangRef.html#icmp-instruction).

`DebugSession` borrows its exact LLVM module and context until finalization. It creates the compile unit, scopes, primitive variable descriptors and locations through private factories. Public scope and variable handles carry an opaque session identity; callers cannot construct them from arbitrary Inkwell metadata. A non-reused identity rejects cross-session handles, including sessions in the same module. Positioned blocks and functions must belong to the exact borrowed module, and instruction or parameter storage must belong to the declared procedure. Direct global storage must belong to the exact module; unsupported constant expressions, including constant GEP addresses, are rejected.

`DebugSession::declare` checks those identities and storage context before calling LLVM 22's record insertion API. The bridge checks that the parent module uses the new debug format and discards the returned `DbgRecord` without turning it into a value or instruction. This avoids Inkwell 0.10's incorrect record-to-instruction return conversion. `finish` finalizes the debug builder and releases its module borrow before callers verify, serialize or move the module.

Location columns and formal parameter ordinals must fit LLVM's 16-bit metadata fields. The safe factories reject larger values before LLVM's assertions or field truncation. Source lines retain their 32-bit range.

Type constructors use opaque session-branded `DebugType` slots, preserving recursive record references through replacement without retaining deleted raw handles. Their checked constructors live in `debug_records/types.rs`; private raw constructors remain under `raw` alongside `raw.rs`. Only private checked input structures reach that module. That module contains the unsafe calls and their safety explanations. The crate denies unsafe code elsewhere; its module-level exception is confined to the bridge. It calls the trusted installed LLVM library and never loads a supplied reference executable, object, or library.

The authored `debug_shim.cpp` contains the LLVM 22 operations without suitable C API equivalents: genuine debug-record erasure, subroutine calling-convention construction and replacing an owned subprogram's signature. The signature factory checks session-owned child types and distinguishes storage types from subroutine types. Signature replacement validates both opaque handles and the shim checks concrete metadata kinds. Suppression cleanup enumerates records from the owned module; it never casts a debug record to an instruction or switches LLVM back to an unsupported old debug format.

## How to change it

Add structural validation to the safe entry point before adding a low-level operation in `raw.rs`. Validate LLVM context ownership as well as Rust lifetimes: two live contexts may share the same Rust lifetime. Reject unsupported shapes before crossing the C API boundary. Keep the checked input constructors private and add malformed-input rejection tests plus successful module verification.

The current tests cover nested record/array indexing, pointer equality, unsized elements, dynamic or out-of-range struct indices, mixed contexts, different address spaces, missing insertion points, and null bytes in instruction names. A debug regression inserts 256 records after constant folding, verifies the module and rejects missing insertion positions, foreign storage contexts, foreign modules sharing a context, foreign session metadata sharing a module, foreign globals, unsupported constant addresses, and another procedure's instruction or parameter storage. Further regressions cover recursive pointer types, invalid cycles by value, layout padding and metadata width limits. Native source tests inspect DWARF and execute the generated programs. Generated native execution of pointer language features belongs to the backend's integration tests.

## Configuration

The bridge uses the workspace's pinned Inkwell and LLVM version. Set `LLVM_SYS_221_PREFIX` to the trusted LLVM 22.1 installation when building. The installation must include `llvm-config`, `clang++`, `llvm-ar` and LLVM development headers. Without the variable, the build locates `llvm-config` on `PATH` and derives that installation's prefix. It validates versions and rejects tools or headers under the supplied reference, corpus or Git directories before execution. Loader override environment variables are removed from tool subprocesses. No runtime option bypasses validation.

`build.rs` compiles only the authored shim with C++17 and archives its newly generated object. Cargo tracks the source, selected tools, LLVM configuration header and installation environment for rebuilds. `OUT_DIR/debug-shim-toolchain.txt` records selected versions and paths. Build tools execute on the Cargo host, while the shim object targets Cargo's Rust `TARGET`; a cross Rust build needs the corresponding C++ headers, runtime and linker environment. This is separate from the Jai CLI's `--target`, which selects emitted Jai objects without rebuilding the host compiler. macOS, iOS and FreeBSD use `libc++`; other Unix targets use `libstdc++`; MSVC builds use their configured SDK runtime. Clean CI images need those development components in addition to LLVM libraries.

## Dependencies

Inkwell, its reexported LLVM C API, installed LLVM 22.1 development tools and the platform C++ runtime. The build workflow adds no Cargo dependency. `jai-codegen` consumes the wrappers; the VM uses separate typed virtual pointers.
