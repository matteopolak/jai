# Native test tools

## What it is

Codegen integration and target/debug unit tests use one installed Clang selector to compile or link
freshly generated fixtures on macOS and Linux. Test setup does not assume an
ARM Homebrew prefix or a particular `/usr` installation layout.

## How it works

`crates/jai-codegen/tests/support/native_tools.rs` selects the driver once per
test process, in this order:

1. `JAI_RS_CLANG`, when explicitly supplied.
2. `LLVM_SYS_221_PREFIX/bin/clang`, using the runtime prefix or the prefix
   recorded while compiling the test.
3. `clang-22`, then `clang`, found through `PATH` when no prefix is configured.

An explicit tool or prefix fails closed if missing or invalid. Selection
canonicalizes symlinks and rejects tools in the checkout's `reference/`,
`corpus/`, `vendor/`, or `.git/` before executing a version probe. The selected file must
be executable and report Clang major version 22, matching the LLVM backend and
C ABI oracle. Version inspection has a five-second deadline. A discovered
incompatible compiler produces a configuration error; it is not silently used.

`clang_command()` removes inherited loader and compiler injection variables
from the tool subprocess. The helper also exposes the canonical `clang()` path
for tooling inspection. Tests compile their own C/C++ sources or this
compiler's newly generated LLVM/objects, then execute those fresh outputs.
The production CLI retains its separate installed-tool security policy.

Standalone CLI integration fixtures clear inherited Jai module, bootstrap,
target, optimization, debug, and reviewed-dependency configuration before
invoking the compiler. A proof test then installs only its explicit dependency
configuration. This keeps an ambient standard-library path or receipt from
changing the source contract under test. Authored foreign-library executables
have a five-second execution limit; local native-input rejection remains a
separate assertion before linker execution.

## How to change it

Include the helper with `#[path = "support/native_tools.rs"] mod native_tools;`
and start compiler/linker invocations with `native_tools::clang_command()`.
Codegen unit tests reuse the root's `crate::test_native_tools` module to avoid
including the same helper twice in one test binary.
Use `--driver-mode=g++` for C++ fixtures. Keep each suite's target, optimization,
linker, and timeout options beside that suite; tool discovery does not change
language semantics or ABI policy.

`native_tool_selection.rs` tests precedence without changing process-wide
environment variables. Its independently authored wrappers exercise invalid
versions, missing/non-executable tools, and protected symlink aliases. A real
installed compiler builds and executes new C and C++ programs as the positive
check.
Update these tests when extending selection or protected roots.

## Configuration

Set a trusted LLVM 22 prefix or an explicit installed driver:

```sh
export LLVM_SYS_221_PREFIX=/path/to/llvm-22
export JAI_RS_CLANG="$LLVM_SYS_221_PREFIX/bin/clang"
cargo test -p jai-codegen --test native_tool_selection --locked -j1
```

`JAI_RS_CLANG` may be a full path or a command name resolved through `PATH`.
An empty override is an error. Install and configure the compiler before
running tests; the helper does not download or execute reference tooling.
macOS packed-relocation suites retain their own `-Wl,-no_fixup_chains` flag.

## Dependencies

The selector uses the Rust standard library, an independently installed
Clang 22 toolchain, and the host linker/SDK used by each native fixture.
It adds no Cargo dependency. LLVM setup and CI platform coverage are described
in [LLVM backend](llvm-backend.md) and [native hosts](native-hosts.md).
