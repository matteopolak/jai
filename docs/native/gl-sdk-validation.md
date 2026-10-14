# GL native SDK validation and integration blockers

The real macOS SDK program creates a CGL context, loads the native procedure
table, compiles and links two shaders, reads active attribute/uniform names and
types through the public string-buffer wrappers, checks locations and checks
the native GL error state. Its context reports OpenGL 4.1. Pixel-format tokens
come from an independent C oracle compiled against the pinned public Apple
SDK. No GL or CGL function is replaced by a test implementation.

This is **isolated SDK evidence, not production integration**. The final trial
uses current NEW peer sources without import repairs. It still requires one
explicit general compiler proposal in an owned test copy:

- [General compiler metadata proposal](compiler-reflection-procedure-flag.patch):
  when procedure field types are erased to `*void` in reflection, preserve
  `PROCEDURE_WITH_VOID_POINTER_TYPE_INFO` in their member flags. The current
  compiler changes the type but drops the marker, preventing the loader from
  distinguishing callbacks from ordinary pointers. The proposal tracks which
  fields were actually erased and ORs the required flag with existing flags.
  It contains no module, path, fixture or symbol special cases.

Earlier trials corrected two AppKit imports in staged copies. The current NEW
window worker now supplies those corrections itself, so that staging repair
has been removed. Root Objective_C exports remain unchanged. The earlier
repair diff is retained only as failure evidence at
`.work/window-appkit-integration-resolved.patch`; it is not an active patch.
Peer checkouts were never modified.

The standalone original reproducer is
[reflection-procedure-flags.jai](../../tests/native-bindings/reflection-procedure-flags.jai).
It checks erased callbacks, ordinary pointers and non-erased callbacks. The
unmodified compiler builds it but the program aborts with flags=0. The proposal
produces flags=8 and passes native and interpreter execution. This flag is
already part of the reviewed bootstrap contract; no public ABI is changed.
The proposal passed scoped Rust formatting and clippy:

```sh
rustfmt --edition 2024 --check .work/compiler-latest/crates/jaic/src/sema/typeinfo.rs
env TMPDIR="$PWD/.work/tmp" CARGO_TARGET_DIR="$PWD/.work/target-latest" \
  LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm \
  cargo clippy --manifest-path .work/compiler-latest/Cargo.toml \
  -p jaic --lib --locked -- -D warnings
```

These commands ran on the proposed source in the owned compiler snapshot.
After saving the separate trial binary, the original source and canonical
compiler were restored and the original flags=0 failure reverified. The
compiler was subsequently refreshed from the latest NEW source branch;
the latest proposal trial and restoration are recorded in
`.work/latest-reflection-proposal-trial.json`. Its restored canonical hash is
`9b4c4fd3179a9c08d9912ec256688491bba3c9698bbba859e6356c33b43ba535`.
The proposal remains a reviewable
patch for the compiler owner/coordinator, not an unreported default change.

Evidence remains in `.work/gl-real-sdk-evidence.json` (initial real crash),
`.work/reflection-flags-before.json` (general reproducer failure),
`.work/gl-sdk-final-evidence.json` (explicitly staged successful SDK checks,
source/patch/test/probe hashes), and `.work/reflection-trial-state.json`
(canonical restoration and reverified failure). Default verification still
attempts the real GL-context test and the reproducer and retains their actual
integration failures. The existing SDL ABI failures remain active as well.

The repeatable driver is `tools/native_bindings/verify_gl_sdk.py`, with an
explicit source-built compiler and optional `--compiler-proposal` label.
It stages current NEW peers without repairs, checks SDK header pins, builds a
per-run static C oracle and records all source/test/oracle/compiler hashes.
The oracle uses a static archive because the compiler's system-library native
search directories resolve archives; using only a dylib produced a real
link failure, retained in earlier evidence. The current successful trial is
`.work/gl-sdk-current-static-oracle.json`. Its debug callback check remains
explicitly unavailable and makes the aggregate verification command nonzero.

Separately, both NSOpenGL constructors pass with the unpatched canonical
compiler: core/legacy profiles, real MSAA values compared with CGL, canonical
type identity across GL configurations, current-context preservation, and
attachment to a real hidden Cocoa window. The reviewed setTitle void dispatch
also round-trips UTF-8 text through the native Cocoa getter. These tests need
neither compiler proposal nor peer-source repair.

The debug-output helper installs actual core/KHR/ARB callbacks, enables their
native message controls and uses native traps for break-on-error. The mode is
carried by a stable private object address in the SDK's per-context user data,
with no mutable process-global mode or pointer tagging. Linux and Windows
source checks instantiate both calls. The host context's independent native
extension enumeration confirms that none of the required debug routes is
available. Its callback runtime result is explicitly **unavailable**, not a
passing skipped assertion. Supported-driver runtime checks remain required.

The GL extension-query path now diagnoses missing query pointers instead of
calling a null procedure. It does not guess erased field kinds from names or
silently substitute a legacy query. Full integration still needs the reviewed
peer imports, the compiler metadata fix, missing POSIX configuration shapes,
remaining context constructors and the other outstanding binding interfaces.
