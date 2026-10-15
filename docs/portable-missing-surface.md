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
| `__debug_manifest_reading := false` | All reviewed hosts |
| `__no_gradle_build_be_verbose := false` | All reviewed hosts |
| `adb_install :: (apk_path: string, reinstall_keeping_data := false, allow_test_apk := false, allow_version_code_downgrade := false, uninstall_and_retry_on_key_mismatch := true, log_errors := true) -> bool` | All reviewed hosts |
| `Algorithm_Id :: enum u32` | All reviewed hosts |
| `android_build_and_install_loader_app :: (project_config: Android_Project_Config, build_options: Build_Options, android_build_options: Android_Build_Options)` | All reviewed hosts |
| `Android_Build_Options :: struct` | All reviewed hosts |
| `android_build_or_update_dynamic_loader :: (project_config: Android_Project_Config, build_options: Build_Options, android_build_options: Android_Build_Options, force_rebuild_loader := false) -> bool` | All reviewed hosts |
| `android_check_for_adb_and_select_device :: (required_reason := "by metaprogram", preferred_model_name := "") #compile_time` | All reviewed hosts |
| `android_compile_helper_program :: (app_name: string, package_name: string, output_path := "", activity := DEFAULT_ACTIVITY, debug := false) -> bool #compile_time` | All reviewed hosts |
| `android_copy_directories_to_device :: (directories: [] string, app_id: string, dest_relative_path := "", only_update_newer_files := false, force_create_directories := false) -> bool` | All reviewed hosts |
| `android_copy_directories_to_device_quest :: android_copy_directories_to_device` | All reviewed hosts |
| `android_copy_file_to_device :: (file_path: string, app_id: string, external_storage_relative_path := "") -> bool` | All reviewed hosts |
| `Android_Default_Theme :: enum u16` | All reviewed hosts |
| `ANDROID_DYNAMIC_LOADER_VERSION :: 3` | All reviewed hosts |
| `android_find_ndk_path :: (log_errors := false) -> bool, string` | All reviewed hosts |
| `android_generate_apk :: (options: Android_Build_Options, config: Android_Project_Config) -> bool, string` | All reviewed hosts |
| `android_generate_apk :: (project_path: string, release := false) -> bool, string #deprecated "Use android_generate_apk that takes Android_Build_Options as first argument"` | All reviewed hosts |
| `android_generate_apk_command_line_tools :: (options: Android_Build_Options, config: Android_Project_Config) -> bool, string` | All reviewed hosts |
| `android_generate_apk_gradle :: (options: Android_Build_Options, config: Android_Project_Config) -> bool, string` | All reviewed hosts |
| `android_generate_apk_handmade :: (options: Android_Build_Options, config: Android_Project_Config) -> bool, string` | All reviewed hosts |
| `android_generate_jks_keystore :: (java_bin_path: string, keystore_path: string, key_alias := DEFAULT_KEYSTORE_ALIAS, key_password := DEFAULT_KEYSTORE_PASSWORD, algorithm := Android_Signing_Key_Signature_Algorithm.EC, key_size := 0, common_name := "Jai Android", organization_name := "Jai", country_code := "US") -> bool, Android_Signing_Key` | All reviewed hosts |
| `android_generate_signing_key_direct :: (out_path: string, key_name: string, algorithm := Android_Signing_Key_Signature_Algorithm.EC, key_size := 0, common_name := "Jai Android", organization_name := "Jai", country_code := "US") -> bool, Android_Signing_Key` | All reviewed hosts |
| `android_get_external_data_path :: (app_id: string) -> string` | All reviewed hosts |
| `android_get_helper_program_executable_name :: () -> string` | All reviewed hosts |
| `ANDROID_HELPER_VERSION :: 2` | All reviewed hosts |
| `Android_Install_Location :: enum u32` | All reviewed hosts |
| `ANDROID_LOADER_LIB_NAME :: "loader"` | All reviewed hosts |
| `Android_Manifest_Binary :: struct` | All reviewed hosts |
| `android_maybe_compile_helper_program :: (app_name: string, package_name: string, output_path := "", activity := DEFAULT_ACTIVITY, debug := false) -> bool #compile_time` | All reviewed hosts |
| `Android_Project_Config :: struct` | All reviewed hosts |
| `Android_Screen_Orientation :: enum` | All reviewed hosts |
| `Android_Screen_Orientation_ :: enum s32` | All reviewed hosts |
| `ANDROID_SDK_LEVEL :: SDK_LEVEL` | All reviewed hosts |
| `Android_Signing_Key :: struct` | All reviewed hosts |
| `Android_Signing_Key_Kind :: enum` | All reviewed hosts |
| `Android_Signing_Key_Signature_Algorithm :: enum` | All reviewed hosts |
| `android_theme_to_string :: (theme: Android_Default_Theme) -> string` | All reviewed hosts |
| `ANDROID_XML_SCHEMA :: "http://schemas.android.com/apk/res/android"` | All reviewed hosts |
| `apk_compute_digest_libressl :: (apk: Android_Apk, algorithm: Digest_Hash_Algorithm) -> [SHA256_DIGEST_LENGTH] u8` | All reviewed hosts |
| `apk_read_signing_block_v2 :: (s: *string) -> bool, Apk_Signing_Block_V2` | All reviewed hosts |
| `apk_sign :: (unsigned_apk_filepath: string, keystore_filepath: string, keystore_password := "password") -> bool, string` | All reviewed hosts |
| `apk_sign2 :: (unsigned_apk_filepath: string, private_key_info: string, certificate: string) -> bool, string` | All reviewed hosts |
| `Apk_Signing_Block_V2 :: struct` | All reviewed hosts |
| `apk_verify :: (apk: Android_Apk, verbose := false) -> bool` | All reviewed hosts |
| `apk_verify :: (filepath: string, verbose := false) -> bool` | All reviewed hosts |
| `Certificiate :: struct` | All reviewed hosts |
| `CheckSSL :: (result: s32, loc := #caller_location) #expand` | All reviewed hosts |
| `copy_android_libcpp :: (cpu_target: CPU_Tag, output_dir: string) -> bool` | All reviewed hosts |
| `decrypt_private_key :: (encrypted_private_key_info: string, password: string) -> bool, private_key_info: string` | All reviewed hosts |
| `deinit :: (using manifest: *Android_Manifest_Binary)` | All reviewed hosts |
| `Digest :: struct` | All reviewed hosts |
| `Digest_Hash_Algorithm :: enum` | All reviewed hosts |
| `DUMMY_U32 : u32` | All reviewed hosts |
| `fh :: #bake_arguments formatInt(base = 16)` | All reviewed hosts |
| `fh2 :: #bake_arguments formatInt(minimum_digits = 2, base = 16)` | All reviewed hosts |
| `fh4 :: #bake_arguments formatInt(minimum_digits = 4, base = 16)` | All reviewed hosts |
| `fh8 :: #bake_arguments formatInt(minimum_digits = 8, base = 16)` | All reviewed hosts |
| `generate_android_project :: (using config: Android_Project_Config, recreate_existing_files := true) -> bool` | All reviewed hosts |
| `get_android_target_triple :: (cpu: CPU_Tag) -> triple: string, triple_with_sdk: string` | All reviewed hosts |
| `get_ndk_libc_paths :: (cpu: CPU_Tag) -> libc_path: string, libc_platform_path: string` | All reviewed hosts |
| `get_ndk_libclang_paths :: () -> [] string` | All reviewed hosts |
| `get_ndk_paths :: () -> NDK_Paths` | All reviewed hosts |
| `gradle_install_apk :: (project_path: string, release := false) -> bool` | All reviewed hosts |
| `jdk_decrypt_private_key :: (encrypted_data: string, password: string) -> bool, string` | All reviewed hosts |
| `jks_read :: (data: string, password: string) -> bool, certificate: string, encrypted_private_key_info: string` | All reviewed hosts |
| `LAUNCH_MODE_SINGLE_TASK : u32` | All reviewed hosts |
| `libressl_error_callback :: (str: *u8, len: u64, u: *void) -> s32 #c_call` | All reviewed hosts |
| `libressl_get_private_key :: (private_key_info: string) -> *evp_pkey_st` | All reviewed hosts |
| `libressl_get_public_key :: (subject_public_key_info: string) -> *evp_pkey_st` | All reviewed hosts |
| `NDK_Paths :: struct` | All reviewed hosts |
| `print_binary_manifest :: (using manifest: Android_Manifest_Binary, print_strings := false, print_resource_ids := false)` | All reviewed hosts |
| `read_binary_manifest_from_apk :: (apk_filename: string) -> bool, Android_Manifest_Binary` | All reviewed hosts |
| `read_binary_manifest_from_file :: (filename: string) -> bool, Android_Manifest_Binary` | All reviewed hosts |
| `read_binary_manifest_from_memory :: (data: string, filename := "<memory>") -> bool, Android_Manifest_Binary` | All reviewed hosts |
| `run_android_link_command :: (message: *Message_Phase, options: Build_Options, extra_args: [] string = .[])` | All reviewed hosts |
| `run_gradle_task :: (project_path: string, task: string, print_output := true) -> bool` | All reviewed hosts |
| `sign_data :: (private_key_info: string, message: string) -> bool, string` | All reviewed hosts |
| `Signature :: struct` | All reviewed hosts |
| `SIGNING_BLOCK_ID_V2_SIGNATURE : u32` | All reviewed hosts |
| `SIGNING_BLOCK_ID_V31_SIGNATURE : u32` | All reviewed hosts |
| `SIGNING_BLOCK_ID_V3_SIGNATURE : u32` | All reviewed hosts |
| `SIGNING_BLOCK_ID_VERITY_PADDING : u32` | All reviewed hosts |
| `to_hex_string :: (a: [8] $T) -> string` | All reviewed hosts |
| `to_hex_string :: (s: string) -> string` | All reviewed hosts |
| `USE_FULL_MODULE :: false` | All reviewed hosts |
| `write_binary_app_manifest_to_builder :: (b: *String_Builder, config: Android_Project_Config) -> bool` | All reviewed hosts |
| `write_binary_app_manifest_to_file :: (using config: Android_Project_Config, out_filepath: string) -> bool` | All reviewed hosts |
| `write_binary_app_manifest_to_memory :: (config: Android_Project_Config) -> bool, string` | All reviewed hosts |

### Default_Metaprogram

Real workspace builds, options, plugin imports/callback ordering, paths, help/version and failures are implemented and tested with explicit -no_check. build remains incomplete: the delegated Check producer/reviewed page supplies no Mac plugin factory or binding-check configuration; compiler target command-line forwarding is separately defective. Full strict lint and ordinary default builds remain blocked, not counted complete.

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

Total: 95 missing reviewed declaration/overload/nested-operation rows
in these largely unimplemented modules. This is not the full library gap
count: partial module behavior, platform backends, compiler dependencies,
independent test review and integrated/native verification remain separate.
