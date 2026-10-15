# Android host orchestration and dependency handoff

The reassigned scope contains 52 exact public names. The integrated host batch
implements 45 names and the string-path overload of `android_generate_apk`.
Seven names remain partial because the canonical crypto-owned signing-key model
is absent: `Android_Build_Options`, the build-options APK dispatcher and its three
backends, and the two loader orchestration procedures. Their concrete source
drafts are preserved separately and are not loaded or counted as compiled.
The naming batch remains complete at `83ba1961`.

Project generation, model defaults and Gradle behavior are described in
[android-project.md](android-project.md) and [android-build.md](android-build.md).
AXML serialization, reading, ownership, supported subsets and system-zlib
dependencies are described in [android-manifest.md](android-manifest.md).
All integrated procedures are available through `Android/Toolchain`; a clean
integrator owns the facade loads. The existing ZIP/APK, ASN.1, ADB and SDK
discovery implementations are reused without changing their ownership.

The new SDK helpers discover valid LLVM NDK layouts from `ANDROID_NDK_HOME`,
`ANDROID_NDK_ROOT`, `NDK_HOME`, `NDK_ROOT`, then the configured SDK's numeric
side-by-side NDK versions and legacy `ndk-bundle`. They require a compiler file
and sysroot directory, not merely an environment string. Host tags use the
build OS. ARM64 and X64 map to the official target triples; SDK suffixes use
the import-time SDK level. Include paths, installed libclang candidates and
libc++ copies follow the standard NDK LLVM sysroot layout. Returned path strings
use the active allocator; callers free owned strings and result arrays.
These layout choices follow the official
[NDK build-system guide](https://developer.android.com/ndk/guides/other_build_systems).
Actual custom-link commands pass objects, libraries and extra arguments as
separate process arguments, propagate launch/nonzero/output failures into
`Message_Phase`, and notify an awaiting compiler phase even after failure.

Device helpers validate package identifiers and relative destinations before
using canonical ADB mkdir/push operations. Package components are nonempty
ASCII identifiers, excluding dot traversal and shell metacharacters. The Quest
directory helper aliases the ordinary helper. External paths use
`/sdcard/Android/data/<package>/files` as an independent policy.
Install flags map to `-r`, `-t`, and `-d`; an update-key mismatch can read the
canonical manifest package, uninstall once, and retry only if uninstall succeeds.
Device selection respects a configured serial, preferred model or sole ready
device and keeps selected serial storage in the durable default allocator.

The helper compiler produces a real host launcher executable named
`jai-android-helper-v2` (with the Windows extension on Windows hosts). It accepts
`JAIC` as an explicit compiler executable, otherwise resolves `jaic` on PATH.
It generates escaped Jai source that launches the configured NativeActivity
through the existing ADB API. Package/activity input excludes remote-shell
metacharacters; source strings escape quotes, backslashes and control bytes.
The launch component also uses the canonical remote-shell quoting helper, so
valid inner-class activity names containing a dollar sign are passed literally.
The default activity is `android.app.NativeActivity`. The maybe-compile API
reuses an existing executable only when its recorded source, including helper
version and debug mode, matches. Output paths are directories; empty means the
current directory. This is a host launcher policy, not an APK, signing, or
device-success claim.

Loader drafts generate a genuine native-activity forwarding C library that
loads the payload library from the app's external data directory, resolves
`ANativeActivity_onCreate`, and forwards lifecycle setup. They invoke NDK clang
with the configured target/sysroot and link Android/log/dl; the wrapper builds
and installs the loader APK and copies the payload only after each prior stage
succeeds. These drafts have only passed formatting: the missing signing model
prevents integration and type checking. No execution is claimed for them.

Run `python3 tools/verify_android_project.py` with the assigned T7
`CARGO_TARGET_DIR`. The runner builds this checkout's compiler/linter with
two jobs and the actual Jai formatter, then performs 108 checks across seven
public-import fixtures: interpreter, Mac arm64 native O0/O2, formatting, and
warnings-denied lint/source checks on Mac arm64/x64, Linux x64 and Windows
x64/arm64. A separate helper source fixture checks target bodies without
executing host compiler/process operations. Actual helper compilation is
asserted by the host interpreter/native fixture. The initial attempt to execute
host actions during cross-target compile-time checking failed on unavailable
foreign APIs (`stat$INODE64`, `syscall`, and Windows APIs); that evidence is
retained in the verification artifacts. No compiler exception or suppressed
diagnostic was introduced to make those host actions run.

Controlled process fixtures inspect argument boundaries, working directories,
nonzero outcomes, missing outputs and mismatch-package extraction. NDK/ADB
command fixtures always fail their actual link/install/uninstall operations;
Gradle install and SDK signer fixtures also always fail. They establish host
orchestration and failure propagation, never successful installation or signing.
Binary manifest tests use independently constructed UTF16/Unicode and stored/
DEFLATE APK vectors, plus bounds/truncation cases. Review regressions cover
dot-only packages and launcher shell metacharacters and failed before the shared
identifier validation was corrected.

No Android SDK/NDK, Gradle, adb, aapt2, apksigner, zipalign or Java runtime was
found in configured/conventional paths or PATH. Xcode clang exists and builds
the native host tests. No SDK-backed APK build, signature or physical-device
result is claimed. Windows zlib linking and all cross-target native execution
remain unverified. Exact status is in
[implementation-remaining.json](status/implementation-remaining.json);
the canonical signing dependency request is in [worker-inbox.md](worker-inbox.md).
