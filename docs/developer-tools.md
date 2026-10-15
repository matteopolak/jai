# Developer tooling

Implementation follows the reviewed public contracts, with canonical records in public modules and private mechanisms under `stdlib/internal/developer-tools`. [Progress](status/developer-tools-progress.md), [deviations](status/developer-tools-deviations.md), [plan](plans/developer-tools.md) and [contract questions](specs/stdlib/developer-tools-questions.md) describe scope and incomplete paths.

## Generate_C_Header

`Header_Info` retains every reviewed public field and zero/default initialization. Populate `exported_types` with reflected types and their C names, or feed `handle_message` compiler TYPECHECKED messages containing PROGRAM_EXPORT declarations. `generate_header` gathers dependencies, forwards struct/union tags, orders by-value definitions, emits C declarators and checks errors before writing. It excludes `main`.

The supported projection is C11 scalar types, fixed arrays, recursive pointers, ordinary structs/unions, exact-width enums/variants and C-call procedures with zero or one return. Procedure values become C function pointers. Every record includes static assertions for reflected runtime size, alignment and field offsets; compiling the generated header is required validation. Unsupported ABI categories produce diagnostics and false instead of dropping declarations.

Original tests generate a header from real type descriptors, compile a C helper against that header, then call it through Jai FFI and verify both its return and field mutation. A rejection case proves implicit-context procedures fail while an existing output file remains unchanged. `python3 tools/check_developer_tools.py` runs interpreter/native O0/O2, formatting/lint and target checks using this worktree's source-built tools. Host dylib construction currently targets macOS; Linux runner adaptation is unfinished.

The module is a supported subset. See deviations before using complex ABI support types, explicit alignment/packing, C++ or transactional output requirements.

## Performance_Report

`+Performance_Report` requests compiler timing, bytecode counters, run-directive records and polymorph records. It buffers a textual summary, sorts run records by elapsed time, and writes on plugin finish. Counters and durations come from Compiler messages. A missing message produces a compiler warning; missing per-category flags are explicitly identified in the summary. Shutdown frees owned state. There are no public configuration options in the reviewed contract.
