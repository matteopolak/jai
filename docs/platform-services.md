# Platform services

## What it is

`jai-platform` is the source and host-service boundary for native and browser embeddings. Its initial implementation is staged for the integration coordinator; passing tests and browser host-service execution must be recorded before treating this boundary as accepted.

## How it works

`Platform::source_files()` supplies a `jai-source::SourceProvider`; `host_services()` supplies explicit typed services. Module discovery and semantic binding consume those providers rather than opening source files themselves. Native source operations live in `jai-native-source`, whose compatibility `Filesystem` and `SourceOverlay` adapters preserve existing native APIs. `NativeSourceSnapshot` retains each first observed canonical filename, file status and source byte image for a source round.

`SharedVfs` stores embedding-supplied files under a normalized POSIX root. `VfsSnapshot` retains immutable `Arc` byte images and a revision. An editor insertion creates data for a later snapshot; it cannot change the bytes a suspended source job already owns. Virtual filenames have identical rules on native and wasm targets: UTF-8, `/` separators, bounded `..`, and no NUL, backslash or drive prefix. Missing virtual inputs never fall through to host files.

`VfsHost` grants a freshly allocated `FileRootId`. Requests require that exact grant, and every transaction is keyed by the actual `SourceOrigin`, including workspace, source range, body and specialization bytes. Reads retain observations, writes and console output remain private until commit, replay must consume the same ordered operations, and a parked journal can resume or cancel only under its original source identity. Atomic publication validates the final file quota and the observed VFS revision before changing files or output. A concurrent editor update rejects publication.

`PlatformCompilerSession` pairs the existing compiler journal with host services. It validates a compiler shadow before staging output and publishing the host journal, then installs the validated compiler state. Source insertion and Compiler Code admission remain the responsibility of the graph owner before committing effects. Genuine asynchronous host tickets retain their keys and journals; unsupported services return typed capability errors rather than fabricated results or empty dependencies.

`NativeHostServices` wraps the existing trusted `HostIo` without weakening original-input guards, reviewed program grants or opaque suspended transaction tokens. The CLI attaches it to workspace builds only after an explicit `--host-file-root`; `--host-file-access read-write` adds writes for that root, while the default is read-only. Without a root, the CLI attaches an empty virtual host that accepts transactional console output but cannot observe native files. Console output uses a private memory journal validated before native file publication. The browser VFS supports file and console transactions; process, clock, CPU, graphics and arbitrary foreign calls require additional authenticated adapters. A capability list alone does not privilege a foreign prototype: semantic binding still validates actual declaration IDs, source receipts, signatures and nominal types.

`PreparedLibrarySession::drive_bound` retains those checked bindings in an opaque `BoundLibrary` with the exact frozen library, target and genuine source bodies. It validates the final foreign-library identity and signature before allowing VM dispatch. Compiler procedures remain compile-time-only in fresh runtime invocations; each invocation receives a distinct origin derived from the prepared source receipt. The VM owns the invocation's begin/finish transaction. Runtime reflection remains missing until an exact reached demand has published an owned snapshot; a cached or default table does not supply that proof.

Each completed source `#run` publishes its own transaction. If a later run or final entry validation fails, effects from earlier completed runs remain committed. The scripting preparation profile must reject unsupported source, workspace and settings mutations inside the request's transaction, before delegating to the compiler journal; that failure rolls back earlier file and console operations from the same run. An embedding requiring atomic publication across the entire preparation needs an outer preparation journal.

## How to change it

Extend `jai-source::SourceProvider` only for source observations. Put native filesystem behavior in `jai-native-source`, and portable host behavior in `jai-platform`. New host requests must use the VM's typed protocol, receive capability checks before observation, and participate in origin-bound replay, suspension and rollback. Charge retained bytes before cloning responses.

Use `FileAbiBindingContext::from_graph_with_provider` for configured native-compatible source trees. `from_selected_sources` is the trusted embedding route for independently authored virtual stdio declarations: it retains the actual graph unit, entry and stdio byte images, and the ordinary ABI binder validates the library and procedures. Neither route loads a native library. Compiler and process source selectors likewise need the selected provider, including its canonicalization rules.

Add parity regressions under `crates/jai-driver/tests/platform_services.rs`: real compiler workspace identities, file/console rollback, exact grant separation, source snapshot edits, suspended transaction identity and final atomic quotas. Browser acceptance must exercise the real wasm worker, multiple source files and actual host requests; source-only compilation alone does not validate file capabilities.

## Configuration

`VfsLimits` defaults to 4 MiB of canonical filename plus payload bytes and 4096 files. Replacements are admitted atomically. `VfsHostLimits` defaults to an 8 MiB retained journal budget, 4096 operations per origin, 1024 origins and 1 MiB of pending/published console bytes. Journal accounting conservatively includes retained snapshots, source identities, observations and staged byte copies.

The virtual root and working directory are explicit constructor inputs. File write and console grants are separate booleans for a VFS host. Native roots and reviewed processes are registered through existing `HostIo` APIs before constructing native services. CLI builds accept one explicit native directory grant: `jai-rs build main.jai --host-file-root ./data --host-file-access read-only` or `read-write`. The root is canonicalized and registered after `OriginalInputPolicy` is installed; writes into protected original-input trees remain denied. No process executable is granted by CLI flags. The `jai-platform/native` feature enables the native umbrella adapter; portable front-end, semantic and VM builds require neither LLVM nor native filesystem operations.

## Dependencies

`jai-source` owns the source contract and portable source name normalization. `jai-platform` depends on `jai-source` and `jai-vm`; optional native support also depends on `jai-native-source`. `jai-driver` owns the compiler journal adapter and existing trusted native `HostIo`. `jai-cli` parses explicit native file grants, installs the trusted original-input policy, and drains only committed console output. `jai-modules` and `jai-sema` retain the compiler's actual source, declaration and arena identities. `jai-runtime` and `jai-wasm` own scripting and browser integration; native LLVM emission remains a separate optional native backend.
