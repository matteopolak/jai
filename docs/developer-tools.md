# Developer tooling

Implementation follows the reviewed public contracts, with canonical records in public modules and private mechanisms under `stdlib/internal/developer-tools`. [Progress](status/developer-tools-progress.md), [deviations](status/developer-tools-deviations.md), [plan](plans/developer-tools.md) and [contract questions](specs/stdlib/developer-tools-questions.md) describe scope and incomplete paths.

## Generate_C_Header

`Header_Info` retains every reviewed public field and zero/default initialization. Populate `exported_types` with reflected types and their C names, or feed `handle_message` compiler TYPECHECKED messages containing PROGRAM_EXPORT declarations. `generate_header` gathers dependencies, forwards struct/union tags, orders by-value definitions, emits C declarators and checks errors before writing. It excludes `main`.

The supported projection includes scalar types, fixed arrays, recursive pointers, ordinary structs/unions, variants, C-call procedures and runtime support records discovered through Header_Info. Enum output defaults to normal C enums; enum_internal_types selects C23 fixed-underlying syntax. Enum member prefixes use uppercase letters from the emitted type name, and type clashes receive numeric suffixes. Procedure values become void pointers. Every record includes C/C++ static assertions for reflected runtime size, alignment and field offsets; compiling the generated header is required validation. Non-C-call procedures, polymorphic structs and imported/constant/void fields are omitted as reviewed. Other unsupported ABI categories produce errors.

Original tests generate headers from real type descriptors, compile C11/C23/C++17 consumers, and call native helpers through Jai FFI. Tests cover field mutation, enum modes, opaque callbacks, support layouts, collision suffixes, non-C-call omission and multiple-return rejection preserving existing output. Support-layout fixtures use test-only records following reviewed bootstrap shapes, not duplicate production prelude definitions. `python3 tools/check_developer_tools.py` runs interpreter/native O0/O2, formatting/lint and target checks using this worktree's source-built tools. Host dylib construction currently targets macOS; Linux runner adaptation is unfinished.

The module is a supported subset. See deviations for production support-descriptor availability, reserved names, explicit alignment/packing and transactional output limits.

## Performance_Report

`+Performance_Report` requests compiler timing, bytecode counters, run-directive records and polymorph records. It buffers a textual summary, sorts run records by elapsed time, and writes on plugin finish. Counters and durations come from Compiler messages. A missing message produces a compiler warning; missing per-category flags are explicitly identified in the summary. Shutdown frees owned state. There are no public configuration options in the reviewed contract.

## Bindings_Generator and staged C parser

`tools/check_developer_bindings.py` builds an independently authored private C generator against the installed official libclang C API. It parses original C headers, emits real Jai bindings with layout assertions, compiles the original native implementation, and exercises generated bindings in interpreter/native O0/O2. Malformed headers and unsupported constructs fail with source diagnostics while preserving existing output. The two-target test verifies LP64/LLP64 C `long` differences and checks generated declarations under matching Jai targets.

The public facade retains reviewed option/model shapes and defaults, exact compatibility arrays, target parameter and literal conversion rules. Both generate_bindings overloads validate a supported one-header/one-library configuration and invoke the source-built backend. It discovers official Clang include paths, unwraps reviewed typedefs, preserves named C parameters/documentation, supports common enum prefixes/aliases and outputs real callable bindings. Malformed input and unsupported options fail with diagnostics and preserve existing output. Returned builders are caller-owned.

Standalone declaration visitors and enum/argument/return-type mutation helpers operate on caller-supplied public model records. Traversal snapshots child pointers, visits shared declaration pointers once and preserves stored parent links. Generation also materializes a C model for both visitor forms and the custom argument-printing hook. Callbacks can rename declarations/parameters, change types and omit output. Generated references follow record names and foreign functions retain original native symbols. Original fixtures rename a record, function and parameter, compile the result and execute C callbacks. Invalid callback output fails and preserves the destination. During generation, parsed nodes/strings/arrays are borrowed until return: do not free or retain them. Caller-created replacement CType records remain caller-owned. Empty include guards and reviewed ignored macros are handled; nonempty macro-value generation remains unsupported.

Run `python3 tools/build_developer_bindings.py --llvm-prefix <official-sdk>` to build the helper beside its private stdlib sources and link the native API to the installed SDK through a private symlink. It neither copies SDK binaries nor depends on the repository target directory. The helper and symlink must be rebuilt for the destination SDK; shared build integration remains coordinator-owned. The [official libclang C API documentation](https://clang.llvm.org/doxygen/group__CINDEX.html) and installed public headers are the only native parser compatibility inputs. The [SDK evidence](native/developer-tools-clang-evidence.json) identifies them. Native APIs also cover diagnostics, source locations, unsaved files and type queries. The reviewed CXIndexOptions record and three bit-view setter/getter pairs preserve reserved bits and match an official C layout probe, including real native index creation. Verification uses libclang23 against the reviewed version21 constant. Callback generation currently parses twice, and C++ bridges, preprocessing models and remaining helpers/reexports are unfinished.

## Print_Vars

`print_vars_to`, `print_vars` and `log_vars` expand over caller expressions. They retain caller scope, use Program_Print for source names, evaluate each expression once, render values/types and align name/value columns. The helper accepts the exact reviewed fixed Code array; the variadic entry points create that array at compile time. `Print_Vars_Config` controls fields, delimiters, indentation and line separators. Logging forwards the caller location. Widths currently count UTF-8 bytes; see questions and deviations for display-cell and source-whitespace limits.

## Rewrite

Initialize a `My_Plugin` through `init`, feed its `gather` hook compiler messages, and call `finish`. Default mode reports edits; explicit `write` enables mutation. No public factory absent from the reviewed contract is added. Deprecated `<<expr` becomes `(expr).*` using the original source expression span. Source snapshots are reread and compared before writes. Overlapping/invalid edits and stale files are refused with diagnostics. Public edit helpers also support independently supplied edits with multiline/CRLF data. Plugin-owned resources are released by its shutdown hook; direct helper callers retain ownership of their input records and strings.

## Debug_Info frame parsing

The initial subset decodes DWARF call-frame instructions and common information entries. It bounds every fixed/LEB128 read, rejects overflow/truncation/unsupported operands, and returns no partial successful result. It supports DWARF32 CIE versions 1/3/4 and little-endian integer operands. Augmentation string/data views borrow input; decoded instruction arrays belong to the active allocator. Operand formats follow the [official DWARF5 specification](https://dwarfstd.org/doc/DWARF5.pdf); public names/records/opcodes follow the reviewed module spec. The fixture parses .eh_frame from an original Clang-built C object and rejects every truncated CIE prefix. Other Debug_Info parsers remain unfinished.

## Debug native helpers

The macOS/Linux subset captures and symbolizes native stacks, checks debugger presence, probes one byte through kernel copy APIs, writes diagnostic text, aborts with reviewed exit codes and traps only when a debugger is present. Symbol text and the returned string array share a native allocation; release the original complete array with `free_backtrace`. The high-level capture uses 256 slots and the low-level helper caps physical capture at 4096 frames. Pointer probes never directly dereference the candidate address. The original protection fixture covers mmap, mprotect and unmap transitions. Actual macOS interpreter/native O0/O2 evidence is separate from Linux source-only support and Android/WASM false-presence target checks. Signal/assert/dialog/minidump/attachment paths remain unfinished.

## Iprof report output and Codex inspection

Iprof's initial subset writes caller-supplied report rows to logs or properly quoted CSV. It omits zero-call rows and uninitialized zones in manual mode, retains conditional zone-history storage, and applies requested text-report minimums. The actual runtime profiler and graphics are unfinished; report tests supply original explicit values rather than claim measured zones.

Codex's initial helpers retrieve a code node's file/import and inspect a resolved declaration's IS_GLOBAL flag. Its public Math import retains canonical module/type identity. The binary metadata format and metrics semantics require refinement before the remaining APIs can be implemented without invented compatibility answers.

## Check

The Windows-only subset exposes the reviewed settings and checks compiler records for array/pointer misuse and small-operand integer promotion risks. It supports manual body invocation and compiler messages, follows module skip settings, and reports continuable compiler errors. Original tests include a real intercepted small-integer procedure and manual array-assignment records. Native binding/symbol and print-format checks remain pending. Two general producer/contract observations are preserved under compiler-requests and listed in progress/questions, separate from the supported passing suite.
