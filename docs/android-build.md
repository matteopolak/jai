# Android APK build orchestration

The independent Gradle API lives in `stdlib/Android/Toolchain/gradle-api.jai`,
with private implementation in `stdlib/internal/android-toolchain/android-gradle.jai`.
The build-options API draft lives in `stdlib/Android/Toolchain/build-api.jai`; its
private implementation is `stdlib/internal/android-toolchain/android-build.jai`. The
project worker owns the canonical project/build records. Signing-key records
remain crypto ownership, with no duplicate type or public crypto generator here.

Gradle tasks run the existing project wrapper (`/bin/sh gradlew` on Unix,
`cmd.exe /c gradlew.bat` on Windows), or installed `gradle` when no wrapper exists.
The wrapper handles its own dependency errors, including an absent wrapper JAR.
No wrapper binary is fabricated and no Gradle installation is downloaded.
Task/install operations propagate launch errors, signals, timeout and nonzero
exit status. APK building requires `app/build/outputs/apk/debug/app-debug.apk` or
`app/build/outputs/apk/release/app-release.apk` after the successful task. An
unsigned Gradle release artifact is not reported as a completed signed build.
Native libraries and assets are copied into the normal project source locations
before building. Existing unrelated project files are retained.

Command-line builds choose an installed SDK build-tools directory by numeric
dotted version, invoke `aapt2 link --output-to-dir`, and package the resulting
binary manifest/resources through the existing ZIP writer. Assets become
`assets/<relative path>` for CONTENTS_OF_PATH or
`assets/<directory name>/<relative path>` for SINGLE_DIRECTORY. Native libraries
become `lib/<JNI ABI>/lib<lib_name>.so`, stored with 4096-byte payload alignment.
The command-line intermediate names are `linked-resources`,
`command-line-unsigned.apk`, `command-line-aligned.apk` and
`command-line-signed.apk` under `intermediate_path`. Previous linked resources
are removed before invoking aapt2 to prevent stale resource success.

Signing uses installed SDK `apksigner` after `zipalign`, then invokes verification.
CUSTOM JKS keys supply the reviewed alias/password; direct keys supply the
reviewed certificate/private-key paths. SDK_DEFAULT_DEBUG searches
`<home>/.android/debug.keystore`, then `<sdk>/debug.keystore`, with the documented
debug credentials. As an independent orchestration policy, AUTO_GENERATE invokes
the actual Java `keytool` executable to create a reusable EC/P-256 JKS file named
`generated-signing-key.jks` in the intermediate directory. This does not implement
or export the separately owned `android_generate_jks_keystore`. Existing keytool
output is reused, and no unavailable tool or failed command yields success.

Handmade mode writes the canonical binary manifest and packages assets/native
libraries with the existing ZIP writer into `handmade-unsigned.apk`. It returns
failure at the actual signing step because canonical `apk_sign`/`apk_sign2` are
not implemented in this independent baseline. The unsigned archive remains
available for inspection; it is never returned as a successful signed build.

An empty `output_path` returns the existing artifact path. Otherwise it is a
directory and `output_apk_name` is a filename, with `.apk` appended if absent.
Successful returned paths are allocated with the active context and are freed
by the caller. Failure returns `false, ""`.

The independent public-import Gradle fixture is `tests/android-project/gradle.jai`;
the build-options fixture draft is `tests/android-project/build.jai`.
Their shell processes are controlled command-behavior fixtures, not Android SDK,
Gradle build, cryptographic signing or device execution evidence. They exercise
working directories and path spaces, failure propagation and missing output.
Install fixture processes always fail, with their selected task checked from a
recorded argument. Signing fixture processes always fail. The draft build-options
fixture inspects the staged unsigned ZIP only; no fixture reports a successful
signature or device installation. Canonical signing-key models are currently
absent, so integration/compilation of build options remains blocked until their
owning worker supplies them. No Android SDK/device success is claimed.

The integrated independent Gradle fixture passed source-built interpreter and
Mac ARM64 native O0/O2 execution, actual repository formatting and warnings-denied
lint. Linux/Windows/Mac x64 and Windows ARM64 checks are source-only. The
build-options draft has not compiled or executed and is not counted complete.

Official tool contracts used:
[AAPT2](https://developer.android.com/tools/aapt2),
[apksigner](https://developer.android.com/tools/apksigner), and
[zipalign](https://developer.android.com/tools/zipalign).
