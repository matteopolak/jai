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

JNI ABI naming, counted OID identity and reviewed JKS constants are implemented. Device/build/signing/manifest and remaining helpers are missing; no device, SDK, signing or crypto success is fabricated.

Reviewed contract: [module page](specs/stdlib/modules/android-toolchain.md).

| Missing public declaration | Condition |
| --- | --- |
| `__adb_path: string` | All reviewed hosts |
| `__debug_manifest_reading := false` | All reviewed hosts |
| `__no_gradle_build_be_verbose := false` | All reviewed hosts |
| `adb :: (command_args: .. string, device_serial := "", log_adb_command_errors := false, print_captured_output := false, loc := #caller_location, try_and_escape_spaces_in_shell_arguments := true) -> (bool, output_string := "", error_string := "", exit_code := 0)` | All reviewed hosts |
| `adb_be_verbose := !true` | All reviewed hosts |
| `Adb_Compression_Algorithm :: enum` | All reviewed hosts |
| `Adb_Device :: struct` | All reviewed hosts |
| `adb_device_serial: string` | All reviewed hosts |
| `adb_devices :: (return_only_ready_devices := false) -> bool, [] Adb_Device` | All reviewed hosts |
| `adb_install :: (apk_path: string, reinstall_keeping_data := false, allow_test_apk := false, allow_version_code_downgrade := false, uninstall_and_retry_on_key_mismatch := true, log_errors := true) -> bool` | All reviewed hosts |
| `adb_pull :: (remote_source: string, local_destination := "", preserve_timestamps := true, disable_compression := false, compression_algorithm := Adb_Compression_Algorithm.UNSPECIFIED) -> bool` | All reviewed hosts |
| `adb_push :: (local_source: string, remote_destination: string, only_update_newer_files := false, dry_run := false, compression_algorithm := Adb_Compression_Algorithm.UNSPECIFIED, disable_compression := false) -> bool` | All reviewed hosts |
| `adb_shell_mkdir :: (path: string) -> bool` | All reviewed hosts |
| `adb_shell_pidof :: (package_name: string) -> bool, s32` | All reviewed hosts |
| `adb_uninstall :: (package_name: string) -> bool` | All reviewed hosts |
| `adb_version :: () -> Adb_Version_Info, bool` | All reviewed hosts |
| `Adb_Version_Info :: struct` | All reviewed hosts |
| `Algorithm_Id :: enum u32` | All reviewed hosts |
| `Android_Apk :: struct` | All reviewed hosts |
| `Android_Apk_Entry :: struct` | All reviewed hosts |
| `ANDROID_APK_SIGNING_BLOCK_MAGIC :: "APK Sig Block 42"` | All reviewed hosts |
| `android_build_and_install_loader_app :: (project_config: Android_Project_Config, build_options: Build_Options, android_build_options: Android_Build_Options)` | All reviewed hosts |
| `Android_Build_Options :: struct` | All reviewed hosts |
| `android_build_or_update_dynamic_loader :: (project_config: Android_Project_Config, build_options: Build_Options, android_build_options: Android_Build_Options, force_rebuild_loader := false) -> bool` | All reviewed hosts |
| `android_check_for_adb_and_select_device :: (required_reason := "by metaprogram", preferred_model_name := "") #compile_time` | All reviewed hosts |
| `android_compile_helper_program :: (app_name: string, package_name: string, output_path := "", activity := DEFAULT_ACTIVITY, debug := false) -> bool #compile_time` | All reviewed hosts |
| `Android_Config_Changes :: enum_flags s32` | All reviewed hosts |
| `android_config_changes_from_string :: (s: string) -> Android_Config_Changes` | All reviewed hosts |
| `android_copy_directories_to_device :: (directories: [] string, app_id: string, dest_relative_path := "", only_update_newer_files := false, force_create_directories := false) -> bool` | All reviewed hosts |
| `android_copy_directories_to_device_quest :: android_copy_directories_to_device` | All reviewed hosts |
| `android_copy_file_to_device :: (file_path: string, app_id: string, external_storage_relative_path := "") -> bool` | All reviewed hosts |
| `Android_Default_Theme :: enum u16` | All reviewed hosts |
| `ANDROID_DYNAMIC_LOADER_VERSION :: 3` | All reviewed hosts |
| `android_find_ndk_path :: (log_errors := false) -> bool, string` | All reviewed hosts |
| `android_find_sdk_path :: () -> bool, string` | All reviewed hosts |
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
| `android_is_app_installed :: (package_name: string) -> bool` | All reviewed hosts |
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
| `apk_deinit :: (apk: *Android_Apk)` | All reviewed hosts |
| `apk_load :: (filepath: string) -> Android_Apk` | All reviewed hosts |
| `apk_print_sections :: (apk: Android_Apk)` | All reviewed hosts |
| `apk_read_signing_block_v2 :: (s: *string) -> bool, Apk_Signing_Block_V2` | All reviewed hosts |
| `apk_sign :: (unsigned_apk_filepath: string, keystore_filepath: string, keystore_password := "password") -> bool, string` | All reviewed hosts |
| `apk_sign2 :: (unsigned_apk_filepath: string, private_key_info: string, certificate: string) -> bool, string` | All reviewed hosts |
| `Apk_Signing_Block_V2 :: struct` | All reviewed hosts |
| `apk_verify :: (apk: Android_Apk, verbose := false) -> bool` | All reviewed hosts |
| `apk_verify :: (filepath: string, verbose := false) -> bool` | All reviewed hosts |
| `asn1_decode_integer :: (data: string) -> s64` | All reviewed hosts |
| `asn1_decode_object_identifier :: (data: string) -> ASN1_Object_Identifier` | All reviewed hosts |
| `ASN1_KNOWN_OIDS :: ASN1_Object_Identifier` | All reviewed hosts |
| `asn1_print :: (data: string, depth := 0, hack_skip_depth := false)` | All reviewed hosts |
| `asn1_print :: (name: string, data: string)` | All reviewed hosts |
| `asn1_print :: (name: string, value: ASN1_Value)` | All reviewed hosts |
| `asn1_read_length :: (s: *string) -> u64` | All reviewed hosts |
| `asn1_read_tag :: (s: *string) -> ASN1_Tag` | All reviewed hosts |
| `asn1_read_value :: (s: *string) -> ASN1_Value` | All reviewed hosts |
| `asn1_read_value :: (s: *string, expected: ASN1_Tag) -> ASN1_Value` | All reviewed hosts |
| `ASN1_Tag :: struct` | All reviewed hosts |
| `ASN1_Tag_Class :: enum u8` | All reviewed hosts |
| `ASN1_Tag_Length_Value :: enum u8` | All reviewed hosts |
| `asn1_to_string :: (oid: ASN1_Object_Identifier) -> string` | All reviewed hosts |
| `ASN1_Universal_Type :: enum u8` | All reviewed hosts |
| `ASN1_Value :: struct` | All reviewed hosts |
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
| `find_java_bin_path_from_environment :: () -> bool, bin_path: string, exe_path: string` | All reviewed hosts |
| `for_expansion :: (apk: Android_Apk, body: Code, flags: For_Flags) #expand` | All reviewed hosts |
| `generate_android_project :: (using config: Android_Project_Config, recreate_existing_files := true) -> bool` | All reviewed hosts |
| `get_android_target_triple :: (cpu: CPU_Tag) -> triple: string, triple_with_sdk: string` | All reviewed hosts |
| `get_ndk_libc_paths :: (cpu: CPU_Tag) -> libc_path: string, libc_platform_path: string` | All reviewed hosts |
| `get_ndk_libclang_paths :: () -> [] string` | All reviewed hosts |
| `get_ndk_paths :: () -> NDK_Paths` | All reviewed hosts |
| `gradle_install_apk :: (project_path: string, release := false) -> bool` | All reviewed hosts |
| `is_adb_installed :: () -> bool, string` | All reviewed hosts |
| `is_app_running :: (package_name: string) -> running: bool, success: bool` | All reviewed hosts |
| `JAVA_ENV_NAME :: "JAVA_HOME"` | All reviewed hosts |
| `jdk_decrypt_private_key :: (encrypted_data: string, password: string) -> bool, string` | All reviewed hosts |
| `jks_read :: (data: string, password: string) -> bool, certificate: string, encrypted_private_key_info: string` | All reviewed hosts |
| `Kilobytes :: (x: int) -> int #expand` | All reviewed hosts |
| `LAUNCH_MODE_SINGLE_TASK : u32` | All reviewed hosts |
| `libressl_error_callback :: (str: *u8, len: u64, u: *void) -> s32 #c_call` | All reviewed hosts |
| `libressl_get_private_key :: (private_key_info: string) -> *evp_pkey_st` | All reviewed hosts |
| `libressl_get_public_key :: (subject_public_key_info: string) -> *evp_pkey_st` | All reviewed hosts |
| `Megabytes :: (x: int) -> int #expand` | All reviewed hosts |
| `NDK_Paths :: struct` | All reviewed hosts |
| `print_binary_manifest :: (using manifest: Android_Manifest_Binary, print_strings := false, print_resource_ids := false)` | All reviewed hosts |
| `read :: read_silly_alias` | All reviewed hosts |
| `read_binary_manifest_from_apk :: (apk_filename: string) -> bool, Android_Manifest_Binary` | All reviewed hosts |
| `read_binary_manifest_from_file :: (filename: string) -> bool, Android_Manifest_Binary` | All reviewed hosts |
| `read_binary_manifest_from_memory :: (data: string, filename := "<memory>") -> bool, Android_Manifest_Binary` | All reviewed hosts |
| `read_block :: (s: *string, length: int) -> string` | All reviewed hosts |
| `read_length_prefixed_block :: (s: *string) -> string` | All reviewed hosts |
| `read_silly_alias :: ($Int_Type: Type, s: *string, $BIG_ENDIAN := false) -> Int_Type` | All reviewed hosts |
| `run_android_link_command :: (message: *Message_Phase, options: Build_Options, extra_args: [] string = .[])` | All reviewed hosts |
| `run_gradle_task :: (project_path: string, task: string, print_output := true) -> bool` | All reviewed hosts |
| `sha1 :: (s: string) -> [SHA_DIGEST_LENGTH] u8` | All reviewed hosts |
| `sha256 :: (s: string) -> [SHA256_DIGEST_LENGTH] u8` | All reviewed hosts |
| `sign_data :: (private_key_info: string, message: string) -> bool, string` | All reviewed hosts |
| `Signature :: struct` | All reviewed hosts |
| `SIGNING_BLOCK_ID_V2_SIGNATURE : u32` | All reviewed hosts |
| `SIGNING_BLOCK_ID_V31_SIGNATURE : u32` | All reviewed hosts |
| `SIGNING_BLOCK_ID_V3_SIGNATURE : u32` | All reviewed hosts |
| `SIGNING_BLOCK_ID_VERITY_PADDING : u32` | All reviewed hosts |
| `stop_app :: (package_name: string) -> bool` | All reviewed hosts |
| `to_hex_string :: (a: [8] $T) -> string` | All reviewed hosts |
| `to_hex_string :: (s: string) -> string` | All reviewed hosts |
| `USE_FULL_MODULE :: false` | All reviewed hosts |
| `write_binary_app_manifest_to_builder :: (b: *String_Builder, config: Android_Project_Config) -> bool` | All reviewed hosts |
| `write_binary_app_manifest_to_file :: (using config: Android_Project_Config, out_filepath: string) -> bool` | All reviewed hosts |
| `write_binary_app_manifest_to_memory :: (config: Android_Project_Config) -> bool, string` | All reviewed hosts |
| `x509_get_subject_public_key_info :: (certificate_data: string) -> ASN1_Value` | All reviewed hosts |
| `zip_add_file :: (using w: *Zip_Writer, filepath: string, zip_filename: string, compression := Zip_Compression_Method.NONE, alignment := 0) -> bool` | All reviewed hosts |
| `zip_add_file_from_memory :: (using w: *Zip_Writer, file_data: string, zip_filename: string, compression := Zip_Compression_Method.NONE, alignment := 0) -> bool` | All reviewed hosts |
| `ZIP_CENTRAL_DIRECTORY_FILE_HEADER_SIGNATURE : u32` | All reviewed hosts |
| `Zip_Central_Directory_Header :: struct` | All reviewed hosts |
| `Zip_Compression_Method :: enum u16` | All reviewed hosts |
| `zip_crc32 :: (s: string) -> u32` | All reviewed hosts |
| `zip_decode_version :: (version_word: u16) -> Zip_Version` | All reviewed hosts |
| `zip_encode_version :: (version: Zip_Version) -> u16` | All reviewed hosts |
| `Zip_End_Of_Central_Directory_Record :: struct` | All reviewed hosts |
| `ZIP_END_OF_CENTRAL_DIRECTORY_RECORD_SIGNATURE : u32` | All reviewed hosts |
| `ZIP_END_OF_CENTRAL_DIRECTORY_RECORD_SIZE :: 22` | All reviewed hosts |
| `zip_eocd_get_start_of_central_directory_offset :: (eocd: string) -> u32` | All reviewed hosts |
| `ZIP_EOCD_OFFSET_FIELD_OFFSET :: 16` | All reviewed hosts |
| `zip_eocd_set_start_of_central_directory_offset :: (eocd: string, new_offset: u32)` | All reviewed hosts |
| `zip_init_writer :: (using w: *Zip_Writer, do_crcs := true, max_alignment := 0)` | All reviewed hosts |
| `Zip_Local_File_Header :: struct` | All reviewed hosts |
| `ZIP_LOCAL_HEADER_SIZE :: size_of(Zip_Local_File_Header)` | All reviewed hosts |
| `Zip_Version :: struct` | All reviewed hosts |
| `ZIP_VERSION_DEFAULT : u16` | All reviewed hosts |
| `zip_write_central_directory :: (using w: *Zip_Writer)` | All reviewed hosts |
| `Zip_Writer :: struct` | All reviewed hosts |

### Default_Metaprogram

Build orchestration and option/message behavior remain implementation work; exact help text/option grammar require further review.

Reviewed contract: [module page](specs/stdlib/modules/default-metaprogram.md).

| Missing public declaration | Condition |
| --- | --- |
| `build :: ()` | All reviewed hosts |
| `HELP_STRING :: #string DONE` | All reviewed hosts |
| `is_absolute_path :: (path: string) -> bool` | All reviewed hosts |
| `message_loop :: (w: Workspace)` | All reviewed hosts |
| `plugins: [..] *Metaprogram_Plugin` | All reviewed hosts |
| `verbose := false` | All reviewed hosts |

### Example_Plugin

Plugin lifecycle callbacks/options/state behavior remain missing. Compiler callback types are reviewed; no placeholder callbacks are counted as implementation.

Reviewed contract: [module page](specs/stdlib/modules/example-plugin.md).

| Missing public declaration | Condition |
| --- | --- |
| `add_source :: (p: *Metaprogram_Plugin)` | All reviewed hosts |
| `before_intercept :: (p: *Metaprogram_Plugin, flags: *Intercept_Flags)` | All reviewed hosts |
| `finish :: (p: *Metaprogram_Plugin)` | All reviewed hosts |
| `get_plugin :: () -> *Metaprogram_Plugin` | All reviewed hosts |
| `HELP_STRING :: #string DONE -option arg This is just an option. You pass it one argument. DONE` | All reviewed hosts |
| `init :: (p: *Metaprogram_Plugin, options: [] string) -> bool` | All reviewed hosts |
| `log_help :: (p: *Metaprogram_Plugin)` | All reviewed hosts |
| `message :: (p: *Metaprogram_Plugin, message: *Message)` | All reviewed hosts |
| `My_Plugin :: struct` | All reviewed hosts |
| `shutdown :: (p: *Metaprogram_Plugin)` | All reviewed hosts |

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

Mutable project state, compiler message integration and actual Visual Studio output generation remain missing, including nested public operations.

Reviewed contract: [module page](specs/stdlib/modules/project-generator.md).

| Missing public declaration | Condition |
| --- | --- |
| `Project_Generator : struct` | All reviewed hosts |

Missing nested public operations:

- `Project_Generator.add_file :: (file: string, take_ownership: bool);`
- `Project_Generator.add_file :: (path: string, file: string);`
- `Project_Generator.build :: (file: string);`
- `Project_Generator.intercept_messages :: (w: Workspace);`
- `Project_Generator.process_message :: (message: *Message);`
- `Project_Generator.reset :: ();`

## Images and resources

### Ico_File

Bitmap loading/resize/ICO encoding remain missing. Review image-size set, component/padding counts and returned-storage contract before claiming exact compatibility.

Reviewed contract: [module page](specs/stdlib/modules/ico-file.md).

| Missing public declaration | Condition |
| --- | --- |
| `create_ico_file :: (x: s32, y: s32, comp: s32, image_data: *u8) -> string` | All reviewed hosts |
| `create_ico_file_from_bitmap_filename :: (bitmap_filename: string) -> string` | All reviewed hosts |
| `get_bytes_for_image :: (comp: s32, size: s32) -> (image_bytes: s32, mask_bytes: s32, total_bytes: s32)` | All reviewed hosts |
| `get_total_bytes_for_size :: (comp: s32, size: s32) -> s32` | All reviewed hosts |

### Icon

Plugin option parsing, diagnostics and real resource attachment remain missing; no fake plugin success or placeholder help string.

Reviewed contract: [module page](specs/stdlib/modules/icon.md).

| Missing public declaration | Condition |
| --- | --- |
| `get_plugin :: () -> *Metaprogram_Plugin` | All reviewed hosts |
| `HELP_STRING :: #string DONE` | All reviewed hosts |
| `init :: (p: *Metaprogram_Plugin, options: [] string) -> bool` | All reviewed hosts |
| `log_help :: (p: *Metaprogram_Plugin)` | All reviewed hosts |
| `message :: (p: *Metaprogram_Plugin, message: *Message)` | All reviewed hosts |
| `shutdown :: (p: *Metaprogram_Plugin)` | All reviewed hosts |

### Windows_Resources

Resource updates, manifest generation, actual tool discovery and console workspace configuration remain missing. Exact resource-ID defaults and manifest DPI/ownership policy need review.

Reviewed contract: [module page](specs/stdlib/modules/windows-resources.md).

| Missing public declaration | Condition |
| --- | --- |
| `add_manifest_to_executable :: (exe_filename: string, options: Manifest_Options, resource_id: s32 = RESOURCE_ID_MANIFEST) -> bool` | OS == .WINDOWS |
| `disable_runtime_console :: (w: Workspace = -1)` | OS == .WINDOWS |
| `find_visual_studio_in_a_ridiculous_garbage_way :: () -> (library_path := "", linker_path := "")` | OS == .WINDOWS |
| `find_windows_kit_root :: () -> (root: string, windows_version: s32)` | OS == .WINDOWS |
| `find_windows_kit_root :: (version: string) -> string` | OS == .WINDOWS |
| `generate_manifest :: (options: Manifest_Options) -> string` | OS == .WINDOWS |
| `ICONDIR :: struct` | OS == .WINDOWS |
| `ICONDIRENTRY :: struct` | OS == .WINDOWS |
| `Manifest_Options :: struct` | OS == .WINDOWS |
| `set_icon_by_data :: (exe_filename: string, icon_data: string, resource_id : s32 = RESOURCE_ID_FIRST_ICON, delete_existing_resources := false) -> bool` | OS == .WINDOWS |
| `set_icon_by_filename :: (exe_filename: string, icon_filename: string, resource_id : s32 = RESOURCE_ID_FIRST_ICON, delete_existing_resources := false) -> bool` | OS == .WINDOWS |

## Text and packages

### Subtitles

Parsing/serialization/formatting and real ownership remain missing; the versioned grammar, escaping/CSV/HTML and exact storage rules need review.

Reviewed contract: [module page](specs/stdlib/modules/subtitles.md).

| Missing public declaration | Condition |
| --- | --- |
| `csv_line_index_within_section: int` | All reviewed hosts |
| `csv_line_number: int` | All reviewed hosts |
| `csv_quote :: (s: string) -> string` | All reviewed hosts |
| `flush_csv_lines :: (builder: *String_Builder, section_name: string, name_map: *Table(string, string), _speaker_name: string, lines: [] string, directions: [] string)` | All reviewed hosts |
| `format_section_as_csv :: (builder: *String_Builder, section: *Subtitles_Section, name_map: *Table(string, string) = null)` | All reviewed hosts |
| `format_section_as_html :: (builder: *String_Builder, section: *Subtitles_Section, character_to_emphasize := "", name_map: *Table(string, string) = null)` | All reviewed hosts |
| `format_sections_as_csv :: (builder: *String_Builder, sections: [] *Subtitles_Section, name_map: *Table(string, string) = null)` | All reviewed hosts |
| `format_sections_as_html :: (builder: *String_Builder, sections: [] *Subtitles_Section, character_to_emphasize := "", name_map: *Table(string, string) = null)` | All reviewed hosts |
| `free :: (using subtitles: *Subtitles)` | All reviewed hosts |
| `get_sections_for_characters :: (subtitles: Subtitles, names: .. string) -> [..] *Subtitles_Section` | All reviewed hosts |
| `load_subtitles_from_file :: (path: string) -> bool, Subtitles` | All reviewed hosts |
| `load_subtitles_from_memory :: (data: string, short_name: string) -> bool, Subtitles` | All reviewed hosts |
| `SECTION_VERSION_NUMBER :: 1` | All reviewed hosts |
| `serialize :: (using subtitles: *Subtitles) -> string` | All reviewed hosts |
| `Subtitles :: struct` | All reviewed hosts |
| `Subtitles_Event :: struct` | All reviewed hosts |
| `Subtitles_Instant :: struct` | All reviewed hosts |
| `Subtitles_Line :: struct` | All reviewed hosts |
| `Subtitles_Section :: struct` | All reviewed hosts |

### Simple_Package

Archive creation/validation/loading remain missing; package/TOC magic and entry wire representation are unresolved. No substitute wire format.

Reviewed contract: [module page](specs/stdlib/modules/simple-package.md).

| Missing public declaration | Condition |
| --- | --- |
| `add :: (package: *Create_Package, entry_name: string, data: [] u8)` | All reviewed hosts |
| `Create_Package :: struct` | All reviewed hosts |
| `deinit :: (using package: *Create_Package)` | All reviewed hosts |
| `Entry_Info :: struct` | All reviewed hosts |
| `init :: (using package: *Create_Package)` | All reviewed hosts |
| `init_from_file :: (package: *Load_Package, filename: string) -> bool` | All reviewed hosts |
| `init_from_memory :: (package: *Load_Package, data: [] u8, name_for_debugging := "") -> bool` | All reviewed hosts |
| `KNOWN_HEADER_SIZE :: 64` | All reviewed hosts |
| `KNOWN_TABLE_OF_CONTENTS_SIZE :: 64` | All reviewed hosts |
| `Load_Package :: struct` | All reviewed hosts |
| `load_table_of_contents :: (package: *Load_Package, data: [] u8, base_file_data_if_file_is_loaded: *u8, name_for_debugging: string, offset_for_debugging: s64) -> bool` | All reviewed hosts |
| `load_table_of_contents_only :: (filename: string, okay_if_it_does_not_exist := false) -> (success: bool, package: Load_Package)` | All reviewed hosts |
| `Package_Header :: struct` | All reviewed hosts |
| `Table_Of_Contents :: struct` | All reviewed hosts |
| `write :: (package: *Create_Package, filename: string, sort_contents := true) -> bool` | All reviewed hosts |

Total: 248 missing reviewed declaration/overload/nested-operation rows
in these largely unimplemented modules. This is not the full library gap
count: partial module behavior, platform backends, compiler dependencies,
independent test review and integrated/native verification remain separate.
