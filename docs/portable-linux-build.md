# Linux cross-link plugin

The six reviewed exports in `specs/stdlib/modules/linux-build.md` now have real
bodies behind a narrow facade. The facade checks the compiler host, so selecting
a Windows target on Mac does not bypass its Windows-host restriction. The
returned type remains the canonical Compiler.Metaprogram_Plugin. A private
allocation retains its allocator and owns the output path through shutdown.

The plugin implements the reviewed environment/default root, separator trimming,
sysroot/startup object/linker flags, object ordering and user/system library
mapping. Process launch uses an argument array, including the literal `$ORIGIN`
argument, without invoking a shell. Missing tools are reported and still
launched. Launch failures, signals, timeout and nonzero exits fail the workspace;
the phase receives the exit status/output path and custom-link completion is
signaled. Add-source and finish are empty as explicitly reviewed; no init callback
is installed. No alternative backend is silently substituted.

Run `CARGO_TARGET_DIR=<own T7 target> python3
tools/check_portable_linux_build_shared.py`. Receipt
`linux-build-shared-1sa562kj/results.json` records **33 passed, zero failed**:
independent private argument/lifecycle tests in interpreter and native Mac ARM64
O0/O2; actual root overrides; two real missing-tool launches through compiler
custom-link phases with observed failed completion; six desktop source/strict
lint contexts; all-target Mac-host rejection; complete manifests and formatting.
The first public-import test diagnosed the absent module before implementation.

The trusted internal tests do not establish a successful Windows public plugin
run. Their missing-tool phase uses the available LLVM backend only to exercise
the message callback independently; public before_intercept still requests the
reviewed X64 backend, which this compiler explicitly does not implement. Windows
execution, an installed Unreal v21 SDK, and successful Linux output remain
required external gates. Clang++ and llvm-ar are not invoked by this workflow.

Test setup corrections were separate from production: the missing-tool workflow
is a procedure invoked by the CLI test addition, allowing strict lint to check
its complete body without requiring compile-time argv or suppressing assertions.
No ignored error, mocked SDK result, or success placeholder is used.
