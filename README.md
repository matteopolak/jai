# Jai, in Rust

[![Compiler checks](https://github.com/matteopolak/jai/actions/workflows/ci.yml/badge.svg)](https://github.com/matteopolak/jai/actions/workflows/ci.yml)

An independent Jai compiler written in Rust. The goal is to compile existing Jai programs and libraries, with a clean implementation that is easy to test, understand, and improve.

**In development:** the compiler runs a growing set of Jai programs, including records, generics and compile-time code. Full standard-library and larger-project builds are still pending.

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
| Numbers and Booleans | Integer widths, floating point, casts and comparisons tested |
| Strings, arrays and pointers | VM and native tests; descriptor copies, iteration and pointer operations |
| Records, unions and enums | Nominal types, defaults, copies, packed layouts and static pointer data tested |
| Procedures | Named/default arguments, multiple results, callbacks and recursion tested |
| Generics and overloads | Procedure and record specialization tested; remaining forms need coverage |
| Context and `Any` | Context overrides, variadic forwarding and value boxing tested |
| Control flow | Conditions, cases, loops, named exits and lexical `defer` tested |
| Modules | Loads, scoped imports, visibility and scalar/enum/type parameters tested; advanced parameters in progress |
| Compile-time code | Source `#run`, reflection and code insertion tested; broader metaprogramming in progress |
| Compiler APIs | Workspace scheduling and selected CLI artifacts tested; broader API integration in progress |
| Foreign calls and native builds | LLVM library backend; host ABI tests and selected system-library calls |
| Debugging | Line tables, locals, records and recursive pointers tested |
| Compiler bootstrap | Independently authored source prelude type-checks; runtime integration in progress |
| Independent standard library | Authored modules included; full compilation and behavior testing pending |
| Reference examples | Source checks in progress; complete coverage pending |
| Focus, Jails, jaison, and other recent projects | Source checks only; full builds pending |
| Browser editor | Real Wasm runs, file tree, source editor and shared source LSP tested; host services and full standard library pending |
| Windows and mobile | C ABI and object tests; runtime compatibility unverified |

The compatibility corpus contains **702 local reference files** and **1,440 files from seven recent upstream projects**. The latest recorded snapshot tokenizes all **2,603 files**, including our library and prelude, and parses **2,451** completely, with 102 more accepted files and no regressions in the same cohort. The earlier body sweep checked **103 pinned support files** with the included Preload; that stage has not been rerun for this snapshot. Full standard-library and upstream project builds remain pending. See the [latest measured frontier](docs/corpus-breadth-frontier.md) and [earlier baseline](docs/corpus-breadth-baseline.md) for the separate stage results.

For example, record specialization and compile-time execution can work together:

```jai
Node :: struct(T: Type) {
    next: *Node(T);
    value: T = 19;
}

answer :: () -> int { return 23; }

main :: () -> int {
    node: Node(int);
    return node.value + #run answer(); // Exit status: 42
}
```

This example is included as [compile-time-record.jai](examples/compile-time-record.jai).

An independently authored standard library is included in [`stdlib/`](stdlib/). Its [coverage report](docs/stdlib/api-coverage.md) records implemented APIs, source checks, and the remaining work.

## Try it

You need [Rustup](https://rustup.rs/) (it picks up this repository's pinned toolchain) and, for native builds, an independently installed LLVM 22 with Clang; see the [LLVM setup guide](docs/llvm-backend.md).

```sh
git clone https://github.com/matteopolak/jai.git
cd jai
python3 tools/check_dependency_age.py   # check dependency release dates before building
cargo build -p jaic-cli --locked
```

The example above is included as `examples/sum.jai`. `jaic run` executes it in the interpreter, `check` only type-checks it:

```sh
cargo run -p jaic-cli -- check examples/sum.jai
cargo run -p jaic-cli -- run examples/sum.jai
```

To build and serve the standalone browser playground, follow the [browser editor setup](docs/browser-editor.md). Its compiler and language service run locally in WebAssembly.

The same lexer and parser power the `jai-lsp` language server (`cargo run -p jai-language-server --bin jai-lsp`); see [language-server.md](docs/language-server.md).

## Compatibility and performance

The local Jai distribution helps establish language behavior. Newer, maintained Jai projects guide compatibility when they differ from that older reference. The [upstream corpus](docs/upstream-corpus.md) records the projects and exact revisions used.

Tests cover rejected programs and the behavior of newly compiled programs. Unsupported features produce errors instead of counting as successful builds.

The compiler uses an independently authored [source prelude](docs/compiler-prelude.md) split into protocol components under `prelude/`. Supplied source distributions remain external compatibility inputs. The retired reference probe used an authorized compiler asset for isolated static inspection and bounded developer-help experiments; [binary inspection](docs/binary-inspection.md) preserves those findings and their limits.

## Working on the compiler

```sh
cargo test --workspace --locked --no-fail-fast
cargo fmt --all -- --check
cargo clippy --workspace --all-targets --locked -- -D warnings
python3 tools/jaic-sweep.py corpus stdlib upstream --timeout 900   # expect only the negative control to fail
```

The workspace is `crates/jaic` (lexer, parser, semantic analysis, IR, interpreter), `crates/jaic-cli` (the `jaic` binary), `crates/jaic-llvm` (native backend), `crates/jai-language-server` and `crates/jai-wasm` (browser build). Start with the [developer guide](docs/README.md) and [compiler architecture](docs/compiler-architecture.md). Rustfmt keeps code formatting consistent, and Cargo enforces a minimum dependency release age of 14 days.

Many pages under `docs/` were written for an earlier multi-crate architecture (`jai-source`, `jai-vm`, `jai-sema`, ...) that has been removed. They still describe language behavior and design intent, but their crate and file references are historical; [compiler architecture](docs/compiler-architecture.md) maps them to `jaic`.
