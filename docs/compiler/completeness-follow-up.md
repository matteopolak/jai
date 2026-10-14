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
