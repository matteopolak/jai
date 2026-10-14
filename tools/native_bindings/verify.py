#!/usr/bin/env python3
"""Run desktop checks and real host native tests with an explicit own compiler.

Results distinguish unsupported platforms, compiler failures, declaration
checks, public-surface checks, and native executions. A declaration import that
passes while a required wrapper is missing does not count as a complete module.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys

from config import TARGETS
from generate import MODULES, condition_for
from spec import parse_spec
from symbols import check_symbols
import ast
import re

ROOT = Path(__file__).resolve().parents[2]
TARGET_CONFIGS = [(os_name, cpu) for os_name in ('linux', 'macos', 'windows') for cpu in ('x64', 'arm64')]


def enabled(condition, os_name, cpu):
    if not condition:
        return True
    values = {'OS': os_name.upper(), 'CPU': cpu.upper(), 'ENABLED': False,
              'ENABLE_ALL_EXTENSIONS': False, 'INCLUDE_DEBUG_BINDINGS': False,
              'INCLUDE_MEDIA_BINDINGS': False, 'INCLUDE_CAMERA_BINDINGS': False,
              'DEFINE_ANDROID_MAIN_AND_CALL_THIS': False, 'ENABLE_STATISTICS': True,
              'RPMALLOC_FIRST_CLASS_HEAPS': True}
    expression = condition.replace('&&', ' and ').replace('||', ' or ')
    expression = re.sub(r'!(?!=)', ' not ', expression)
    expression = re.sub(r'\.(WINDOWS|LINUX|MACOS|ANDROID|IOS|X64|ARM64)', lambda m: repr(m[1]), expression)
    for name, value in values.items():
        expression = re.sub(r'\b' + name + r'\b', repr(value), expression)
    tree = ast.parse(expression.strip(), mode='eval')
    if any(not isinstance(node, (ast.Expression, ast.BoolOp, ast.UnaryOp, ast.Compare, ast.Constant,
                                 ast.And, ast.Or, ast.Not, ast.Eq, ast.NotEq, ast.Load)) for node in ast.walk(tree)):
        raise ValueError('Unsupported condition: ' + condition)
    return bool(eval(compile(tree, '<reviewed-condition>', 'eval'), {'__builtins__': {}}))


def stage(destination, foundation=None):
    # This tree contains only other workers' NEW independent sources and our
    # owned bindings. Never copy a bootstrap definition into our source tree.
    foundation = foundation or ROOT.parent / 'stdlib' / 'stdlib'
    if not (foundation / 'prelude/module.jai').is_file():
        raise SystemExit('The independent foundation bootstrap is not ready')
    shutil.copytree(foundation, destination, dirs_exist_ok=True)
    for worker, modules, internals in [
        ('numerics',['Math','Sloppy_Math','Float16','Color_Interpolation','GetRect','GetRect_LeftHanded'],['numerics']),
        ('compiler',['Compiler','Jai_Lexer','Code_Visit','Program_Print'],['compiler-api','jai-lexer','code-visit','program-print'])
    ]:
        source = ROOT.parent/worker/'stdlib'
        for name in modules:
            if (source/name/'module.jai').is_file():
                shutil.copytree(source/name,destination/name,dirs_exist_ok=True)
        for name in internals:
            if (source/'internal'/name).is_dir():
                shutil.copytree(source/'internal'/name,destination/'internal'/name,dirs_exist_ok=True)
    for module in MODULES:
        shutil.copytree(ROOT/'stdlib'/module, destination/module, dirs_exist_ok=True)
    shutil.copytree(ROOT/'stdlib/internal/bindings', destination/'internal/bindings', dirs_exist_ok=True)


def invoke(command, env, timeout=120):
    try:
        p = subprocess.run([str(x) for x in command], env=env, capture_output=True, text=True, timeout=timeout)
        return {'exit': p.returncode, 'stdout': p.stdout, 'stderr': p.stderr}
    except subprocess.TimeoutExpired as e:
        return {'exit': None, 'stdout': str(e.stdout or ''), 'stderr': 'Timeout after ' + str(timeout) + ' seconds'}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--compiler', type=Path, required=True)
    parser.add_argument('--module', action='append', choices=MODULES)
    parser.add_argument('--runtime', action='store_true')
    parser.add_argument('--report', type=Path, default=ROOT/'.work/verification.json')
    parser.add_argument('--foundation', type=Path, help='Explicit previously staged NEW independent foundation sources')
    args = parser.parse_args()
    compiler = args.compiler.resolve(strict=True)
    work = ROOT/'.work/runs'/(args.report.stem+'-'+str(os.getpid()))
    work.mkdir(parents=True, exist_ok=True)
    stdlib = work/'stdlib'
    stage(stdlib, args.foundation)
    env = dict(os.environ, JAIC_STDLIB=str(stdlib), JAIC_NATIVE_LIBS=str(ROOT/'.work/native'), TMPDIR=str(ROOT/'.work/tmp'))
    report = {'compiler': str(compiler), 'compiler_sha256': hashlib.sha256(compiler.read_bytes()).hexdigest(), 'staging_root': str(work),
              'targets': [], 'native': [], 'privacy': []}
    report['staged_sources'] = {str(p.relative_to(stdlib)):hashlib.sha256(p.read_bytes()).hexdigest()
                                for p in sorted(stdlib.rglob('*.jai')) if 'Extensions' not in p.parts}
    report['specs'] = {}
    report['symbols'] = []
    for module, slug in MODULES.items():
        if args.module and module not in args.module:
            continue
        spec = parse_spec((ROOT/'docs/specs/stdlib/modules'/f'{slug}.md').read_text())
        report['specs'][module] = hashlib.sha256((ROOT/'docs/specs/stdlib/modules'/f'{slug}.md').read_bytes()).hexdigest()
        if args.runtime and module in ('lz4','meshoptimizer','Curl','freetype','stb_image','stb_image_resize','stb_image_write','stb_vorbis','MojoShader'):
            report['symbols'].extend(check_symbols(module, spec, enabled, ROOT/'.work/native'))
        for os_name, cpu in TARGET_CONFIGS:
            file = work/'module-check.jai'
            file.write_text('#import "' + module + '"; main :: () {}\n')
            command = [compiler, file, '-check', '-no_dce', '-os', os_name, '-cpu', cpu]
            result = invoke(command, env)
            result.update(module=module, os=os_name, cpu=cpu, check='declarations')
            result['status'] = 'passed' if result['exit'] == 0 else 'unsupported' if 'requires its documented native platform' in result['stderr'] else 'failed'
            report['targets'].append(result)
            if result['status'] == 'passed':
                # Qualified aliases force lookup of required importer-visible
                # names. They do not promote helpers or make missing procedures
                # disappear behind DCE.
                names = sorted(set(d.name for d in spec.declarations if d.name != 'operator =='))
                lines = ['M :: #import "' + module + '";']
                for i, name in enumerate(names):
                    conditions = sorted(set(condition_for(module, d, spec) for d in spec.declarations if d.name == name))
                    if any(enabled(c, os_name, cpu) for c in conditions):
                        records = [d for d in spec.declarations if d.name == name]
                        is_variable = any(re.match(r'(?:using )?\w+\s*:(?!:)', d.code) for d in records)
                        expression = 'type_of(M.' + name + ')' if is_variable else 'M.' + name
                        lines.append('visible_' + str(i) + ' :: ' + expression + ';')
                lines.append('main :: () {}')
                file.write_text('\n'.join(lines))
                public_result = invoke(command, env)
                public_result.update(module=module, os=os_name, cpu=cpu, check='public_names',
                                     status='passed' if public_result['exit'] == 0 else 'failed')
                report['targets'].append(public_result)
            print(module, os_name+'-'+cpu, result['status'])
    for module, private in [('lz4', 'liblz4'), ('xxHash', 'binding_XXH32'), ('stb_image', 'FILE'),
                            ('Curl', 'Native'), ('Curl', 'Varargs'), ('dxc_compiler', 'IMalloc'),
                            ('MojoShader', 'MOJOSHADER_uniformType'), ('Objective_C', 'binding_objc_class')]:
        if args.module and module not in args.module:
            continue
        file = work/'privacy-check.jai'
        file.write_text('M :: #import "'+module+'"; leaked :: M.'+private+'; main :: () {}\n')
        result = invoke([compiler,file,'-check','-os','windows' if module=='dxc_compiler' else 'macos','-cpu','x64'], env)
        result.update(module=module, member=private)
        result['status'] = 'passed' if result['exit'] != 0 and ('has no exported member `'+private+'`') in result['stderr'] else 'failed'
        report['privacy'].append(result)
    if args.runtime:
        for name in ['lz4', 'xxhash', 'images', 'meshoptimizer', 'freetype', 'posix', 'curl', 'ios', 'objective-c', 'mojoshader']:
            relevant = {'xxhash': ['xxHash'], 'images': ['stb_image', 'stb_image_write', 'stb_image_resize', 'stb_vorbis'], 'posix': ['POSIX'], 'curl':['Curl'], 'ios':['iOS'], 'objective-c':['Objective_C'], 'mojoshader':['MojoShader']}.get(name, [name])
            if args.module and not any(m in args.module for m in relevant):
                continue
            source = ROOT/'tests/native-bindings'/f'{name}.jai'
            if not source.is_file():
                report['native'].append({'name': name, 'status': 'not_implemented'})
                continue
            exe = work/(name+'-test')
            result = invoke([compiler, source, '-exe', exe], env)
            result.update(name=name, phase='build', status='passed' if result['exit']==0 else 'failed')
            report['native'].append(result)
            if result['exit'] == 0:
                result = invoke([exe], env)
                result.update(name=name, phase='run', status='passed' if result['exit']==0 else 'failed')
                report['native'].append(result)
    args.report.write_text(json.dumps(report, indent=2)+'\n')
    failures = [x for category in ['targets','privacy','native','symbols'] for x in report[category] if x['status'] in ['failed','not_implemented','unavailable']]
    print(str(len(failures))+' failed or unimplemented checks; report: '+str(args.report))
    return 1 if failures else 0


if __name__ == '__main__':
    sys.exit(main())
