#!/usr/bin/env python3
"""Validate canonical Runtime discard through the binding logger's real core.

Host sinks use actual raw descriptor writes. No Android SDK mock or device pass
is supplied. Only the authorized artifact and existing independent stage are
read; transitive dependency gaps remain failures, never fake locks.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil

from verify import ROOT, invoke, stage_for_checks, place_private_unit

EXPECTED_OUT = '4:Jai:payload\nsink-complete\nfresh-out\n6:tag:second\nsink-complete\n'
EXPECTED_ERR = 'fresh-error\n'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--compiler', type=Path, required=True)
    parser.add_argument('--jailint', type=Path, required=True)
    parser.add_argument('--existing-stdlib', type=Path, required=True)
    parser.add_argument('--report', type=Path, required=True)
    args = parser.parse_args()
    pin = json.loads((ROOT/'docs/native/android-logger-runtime-inputs.json').read_text())
    dependency = ROOT/pin['artifact_root']
    work = ROOT/'.work/runs'/('android-logger-discard-'+str(os.getpid()))
    stdlib = work/'stdlib'
    report = dict(scope='Actual host logger-core/Runtime buffer controls; not Android SDK/device execution',
                  runtime_commit=pin['supplied_commit'], work=str(work), checks=[], dependencies={})
    stage_for_checks(stdlib, args.existing_stdlib)
    for name, expected in pin['pinned_files'].items():
        source = dependency/name
        data = source.read_bytes()
        actual = hashlib.sha256(data).hexdigest()
        if actual != expected:
            raise SystemExit('Authorized Runtime dependency hash mismatch: '+name)
        target = stdlib/name
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(data)
        report['dependencies'][name] = actual
    for name in pin['required_transitive_files']:
        source = dependency/name
        if source.is_file():
            target = stdlib/name
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(source, target)
            report['dependencies'][name] = hashlib.sha256(source.read_bytes()).hexdigest()
        elif not (stdlib/name).is_file():
            report['checks'].append(dict(phase='dependency', status='missing_required_dependency', path=name))
    compiler = args.compiler.resolve(strict=True)
    report['compiler_sha256'] = hashlib.sha256(compiler.read_bytes()).hexdigest()
    source = place_private_unit('android-logger-output', ROOT/'tests/native-bindings/android-logger-output.jai',
                                stdlib, {})
    env = dict(os.environ, JAIC_STDLIB=str(stdlib), TMPDIR=str(ROOT/'.work/tmp'))
    env.setdefault('JAIC_NATIVE_LIBS', str(ROOT/'.work/native'))
    for target_os, cpu in [('macos','x64'), ('macos','arm64'), ('linux','x64'), ('linux','arm64')]:
        result = invoke([compiler, source, '-check', '-no_dce', '-os', target_os, '-cpu', cpu], env)
        result.update(phase='host-core-source', target=target_os+'-'+cpu,
                      status='passed' if result['exit'] == 0 else 'failed')
        report['checks'].append(result)
    for cpu in ('x64', 'arm64'):
        result = invoke([compiler, ROOT/'tests/native-bindings/android-helpers.jai',
                         '-check', '-no_dce', '-os', 'android', '-cpu', cpu], env)
        result.update(phase='required-Android-source', target='android-'+cpu,
                      status='passed' if result['exit'] == 0 else 'required_target_unverified')
        report['checks'].append(result)
    for mode in ('interpreter', 'native-O0', 'native-O2', 'native-sanitized'):
        exe = work/mode
        if mode == 'interpreter':
            command = [compiler, source, '-interp']
        else:
            options = ['-O2'] if mode == 'native-O2' else ['-O0']
            if mode == 'native-sanitized':
                options += ['-sanitize', 'address,undefined']
            build = invoke([compiler, source, *options, '-exe', exe], env)
            build.update(phase='host-build', mode=mode, status='passed' if build['exit'] == 0 else 'failed')
            report['checks'].append(build)
            if build['exit'] != 0:
                continue
            command = [exe]
        result = invoke(command, env)
        matched = result['exit'] == 0 and result['stdout'] == EXPECTED_OUT and result['stderr'] == EXPECTED_ERR
        result.update(phase='host-observable-output', mode=mode, status='passed' if matched else 'failed',
                      expected_stdout=EXPECTED_OUT, expected_stderr=EXPECTED_ERR)
        report['checks'].append(result)
    lint = invoke([args.jailint.resolve(strict=True), '-D', 'warnings', '--config', ROOT/'jailint.toml',
                   '--context', source, stdlib/'internal/bindings/android-log', source], env)
    lint.update(phase='strict-context-lint', status='passed' if lint['exit'] == 0 else 'failed')
    report['checks'].append(lint)
    report['staged_sources'] = {str(p.relative_to(stdlib)):hashlib.sha256(p.read_bytes()).hexdigest()
                                for p in sorted(stdlib.rglob('*.jai')) if 'Extensions' not in p.parts}
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2)+'\n')
    failures = sum(row['status'] != 'passed' for row in report['checks'])
    print(str(failures)+' failed/unverified dependency, source or host controls; '+str(args.report))
    return 1 if failures else 0


if __name__ == '__main__':
    raise SystemExit(main())
