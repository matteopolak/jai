# Foreign function ABI

## What it is

`jai-codegen` declares checked foreign procedure prototypes and lowers C definitions, direct calls, and indirect calls using explicit Apple ARM64, Linux/Android ARM64 AAPCS64, macOS/Linux x86-64 System V, Windows x64/ARM64 and wasm32/wasm64 canonical C ABI classifiers. The internal Jai aggregate calling convention remains a separate path. A supported LLVM target can emit internal Jai calls even when that target has no supported foreign C classifier.

## How it works

`target.rs` selects the LLVM target and supplies its `TargetData` to `abi.rs`. Scalar C arguments retain their integer, Boolean, float, or pointer representation; narrow integer and Boolean parameters/results carry platform-specific extension attributes. Linux/Android and Windows ARM64 omit Darwin's narrow extension attributes. Windows x64 extends Boolean carriers only. Enum and distinct identities remain in checked IR while their declared representation determines the physical C carrier.

Small ARM64 composites use integer carriers or homogeneous float aggregates; larger composites use indirect storage, including hidden result pointers. System V x86-64 composites use up to two integer/SSE eightbytes, falling back to `byval` when an aggregate cannot fit the remaining argument registers. A source aggregate is copied into compiler-owned storage before marshaling; returned C carriers are reconstructed into the source storage type. Buffers cover the largest carrier, use explicit unaligned accesses where needed, and are allocated once in function entry.

Windows x64 directly coerces 1/2/4/8-byte aggregate storage to integers and passes other aggregates through caller-owned storage aligned to at least 16 bytes. Windows ARM64 uses its independently checked aggregate rules and suppresses homogeneous-float argument carriers on variadic signatures. WebAssembly validates the actual pointer width, unwraps one unpadded scalar field through nested records and otherwise uses naturally aligned `byval` arguments and hidden results. Experimental multivalue and component-model ABIs are outside this path.

C definitions reconstruct incoming parameters into ordinary source locals and marshal captured returns after deferred cleanup. Self-written C fixtures call generated aggregate callbacks, proving the adapters in both directions. The universal `Any` descriptor uses the shared checked record-storage accessor and two actual pointer fields. A self-written C fixture receives it by value, checks its descriptor pointer, mutates its pointed-to integer, and returns the descriptor through the classified result ABI.

C variadic calls promote `f32` to `f64` and narrow integer/Boolean arguments to `s32`. Variadic aggregate arguments currently produce an explicit unsupported diagnostic. Unknown targets, context-bearing C procedures, and multiple foreign language results also fail explicitly. Custom records use their checked field offsets and alignment: System V sends aggregates containing unaligned fields through memory, while Apple classifies homogeneous float aggregates before integer or indirect carriers. System V `byval` argument storage has at least eight-byte alignment; hidden result storage retains the record alignment.

Direct and indirect call lowering select their path from the checked `CallingConvention`. An indirect C call first prepares a typed `abi::Signature`, including its target and C++ result-policy validation; an indirect Jai call uses `TypeLowerer::function` and `internal_call` without requesting a foreign platform. LLVM's [calling-convention rules](https://llvm.org/docs/LangRef.html#calling-conventions) still require the lowered caller and callee to agree. A target triple supplies layout and machine lowering; it does not change a checked Jai procedure into a C procedure.

LLVM declarations include exact foreign symbols. Resolved typed library declaration metadata remains attached to prototypes and the checked library dependency table for the linker driver; LLVM lowering does not search for or load libraries. See [foreign library declarations](foreign-libraries.md). Runtime reachability omits compiler-only prototypes and helpers used solely during `#run`; runtime references to compiler requests fail with a typed call chain. See [native reachability](native-reachability.md).

Aggregate leaf traversal skips zero-sized subtrees and visits each `(TypeId, byte offset)` once. This keeps enormous arrays of empty records and repeated union graphs compact. Classification stops with a structured diagnostic after 65,536 unique nodes; changing that bound requires preserving bounded pending work, not only limiting the final leaf count.

The classifier follows the [Apple ARM64 platform rules](https://developer.apple.com/documentation/xcode/writing-arm64-code-for-apple-platforms), [AAPCS64 aggregate rules](https://github.com/ARM-software/abi-aa/blob/main/aapcs64/aapcs64.rst), and [System V x86-64 ABI](https://gitlab.com/x86-psABIs/x86-64-ABI/-/raw/master/x86-64-ABI/low-level-sys-info.tex). LLVM carriers were additionally compared with trusted Clang output from self-written C source using the upstream [AArch64](https://github.com/llvm/llvm-project/blob/main/clang/lib/CodeGen/Targets/AArch64.cpp) and [x86](https://github.com/llvm/llvm-project/blob/main/clang/lib/CodeGen/Targets/X86.cpp) implementations as primary references.

## How to change it

Extend `abi/platform.rs`, the ARM64 helpers in `abi/aapcs64.rs`, Windows in `abi/windows.rs`, WebAssembly in `abi/webassembly.rs`, and `abi::Signature` classification and `foreign.rs` marshaling together. Add a C fixture that both consumes and returns the new type; declaration shape alone does not prove interoperability. Register exhaustion, mixed integer/float fields, padding, unions, narrow extension, indirect calls, and variadic promotions need separate coverage.

`tests/foreign_abi.rs` emits LLVM object files directly, then compiles only self-written C fixture source and links those new objects with installed Clang, then runs that new executable. macOS ARM64 scalar, pointer mutation, varargs, mixed records, homogeneous float aggregates, unions, and large indirect returns execute successfully. [Custom record C ABI verification](native-custom-record-abi.md) covers ten nested, packed, reduced-alignment, and over-aligned layouts in both C directions at `O0` and `O2`. Ten-target shape and register-exhaustion tests compare carrier and ABI attributes with Clang 22. Linux ARM64 argument alignment and pointer-only carriers have independent oracle coverage. Custom adapters additionally have an object-emission gate at both optimization levels for all ten targets. These cross-target comparisons do not claim native execution; see [cross-target acceptance](cross-target-acceptance.md) for the separate object and hosted execution boundaries.

## Configuration

LLVM 22.1 must be installed. On the development host:

```sh
LLVM_SYS_221_PREFIX=/opt/homebrew/opt/llvm RUSTC_WRAPPER= CARGO_TARGET_DIR=target cargo test -p jai-codegen --test foreign_abi --locked -j1
```

The native target triple chooses the classifier. No fallback applies to an unsupported C target ABI. For example, i686 Linux has LLVM target/layout support for internal Jai callbacks but retains an explicit unsupported C ABI diagnostic. `tests/internal_call_targets.rs` checks scalar, aggregate and multiple-result callback object emission plus genuine foreign-classifier and Microsoft-environment rejection; the cross-target CLI debug fixture keeps its original assertions. Native fixtures validate Clang 22 from `JAI_RS_CLANG`, `LLVM_SYS_221_PREFIX/bin/clang`, or `PATH`.

## Dependencies

The backend uses Inkwell/LLVM 22.1, immutable `jai-types` descriptors and layout policy, checked `jai-ir` procedure identities and prototypes, shared `TypeLowerer`, and compiler-owned union/ABI temporary allocation helpers. Tests use the trusted installed Clang and C standard headers; no reference native binaries, libraries, or objects are loaded.
