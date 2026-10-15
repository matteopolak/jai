# Browser runtime verification without native facade imports

The reviewed [Thread](../specs/stdlib/modules/thread.md) API has conditional
desktop/mobile/console availability, not a browser WASM facade. Its explicit
guard is correct. The old combined playground test imported Thread and File to
test the interpreter's cooperative scheduler and virtual filesystem. That
coupled valid compiler-runtime behavior to unsupported public module assumptions.

## Independent split design

The provider already exists: `PlayHost` selects cooperative threading;
`Interp::inline_thread_foreign` implements scheduler operations; `SandboxHost`
implements in-memory file/stdio operations backed by the playground VirtualFs.
No new provider, public module, export, OS constant, import rewrite, native
fallback or test-specific compiler exception is needed.

Two original crate-owned Jai fixtures declare only the existing C-shaped foreign
hooks they use. These declarations are private sandbox protocol consumers, not
public Thread/POSIX/File compatibility or portable native C bindings. The mutex
u64 is an address-keyed sandbox token, not an assertion about pthread_mutex_t
layout. The scheduler's u64 handles are its existing logical identifiers. Entries
are genuine typed-pointer C-call procedures, and joins return actual callback
results. No fake worker, serial callback loop, fabricated return or ignored error.

- `crates/jai-wasm/tests/fixtures/cooperative-runtime.jai`: three workers must
  cross a start barrier before proceeding, yield while holding a mutex so other
  workers contend/block, perform all thirty protected updates, retain each
  worker's ten completions, and join its actual returned work pointer. A fake
  serial worker loop cannot pass the barrier. All foreign status values are
  checked. Repeated runs test scheduler isolation and cleanup after real joins.
- `sandbox-files.jai`: real virtual stdio writes, closes and reopens /tmp/x.txt,
  verifies exact data/EOF, reads actual workspace source bytes, and checks missing
  files. A second independent play cannot see the first run's file.

The Rust playground test is split into these positive runtime checks and explicit
public Thread rejection. Negative scheduler controls reject an invalid join
handle and report a real blocked-join/mutex deadlock. No passing skip replaces
any old behavioral assertion. Standard-library calls/asserts are replaced by
independent runtime status/data/exit checks, preserving and strengthening the
original scheduling/file intent at the provider that actually owns it.

`tests/compiler-semantics/browser-thread-target-rejection.jai` and the CLI
`cleanroom_browser_guard` test require actual public Thread import rejection on
wasm64-unknown-wasi. The playground and real wasm32 compiler-host tests likewise
require a static-assert target diagnostic for that import, without pinning its
public/private implementation file location. The public source/guard
and all native Thread implementations are unchanged.

## Reproduction and executed evidence

User's current CI reports a Thread target-guard failure with the other 29 tests
passing. This checkout's older independent staged library fails the old combined
test first at File's OS_IS_UNIX guard (`target/playground-thread-red.log`). An
isolated actual Thread import then confirms its direct browser guard separately
(`target/playground-thread-guard-exact.log`). These are distinct baseline facts;
no claim that this local staged snapshot is the current CI candidate. No peer
active tree/branch/source was fetched, inspected or edited, and no remote operation
was required for the independent reduction/design.

The first private fixture draft used puts, which this provider does not support;
both actual failures are retained in `target/playground-runtime-split-first.log`.
The fixtures now use its existing write hook with exact byte-count checks rather
than adding a stub/alias or broadening the runtime. Runtime/storage operations
themselves had already reached the final output call in that failed run.

Executed commands (own sources, independent staged prelude):

```
JAIC_STDLIB=$PWD/target/runtime-configuration-candidate/stdlib CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo test --locked -p jai-wasm --lib play::tests::sandbox_
JAIC_STDLIB=$PWD/target/runtime-configuration-candidate/stdlib CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo test --locked -p jai-wasm --lib play::tests::public_thread_module_rejects_browser_target
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm JAIC_STDLIB=$PWD/target/runtime-configuration-candidate/stdlib CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo test --locked -p jaic-cli --test cleanroom_browser_guard
JAIC_STDLIB=$PWD/target/runtime-configuration-candidate/stdlib CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo build --locked -p jai-wasm --target wasm32-unknown-unknown
node tools/check_playground_runtime_wasm.mjs target/wasm32-unknown-unknown/debug/jai_wasm.wasm
```

Four focused playground tests pass, including actual worker execution under the
native Rust sandbox host. Actual wasm32 execution repeats each fixture three
times and verifies file isolation, invalid join, deadlock and public Thread guard;
it is not a compile-only substitute. CLI evidence is source checking/rejection,
not native OS threads or a native SDK execution claim. Logs:
playground-runtime-controls, playground-thread-guard-exact,
playground-runtime-cli-guard and playground-runtime-wasm-execution-final under
target. Scoped Rust formatting/item spacing, host all-target and actual wasm32
clippy -D warnings, fixture jaifmt --check and target-aware strict jailint pass.
The deliberate public Thread rejection fixture is formatted but intentionally
not treated as a positive linter root; its failure is required by the CLI test.

## Full local suite and integration handoff

`target/playground-runtime-full-suite.log` retains the complete local browser
suite result: 25 pass, seven fail, no ignores. Other tests are unchanged. Their
exact expectations and classifications for the owning integration/test reviewer:

| Failing test | Expectation/evidence | Disposition |
| --- | --- | --- |
| allocations_the_host_cannot_make_fail_without_aborting | Basic alloc(-1) must return null; local module asserts instead | Wrapper policy not established by the reviewed inventory inspected here; obtain exact contract. Preserve genuine host-allocation/no-abort fuzz safety with an independent provider regression. |
| exit_ends_the_program_with_its_code | Basic.exit on browser WASM | Reviewed Basic limits exit to declared POSIX/Windows targets: unsupported public API oracle. Preserve provider process-exit coverage separately; do not add a WASM facade export. |
| lines_are_read_with_file_read_line | File.read_stdin_line on browser; local File guard fails | Public name absent from current reviewed File inventory and target coverage cannot be inferred. Preserve line/EOF/CRLF behavior via supported sandbox protocol in the separate migration. |
| standard_input_is_read_through_the_c_stream | Import public POSIX for browser stdin | Unsupported module-target oracle; public guard must remain. Preserve actual sandbox stdin behavior via private supported hooks. |
| play_exports::arguments_and_fixed_input_reach_the_program | Same POSIX-dependent input fixture through export bridge | Same target issue; export owner must retain args/input coverage when migrating its fixture. |
| output_keeps_the_order_of_stdout_and_stderr_writes | Basic.log_error adds a newline; local output lacks it | Reviewed declaration alone does not establish logging newline policy. Review behavior oracle independently; retain real ordered stream-write coverage. |
| language_server::expansions_inlay_hints_and_format_strings_work_in_the_bridge | Expected bridge metadata differs in local staged Basic | Separate dependency/IDE result requiring integration/LSP owner review. No recovery/cache/metadata feature was changed here. |

These failures are neither suppressed nor counted as completion. Integration
owns its active tree and other native/test migrations. Adopt this small test-only
split into the approved current baseline, rerun the whole browser suite there,
and audit public Thread/POSIX-dependent tour/runtime examples under reviewed
target contracts. This worker claims no current-candidate full pass or browser
stdlib completeness. Existing sandbox ABI/lifecycle limitations remain; no
native pthread ABI, CPU parallelism or public WASM Thread promise is added.
