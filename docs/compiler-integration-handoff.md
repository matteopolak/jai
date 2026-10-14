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

These are forwarded from compiler options. Temporary-storage size is a compiler
target constant forwarded privately, not a fourth public runtime parameter.
The existing compiler selects one
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

Lexical float precision now survives untyped aliases/folding/overloads and module
arguments. Typed module parameters use the shared constant conversion path, rather
than synthesizing new literal ASTs. See [precision](compiler/literal-precision.md).
The focused compiler suite includes 150 unit tests, 32 module, five literal and
three layout regressions. All 19 owned stdlib fixtures pass in interpreter and
native modes against the test overlay, and the 11 public-language fixtures pass.
Core `cargo clippy --locked -p jaic --lib --tests -- -D warnings` passes.

The source-built `target/debug/jailint -D warnings` passes the four public owned
facades, all four private implementation directories, and the new data fixtures
with `JAIC_STDLIB` set to the independent test overlay. No lint rule is disabled.
Modified Rust files were formatted with scoped rustfmt.

Building the repository formatter against that overlay currently fails:

```sh
JAIC_STDLIB="$PWD/target/cleanroom-test-stdlib" target/debug/jaic jaifmt/main.jai -O2 -exe "$PWD/target/cleanroom-jaifmt"
```

`Extensions/Args/generate.jai:775` calls the reviewed builder overload
`print(*out, ...)`, which the independent foundation does not yet export.
The reviewed Basic page specifies both the overload and its alias to
`print_to_builder`. Extensions remain intact; implementing that foundation
overload belongs to its owner. No supplied formatter binary was executed. Jai format/check remains
blocked pending an authorized tool/dependency integration solution; it is not
claimed passing. Retry the source build after integration changes.

## Editor and browser integration

Module completion follows transitive exported imports and retains every
only/except filter. Unqualified completion also applies import/using filters.
Cycle protection follows the active path so independent filtered paths can
contribute different names. The original core regression checks qualified facade
and unqualified filtered completion; module regressions now total 33.

The browser build can select independent sources with `JAIC_STDLIB`. Its new
Compiler-record/global-data regression passes. The broader pre-existing browser
suite passes 17/27 against the overlay; see [exact failures](compiler/browser-integration-status.md).
LSP library and framing suites pass 25 and three tests. Core/browser clippy passes
with warnings denied.

Generated facade declarations use independent topical/alphabetic organization,
preserving member layouts and explicit enum values. Both generators produce
byte-identical output on repeated regeneration. Source-built jailint passes the
regenerated facade/private trees, and all 19 focused fixtures pass again in both
modes. Jai formatter execution remains blocked as described above.

Procedure/macro signatures now preserve using filters through binding; embedded
computed filters resolve during field layout. Original tests verify selected
names, mapper execution and original field storage. See
[using propagation](compiler/using-filter-propagation.md). Module regressions now
total 35. The memory-breakpoint and developer-debugger entry points diagnose
unavailable debugger support; the negative breakpoint fixture verifies an ordinary
compiler error. No successful breakpoint installation is claimed.

Rechecking the reviewed Basic page confirms `tprint`, `log_error`, command-line
arguments, platform `exit`, and builder `print` are specified exports. Their
browser/formatter failures are missing foundation implementations, not authority
for compiler special cases. The browser status document records this correction.

Code_Using export/printing now retains computed filters and parameter usings, and
procedure-header printing includes available bodies when enabled. Static filters
retain their category but cannot yet be printed because their public expression
representation is unspecified; source reconstruction reports failure instead of
dropping them. The new Code-copy fixture passes in both modes. Segment handles
also survive a separate #run and aliases: their opaque allocations participate in
the same real-global relocation map as registered data. Focused facade fixtures
now total 21.

## Replacement integration corrections

The reviewed Runtime_Support contract has exactly three boolean module parameters.
TEMPORARY_STORAGE_SIZE is a compiler target constant/build option, not a fourth
public module parameter. Bootstrap now passes only the reviewed parameters.
All modules, including bundled ones, reject unknown names and excess positional
arguments. Explicit imports of the configured runtime validate parameters and
reject conflicting values instead of silently discarding them.

IDE audits admit their explicitly selected internal source entry only; strict
application imports/entries remain private. Regression coverage is in
cleanroom_modules.rs. Guarded interpreter transfers now use kernel-mediated
copy APIs; protection changes cannot invalidate a userspace-copy safety premise.
The strengthened original mmap/mprotect regression failed with SIGBUS before
this fix and passes without manual invalidation afterward.
Bootstrap atomics now lower through common validated IR. See
[atomic semantics and regressions](compiler/bootstrap-atomics.md) and the mandatory
[deviations report](status/compiler-deviations.md). Native O0/O2, interpreter host
contention, and actual shared-memory WASM worker contention pass; these are
focused compiler/backend verification, not a production integration claim.
Progress and next tasks are maintained in [compiler progress](status/compiler-progress.md).

## Caller-scope context cleanup checkpoint

Backtick defer-pop now retains caller-block lifetime, including conditional and nested macro registration. Context selection uses local runtime storage; cleanup marks move when a macro inserts caller-owned actions. Ordinary caller-owned defers share activation guards. Explicit push blocks restore before outer return cleanup. See compiler/context-cleanup.md. Original core cases: eight pass; native/WASM O0/O2 execution passes. Core unit plus focused integration: 207 passed, one existing ignored test not counted. LLVM/core clippy with warnings denied and scoped Rust formatting checks pass. No stdlib Jai sources changed in this batch.

## Generic defaults / foundations integration request

Source descriptors now expose declared parameter defaults; existing source identity is preserved. Instance parameters exposes defaults evaluated with preceding actual bindings; specified_parameters remains actual values. Compare instance defaults for dependent default elision (see compiler/generic-default-reflection.md). No peer writes performed. Six original core tests and native/WASM64 O0/O2 storage tests pass; invalid defaults and actual-argument serialization failures propagate. Public dependent-default encoding remains an explicit reviewed-contract question. Two IDE match arms only hide internal unbound reflection entities; LSP parser behavior was not changed.

Source-built formatter integration found and fixed direct context assignment in speculative/lambda/conversion contexts. FnCtx context storage is now private and all initialization uses the runtime setter. Core context regressions now number nine. Latest core/LLVM verification: 240 passed across unit and focused Rust integration tests (one existing ignored test not counted); clippy core/LLVM/LSP/browser with warnings denied passes.

## Verified formatter, atomic contention and performance checkpoint

Repository jaifmt builds against the fresh independent foundation/bindings overlay. All owned public/private Jai paths and four new contract fixture directories pass jaifmt --check and jailint -D warnings using repository config; tools/dev.py workflows also pass. The record generator invokes that source-built formatter and regeneration is hash-idempotent. See compiler/formatting-verification.md for scope/commands. Extensions is untouched.

Run_Directive_Report.Record is now reviewed and implemented. Performance flags forward to actual Rust measurements; nested reports materialize normally and unrequested run data stays blank. Actual wasm32 compiler hosts diagnose unavailable monotonic timing rather than report manufactured zero durations. Native compilers targeting WASM measure native host work. Native-only interpreter fiber state is compiled only on supported Unix/Windows x86_64/aarch64 hosts; unsupported fiber diagnostics remain intact. Actual wasm32 cargo check and clippy -D warnings pass.

Atomic runtime tests now add contended exchange accounting and 30,000-round release/publication handshakes natively and in shared WASM. The interpreter separately validates 80,000 contended exchanges. The new real-prelude scalar fixture covers enum and procedure values. Focused full Rust result is 240 passed, one existing ignored test not counted. LSP library: 25 passed; CLI program arguments: passed. Public language suite: 11 passed. Four new contract cases supplement the earlier 21, with interpreter/native verification. Browser fresh-overlay broad result is 19/28; LSP auto-import and the legacy System executable-path test still need dependency/API review. No failure gates/assertions changed, no fabricated reference results, and no production integration/corpus/release claim.
