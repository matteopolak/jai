# Android project generation

`Android/Toolchain` now exports the reviewed canonical project configuration,
orientation and theme models. Import parameters `SDK_LEVEL=34` and
`ENABLE_ARM_LSE=true` are declared by the facade; `ANDROID_SDK_LEVEL` aliases the
configured SDK level. Individual project target levels remain independently
assignable. Backend LSE activation requires the Android compiler plugin and is
outside this project-file generator.

`generate_android_project` creates a NativeActivity Gradle application with
settings, root/app build files, assets and JNI-library directories, a manifest,
Gradle properties, wrapper distribution properties and an IDE workspace. The
configuration's package, display name, versions, SDK levels, native library,
orientation, theme, permissions, features and metadata feed the generated files.
XML attributes and Groovy quoted strings are escaped. The manifest override is
written byte-for-byte when nonempty. Existing app build files reject generation
when recreation is disabled; recreation preserves an existing IDE workspace.
File/directory operation failures return false. A failure can leave earlier
files updated; there is no transactional filesystem contract.

The reviewed specification does not prescribe complete templates. Independently
chosen templates use Gradle's Android application plugin, Google/Maven Central
repositories, `android.app.NativeActivity` and the standard native-library
metadata entry. VR adds Samsung VR application metadata; Quest passthrough splash
adds Oculus passthrough splash metadata. Theme strings use Android framework
style references such as `@android:style/Theme.Black.NoTitleBar`. Invalid enum
values produce an empty theme or unspecified orientation. No wrapper JAR or
downloaded executable is fabricated: users need installed Gradle or a genuine
wrapper supplied separately. This work does not claim an SDK/Gradle APK build or
device execution.

The project fixture first failed for the missing exported configuration name.
It now passes the interpreter and Mac arm64 native O0/O2, exercising escaping,
metadata/features/permissions, regeneration refusal, override and workspace
preservation. A separate fixture verifies import-time SDK overrides. Formatting
and warnings-denied lint pass. Windows x64 and Linux x64 checks pass as source
checks only. The CLI rejects `-os android`; Android execution is unavailable.

`Android_Build_Options` is drafted in `project-build-types.jai`, but public loading is deferred because its canonical `Android_Signing_Key`
dependency belongs to the portable signing owner and is absent in this checkout.
No duplicate signing model or stub has been introduced. The integrated project
batch is validated and committed by the parent; build-options source remains an
unloaded, uncompiled draft. See the parent exact inventory for current status.
