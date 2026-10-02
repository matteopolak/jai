# CLI workspace artifacts

## What it is

The CLI's `build`, `emit-object`, and `emit-llvm` commands execute source compiler recipes through the bounded workspace scheduler, then emit real artifacts for the resulting checked workspaces. A recipe may have no root `main` and create child applications instead.

## How it works

`workspace_build.rs` constructs one `CompilerSession` and `WorkspaceScheduler` using the selected LLVM target's actual source platform and layout. The scheduler rebuilds graphs when `#run` commits generated source, files, children, or build settings. All workspaces must finish semantic checking before the CLI plans output files. Empty children report that they are awaiting inputs; executable children with source but no application entry also fail explicitly.

`compiler_destroy_workspace` retires its selected workspace from the build plan. Retiring the root preserves surviving children and their independent destinations. A session that retires every workspace succeeds without selecting native tools or producing artifacts, including for `emit-llvm` on stdout; any existing output files remain untouched. Retired children do not require inputs or an entry, and their invalid source is never compiled. Retirement is transactional: a later rejected request rolls back the recipe, and the CLI publishes no artifacts for that failed build.

`jai_sema::select_entry` looks up the root source namespace's `main` binding, follows its `DeclarationId` into the same checked library, and validates its parameter and result types. Imported `main` procedures cannot become application entries. No debug name, synthetic procedure, or second semantic execution supplies the entry. A root with no entry can orchestrate child builds; an executable build with no actual entries produces an error. Object and disabled-output workspaces can be checked libraries without an entry.

Committed bitcode and machine optimization settings override the corresponding CLI defaults when set. A requested target that differs from the selected target is rejected by the scheduler before artifact emission. Host executables use the guarded installed Clang path; cross-target object and LLVM emission use the selected LLVM machine. Executable emission uses a real checked entry procedure. A source `OBJECT_FILE` workspace lowers its checked library bodies without adding an executable wrapper. Object publication uses all bodies unless explicit program exports select runtime roots; bodies that reach compiler-only requests fail native lowering. `NO_OUTPUT` explicitly suppresses emission after semantic checking.

`DYNAMIC_LIBRARY` and `STATIC_LIBRARY` require an explicit [program export table](program-exports.md). Exported procedures must use `#c_call` with no implicit context. Lowering retains the exported procedures and their runtime dependencies without publishing compiler recipe bodies. A host dynamic library uses installed Clang on macOS or Linux, with its requested filename recorded as the loader identity; a static library uses installed `llvm-ar` on a freshly emitted object. Cross-target dynamic linking is explicitly unsupported. `emit-llvm` and `emit-object` inspect the same checked library without packaging it. Library builds require no language `main`.

Compiler `output_path` takes precedence over the command's output argument and resolves relative paths against the physical root source's directory. Without a source override, the root uses the command's output; children append a sanitized workspace name, or `workspace-ID`, to that path. LLVM children without a command output receive a file beside the root source. Duplicate destinations, source-input overwrites, and protected reference or selected native-tool destinations fail before writing any artifact. Each file is staged and renamed after its object emission, archive, or link succeeds, preserving an existing destination on failure. Native/backend errors after planning can still leave earlier successfully emitted workspace artifacts; multi-artifact emission is not an atomic filesystem transaction.

When the source Compiler setter supplies its actual `#caller_location` parameter, the session retains the latest committed origin for each setting. Artifact policy errors use that location for output kind and destination failures; setters without location metadata retain an explicit diagnostic without a fabricated source position.

`check` and `check-library` retain their pure, single-unit policy and write no native output. Their source discovery and final semantic check share one actual compiler session and type/layout policy. Discovery uses `DiscoveryEffectPolicy::Disabled`, so source conditions can receive typed semantic decisions while compiler mutation and output effects remain unavailable. They are not workspace execution commands. Warning and informational compiler messages go to stderr. Committed `write_string` and `write_strings` effects forward their raw bytes to the requested standard stream, including non-text bytes. Failed transactions publish no output, and scheduler replay does not print a committed recipe twice. A recipe that writes to stdout before `emit-llvm` also places those requested bytes before the IR; use a file output when the IR must be separate.

Final checked [source warnings](deprecated-procedures.md) render once per workspace or check result, retaining both the original use site and related declaration site. The CLI consumes the checked library's retained diagnostic payload; intermediate scheduler passes stay silent.

Example of a reduced, independently authored compiler recipe:

```jai
compiler_create_workspace :: (name: string) -> s64 #compiler;
add_build_string :: (data: string, w: s64) #compiler;
Build_Options :: struct { output_path: string; }
set_build_options :: (options: Build_Options, w: s64 = -1) #compiler;

recipe :: () {
    child := compiler_create_workspace("child");
    add_build_string("main :: () -> int { return 37; }", child);
    set_build_options(Build_Options.{output_path = "child-program"}, child);
}
#run recipe();
```

`jai-rs build recipe.jai` builds `child-program` beside the recipe. It does not fabricate a root executable.

## How to change it

Extend artifact planning in `jai-cli/src/workspace_build/planning.rs` and CLI settings seeding in its `settings.rs` sibling, CLI/environment target parsing in `backend.rs`, and source selection in `source_configuration.rs`. Keep entry selection in `jai-sema/src/modules/entry.rs` shared with ordinary executable resolution. Additional artifact kinds need a typed request, source publication/symbol policy, and packaging implementation rather than treating an unsupported child as successfully built.

Pure checking is orchestrated in `source_check.rs`. Keep its discovery and final resolver on the same actual session with `DiscoveryEffectPolicy::Disabled`; source decision metadata must refer to the retained graph's declaration, module, and type identities.

Keep final source-warning rendering in `source_warnings.rs`, called only by the successful check and scheduler consumers. Extend semantic collection and `jai-source` validation when adding another warning category; printing during resolution would repeat diagnostics after generated-source rebuilds.

When adding a supported compiler setting, update its source projection, VM request, driver `BuildSettings`, scheduler policy, and artifact mapping together. Test settings by running the CLI against independently authored sources and executing only newly emitted host fixtures. Do not execute or link supplied reference native tools, objects, or libraries.

The authored lifecycle, compiler prelude and runtime schema fixtures are mandatory on a clean checkout. The complete prelude source comes from `jai_modules::compiler_prelude_source()` and its repository-authored fragments, so generated-source replay cannot silently skip its integration check. Authored C consumers use installed Clang from `LLVM_SYS_221_PREFIX` or `PATH`, with the same supplied-input root exclusion on every host.

`workspace_lifecycle` also exercises a retained stallable source guard that loads only its selected file, a parent waiting for an actual `NO_OUTPUT` child, and checked record-field runs that precede global initialization and ordinary parameter defaults. Each positive case builds and executes a freshly emitted host program; cancellation and retirement cases preserve the prior destinations.

## Configuration

The ordinary native flags and environment variables are documented in [native build](native-build.md). `JAI_RS_AR` selects an installed archiver; by default the CLI uses `llvm-ar` under `LLVM_SYS_221_PREFIX` (including the build-time prefix), or searches `PATH`. Both compiler and archiver paths are canonicalized and excluded from supplied reference executables. Loader and native library search overrides are removed from native tool subprocesses. Ordinary source-declared local native libraries remain unsupported and are never opened. The separately configured [reviewed VMA gate](reviewed-native-linking.md) validates one exact declared library identity and links only its fresh source-built snapshot; a source path or persisted receipt cannot supply link authority. Scheduler and replay limits retain their bounded defaults documented in [workspace scheduling](workspace-scheduler.md).

Native tool and output protection also resolves lexical paths and symlink prefixes before requiring a final file to exist. Protected `reference`, `vendor`, and `corpus/upstream` paths remain protected in a clean checkout, including dangling aliases into an absent source directory. Permission errors and malformed paths fail explicitly; only missing optional source fixtures are skipped. Extend prefix handling in `native_paths.rs` and preserve the protected-root tests in `native_tools.rs`.

`JAI_RS_MODULE_PATH` lists ordinary module search roots. `JAI_RS_STDLIB` adds one explicitly selected source-library root and requires real Preload source there or in the ordered search roots. Explicit directories and bootstrap file paths must exist and are canonicalized before graph loading. `JAI_RS_PRELOAD=off`, `search`, or a source-file path explicitly overrides Preload selection. With neither standard-library nor Preload selection, the CLI preserves its standalone mode. Selecting a library root never makes a missing Preload optional.

`JAI_RS_RUNTIME_SUPPORT=search` or a source-file path selects an actual Runtime_Support module. It requires Preload and all three explicit boolean settings: `JAI_RS_RUNTIME_ENTRY`, `JAI_RS_RUNTIME_INITIALIZATION`, and `JAI_RS_RUNTIME_BACKTRACE`, each accepting `true`/`false` or `1`/`0`. `off` disables Runtime_Support. The CLI stages these values as authoritative root workspace build settings before any recipe executes. The scheduler derives its checked `DEFINE_SYSTEM_ENTRY_POINT`, `DEFINE_INITIALIZATION`, and `ENABLE_BACKTRACE_ON_CRASH` module parameters from each workspace's actual settings on every rebuild; source build options can change them. Entry without initialization, or backtrace without entry, is rejected as an invalid explicit CLI policy. This configuration does not establish that the complete supplied library compiles; unsupported source features remain ordinary located diagnostics.

## Dependencies

`jai-driver` workspace scheduling and compiler transactions, `jai-modules` physical/virtual source providers and bootstrap policy, semantic source entry selection, the LLVM backend, installed Clang, and installed `llvm-ar` for archives. Compiler recipes run in the Rust VM; supplied native binaries remain static reference material.
