# Cross-target object and ABI acceptance

## What it is

The native backend emits LLVM objects for explicitly selected targets. Canonical C interoperability has ten explicit platform selections: ARM64/x86-64 macOS, Linux and Windows; wasm32/wasm64; ARM64 Android and iOS. An emitted object, a matching Clang declaration and an executed application establish different levels of evidence.

## How it works

`NativeTarget` owns the target machine and data layout. Semantic resolution receives the same target facts before backend lowering, including pointer width and target-dependent layout. `tests/cross_targets.rs` resolves an independently authored context-and-record program, evaluates it in the bounded VM, emits objects at `O0` and `O2`, and checks the actual object header and machine identifier. A second authored source fixture declares packed C prototypes and a generated C callback while the program has an implicit context schema. It emits objects for every proven target, checking that source C boundaries use their context-free ABI. Both fixtures pass the actual LLVM layout policy into semantic resolution.

| Selected target | Object format checked | Foreign C ABI |
| --- | --- | --- |
| Linux x86-64 | ELF, x86-64 | System V AMD64 |
| Linux ARM64 | ELF, AArch64 | AAPCS64 |
| macOS x86-64 | Mach-O, x86-64 | System V AMD64 |
| macOS ARM64 | Mach-O, ARM64 | Apple ARM64 |
| Windows x86-64 | COFF, x86-64 | Microsoft x64 |
| Windows ARM64 | COFF, ARM64 | Windows ARM64 |
| WebAssembly 32 / 64 | Wasm object | Canonical Clang C ABI |
| Android ARM64 | ELF, AArch64 | AAPCS64 |
| iOS ARM64 | Mach-O, ARM64 | Apple ARM64 |

The object tests do not link or execute cross-target programs. Windows, WebAssembly and mobile targets have independently checked C classifiers, but still require linker/runtime integration and execution acceptance. Android is selected explicitly; its aggregate carriers follow the independently proved AAPCS64 rules. ARM32, Windows x86-32 and other unimplemented C platforms fail explicitly.

`tests/desktop_abi.rs` compiles self-written, header-free C with installed Clang 22 for all ten target triples. It compares aggregate and scalar carrier types, return/parameter extension attributes, hidden results, `byval`, alignment and ARM64 homogeneous-float `alignstack` attributes. `tests/foreign_custom_records.rs` additionally compares ten nested, packed, reduced-alignment and over-aligned layouts. These cross-target comparisons require no SDK because they stop at LLVM IR. The custom adapter object test exercises incoming parameter decoding, direct and indirect outgoing calls and return encoding at both optimization levels on each target; native linked execution of both directions remains a host-only check.

Linux ARM64 follows AAPCS64 instead of the Apple variant: narrow scalar carriers omit Darwin's extension attributes, homogeneous floats carry stack-alignment attributes, and aggregate argument alignment excludes the record's own minimum-alignment annotation. Pointer-only ARM64 aggregates preserve pointer argument carriers. Both x86-64 desktop targets use the System V register budget and memory fallback.

Windows x64 uses direct integer carriers for 1/2/4/8-byte records and indirect storage otherwise; caller-owned aggregate temporaries are at least 16-byte aligned. Windows ARM64 disables homogeneous-float argument carriers for variadic signatures. WebAssembly uses its actual 32- or 64-bit pointer width, unwraps single unpadded scalar records and passes other aggregates indirectly. This is the canonical Clang C ABI, not the component model or experimental multivalue ABI. iOS follows Apple ARM64 carriers.

The compiler CI matrix selects four native hosts and runs the full native fixtures on each. Only completed jobs establish execution on those hosts; the historical two-host scalar checkpoint in [native host checks](native-hosts.md) does not prove the current expanded suite.

## How to change it

Add a target to `abi/platform.rs` only alongside its genuine classification rules and independent Clang proof fixtures. Extend `cross_targets.rs` with the selected architecture, operating system, pointer width and object machine header. Keep unsupported classifier targets explicit. Document object emission, carrier proof, link acceptance and actual execution independently; a classifier proof does not establish runtime availability.

Cross-linking needs target tools and development inputs: a Linux target sysroot and compatible linker, Apple SDK and deployment target for macOS/iOS, Windows SDK plus MSVC-compatible libraries or an explicitly supported alternative, Android NDK/sysroot, or a WebAssembly linker and chosen runtime. iOS additionally needs code signing, provisioning and a device or compatible simulator; Android execution needs a device/emulator with matching API level. Header-free carrier/object tests establish none of those deployment requirements. The existing CLI rejects cross-target executable linking; `emit-object` is the supported cross-target boundary.

## Configuration

```sh
LLVM_SYS_221_PREFIX=/path/to/llvm-22 RUSTC_WRAPPER= CARGO_TARGET_DIR=target \
  cargo test -p jai-codegen --test cross_targets --test desktop_abi \
  --test foreign_custom_records --locked -j1
```

The fixture tool selector accepts `JAI_RS_CLANG`, then `LLVM_SYS_221_PREFIX/bin/clang`, then a validated LLVM 22 Clang on `PATH`. Original reference artifacts are never tools or link inputs. `.github/workflows/ci.yml` uses `macos-15`, `macos-15-intel`, `ubuntu-24.04` and `ubuntu-24.04-arm`, with architecture assertions; `workflow_dispatch` allows a reviewed checkpoint to be rerun.

## Dependencies

LLVM/Inkwell 22.1, checked `jai-types` layouts and `jai-ir`, semantic resolution, the bounded VM and independently installed Clang 22. Native execution additionally depends on each host's trusted linker, headers and system libraries. Hosted tests use the signed LLVM Ubuntu archive or Homebrew and preserve the locked 14-day Rust dependency policy. No reference native binaries, objects or libraries are executed or loaded.
