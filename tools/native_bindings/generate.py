#!/usr/bin/env python3
"""Generate native ABI facades exclusively from the reviewed public specs."""
import argparse
from collections import Counter, defaultdict
import hashlib
import json
from pathlib import Path
import re

from spec import parse_spec
from config import IMPORTS, LIBRARIES, PARAMETERS, PRIVATE, TARGETS
from wrappers import simple_body, forwarding_body

ROOT = Path(__file__).resolve().parents[2]
MODULES = {
    'Android': 'android', 'Android/AAudio': 'android-aaudio', 'Android/EGL': 'android-egl',
    'Curl': 'curl', 'd3d11': 'd3d11', 'd3d12': 'd3d12', 'd3d_compiler': 'd3d-compiler',
    'dxc_compiler': 'dxc-compiler', 'dxgi': 'dxgi', 'freetype': 'freetype', 'GL': 'gl',
    'ImGui': 'imgui', 'iOS': 'ios', 'Linux': 'linux', 'lz4': 'lz4', 'macOS': 'macos',
    'meshoptimizer': 'meshoptimizer', 'Metal': 'metal', 'MojoShader': 'mojoshader',
    'nvidia_aftermath': 'nvidia-aftermath', 'nvtt': 'nvtt', 'Objective_C': 'objective-c',
    'POSIX': 'posix', 'rpmalloc': 'rpmalloc', 'SDL': 'sdl', 'stb_image': 'stb-image',
    'stb_image_resize': 'stb-image-resize', 'stb_image_write': 'stb-image-write',
    'stb_vorbis': 'stb-vorbis', 'telemetry3': 'telemetry3', 'Vulkan': 'vulkan',
    'Windows': 'windows', 'X11': 'x11', 'xxHash': 'xxhash',
}
COM_MODULES = {'d3d11', 'd3d12', 'd3d_compiler', 'dxc_compiler', 'dxgi', 'Windows', 'nvtt'}


def split_arguments(text):
    parts, start, depth, quoted = [], 0, 0, False
    for i, c in enumerate(text):
        if c == '"' and (i == 0 or text[i - 1] != '\\'):
            quoted = not quoted
        if quoted:
            continue
        if c in '([{':
            depth += 1
        elif c in ')]}':
            depth -= 1
        elif c == ',' and depth == 0:
            parts.append(text[start:i].strip())
            start = i + 1
    if text[start:].strip():
        parts.append(text[start:].strip())
    return parts


def procedure_parts(code):
    match = re.match(r'(.+?)\s*::\s*(?:inline\s+)?\(', code)
    if not match:
        return None
    start, depth = match.end(), 1
    for i in range(start, len(code)):
        if code[i] == '(':
            depth += 1
        elif code[i] == ')':
            depth -= 1
            if not depth:
                params = split_arguments(code[start:i])
                if params and not any(':' in p for p in params):
                    return None
                names = [p.split(':', 1)[0].strip().removeprefix('using ') for p in params]
                return match[1].strip(), params, names, code[i + 1:]
    raise ValueError('Unclosed procedure signature: ' + code)


def guard(code, condition):
    return '#if ' + condition + ' {\n' + code + '\n}\n' if condition else code + '\n'


def condition_for(module, declaration):
    condition = declaration.condition
    if condition == 'else branch':
        if module == 'Objective_C':
            condition = 'OS != .MACOS' if declaration.name == 'BOOL' else 'CPU != .X64'
        elif module == 'telemetry3':
            condition = 'ENABLED && OS == .WINDOWS'
        elif module == 'rpmalloc':
            condition = '!ENABLE_STATISTICS'
        else:
            raise ValueError(f'{module}: ambiguous else condition')
    if condition == 'GLX extension':
        condition = 'OS == .LINUX'
    return condition


def com_forward(module, declaration):
    parts = procedure_parts(declaration.code)
    if module not in COM_MODULES or not parts:
        return None
    name, params, args, tail = parts
    if name == 'vtable' and len(args) == 1:
        return declaration.code + ' { return ' + args[0] + '.vtable; }'
    if args and args[0] == 'this':
        target = re.match(r'this:\s*\*([\w]+)', params[0])
        if target and name.startswith(target[1] + '_'):
            method = name[len(target[1]) + 1:]
            if method == 'Destructor':
                method = 'Destructor'
            call = 'this.vtable.' + method + '(' + ', '.join(args) + ');'
            ret = 'return ' if '->' in tail and not re.search(r'->\s*(?:void|\(\))\b', tail) else ''
            return declaration.code + ' { ' + ret + call + ' }'
    return None


def generate_facade(module, spec):
    shapes = defaultdict(list)
    for shape in spec.shapes:
        shapes[shape.name].append(shape)
    ledger, output, emitted = [], [], set()
    for d in spec.declarations:
        record = {'name': d.name, 'signature': d.code, 'condition': d.condition, 'spec_line': d.line}
        condition = condition_for(module, d)
        key = (condition, d.code)
        if key in emitted:
            record.update(status='duplicate', reason='Exact repeated inventory signature')
            ledger.append(record)
            continue
        emitted.add(key)
        code = d.code.rstrip(';')
        if re.search(r'\*struct$', code):
            code += ' {}'
        if re.search(r'\w+\.$', code):
            record.update(status='unresolved', reason='Reviewed inventory omits aggregate initializer contents')
            ledger.append(record)
            continue
        aggregate = re.search(r':(?::)?\s*(?:struct|union|enum(?:_flags)?)(?:\s|$)', code)
        if aggregate:
            candidates = shapes[d.name]
            exact = [s for s in candidates if s.condition == condition]
            selected = exact or [s for s in candidates if not s.condition]
            if not selected and len(candidates) == 1:
                selected = candidates
            if not selected:
                record.update(status='unresolved', reason='No unambiguous shape for this configuration')
                ledger.append(record)
                continue
            blocks = []
            for s in selected:
                body = s.code
                if s.member_list:
                    # The prose renderer omits the terminal semicolon of an
                    # inline anonymous member and uses postfix overlay notation.
                    body = re.sub(r'(\w+):\s*([^;{}]+?)\s+#overlay\s+(\w+);',
                                  r'#overlay (\3) \1: \2;', body)
                    body = re.sub(r'([^;{}\s])\s+}', r'\1; }', body)
                if module == 'SDL' and d.name == 'Hack':
                    body = body.replace('K :: inline (scancode: SDL_Scancode) -> s32',
                                        'K :: inline (scancode: SDL_Scancode) -> s32 { return cast(s32) scancode | (1 << 30); }')
                # Member-list headers omit type widths and directives; inventory
                # headers preserve those. Complete shape blocks retain overlays.
                if body.startswith(d.name + ' :: ') and '{' in body:
                    old_header = body[:body.index('{')].strip()
                    if '(' not in old_header and not re.search(r'#(?:align|no_padding)', old_header):
                        body = code + ' ' + body[body.index('{'):]
                blocks.append(guard(body, s.condition if s.condition != condition else ''))
            code = '\n'.join(blocks)
            record['status'] = 'declared'
        elif '#foreign' in code or '#elsewhere' in code:
            code += ';'
            record['status'] = 'declared'
        elif procedure_parts(code):
            forwarded = com_forward(module, d)
            if forwarded:
                code = forwarded
                record['status'] = 'forwarded'
            else:
                parts = procedure_parts(code)
                body = simple_body(module, d.name, condition)
                if body is None:
                    body = forwarding_body(module, d, spec.declarations, parts, procedure_parts)
                if body is not None:
                    code += ' { ' + body + ' }'
                    record['status'] = 'implemented'
                else:
                    record.update(status='unresolved', reason='Requires independently authored wrapper body')
                    ledger.append(record)
                    continue
        else:
            code += ';'
            record['status'] = 'declared'
        output.append(guard(code, condition))
        ledger.append(record)
    return '\n'.join(output), ledger


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true')
    parser.add_argument('--module', action='append', choices=MODULES)
    args = parser.parse_args()
    all_ledger = {}
    stale = []
    for module, slug in MODULES.items():
        page = ROOT / 'docs/specs/stdlib/modules' / (slug + '.md')
        spec = parse_spec(page.read_text())
        code, entries = generate_facade(module, spec)
        digest = hashlib.sha256(page.read_bytes()).hexdigest()
        all_ledger[module] = {'spec': str(page.relative_to(ROOT)), 'spec_sha256': digest,
                              'counts': dict(Counter(e['status'] for e in entries)), 'declarations': entries}
        if args.module and module not in args.module:
            continue
        path = ROOT / 'stdlib' / module / 'declarations.jai'
        preamble = ['#scope_file']
        preamble += ['#import "' + dep + '";' for dep in IMPORTS.get(module, [])]
        preamble += [PRIVATE.get(module, '')]
        library_names = sorted(set(re.findall(r'#(?:foreign|elsewhere)\s+(\w+)', code + '\n' + PRIVATE.get(module, ''))))
        for name in library_names:
            if name == 'gl_lib':
                preamble.append('#if OS == .WINDOWS { gl_lib :: #library,system "opengl32"; }\nelse #if OS == .MACOS { gl_lib :: #library,system "OpenGL"; }\nelse { gl_lib :: #library,system "GL"; }')
            else:
                preamble.append(name + ' :: #library,system "' + LIBRARIES.get(name, name) + '";')
        preamble.append('#scope_export')
        code = '// Generated from ' + str(page.relative_to(ROOT)) + '.\n// Regenerate with tools/native_bindings/generate.py; do not hand-edit.\n\n' + '\n'.join(preamble) + '\n\n' + code
        if args.check:
            if not path.exists() or path.read_text() != code:
                stale.append(str(path.relative_to(ROOT)))
        else:
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(code)
        entry = ROOT / 'stdlib' / module / 'module.jai'
        entry_code = '\n'.join(spec.parameter_blocks or [PARAMETERS.get(module, '')]) + '\n'
        if module in TARGETS:
            entry_code += '#assert ' + TARGETS[module] + ', "' + module + ' requires its documented native platform";\n'
        entry_code += '#load "declarations.jai";\n'
        wrappers = ROOT / 'stdlib' / module / 'wrappers.jai'
        if wrappers.exists():
            entry_code += '#load "wrappers.jai";\n'
        if args.check:
            if not entry.exists() or entry.read_text() != entry_code:
                stale.append(str(entry.relative_to(ROOT)))
        else:
            entry.write_text(entry_code)
    path = ROOT / 'docs/native/bindings-coverage.json'
    serialized = json.dumps({'format': 1, 'note': 'Declared is not ABI or runtime verified. Unresolved entries are not implemented.', 'modules': all_ledger}, indent=2) + '\n'
    if args.check:
        if not path.exists() or path.read_text() != serialized:
            stale.append(str(path.relative_to(ROOT)))
        if stale:
            raise SystemExit('Stale generated files:\n' + '\n'.join(stale))
    else:
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(serialized)
    for module, value in all_ledger.items():
        print(module + ': ' + ', '.join(f'{count} {status}' for status, count in value['counts'].items()))


if __name__ == '__main__':
    main()
