# Native dependency build repair

Exclusive scope: xxhash070 Windows ARM64 build branch/helper and matching tests/
documentation. No rpmalloc artifact changes, shared scaffold refactors, compiler,
stdlib or Extensions edits. Worker inbox is absent in this fresh worktree.

Confirmed full reproduction using official Microsoft CRT/SDK headers/libraries:
the unpatched ARM64 object references __emulu and the static-libcmt DLL link fails
exactly on that symbol. The new hash-checked private build copy restricts the
intrinsic to x86/x64; ARM64 selects upstream's existing unsigned multiplication.
The unchanged flags now link a real ARM64 DLL, with all 24 original exports and
no __emulu reference. Both official-vector test executables cross-link as ARM64.

Five deterministic offline policy tests pass, real official v0.7.0 full sanity
checks pass on macOS ARM64 for static and shared artifacts, and original x64
Windows source compiles/retains exports. Ruff lint passes; new test tools are
formatted. Native Windows ARM64/x64 loading/hash execution and integrated Jai
consumers remain coordinator CI gates; no host/cross evidence is called a native
Windows pass. No publication/CI dispatch or forbidden source access occurred.

Integrator overlap: only prepare_xxhash_arm64_source and a two-line conditional
at compile_units entry were added to build_native_libs.py. Existing build/archive/
DLL artifact logic is untouched so rpmalloc ownership can integrate separately.
See [repair/provenance/commands](../tools/xxhash-arm64-build.md).
