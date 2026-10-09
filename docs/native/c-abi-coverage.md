# C ABI coverage matrix

## What it is

Which C aggregate shapes the fixtures check on which platform, and where each check runs. The rules themselves are in [C ABI, callbacks and C++ methods](c-abi.md).

## How it works

Every row is a generated fixture, regenerated with `python3 tests/native/c-aggregate-abi/generate.py` and formatted with `jaifmt`. `tests/native/c-struct-returns` predates the generator and is still the reference for returns.

| What | Fixture | Interpreter | Native build |
| --- | --- | --- | --- |
| Struct returned by C, passed to C, returned by a Jai `#c_call`, round trip | `c-struct-returns` (58 shapes), `c-aggregate-abi` (`ret_`, `check_`, `call_`, `apply_check_`) | host | host, x86-64 under Rosetta on Apple silicon |
| Struct argument of a Jai `#c_call` called from C: alone, after five integers, after seven integers, after eight doubles | `c-aggregate-abi` (`pass_`, `passtail_`, `passfar_`, `passd_`) | host | same |
| Packed (`#no_padding`, member `#align 1`) by value, as results and callback arguments | `c-aggregate-abi` (`pk_*`) | host | same |
| 1 KiB result | `c-aggregate-abi` (`big1k`) | host | same |
| Struct through `...` read with `va_arg`: alone, three of them, after eight fixed integers | `c-variadic-aggregates` | host | same |
| `#cpp_return_type_is_non_pod` callbacks | `cpp_non_pod_callback_results` (needs `c++`) | Unix hosts | Unix hosts |
| `long double` | `c-long-double` | not Windows | not Windows |
| Classifier rules for every ABI | unit tests in `crates/jaic/src/abi.rs` | all | all |

"Host" is whatever runs `cargo test --test native`: linux-x64 and linux-arm64 (System V and AAPCS64), macos-arm64 (Apple AAPCS64), windows x64 and arm64 (against a DLL for the interpreter, a static `.lib` natively). Which ABI rule each platform exercises:

| Rule | linux-x64 | linux-arm64 | macos-arm64 | Windows x64 | Windows arm64 |
| --- | --- | --- | --- | --- | --- |
| Packed unaligned member is MEMORY | yes | no rule | no rule | no rule | no rule |
| Multi-piece aggregate with too few registers goes whole to the stack | yes | yes | yes | n/a | yes |
| Variadic aggregates | registers like fixed | registers like fixed | stack | by reference over 8 bytes | no HFAs, x0-x7 then stack |
| Hidden result pointer of a foreign call (no size limit) | `rdi` | `x8` | `x8` | first argument slot (`rcx`) | `x8` |

Not covered, by design: variadic `#c_call` procedures and `long double` callbacks in the interpreter (refused), callbacks with more stack arguments than the thunks have slots, more than 64 thunks of one return shape per interpreter (why the fixture is split into programs of ten shapes).

## How to change it

- Add a shape: append to `SHAPES` (or `VA_SHAPES`) in `generate.py` and rerun it. Keep definition lines of `shapes.c` unindented and on one line: the Windows run exports every such name from the DLL by scanning them.
- Keep programs under 64 callbacks per return shape (`CHUNK`).

## Configuration

None; the tests skip without `cc` (`clang` and `llvm-ar` on Windows).

## Dependencies

`crates/jaic-cli/tests/native.rs` (`run_shapes_fixture`), `crates/jaic/src/abi.rs`, `interp/native.rs`, `interp/native/callbacks.rs`, `crates/jaic-llvm/src/lower.rs`.
