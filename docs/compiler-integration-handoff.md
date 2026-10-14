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

Qualified module lookup now enforces exports, and lookup no longer searches sibling
files' private imports or names excluded by `only`. Original scope regressions
verify these boundaries and independent `#load` visibility. The LSP worker should
retain the same boundary when enumerating namespace completion candidates; legacy
IDE enumeration of non-file-private entities needs alignment with exported entities.

The loader now enforces [private internal source loading](compiler/internal-source-policy.md).
Facades inside the selected library may import `internal/...`; application imports
and loads into that canonical directory are rejected, including cache hits and
symlink aliases. Generated text without source provenance must use public facades.

Computed using filters now retain their kind in the core AST (`UsingFilterKind`),
and aggregate filters/maps are resolved in `sema/using.rs`. The parser recognizes
the mapper procedure expression in `using,map(...)`; computed filters no longer
erase `only` versus `except`. IDE aggregate completion preserves mapped names and
original declaration locations. These are compiler-owned parser/sema overlaps for
the LSP worker to retain during integration.

The public-language runner passed all 11 fixtures against the independently
implemented foundation in the stdlib worker's checkout (read-only integration
input) on 2026-10-14. It uses this checkout's `target/debug/jaic` with an explicit
`--stdlib-root`. Core-only tests also cover literal default precision, valid `0h`
widths and AST precision/radix/sign flags. Full stdlib and corpus completion is
not implied by this focused run.

Inherited inline layout targets now resolve through `using` and `#as using`:
`#overlay(implementation_data)` can target a field inherited from a previously
laid-out base. The same resolver supports `#place`, nested inline embedding and
embedded filters; a target behind a using pointer has no inline offset and is
diagnosed. `crates/jaic/tests/cleanroom_layout.rs` reproduces and verifies the
foundation temporary-storage blocker using independent aggregate names. Rebuild
the compiler with the command above before enabling the pending foundation source.

Compiler facade adapters now support workspace interception, statement edits and
scoped source addition. Code scope selectors are accepted only in the running
workspace, as the reviewed precondition requires; FILE selectors retain their
private file namespace and relative-load origin. Unknown modification bodies and
invalid workspace IDs are diagnostics. The version string now identifies this
actual jaic package version instead of a historical reference-version spelling.

The test overlay optionally accepts `--bindings /absolute/path/to/new/stdlib` and
copies only the new POSIX/Linux/macOS/Windows bindings and their private helpers.
This enables the Program_Print plugin's real file-output fixture while preserving
every other checkout. Full integration remains coordinator-owned.

AST user-declaration events now classify system modules from the selected
bootstrap's library root, rather than the Runtime_Support module folder. This
retains the compiler's user-only typechecked event policy under the new layout.
FILE/IMPORT events still describe actual loaded sources. Failed file/module loads
remain failed on cache hits instead of becoming empty successes.

Core parser/IDE overlap should be integrated through documented changes. This
worker owns loader/bootstrap and semantic compatibility changes; the LSP worker
owns partial-edit resilience and keyword navigation. No other checkout is modified.
See [implementation plan](compiler/cleanroom-implementation-plan.md) for remaining
work and [distribution policy](tools/stdlib-integration-decisions.md) for private
internal import requirements.

Compiler-managed global data now retains storage and relocation identity across
compile-time registration and target execution. See
[data contracts and limits](compiler/compiler-global-data.md). The three focused
data fixtures pass in interpreter and native modes. Invalid segment descriptors
and alignments produce diagnostics. No arbitrary discrete backend section is
claimed; the corresponding return boolean is false.

## Formatting and lint status

The source-built `target/debug/jailint -D warnings` passes the four public owned
facades, all four private implementation directories, and the new data fixtures
with `JAIC_STDLIB` set to the independent test overlay. No lint rule is disabled.
Modified Rust files were formatted with scoped rustfmt.

Building the repository formatter against that overlay currently fails:

```sh
JAIC_STDLIB="$PWD/target/cleanroom-test-stdlib" target/debug/jaic jaifmt/main.jai -O2 -exe "$PWD/target/cleanroom-jaifmt"
```

`Extensions/Args/generate.jai:775` calls `print(*out, ...)`, but the reviewed Basic
API supplies builder formatting through `print_to_builder` rather than that print
overload. Extensions must remain intact. No legacy compatibility overload was
invented and no supplied formatter binary was executed. Jai format/check remains
blocked pending an authorized tool/dependency integration solution; it is not
claimed passing. Retry the source build after integration changes.
