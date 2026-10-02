#!/usr/bin/env python3
"""Bounded native reference probes, permitted only on GitHub-hosted ARM64 macOS."""
import hashlib
import json
import os
from pathlib import Path
import platform
import resource
import signal
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
EXPECTED = 'a76ba6e153838a81e3ed4edbcc4ec42ad86c333cdeaf4053fdc592ed0b61600e'
EXPECTED_PRELOAD = '1d00c2ecde58c5362c8e2edf978d57eb490a39076eb6ebf7d118a9811a851904'


def hosted_native(environment, system, machine):
    return (environment.get('GITHUB_ACTIONS') == 'true'
            and environment.get('RUNNER_ENVIRONMENT') == 'github-hosted'
            and system == 'Darwin' and machine == 'arm64')


def limits():
    resource.setrlimit(resource.RLIMIT_CPU, (10, 10))
    resource.setrlimit(resource.RLIMIT_FSIZE, (2 * 1024 * 1024, 2 * 1024 * 1024))
    resource.setrlimit(resource.RLIMIT_NOFILE, (128, 128))
    resource.setrlimit(resource.RLIMIT_CORE, (0, 0))


def main():
    if not hosted_native(os.environ, platform.system(), platform.machine()):
        raise SystemExit('Reference execution refused outside a GitHub-hosted ARM64 macOS runner')
    binary = (ROOT / 'reference/bin/jai-macos').resolve(strict=True)
    with binary.open('rb') as stream:
        actual = hashlib.file_digest(stream, 'sha256').hexdigest()
    if actual != EXPECTED:
        raise SystemExit('Reference execution refused: binary identity mismatch')
    preload = (ROOT / 'reference/modules/Preload.jai').resolve(strict=True)
    with preload.open('rb') as stream:
        preload_hash = hashlib.file_digest(stream, 'sha256').hexdigest()
    if preload_hash != EXPECTED_PRELOAD:
        raise SystemExit('Reference execution refused: bootstrap identity mismatch')
    output = ROOT / 'artifacts/probe'
    output.mkdir(parents=True, exist_ok=True)
    report = {'binary_sha256': actual, 'preload_sha256': preload_hash, 'platform': platform.platform(),
              'architecture': platform.machine(), 'executed_reference_code': True,
              'limits': {'wall_seconds': 15, 'cpu_seconds': 10, 'output_bytes_per_stream': 2 * 1024 * 1024},
              'scope': 'developer help only; the inspected Preload bootstrap may be parsed; no supplied libraries or generated programs are run',
              'assessment': 'observational evidence only; not certified harmless', 'probes': []}
    with tempfile.TemporaryDirectory(prefix='jai-probe-') as temp:
        scratch = Path(temp).resolve()
        # Profile paths are escaped as string literals, not evaluated as source.
        profile = f'''(version 1)
(deny default)
(allow process-exec (literal {json.dumps(str(binary))}))
(allow sysctl-read)
(allow mach-lookup)
(allow file-read*
    (literal "/")
    (literal {json.dumps(str(binary))})
    (literal {json.dumps(str(preload))})
    (subpath "/System") (subpath "/usr/lib") (subpath "/Library/Apple")
    (literal "/dev/null") (literal "/dev/urandom") (literal "/dev/random")
    (subpath {json.dumps(str(scratch))}))
(allow file-write* (subpath {json.dumps(str(scratch))}))
'''
        (output / 'sandbox.sb').write_text(profile)
        control_profile = profile.replace(json.dumps(str(binary)), '"/usr/bin/printf"')
        with tempfile.TemporaryFile(dir=scratch) as control_output:
            control = subprocess.run(['/usr/bin/sandbox-exec', '-p', control_profile,
                                      '/usr/bin/printf', 'sandbox-control-ok'], cwd=scratch,
                env={'PATH': '/usr/bin:/bin', 'HOME': str(scratch), 'TMPDIR': str(scratch)},
                stdin=subprocess.DEVNULL, stdout=control_output, stderr=control_output,
                timeout=15, preexec_fn=limits)
            control_output.seek(0)
            report['trusted_control'] = {'returncode': control.returncode,
                                       'output': control_output.read(1024).decode('utf-8', errors='replace')}
        if control.returncode != 0 or report['trusted_control']['output'] != 'sandbox-control-ok':
            report['executed_reference_code'] = False
            (output / 'report.json').write_text(json.dumps(report, indent=2) + '\n')
            raise SystemExit('Sandbox control failed; reference execution refused')
        binary.chmod(0o500)
        for arguments in (('--', 'help'),):
            with tempfile.TemporaryFile(dir=scratch) as stdout, tempfile.TemporaryFile(dir=scratch) as stderr:
                process = subprocess.Popen(['/usr/bin/sandbox-exec', '-p', profile, str(binary), *arguments],
                    cwd=scratch, env={'PATH': '/usr/bin:/bin', 'HOME': str(scratch), 'TMPDIR': str(scratch)},
                    stdin=subprocess.DEVNULL, stdout=stdout, stderr=stderr,
                    start_new_session=True, preexec_fn=limits)
                timed_out = False
                try:
                    process.wait(timeout=15)
                except subprocess.TimeoutExpired:
                    timed_out = True
                    os.killpg(process.pid, signal.SIGKILL)
                    process.wait()
                stdout.seek(0); stderr.seek(0)
                result = {'arguments': list(arguments), 'returncode': process.returncode, 'timed_out': timed_out,
                          'stdout': stdout.read(2 * 1024 * 1024).decode('utf-8', errors='replace'),
                          'stderr': stderr.read(2 * 1024 * 1024).decode('utf-8', errors='replace')}
                report['probes'].append(result)
                (output / 'report.json').write_text(json.dumps(report, indent=2) + '\n')
                print(f'{" ".join(arguments)}: exit={process.returncode}, timed_out={timed_out}')
        report['scratch_files'] = sorted(str(p.relative_to(scratch)) for p in scratch.rglob('*') if p.is_file())
        (output / 'report.json').write_text(json.dumps(report, indent=2) + '\n')
    if any(p['timed_out'] or p['returncode'] != 0 for p in report['probes']):
        raise SystemExit('Reference probe did not pass; inspect retained evidence')


if __name__ == '__main__':
    main()
