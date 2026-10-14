# Compiler completeness follow-up

This continuation addresses four independently reproduced compiler boundaries.
Only reviewed specifications, own compiler sources and NEW producer reproducers
are inputs. Producer tests are copied to this checkout before execution.

1. Constant aggregate writes: reproduce qualified arrays/records and compare
   unqualified, nested, alias and mutable cases. Repair writable-place semantics
   generally; preserve real pointer writes and const diagnostics. Core tests
   reject invalid programs; backend tests execute valid mutation cases.
2. Runtime storage: trace workspace option settlement and runtime initialization.
   Add private compiler-owned configuration propagation without public module
   parameters. Test nondefault executable allocation, late setters and independent
   workspaces. Runtime cooperation outside ownership is documented precisely.
3. Windows interpreted threads: reproduce suspended CRT entry through the
   scheduler, model initial suspension/count/resume/exit and handle cleanup, and
   test scheduler behavior on this host. Actual Windows CPU verification remains
   a separate platform gate; no foreign thread calls interpreted code directly.
4. Alias documentation: trace public facade exports through imports/loads and
   resolve callable headers with cycle/visibility guards. Original LSP tests
   retain alias name, overloads, named parameters/defaults and import edits.

Each batch starts with a failing original test, follows the compiler abstraction
responsible for the behavior, and ends with scoped formatting, regression and
clippy checks plus a durable commit. Unsupported cases and platform verification
limits remain in the deviations ledger and questions document.

## Constant aggregate validation

Assignment checking now resolves every member/index container rather than only
the leftmost identifier. This finds constants behind module/type/alias qualifiers
and preserves pointer indirection into separate mutable storage. Existing-target
declarations (`ok:, record.field = pair()`) use the same validation. Scratch
checking retains macro caller scope, including deferred backtick resolution.
Resolution errors propagate normally; no failed probe is counted as success.

Original core tests reject qualified arrays, records, nested record arrays and
alias qualifiers, plus mixed declarations. Native/WASM64 O0/O2 and interpreter
tests execute mutable qualified globals and constant pointers. The exact two NEW
MPEG rejection fixtures, staged under target/producer-fixtures, both diagnose
`cannot assign into the constant` after refreshing independent portable and
numerics dependencies. Earlier stale-overlay/missing-Math logs are retained.
This repairs direct language assignment; immutable pointer types or protection
against intentional writes through raw addresses are not claimed.

## Managed Windows interpreter threads

`CreateThread` and `_beginthreadex` create gated scheduler threads. Suspension
counts are independent of blocking reasons, so wait expiration cannot release a
suspended thread. Resume reports the previous count, including zero. Interpreted
SuspendThread supports nested counts and self-suspension; suspending a thread
inside native code diagnoses the unavailable OS-level operation. A return or
explicit `_endthreadex`/ExitThread unwinds only that managed thread, records its
exit code and signals its handle. Entry/adopted native-thread termination is
explicitly unsupported. Windows thread ids are recorded on the actual OS thread
before creation returns, and GetThreadId agrees with the creation output.

The [official CRT contract](https://learn.microsoft.com/en-us/cpp/c-runtime-library/reference/beginthread-beginthreadex)
establishes gated startup, unsigned callback results and caller-owned handles;
[explicit CRT exit](https://learn.microsoft.com/en-us/cpp/c-runtime-library/reference/endthread-endthreadex)
terminates the current thread. This implementation uses Rust-owned OS threads
to execute interpreted procedures under the existing baton scheduler.

Original tests execute both APIs, zero/timed waits, nested suspend counts,
resumption, exit-code queries, explicit CRT exit and handle closure on this host.
Cross-target Rust checking/clippy is separate from Windows execution. The exact
NEW Windows producer repro is staged under target/producer-fixtures/windows-threads
for platform validation. Non-Windows scheduler tests use scheduler ids because
they have no Windows OS identity. Actual Windows x64/ARM64 runtime remains a gate.

## Public alias completion documentation

The tolerant export index retains simple dotted constant alias paths and lexical
visibility. A separate alias resolver follows named imports, module/load graphs
and local alias chains, then rewrites callable header names to the exported alias.
Parameter names/defaults and each overload header come from the actual target.
Public facade comments take precedence; target comments supply missing docs.
File-private qualifiers resolve only in their declaring file; external lookups
accept exports only. A visited-path guard and finite depth bound stop cycles.

Original LSP tests cover loaded overloads, private qualifiers, renamed public
headers, valid aliases to private local procedures, inaccessible private targets
and cycles. The unchanged Basic print/ranking assertions pass against the selected
NEW independent library. The auto-import test setup now honors JAIC_STDLIB so this
dependency can be selected explicitly; no assertion/library substitute was used.
Complex computed aliases, struct-member namespaces and unnamed import/filter
resolution retain their original expression documentation in this token index;
they are not represented as fabricated callable headers. Existing display limits
of four headers and 200 bytes per scanned header remain unchanged. This is an IDE
documentation improvement and does not change callable/type/storage identity.
