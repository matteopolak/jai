# C++ method calls

## What it is

`#cpp_method` represents a receiver-first C++ method ABI in procedure definitions and procedure types. It is used by the pinned sgpu Slang vtables and shader filesystem callbacks; it has a distinct canonical type identity from `#c_call`.

## How it works

The syntax selects `CallingConvention::CppMethod` and disables the implicit Jai context. Registry construction requires a pointer receiver in parameter zero, no variadic pack, and at most one result. Indirect vtable calls preserve that signature and use the target's foreign ABI classifier; generated method bodies use the same incoming parameter carriers.

The native implementation supports scalar, enum, pointer and procedure-pointer parameters/results on the ten explicitly classified C ABI platforms, including 32-bit WebAssembly. Header-free Clang++ target fixtures compare the actual method calling convention, receiver-first signature and integer extension attributes with the classifier. Aggregate carriers are rejected for C++ methods because their non-POD rules and hidden result ordering need separate ABI evidence. The reflection descriptor publishes `IS_CPP_METHOD` (`0x1000_0000`) and `HAS_NO_CONTEXT` (`8`), without claiming `IS_C_CALL`.

`crates/jai-codegen/tests/cpp_methods.rs` contains an independently authored C++ virtual-object oracle. It checks a generated caller against a real C++ vtable and a C++ virtual call against a generated Jai method. This contract fixture is separate from upstream project acceptance.

`tests/sdk/imgui-method.jai` additionally calls the selected Vk-Engine `ImDrawList::AddRectFilled` symbol in a reviewed source-rebuilt ImGui 1.90.4 docking archive. The native CPU draw fixture passes with real reference parameters and default arguments; [graphics project acceptance](graphics-project-acceptance.md) records its source revision, target and evidence limits.

The native oracle and aggregate rejection test pass on the current Apple ARM64 host. Registry invariants, source callback incompatibility, VM foreign-call rejection, and procedure suffix parsing also pass their targeted tests. Strict `jai-types` and `jai-codegen` library Clippy passed at that checkpoint. Cross-target fixtures in `cpp_target_abi.rs` prove typed ABI shape; other targets still require an executed oracle to establish runtime behavior.

## How to change it

Keep signature invariants in `jai-types` and target carrier restrictions in `jai-codegen::cpp_methods`. Extend aggregate or variadic handling only with independent C++ ABI fixtures for each supported platform. Preserve the convention in procedure equality, overload matching and reflection; avoid inferring methods from names or pointer layouts. The VM must not execute native methods without an approved foreign-effects adapter.

## Configuration

Native target selection determines available ABI classification. Unsupported targets and unsupported C++ value carriers fail explicitly. The fixture builds only its authored C++ source with trusted `/usr/bin/clang++`; it does not link or load corpus native dependencies.

## Dependencies

`jai-syntax` procedure suffix parsing, the checked `jai-types` registry, `jai-ir` foreign signature validation, semantic procedure binding and reflection, and LLVM foreign argument/result marshaling. Native tests additionally need trusted Clang C++ and the platform's normal C++ runtime.
