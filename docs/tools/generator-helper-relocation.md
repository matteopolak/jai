# Relocatable generator native helper

The platform helper builder previously embedded its absolute build path as the
Mach-O install identity. Moving a complete candidate left actual native consumers
looking for the removed original path. An independently linked C consumer
reproduced that loader failure (exit-6).

The normal builder now sets `@rpath/libgenerator_platform.dylib` on Mac and accepts
a generic `--output-dir` for build/package placement. Native source and exported
functions are unchanged. An actual consumer links with its own loader-relative
rpath, then its complete package is renamed before execution. It calls the real
helper, reads back real temporary-file bytes and removes the file. That consumer
passes after the repair; no search-path fallback or fixture-only library source
is added. All new build/scratch output is in the assigned T7 area.

The [receipt](../status/generator-helper-relocation.json) records commands, install
identity and native image hash. This proves one Mac ARM64 helper relocation,
not whole compiler/resource/sysroot distribution closure or native Windows/Linux.
