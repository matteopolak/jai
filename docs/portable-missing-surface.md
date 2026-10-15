# Remaining owned public surface

Generated from reviewed specs by tools/generate_portable_missing_surface.py.
Every row below is MISSING, including types/constants; a name in this inventory
is not a declaration-only completion claim. This complements the module ledger
and detailed partial-module inventories for Machine, Pool, time, Socket,
Registry, MPEG and executable formats. Ownership exclusions are not listed.
Rows preserve each overload/condition; declarations are independently grouped
alphabetically within responsibility groups. No source implementation/history
or legacy test expectations are inventory inputs.

## Build and toolchain

### Android/Toolchain

JNI/OID/JKS constants/SHA, ASN.1 primitives/diagnostics/X509, ZIP32 records/writer/CRC/offset/unit helpers, APK whole-file views/iteration, manifest flags, Java launcher and reviewed ADB operations have independent behavior tests. Deflate uses real stored blocks (size tradeoff). Real SDK/device and Windows Process integration remain pending. Install recovery, higher-level build/signing/manifest and remaining helpers are missing; marker-only APK is not claimed signature-valid.

Reviewed contract: [module page](specs/stdlib/modules/android-toolchain.md).

| Missing public declaration | Condition |
| --- | --- |
| `Algorithm_Id :: enum u32` | All reviewed hosts |
| `android_generate_jks_keystore :: (java_bin_path: string, keystore_path: string, key_alias := DEFAULT_KEYSTORE_ALIAS, key_password := DEFAULT_KEYSTORE_PASSWORD, algorithm := Android_Signing_Key_Signature_Algorithm.EC, key_size := 0, common_name := "Jai Android", organization_name := "Jai", country_code := "US") -> bool, Android_Signing_Key` | All reviewed hosts |
| `android_generate_signing_key_direct :: (out_path: string, key_name: string, algorithm := Android_Signing_Key_Signature_Algorithm.EC, key_size := 0, common_name := "Jai Android", organization_name := "Jai", country_code := "US") -> bool, Android_Signing_Key` | All reviewed hosts |
| `apk_compute_digest_libressl :: (apk: Android_Apk, algorithm: Digest_Hash_Algorithm) -> [SHA256_DIGEST_LENGTH] u8` | All reviewed hosts |
| `apk_read_signing_block_v2 :: (s: *string) -> bool, Apk_Signing_Block_V2` | All reviewed hosts |
| `apk_sign :: (unsigned_apk_filepath: string, keystore_filepath: string, keystore_password := "password") -> bool, string` | All reviewed hosts |
| `apk_sign2 :: (unsigned_apk_filepath: string, private_key_info: string, certificate: string) -> bool, string` | All reviewed hosts |
| `Apk_Signing_Block_V2 :: struct` | All reviewed hosts |
| `apk_verify :: (apk: Android_Apk, verbose := false) -> bool` | All reviewed hosts |
| `apk_verify :: (filepath: string, verbose := false) -> bool` | All reviewed hosts |
| `Certificiate :: struct` | All reviewed hosts |
| `CheckSSL :: (result: s32, loc := #caller_location) #expand` | All reviewed hosts |
| `decrypt_private_key :: (encrypted_private_key_info: string, password: string) -> bool, private_key_info: string` | All reviewed hosts |
| `Digest :: struct` | All reviewed hosts |
| `Digest_Hash_Algorithm :: enum` | All reviewed hosts |
| `fh :: #bake_arguments formatInt(base = 16)` | All reviewed hosts |
| `fh2 :: #bake_arguments formatInt(minimum_digits = 2, base = 16)` | All reviewed hosts |
| `fh4 :: #bake_arguments formatInt(minimum_digits = 4, base = 16)` | All reviewed hosts |
| `fh8 :: #bake_arguments formatInt(minimum_digits = 8, base = 16)` | All reviewed hosts |
| `jdk_decrypt_private_key :: (encrypted_data: string, password: string) -> bool, string` | All reviewed hosts |
| `jks_read :: (data: string, password: string) -> bool, certificate: string, encrypted_private_key_info: string` | All reviewed hosts |
| `libressl_error_callback :: (str: *u8, len: u64, u: *void) -> s32 #c_call` | All reviewed hosts |
| `libressl_get_private_key :: (private_key_info: string) -> *evp_pkey_st` | All reviewed hosts |
| `libressl_get_public_key :: (subject_public_key_info: string) -> *evp_pkey_st` | All reviewed hosts |
| `sign_data :: (private_key_info: string, message: string) -> bool, string` | All reviewed hosts |
| `Signature :: struct` | All reviewed hosts |
| `SIGNING_BLOCK_ID_V2_SIGNATURE : u32` | All reviewed hosts |
| `SIGNING_BLOCK_ID_V31_SIGNATURE : u32` | All reviewed hosts |
| `SIGNING_BLOCK_ID_V3_SIGNATURE : u32` | All reviewed hosts |
| `SIGNING_BLOCK_ID_VERITY_PADDING : u32` | All reviewed hosts |
| `to_hex_string :: (a: [8] $T) -> string` | All reviewed hosts |
| `to_hex_string :: (s: string) -> string` | All reviewed hosts |

### Default_Metaprogram

Real Check-enabled workspace builds, binding configuration, options, plugin imports/callback ordering, paths, help/version and failures pass, including full owned strict lint. build remains partial only for unsupported compiler backend/debugger and selected-workspace command-line execution dependencies; no CLI bypass or fabricated completion.

Reviewed contract: [module page](specs/stdlib/modules/default-metaprogram.md).

| Missing public declaration | Condition |
| --- | --- |
| `build :: ()` | All reviewed hosts |

### Example_Plugin

All reviewed record/options/lifecycle exports implemented. Canonical type/defaults, initialized state, malformed options, phase/typecheck/completion diagnostics and owned shutdown pass interpreter/native O0/O2 and strict lint; the actual default workspace loader builds and runs a target with +Example_Plugin. No source/artifact-producing callback is fabricated.

Reviewed contract: [module page](specs/stdlib/modules/example-plugin.md).

| Missing public declaration | Condition |
| --- | --- |

### linux_build

Windows-host Unreal cross-link orchestration remains missing; actual external toolchain/native integration is also pending.

Reviewed contract: [module page](specs/stdlib/modules/linux-build.md).

| Missing public declaration | Condition |
| --- | --- |
| `add_source :: (p: *Metaprogram_Plugin)` | All reviewed hosts |
| `before_intercept :: (p: *Metaprogram_Plugin, flags: *Intercept_Flags)` | All reviewed hosts |
| `finish :: (p: *Metaprogram_Plugin)` | All reviewed hosts |
| `get_plugin :: () -> *Metaprogram_Plugin` | All reviewed hosts |
| `message :: (p: *Metaprogram_Plugin, message: *Message)` | All reviewed hosts |
| `shutdown :: (p: *Metaprogram_Plugin)` | All reviewed hosts |

### Project_Generator

All reviewed public state/method behavior implemented: owned unique file collection/reset, real compiler workspaces and four deterministic XML/solution artifacts. Collection interpreter/native O0/O2, actual target O0/O2, defaults/persistence/escaping/filters/unchanged mtimes and write failure pass. Full strict lint remains blocked by general SandboxHost compile-time executable-path SDK support; no default or lint workaround. Native Visual Studio execution/resource availability remain pending.

Reviewed contract: [module page](specs/stdlib/modules/project-generator.md).

| Missing public declaration | Condition |
| --- | --- |

Total: 39 missing reviewed declaration/overload/nested-operation rows
in these largely unimplemented modules. This is not the full library gap
count: partial module behavior, platform backends, compiler dependencies,
independent test review and integrated/native verification remain separate.
