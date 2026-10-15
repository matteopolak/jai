# Full available compiler suite and remaining gates

The entire available jaic and jaic-llvm all-target suite was run with no test-name
filter. The pre-change run passed 299 cases; the final worker-lifecycle run passes
307. The only ignored test is the existing corpus_sweep. It was not unignored,
altered or counted as success: corpus/vendor source restrictions and full corpus
integration remain coordinator responsibility. Windows-only test targets report
zero cases on macOS; that is platform gating, not native Windows runtime evidence.

```sh
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm PATH=/opt/homebrew/opt/llvm/bin:$PATH JAIC_STDLIB="$PWD/target/runtime-configuration-candidate/stdlib" CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo test --locked -p jaic -p jaic-llvm --all-targets --no-fail-fast
```

Logs: target/compiler-full-suite.log (before),
target/compiler-full-suite-final-reviewed.log (after). The command includes all
current library/integration targets, rather than enumerating selected passing
cleanroom targets. No assertions, skip markers, diagnostics or tests were weakened.
This is full available Rust core/backend coverage for the host configuration,
not complete language/API/corpus/platform coverage. The own library candidate
contains the documented private runtime adapter; production adoption is pending.

| Observation / expectation | Classification | Evidence and action |
| --- | --- | --- |
| Invalid POSIX start ABI silently accepted, with a zero-result fallback | Genuine callback ABI defect | Shared signature validation now rejects before spawn; invalid scalar shape diagnoses instead of returning zero. Original red and typed-pointer mutation/join regression pass. |
| Extra LSP auto-import failure during runtime fixture rebuild | Test staging defect | Initial 25/15 result retained; serial 25/16 passes. CLI now stages per-process private candidates and concurrent runtime/LSP checks pass without changing the default candidate or LSP assertions. |
| No current core/backend test failure | Host suite green | 307 pass; no test-name filter. Existing interpreter/native/WASM/ABI/regression targets run normally. |
| Workers survive compiler destruction; program storage previously drops first | Genuine lifetime defects | Original Arc and destructor-order reds retained. Cooperative cancellation/join, callback leases and early interpreter field drop fixed; five original host cases pass. |
| Native duplicated thread handle must report the actual Jai u32 result | Genuine SDK ABI defect | Prior Rust unit entry could report a different OS exit. Real CRT entry now returns the result; original SDK fixture and Windows regressions added. Native execution pending CI. |
| Nondefault managed security/stack options were silently discarded | Unsupported feature presented as defaults | Now explicit original regression-backed diagnostics; normal compiled native SDK path unchanged. |
| Windows runtime/name/backtrace results | Unavailable host verification | Source/clippy/cross-PE evidence only here. Run x64/ARM64 CI commands in windows-thread-entry-lifecycle.md and existing naming/unwind reports. |
| Canonical .data address for named fixed-array constants | Unspecified reviewed behavior / invalid test oracle | Updated core-syntax-and-types.md explicitly establishes no canonical address/lifetime/mutation/equal-constant guarantee. Retain observation; use explicit mutable stable backing. No pooling or passing identity claim. |
| Unregistered alias suspend/resume; nonreturning native calls; active external callback shutdown | Explicit interpreter bounds | Real native queries/waits/results work; unsafe gate bypass diagnoses, and teardown waits native work. Full asynchronous/control integration is not claimed. |
| POSIX native handle interoperability/detach state | Existing reduced scheduler semantics / missing coverage | threads.rs uses scheduler IDs and does not track detach state. This Windows entry batch does not claim native pthread alias/detach conformance; implement genuine POSIX entry/ownership and state validation with independent SDK tests. |
| Native Rust panic=abort build | Explicit unsupported native configuration | Private cancellation requires Rust unwinding; the tested compile diagnostic prevents silent process abort on teardown. wasm32 inline scheduling still builds/runs. |
| Uninstantiated/ambiguous expansion AST result types | Incomplete/refinement scope | Checked concrete results fixed in 6e000b3. Template/ambiguous-span metadata remains explicitly bounded; see typed-expression-metadata.md. |
| RDRAND/RDSEED, RDTSCP processor identifier, WASM cycle counter | Genuine architectural semantic/coverage gaps | Baseline synthetic paths remain documented in cpuid.md and deviations. Real CPUID is preserved; these other operations are not counted completed merely because this suite lacks focused regressions. |
| Portable runtime protocol adoption and D3D/DXC dependencies | Producer/integration gates | Staged candidate support is not production integration. Existing reports retain exact adapter/dependency/SDK-layout evidence. No compiler module-name exceptions or invented exports. |
| Legacy replaced-stdlib suite migration | Integration-owned test provenance work | Mailbox assigns migration/deletion after preserving independent language/safety/ABI/Extensions/corpus cases. This worker does not alter that suite or its skip/coverage baselines. |

No obsolete/private API expectation was restored. No legacy expectation correction
was needed for the full available Rust core/backend run. Positive new tests come
from reviewed language/lifetime requirements and official SDK contracts, not old
library bodies or legacy convenience APIs. Independent source checking and actual
native execution are reported separately. General debugger/alternate-backend and
remaining public AST/API limits stay in the mandatory deviations report; passing
this suite does not establish complete implementation of untested contracts.
