# Platform and native host boundary

## What it is

`jai-platform` owns the portable source snapshot and typed host-service interface. Its optional native source adapter uses the recovered `jai-native-source` observations; the driver native host adapter wraps actual registered `HostIo` grants without opening a supplied compiler or native library.

## How it works

An embedding selects a source provider separately from explicit host capabilities. `VfsSnapshot` retains immutable source byte images under a portable POSIX namespace; missing inputs never fall through to OS files. Native snapshots retain an actual successful read, verify its decoded bytes through the lexer, and preserve the owning `SourceTextSnapshot`. The dependency packet registers that native observation/overlay/loader path once.

`HostServices` extends the existing VM request protocol. Requests and suspended journals retain their exact `SourceOrigin`, allocated root grant and actual pending ticket. A VFS host stages file and console operations, checks complete replay and revision/quota admission, then publishes one in-memory transaction. Processes, clock and arbitrary foreign/native services stay explicitly unsupported by that host.

`NativeHostServices::new` consumes an already configured `HostIo` root and rejects active, parked or previously observed source journals. It forwards original-input protection, exact argument/program policies, fingerprint checks and actual opaque suspend/resume/cancel tokens. Its private console transaction is validated before native publication. The current underlying provider admits one distinct file target per transaction; broader native publication requires a separate real journal.

This finite recovery registers the source/host producers and their direct typed protocol consumer. It does not register the old `PlatformCompilerSession`: the current compiler session lacks its required owned suspension APIs. Retained whole-build host attachment, final-library binding capture, source ABI selection and browser worker execution require their own current producer/consumer closures. No source-name-only grant, empty pending job or fabricated completion is provided.

## How to change it

Keep OS source reads in `jai-native-source`. Extend the canonical VM host protocol and Platform interface together, checking grants and retained byte admission before observation. Preserve the actual cached-read validator, source allocation witnesses and original-input policy. Native constructors must attach before observations, and cancellation must use the same actual parked token; equal path spelling does not transfer authority.

The authored tests cover VFS rollback/replay, exact grant separation, source edits, quotas and console rejection. Native adapter tests stage a real file and prove a rejected console publication leaves its sentinel intact, retain original-input write protection, and reject adoption of an active journal. These fixtures remain unexecuted until the coordinator runs the combined dependency closure.

## Configuration

`VfsLimits` defaults to 4 MiB of canonical filenames plus payload and 4096 files. `VfsHostLimits` defaults to an 8 MiB journal, 4096 requests per origin, 1024 origins and 1 MiB of console output. A VFS root, working directory and write/console grants are explicit constructor inputs. Native root and reviewed program grants are registered through `HostIo` before adapter construction.

The `jai-platform/native` feature selects the native source umbrella on non-wasm targets. Driver native host registration is target-gated. The portable Platform crate depends on neither LLVM nor native filesystem source adapters by default. This packet alone does not claim the entire driver is wasm-ready.

## Dependencies

`jai-source` supplies the recovered pure `SourceProvider`, path normalization and actual source owner types. The graph source-provider packet supplies `jai-native-source`, real cached read/decode validation and loader/facade consumers. `jai-platform` uses `jai-vm`'s actual typed request protocol. The driver adapter uses existing `HostIo`, `OriginalInputPolicy` and `CompilerSession` identities. Compiler journal attachment is owned by the current driver/source recovery, not emulated here.
