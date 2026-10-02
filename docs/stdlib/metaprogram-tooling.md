# Metaprogram tooling

## What it is

This area provides independently authored pieces of the standard-library tooling APIs. It currently supports an example plugin, text helpers, format recognition, metadata records, and validation; it does not provide a complete build, profiler, bindings, project, or packaging system.

The [machine-readable API inventory](../../stdlib/.coverage/metaprogram-tooling.json) records 56 reference source files, including procedure signatures, defaults, record fields, enum members, declaration visibility, source hashes, and implementation status. Native binaries, examples, and tests are excluded. Newer maintained declarations take precedence for conflicting contracts; the original distribution contracts are labeled `legacy`. Reference files were read as API specifications and were not executed or linked.

## How it works

| Component | Implemented behavior | Remaining work |
| --- | --- | --- |
| `Example_Plugin` | Allocates a real `Metaprogram_Plugin`, registers callbacks, counts messages, reports phases and typecheck counts, handles `-option arg`, and frees the plugin at shutdown. | Running a complete compilation with the legacy message service. |
| `Program_Print` | Appends escaped string-literal contents to a `String_Builder`. The caller supplies quotation marks. Legacy `print_procedure_bodies` is retained. | The newer `print_expression(builder: *String_Builder, node: *Code_Node)` needs a genuine compiler AST printing provider. AST reconstruction and plugin output are absent. |
| `Toolchains/macOS.jai` | Produces target triples and converts macOS/iOS versions to Darwin versions. | SDK discovery and subprocess execution. |
| `MacOS_Bundler` | Writes plist XML keys, strings, booleans, and complete document wrappers. Text escapes `&`, `<`, and `>`. Unsupported `Any` types return `false` before appending a key. | App directories, executable/resource copies, and icon conversion. |
| `Project_Generator` | Derives the legacy project-filter folder for a source path, with substring trimming for `modules` and `doc` and rejection of `..`. | Solution, project, filter, and user-file generation and writing. |
| `generate_c_header` | Maps the reserved identifier `signed` to `_signed`. | Exported type collection and complete C declaration/header generation. |
| `Bindings_Generator` | Exposes the newer options record, strip flags, and default include path. | `generate_bindings(options: Generate_Bindings_Options, output_filename: string) -> bool` is absent. |
| `Codex` | Exposes the legacy packed `Metrics` record and revision-control enum, with the original usage-mode parameter. | Metric collection, compiler plugins, serialization, file loading, and the remaining records. Selecting `READ` or `WRITE` does not supply those services. |
| `Simple_Package` | Exposes entry, header, and table-of-contents metadata. Its private header validator checks magic/version and offset bounds without overflowing an offset-plus-size expression. | Package initialization, entry loading, lookup tables, memory ownership, and writing. |
| `debug_info` | Provides a bounded private C-string reader. Invalid offsets and unterminated strings return failure. Returned text borrows the input bytes. | DWARF, CodeView, and PDB decoding. |
| `executable_formats` | Recognizes archive, Apple universal, AMD64 COFF/PE, ELF, and 64-bit little-endian Mach-O headers. Removes trailing zero padding from byte arrays without indexing an empty array. | Full object/archive parsers, relocation handling, symbols, section access, and Mach-O generation. |

`Autorun`, `Performance_Report`, `BuildCpp`, `linux_build`, `Iprof`, and the Android SDK/project/plugin workflows have API inventory entries but no callable implementation. The newer `BuildCpp` and `Bindings_Generator` sources contain trivial return bodies; those bodies were not reproduced. There are no success-returning substitutes for unavailable build or generation work.

Recognition is deliberately narrower than a complete file validator: `is_coff` accepts AMD64 headers, `is_macho` accepts the 64-bit little-endian magic, and `is_elf` requires at least 64 bytes. A recognized header does not establish that the rest of the file is valid. PE probing checks every referenced header span before reading it. These probes read bytes explicitly rather than dereferencing potentially unaligned typed pointers.

The version helper uses `minor + 4` for macOS 10, so `10.13` gives Darwin `17`. This follows the original API's examples; its implementation used an inconsistent subtraction. Package header validation accepts an empty table of contents ending exactly at the file boundary and rejects offsets below the 64-byte header. Plist generation assumes input strings contain valid XML text and does not validate Unicode or forbidden XML control characters.

## How to change it

Extend the corresponding file under `stdlib/`, and update the matching inventory entry from `pending_absent` only after a real implementation exists. Preserve parameter names, defaults, visibility, fields, and enum values. Keep incompatible legacy records distinct from newer maintained contracts. `Example_Plugin` uses `#import,file "legacy/Compiler/module.jai"` because its callbacks use the original message ABI. `Program_Print` currently uses only `Basic.String_Builder`; its independent escaping helper does not import or inspect either compiler AST schema.

Text helpers append to the caller's builder and do not own its final string. Binary probes and string views do not allocate and borrow their input storage. Do not add decoder functions that report success without parsing and validating their output, and do not use the bundled reference libraries or compiler as execution providers.

The frozen independent compiler snapshot is `target/standard-library-snapshots/b1b820444e2a6585cda11d8efc2bf2186c5a6623cf54312552ba403d4e64fd13/jai-rs`. Check syntax with `parse FILE`. Check resolved source with:

```sh
JAI_RS_MODULE_PATH="$PWD/stdlib" \
JAI_RS_PRELOAD="$PWD/prelude/Preload.jai" \
JAI_RS_RUNTIME_SUPPORT=off \
target/standard-library-snapshots/b1b820444e2a6585cda11d8efc2bf2186c5a6623cf54312552ba403d4e64fd13/jai-rs check-library FILE
```

The inventory includes the final per-file results and an independently authored compile-time probe with malformed/truncated headers, overflow-sized PE offsets, zero padding, unterminated strings, and path/name cases. Its inverted assertion must fail. Native execution, complete plugin sessions, and subprocess workflows have not been verified.

A separate observation uses frozen CLI snapshot `9508def6f527169083405db10c93d9d377289fecdca749a546eb849ca39d501d`. All 11 authored files parse; seven pass source checking. `Example_Plugin`, `Program_Print`, `MacOS_Bundler`, and `Toolchains/macOS.jai` stop at the shared `Basic/String_Builder.jai:2:38` typed constant-evaluation diagnostic. The pure compile-time probe passes, and its inverted assertion fails. Source-file and source-root hashes were unchanged across this observation. Earlier results remain in the inventory. `build_inputs_verified` is `false`: this frozen CLI predates later Rust changes and does not prove that the current Rust tree was built or tested.

## Configuration

`Example_Plugin` accepts `-option arg`; its message count is shared by module instances, matching the legacy example behavior. `Codex` retains `USAGE_MODE := Usage_Mode.WRITE`, with `WRITE = 1` and `READ = 2`. The newer binding-options record contains `libpaths`, `libnames`, `include_paths`, `source_files`, `system_include_paths`, `extra_clang_arguments`, `strip_flags`, and `header`; the default include-path constant is `/usr/include`.

`Toolchains/macOS.jai` has no SDK environment lookup yet. Original `MACOS_SDK_PATH`, Android `NDK_HOME`/`ANDROID_NDK_HOME`, Linux SDK paths, profiler module parameters, and build-tool switches are recorded as pending API/configuration surface in the inventory. No environment lookup or command execution is implied by those records.

## Dependencies

Plugin callbacks use the independently authored schemas in `stdlib/legacy/Compiler/` and `Basic` allocation/output. String and plist helpers use `Basic.String_Builder`; target triples use `Basic.sprint` and assertions. The standalone probes, metadata schemas, header validator, bounded string reader, and path/name helpers need only the independent preload types and source language.

Future build, SDK, and bundle workflows require independent process/filesystem providers. Bindings generation requires an explicitly configured external libclang implementation rather than bundled reference artifacts. Full profiling and compiler reporting require actual message, AST, timing, memory, and output services; format/debug decoders require bounded parsing and documented storage ownership.
