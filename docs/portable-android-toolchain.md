# Android toolchain owned API inventory

get_android_project_jni_architecture_name(cpu_target:CPU_Tag) -> string now
implements the reviewed host-independent JNI directory mapping. X64 yields
x86_64; ARM64 yields arm64-v8a. These are actual Android NDK ABI identifiers, not
a guessed ELF triple or an assertion that this compiler can target Android.
Unsupported UNINITIALIZED/KRAMPU/CUSTOM tags diagnose explicitly; no substitute
ABI is returned as success. Fine invalid-tag diagnostic policy is an independent
supported-domain choice, not a reviewed reference error-message guarantee.

Official native ABI contract:
https://developer.android.com/ndk/guides/abis .
The single canonical bootstrap CPU_Tag is reused; no duplicate enum/type alias
or compiler special case. Returned names are immutable static string storage.
Exact public alias lives in Android/Toolchain/module.jai; implementation is private
internal/android-toolchain/abi-names.jai. The parent Android bindings remain the
bindings worker's scope and are untouched. Formatting scope now explicitly
includes this owned nested module while continuing to exclude the binding parent.

android-abi-name.jai checks both exact values/private visibility. Its unsupported
CPU fault fixture checks a genuine diagnostic. Interpreter/native and Linux/
Windows body checks execute in the portable runner; focused source-built strict
lint passes. Missing-module failure remains target/android-abi-name-red.log.

The ENTIRE rest of Android/Toolchain remains missing, including ADB operations,
SDK/NDK discovery, project/APK/manifest generation, signing/verification,
ASN.1/JKS helpers and public records/constants needed by those operations.
No declarations, fake device/crypto results, stub callbacks or invented defaults
are credited. Exact missing public declarations/overloads are generated from the
reviewed page into portable-missing-surface.md. This module is partial.

Android target checking remains unavailable (-os android rejected); the host-side
ABI naming helper does not need an Android target, SDK installation, device,
credentials or auth. No ADB/device/auth action was run. Public signing helpers
will require independently supplied test keys and explicit native dependencies;
they must never read harness/real credentials.

Specific next oracle/dependency questions: SDK_LEVEL and other omitted default
constants/module parameters; adb output/storage ownership and device selection;
shell escaping rules; exact manifest/ASN.1 error behavior. Compiler Build_Options/
Message callbacks exist as reviewed interfaces, but the remaining actual build
and device orchestration is implementation work, not automatically blocked by
a missing type or excused by this one implemented helper.
