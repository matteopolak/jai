# Legacy expectations versus reviewed contracts

This classifies failures without removing coverage or changing public applications.
Reviewed specifications and new genuine behavior fixtures are the oracle. Original
failure evidence remains in the integration artifacts directory.

| Expectation / location | Evidence and action |
| --- | --- |
| Basic.log in LSP ambiguity/ranking tests | Basic inventory explicitly lists both log/log_error overloads. Missing implementation is genuine. Tests remain unchanged; request 14 corrects the earlier integration misclassification. |
| Basic/print.jai or Basic-only definition locations | Independent architecture puts implementations in internal/basic with exact public aliases. Navigation now targets canonical definitions and requires both reviewed overloads. Re-export navigation remains asserted and reveals a genuine recovery failure. |
| Explicit allocator arguments in basic-allocation-arrays.jai | Basic specifies alloc(size), free(memory), realloc(memory,size,old_size); allocator selection belongs to context. This mixed fixture remains failing pending complete assertion-preserving migration. No extra overload is invented. |
| compiler_custom_link_command_is_complete(w,status) in library/CLI/native fixtures | Compiler inventory specifies one Workspace argument. Command-result/error coverage needs actual result checking and compiler_report; discarding nonzero status would weaken coverage. Existing failures remain. |
| Workspace IDs 2/3/4 in compiler-workspace-ids.jai | Workspace handles are opaque; numbering is not reviewed. Identity/lifecycle tests should use returned handles. Its get_current_workspace failure during actual #run is separately a genuine compiler investigation, retained. |
| WASI Basic.exit used by preserved Extensions/Args | Reviewed Basic lists exit only in POSIX/Windows sections. Extensions remain unchanged. This is an integration-contract conflict for coordinator review, not authority to invent an export or omit formatter/browser checks. |
| Formatted #place aggregate in c_structs_by_value | C values/ABI calculations match, but a placed array prints additionally. Basic omits overlay members; whether #place sets reflected OVERLAY needs a precise decision. Keep the original assertion and investigate metadata rather than blessing output. |
| Runtime fixture overrides configured bootstrap flags | Startup options must align with executable/embedding configuration. Complete original source remains a required conflict rejection; unchanged storage assertions separately pass against the configured runtime. Alternate-instance behavior remains questioned. |
| New debugger fixture accessed B.Memory_Debugger_Interface | Latest Basic review explicitly makes it a contextual constraint type, not an ordinary export. That access is replaced by non-export assertions and an explicit rejection case; public selected Hooks identity and all callback/allocation assertions remain. A general declaring-file lookup fix lets the real parameter defaults use the private helper. |
| Browser C I/O/exit tests imported POSIX or called read_stdin_line/Basic.exit on Wasm | POSIX's documented target guard excludes Wasm; Basic.exit is only native POSIX/Windows, and no reviewed File/Basic read_stdin_line exists. The tests now declare the actual sandbox C ABI directly, preserving fgets/getline/getc/fread/EOF, argument/input export, CRLF/empty/unterminated line and process-exit output/status assertions. No public export was added or platform guard weakened. These test programs establish the compiler host bridge, not new stdlib API compatibility. |
| Oversized host allocation fixture expected alloc(-1) to return null | Negative Basic allocation is rejected by the independent allocator's existing assertion, not a valid size. The two enormous positive requests and huge global-memory failure retain all original output/cannot-allocate checks. A separate required negative-size test now asserts a contained runtime diagnostic and alloc call stack, preserving host-survival/negative-input coverage. |

Oracles: [Basic](../specs/stdlib/modules/basic.md),
[Compiler](../specs/stdlib/modules/compiler.md),
[Runtime_Support](../specs/stdlib/modules/runtime-support.md), and
[scope language](../specs/jai/modules-workspaces-and-examples.md).
See [requests](../integration-requests.md) and
[deviations](../status/integration-deviations.md) for unresolved work.
# Refresh-nine fixture corrections

- `crates/jai-wasm/src/play.rs` output-order fixture explicitly supplies the
  newline to `log_error("bad\n")`. The reviewed Basic logging policy does not
  append one. All stdout/stderr content and ordering assertions remain intact.
- `tests/portable-stdlib/basic-sleep.jai` keeps the real elapsed-time lower bound
  and zero-sleep check, using native QueryPerformanceCounter/frequency on Windows
  and POSIX monotonic time elsewhere. The former unconditional POSIX test import
  rejected Windows before exercising the supported public sleep operation.

