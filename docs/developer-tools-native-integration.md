# Developer tooling native integration

This worker owns the native sources/build scripts below. Shared manifest and packaging changes remain coordinator-owned. The proposed machine-readable dependency entries are in [the owned manifest](../tools/developer-tools-native-manifest.json); they are not integrated shared configuration.

## Bindings_Generator build and link

1. Supply the official SDK through `DEVELOPER_TOOLS_LLVM_PREFIX` or `python3 tools/build_developer_bindings.py --llvm-prefix <sdk>`. The SDK must contain `bin/clang`, public `include/clang-c` headers and `lib/libclang.dylib` or `lib/libclang.so` for the build host. No original Jai distribution or vendored module is an input.
2. Build `stdlib/internal/developer-tools/clang-bindings/main.c` using that SDK's compiler, include directory, library directory and runtime search path. The output is `stdlib/internal/developer-tools/clang-bindings/developer-tools-clang`; the public driver derives this location from its own source path.
3. Create the private libclang symlink and `compiler-path.txt` in the same directory using the configured SDK. The public native facade references the symlink; include discovery reads the configured compiler path. Keep the configured SDK installed for runtime use; binaries are not copied into stdlib.
4. Shared source-build/package setup should run this build action after installing the SDK and before compiler metaprograms/native binding consumers execute. Preserve the helper's stdlib-relative location. Rebuild/reconfigure on another host or SDK; a package must not retain a producer machine's absolute symlink.
5. Run the original public generator/native API fixtures and inspect production helper/native consumer dependencies against the configured SDK. Runtime effects, configured-path checks and SDK version evidence must remain distinct from source-only cross-target checks. The current host uses SDK23 while the reviewed compatibility constant stays21; SDK21 execution is not certified.

`tools/check_developer_sdk_configuration.py` stages an owned nondefault SDK layout pointing to the installed official SDK. It verifies the production helper's library and runtime search path, native facade consumer links and actual configured compiler invocation during include discovery. Original C bindings execute through the interpreter and native O0/O2 consumers. The test restores the primary SDK configuration afterward. [Host evidence](native/developer-tools-configured-sdk-evidence.json) certifies this host SDK23 configuration; Linux execution and SDK21 remain pending. Source-build packaging must regenerate both the private symlink and compiler path on the destination.

## Iprof native clocks

The measured manual core uses existing canonical POSIX/Windows dependencies directly; there is no new private clock binary to package. Preserve normal libc/kernel32 linkage through those facades. Host interpreter/native O0/O2 verifies actual monotonic-clock spans, counts, lifetime and measured CSV. `tools/check_developer_profiler_windows.py` separately checks public SDK counter-record ABI, x64 O0/O2 kernel32 imports and arm64 compilation. Its [evidence](native/developer-tools-profiler-windows-evidence.json) does not certify Windows execution. Coordinator jobs must execute the original manual-clock fixture on Windows/Linux before promoting those branches to native coverage. Automatic instrumentation/frame history/report creation remain implementation work.

## Debug native runtime

Build the owned `debug-native` sources with `tools/build_developer_debug.py` for the destination host. Install the resulting library beside its sources, matching the existing facade's private foreign-library reference. The Windows backend additionally links public SDK DbgHelp/kernel APIs; its cross-build evidence does not certify Windows execution. Coordinator integration must also provide common DbgHelp serialization if other components use that process-global API concurrently.

## Coordinator-owned acceptance steps

Debug-format fixture jobs also require the configured official `llvm-dwarfdump`, `llvm-objcopy`, `llvm-pdbutil` and LLD tools. The focused runner produces original C debug objects/PDBs, SDK row/FPM byte oracles, then stages the owned private DWARF line decoder for isolated execution. That pure Jai decoder adds no production native library or shared manifest entry. Its staging is test-only; public DWARF compilation-unit/parser integration remains unfinished. Retain host decoder execution separately from execution of the x86/x64/arm64 target programs, which these jobs do not run.

- Add these build actions and installation paths to the shared dependency manifest without changing public module identities.
- Exercise source builds in configured SDK jobs, keeping SDK21/SDK23 results separate.
- Run Windows native Debug and binding workflows on Windows; retain Linux runtime jobs separately from this worker's host decoding/target checks.
- Package or rebuild the private helpers without absolute producer paths, and run public binding generation from an installed stdlib layout.
- Keep the new reviewed-spec test runner as the developer-tools gate. Legacy replaced-stdlib compatibility tests are not required by this worker.
