#!/usr/bin/env python3
"""Enumerate missing owned public declarations from reviewed specs only."""
from pathlib import Path
import re
from portable_api_spec import parse_spec

ROOT = Path(__file__).resolve().parents[1]
MODULES = [
    ('Build and toolchain', 'Android/Toolchain', 'android-toolchain',
     {'get_android_project_jni_architecture_name', 'ASN1_Object_Identifier', 'asn1_oid_equals',
      'OID_SUN_JKS_ENCRYPTION', 'JKS_MAGIC', 'JKS_MAGIC_LITTLE_ENDIAN'},
     'JNI ABI naming, counted OID identity and reviewed JKS constants are implemented. Device/build/signing/manifest and remaining helpers are missing; no device, SDK, signing or crypto success is fabricated.'),
    ('Build and toolchain', 'Default_Metaprogram', 'default-metaprogram', set(),
     'Build orchestration and option/message behavior remain implementation work; exact help text/option grammar require further review.'),
    ('Build and toolchain', 'Example_Plugin', 'example-plugin', set(),
     'Plugin lifecycle callbacks/options/state behavior remain missing. Compiler callback types are reviewed; no placeholder callbacks are counted as implementation.'),
    ('Build and toolchain', 'linux_build', 'linux-build', set(),
     'Windows-host Unreal cross-link orchestration remains missing; actual external toolchain/native integration is also pending.'),
    ('Build and toolchain', 'Project_Generator', 'project-generator', set(),
     'Mutable project state, compiler message integration and actual Visual Studio output generation remain missing, including nested public operations.'),
    ('Images and resources', 'Ico_File', 'ico-file', set(),
     'Bitmap loading/resize/ICO encoding remain missing. Review image-size set, component/padding counts and returned-storage contract before claiming exact compatibility.'),
    ('Images and resources', 'Icon', 'icon', set(),
     'Plugin option parsing, diagnostics and real resource attachment remain missing; no fake plugin success or placeholder help string.'),
    ('Images and resources', 'Windows_Resources', 'windows-resources', set(),
     'Resource updates, manifest generation, actual tool discovery and console workspace configuration remain missing. Exact resource-ID defaults and manifest DPI/ownership policy need review.'),
    ('Text and packages', 'Subtitles', 'subtitles', set(),
     'Parsing/serialization/formatting and real ownership remain missing; the versioned grammar, escaping/CSV/HTML and exact storage rules need review.'),
    ('Text and packages', 'Simple_Package', 'simple-package', set(),
     'Archive creation/validation/loading remain missing; package/TOC magic and entry wire representation are unresolved. No substitute wire format.'),
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
