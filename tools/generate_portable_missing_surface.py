#!/usr/bin/env python3
"""Enumerate missing owned public declarations from reviewed specs only."""
from pathlib import Path
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
      'ASN1_Tag_Class', 'ASN1_Tag_Length_Value', 'ASN1_Universal_Type', 'ASN1_Tag', 'ASN1_KNOWN_OIDS',
      'asn1_read_tag', 'asn1_read_length', 'asn1_decode_integer', 'asn1_decode_object_identifier',
      'asn1_to_string', 'read_silly_alias', 'read', 'read_block', 'ASN1_Value', 'asn1_read_value', 'read_length_prefixed_block', 'asn1_print', 'x509_get_subject_public_key_info'},
     'JNI/OID/JKS/SHA, ASN.1 primitive/cursor/value/diagnostic APIs, manifest flags, Java launcher and reviewed ADB discovery/server/quoting/storage/cache operations have independent behavior tests. Real SDK/device and Windows Process integration remain pending. Install recovery, higher-level build/signing/manifest and remaining helpers are missing; no device, SDK or signing success is fabricated.'),
    ('Build and toolchain', 'Default_Metaprogram', 'default-metaprogram', set(),
     'Build orchestration and option/message behavior remain implementation work; exact help text/option grammar require further review.'),
    ('Build and toolchain', 'Example_Plugin', 'example-plugin', set(),
     'Plugin lifecycle callbacks/options/state behavior remain missing. Compiler callback types are reviewed; no placeholder callbacks are counted as implementation.'),
    ('Build and toolchain', 'linux_build', 'linux-build', set(),
     'Windows-host Unreal cross-link orchestration remains missing; actual external toolchain/native integration is also pending.'),
    ('Build and toolchain', 'Project_Generator', 'project-generator', set(),
     'Mutable project state, compiler message integration and actual Visual Studio output generation remain missing, including nested public operations.'),
]


def main():
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
        remaining = [d for d in spec.declarations if d.name not in implemented]
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
