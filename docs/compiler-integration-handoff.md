# Compiler integration handoff

## Source build and invocation

The current Rust compiler builds with:

```sh
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo build --locked -p jaic-cli --bin jaic
```

The source-built executable is
`/Users/matthew/projects/jai/artifacts/cleanroom-workers/compiler/target/debug/jaic`.
Select the independently implemented library explicitly:

```sh
JAIC_STDLIB=/absolute/path/to/new/stdlib /Users/matthew/projects/jai/artifacts/cleanroom-workers/compiler/target/debug/jaic /absolute/path/to/main.jai -interp
```

Use `-check` for checking and omit `-interp` for native compilation. During early
core iteration `--no-default-features` builds a CLI without native LLVM output.
Do not use supplied/reference executables.

## Bootstrap and runtime contract

The only automatic bootstrap entry is `<stdlib>/prelude/module.jai`.
`Preload` is the public import alias for that selected entry; it must share nominal
types and mutable globals with the implicit bootstrap instance. Do not create a
second `module.jai` or another prelude root. Library root discovery, trap helper
lookup, browser embedding, native CLI and LSP wiring use this layout.

The compiler automatically loads `Runtime_Support` with named parameters:

| Parameter | Default |
| --- | --- |
| `DEFINE_SYSTEM_ENTRY_POINT` | `true` |
| `DEFINE_INITIALIZATION` | `true` |
| `ENABLE_BACKTRACE_ON_CRASH` | `false` |
| `TEMPORARY_STORAGE_SIZE` | `32768` (`s64`) |

These are forwarded from compiler options. The existing compiler selects one
implicit runtime instance per program; the language guide does not establish the
behavior of explicitly parameterizing that reserved module. Bootstrap records
belong to the foundation worker. Compiler-specific facades and helpers belong to
this worker; no duplicate bootstrap records should be defined there.

## Current verification and coordination

The LLVM source build above succeeded on 2026-10-14. The supplied snapshot has no
foundation module files, so runtime fixture execution awaits new foundation code.
Original virtual-filesystem regressions in `crates/jaic/tests/cleanroom_modules.rs`
exercise loader contracts without requiring any old library implementation.

Core parser/IDE overlap should be integrated through documented changes. This
worker owns loader/bootstrap and semantic compatibility changes; the LSP worker
owns partial-edit resilience and keyword navigation. No other checkout is modified.
See [implementation plan](compiler/cleanroom-implementation-plan.md) for remaining
work and [distribution policy](tools/stdlib-integration-decisions.md) for private
internal import requirements.
