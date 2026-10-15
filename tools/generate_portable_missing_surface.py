#!/usr/bin/env python3
"""Enumerate missing owned public declarations from reviewed specs only."""
from pathlib import Path
import json
import re
from portable_api_spec import parse_spec

ROOT = Path(__file__).resolve().parents[1]
MODULES = [
    ('Build and toolchain', 'Android/Toolchain', 'android-toolchain',
     {'get_android_project_jni_architecture_name', 'ASN1_Object_Identifier', 'asn1_oid_equals',
      'OID_SUN_JKS_ENCRYPTION', 'JKS_MAGIC', 'JKS_MAGIC_LITTLE_ENDIAN', 'sha1', 'sha256',
      'Adb_Version_Info', 'Adb_Device', 'Adb_Compression_Algorithm', '__adb_path', 'adb_device_serial',
      'adb_be_verbose', 'adb', 'adb_version', 'adb_devices', 'is_adb_installed', 'adb_push', 'adb_pull',
      'adb_shell_mkdir', 'adb_shell_pidof', 'adb_uninstall', 'stop_app', 'is_app_running', 'android_is_app_installed',
      'JAVA_ENV_NAME', 'find_java_bin_path_from_environment',
      'android_find_sdk_path',
      'Android_Config_Changes', 'android_config_changes_from_string',
      'Zip_Version', 'zip_decode_version', 'zip_encode_version', 'ZIP_CENTRAL_DIRECTORY_FILE_HEADER_SIGNATURE',
      'ZIP_END_OF_CENTRAL_DIRECTORY_RECORD_SIGNATURE', 'ZIP_END_OF_CENTRAL_DIRECTORY_RECORD_SIZE',
      'ZIP_EOCD_OFFSET_FIELD_OFFSET', 'zip_eocd_get_start_of_central_directory_offset',
      'zip_eocd_set_start_of_central_directory_offset', 'zip_crc32', 'Kilobytes', 'Megabytes',
      'Zip_Compression_Method', 'Zip_Local_File_Header', 'Zip_Central_Directory_Header',
      'Zip_End_Of_Central_Directory_Record', 'ZIP_LOCAL_HEADER_SIZE', 'ZIP_VERSION_DEFAULT',
      'Zip_Writer', 'zip_init_writer', 'zip_add_file', 'zip_add_file_from_memory', 'zip_write_central_directory',
      'Android_Signing_Key', 'Android_Signing_Key_Kind', 'Android_Signing_Key_Signature_Algorithm',
      'Android_Apk', 'Android_Apk_Entry', 'apk_load', 'apk_deinit', 'for_expansion', 'apk_print_sections',
      'ANDROID_APK_SIGNING_BLOCK_MAGIC',
      'ASN1_Tag_Class', 'ASN1_Tag_Length_Value', 'ASN1_Universal_Type', 'ASN1_Tag', 'ASN1_KNOWN_OIDS',
      'asn1_read_tag', 'asn1_read_length', 'asn1_decode_integer', 'asn1_decode_object_identifier',
      'asn1_to_string', 'read_silly_alias', 'read', 'read_block', 'ASN1_Value', 'asn1_read_value', 'read_length_prefixed_block', 'asn1_print', 'x509_get_subject_public_key_info'},
     'JNI/OID/JKS constants/SHA, ASN.1 primitives/diagnostics/X509, ZIP32 records/writer/CRC/offset/unit helpers, APK whole-file views/iteration, manifest flags, Java launcher and reviewed ADB operations have independent behavior tests. Deflate uses real stored blocks (size tradeoff). Real SDK/device and Windows Process integration remain pending. Install recovery, higher-level build/signing/manifest and remaining helpers are missing; marker-only APK is not claimed signature-valid.'),
    ('Build and toolchain', 'Default_Metaprogram', 'default-metaprogram',
     {'HELP_STRING', 'is_absolute_path', 'message_loop', 'plugins', 'verbose'},
     'Real Check-enabled workspace builds, binding configuration, options, plugin imports/callback ordering, paths, help/version and failures pass, including full owned strict lint. build remains partial only for unsupported compiler backend/debugger and selected-workspace command-line execution dependencies; no CLI bypass or fabricated completion.'),
    ('Build and toolchain', 'Example_Plugin', 'example-plugin',
     {'HELP_STRING', 'My_Plugin', 'add_source', 'before_intercept', 'finish', 'get_plugin', 'init', 'log_help', 'message', 'shutdown'},
     'All reviewed record/options/lifecycle exports implemented. Canonical type/defaults, initialized state, malformed options, phase/typecheck/completion diagnostics and owned shutdown pass interpreter/native O0/O2 and strict lint; the actual default workspace loader builds and runs a target with +Example_Plugin. No source/artifact-producing callback is fabricated.'),
    ('Build and toolchain', 'linux_build', 'linux-build', set(),
     'Windows-host Unreal cross-link orchestration remains missing; actual external toolchain/native integration is also pending.'),
    ('Build and toolchain', 'Project_Generator', 'project-generator',
     {'Project_Generator', 'Project_Generator.reset', 'Project_Generator.add_file',
      'Project_Generator.process_message', 'Project_Generator.build', 'Project_Generator.intercept_messages'},
     'All reviewed public state/method behavior implemented: owned unique file collection/reset, real compiler workspaces and four deterministic XML/solution artifacts. Collection interpreter/native O0/O2, actual target O0/O2, defaults/persistence/escaping/filters/unchanged mtimes and write failure pass. Full strict lint remains blocked by general SandboxHost compile-time executable-path SDK support; no default or lint workaround. Native Visual Studio execution/resource availability remain pending.'),
]


def main():
    transfer_file = ROOT / 'docs/status/portable-scope-transfers.json'
    transferred = json.loads(transfer_file.read_text())['Android/Toolchain']['excluded_names'] if transfer_file.exists() else []
    lines = ['# Remaining owned public surface', '',
             'Generated from reviewed specs by tools/generate_portable_missing_surface.py.',
             'Every row below is MISSING, including types/constants; a name in this inventory',
             'is not a declaration-only completion claim. This complements the module ledger',
             'and detailed partial-module inventories for Machine, Pool, time, Socket,',
             'Registry, MPEG and executable formats. Ownership exclusions are not listed.',
             'Rows preserve each overload/condition; declarations are independently grouped',
             'alphabetically within responsibility groups. No source implementation/history',
             'or legacy test expectations are inventory inputs.', '']
    total = 0
    previous_group = None
    for group, module, slug, implemented, note in MODULES:
        if group != previous_group:
            lines += [f'## {group}', '']
            previous_group = group
        page = ROOT/f'docs/specs/stdlib/modules/{slug}.md'
        spec = parse_spec(page.read_text())
        remaining = [d for d in spec.declarations if d.name not in implemented
                     and not (module == 'Android/Toolchain' and d.name in transferred)]
        lines += [f'### {module}', '', note, '',
                  f'Reviewed contract: [module page](specs/stdlib/modules/{slug}.md).', '',
                  '| Missing public declaration | Condition |', '| --- | --- |']
        for declaration in sorted(remaining, key=lambda d: (d.name.casefold(), d.condition, d.code)):
            code = declaration.code.replace('|', '&#124;')
            lines.append(f'| `{code}` | {declaration.condition or "All reviewed hosts"} |')
            total += 1
        lines += ['']
        nested = []
        for shape in spec.shapes:
            for match in re.finditer(r'^\s*(\w+\s*::\s*\([^\n]+)', shape.code, re.MULTILINE):
                method_name = match[1].split('::', 1)[0].strip()
                if f'{shape.name}.{method_name}' in implemented:
                    continue
                nested.append(f'{shape.name}.{match[1].strip()}')
        if nested:
            lines += ['Missing nested public operations:', '']
            lines += [f'- `{signature}`' for signature in sorted(nested)]
            lines += ['']
            total += len(nested)
    lines += [f'Total: {total} missing reviewed declaration/overload/nested-operation rows',
              'in these largely unimplemented modules. This is not the full library gap',
              'count: partial module behavior, platform backends, compiler dependencies,',
              'independent test review and integrated/native verification remain separate.', '']
    (ROOT/'docs/portable-missing-surface.md').write_text('\n'.join(lines))
    print(f'Enumerated {total} exact missing public rows; no functionality credited')


if __name__ == '__main__':
    main()
