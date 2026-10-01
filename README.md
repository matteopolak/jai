# Jai, in Rust

[![Compiler checks](https://github.com/matteopolak/jai/actions/workflows/ci.yml/badge.svg)](https://github.com/matteopolak/jai/actions/workflows/ci.yml)

An independent Jai compiler written in Rust. The goal is to compile existing Jai programs and libraries, with a clean implementation that is easy to test, understand, and improve.

**Early development:** small programs compile and run today. The standard library and larger Jai projects still need substantial language support before they can build.

```jai
sum_to :: (n: int) -> int {
    total := 0;
    while n > 0 {
        total += n;
        n -= 1;
    }
    return total;
}

main :: () -> int {
    return sum_to(9); // Exit status: 45
}
```

## What works today

| Area | Status |
| --- | --- |
| Integers and Booleans | Supported in the current subset |
| Procedures, arguments, return values, recursion | Supported |
| Local variables, nested scopes, scalar casts | Supported |
| Arithmetic, comparisons, compound assignment | Supported |
| `if`, `while`, short-circuit `&&` and `\|\|` | Supported |
| Native compilation | Small programs tested on ARM64 macOS |
| Strings, arrays, pointers, structs, enums | Not implemented in compilation yet |
| Imports, modules, generics, overloads | Not implemented yet |
| Compile-time execution and compiler APIs | Not implemented yet |
| Full standard library and reference examples | Not compiling yet |
| Focus, Jails, jaison, and other recent projects | Source checks only; full builds pending |
| Linux, Windows, mobile, WebAssembly | Planned; runtime compatibility unverified |

The lexer currently accepts **702 local reference files** and **1,440 files from seven recent upstream projects**. These checks test reading and tokenizing source, not successful compilation. [Compatibility coverage](docs/reference-compatibility.md) explains the remaining work.

## Try it

You need [Rustup](https://rustup.rs/), Python 3.11 or newer, and an independently installed LLVM 22 with Clang. Rustup uses this repository's pinned toolchain automatically.

On macOS, install LLVM with Homebrew and set `LLVM_SYS_221_PREFIX` to its installation directory. See the [LLVM setup guide](docs/llvm-backend.md) for exact commands and troubleshooting.

```sh
git clone https://github.com/matteopolak/jai.git
cd jai

# Check dependency release dates before building.
python3 tools/check_dependency_age.py
cargo build -p jai-cli --locked
```

The example above is included as `examples/sum.jai`:

```sh
cargo run -p jai-cli -- check examples/sum.jai
cargo run -p jai-cli -- build examples/sum.jai sum
./sum
echo $? # 45
```

You can also inspect a source file with `lex`, or save its LLVM output with `emit-llvm`:

```sh
cargo run -p jai-cli -- emit-llvm examples/sum.jai sum.ll
```

## Compatibility and performance

The local Jai distribution helps establish language behavior. Newer, maintained Jai projects guide compatibility when they differ from that older reference. The [upstream corpus](docs/upstream-corpus.md) records the projects and exact revisions used.

Tests cover rejected programs and the behavior of newly compiled programs. Benchmarks measure compiler time and Rust allocations so performance work can be based on measurements. Unsupported features produce errors instead of counting as successful builds.

The supplied source distribution stays outside this repository. An authorized reference compiler asset is used for isolated static inspection and bounded version/help experiments in CI. [Binary inspection](docs/binary-inspection.md) documents the findings and limits of static analysis.

## Working on the compiler

For a public checkout:

```sh
cargo test --workspace --locked -- \
  --skip lex_entire_reference_without_executing_it \
  --skip supplied_executable_is_rejected_before_backend_execution
cargo fmt --all -- --check
cargo clippy --workspace --all-targets --locked -- -D warnings
cargo bench -p jai-bench --bench compiler --locked -- --test --skip reference_lex
```

The two skipped tests require the separately supplied reference files. Local reference checks run them without those filters.

Start with the [developer guide](docs/README.md) for architecture, language coverage, benchmarks, and dependency policy. Rustfmt keeps code formatting consistent, and Cargo enforces a minimum dependency release age of 14 days.
