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

Counted OID identity is also implemented: canonical ASN1_Object_Identifier with
twelve inline u64 arcs and inferred count; asn1_oid_equals compares only active
prefixes, diagnoses invalid counts and ignores inactive storage. The reviewed Sun
OID retains exactly eleven active arcs and its twelfth trailing zero. Global OID
and both JKS magic constants are immutable; ordinary value copies remain mutable.
JKS_MAGIC uses its reviewed typed-u32 constant and JKS_MAGIC_LITTLE_ENDIAN uses
the exact #run u32 form. Their numeric values follow the explicit reviewed
0xfeedfeed values, without inferring a byte swap from the name. The review's
byte-swap explanation is mathematically inconsistent: reversing bytes would give
0xedfeedfe. This rationale question is recorded; no alternate public value or
working JKS decoder is invented.

android-oid.jai covers every count0..12, each active difference, inactive tails,
canonical metadata/layout, exact typed constants and independent copies. Native
O2 and focused strict lint pass. Constant nested-array and typed-scalar writes
are required compile rejections. Invalid count is a checked safety fault.
These data/equality primitives are not signing, ASN.1 decoding or JKS loading.

`sha1(s: string) -> [20]u8` and `sha256(s: string) -> [32]u8` now provide the
reviewed fixed-array digest APIs. Public aliases retain parameter name `s` and
canonical array types. Independent scalar implementations live under
internal/crypto/sha.jai: shared block/padding/bit-length and big-endian word
handling, independently organized compression functions and immutable standard
mathematical constants. Only the compression functions disable arithmetic
overflow checking, because their specified additions are modulo 2^32. No native
crypto dependency, signing process, device, key or credential is involved.

`python3 -B tools/check_portable_sha.py` builds 270 independent vectors using
native hashlib, including every byte length0..256, larger block-boundary cases
through65537 and the million-a case. Both digests match all vectors in the
interpreter and native ARM64/translated x64 O0/O2. Inputs include embedded NUL
and deliberately unaligned data. Empty/abc standard vectors remain ordinary
root regressions. Linux/Windows x64/ARM64 bodies check; native execution on those
OSes remains pending. Focused strict lint and formatting/check pass.
Evidence: target/android-sha-vectors-final.log, target/android-sha-strict.log.

Valid input must be readable string storage. An invalid signed length or a byte
length outside the 64-bit bit-length domain logs an error independently of
optional assertions; with assertions disabled or an explicitly continuing
assertion handler the API returns a zero array, which is not a digest
success claim. That invalid-input continuation is independent defensive behavior,
not a reviewed reference guarantee or tested supported hashing domain. No
streaming/accelerated SHA interface or extra digest constants are exported.

The rest of Android/Toolchain remains missing, including ADB operations,
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
