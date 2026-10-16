"""Check the three reviewed guard repairs without running the whole target matrix."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
MODULES = ("macOS", "nvidia_aftermath", "nvtt")
TARGETS = (
    ("linux", "x64"),
    ("linux", "arm64"),
    ("macos", "x64"),
    ("macos", "arm64"),
    ("windows", "x64"),
    ("windows", "arm64"),
    ("wasm", None),
)


def first_error(stderr):
    line = next(
        (line for line in stderr.splitlines() if "error: " in line), "no error message"
    )
    line = line.replace(str(ROOT / "stdlib") + "/", "")
    location, separator, message = line.partition(": error: ")
    return location.split(":")[0] + ": " + (message if separator else line)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compiler", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    compiler = args.compiler.resolve(strict=True)
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=False)
    manifest = ROOT / "tests/stdlib-targets.txt"
    expected = {}
    for line in manifest.read_text().splitlines():
        if line.startswith(tuple(module + " " for module in MODULES)):
            key, diagnostic = line.split(": ", 1)
            if key in expected:
                raise ValueError("duplicate expectation: " + key)
            expected[key] = diagnostic
    guarded = [manifest, compiler]
    # A dependency adoption must not masquerade as a single coherent source pin.
    # Fingerprinting sources does not expand the 21 executed module/target checks.
    guarded.extend(
        path
        for path in (ROOT / "stdlib").rglob("*.jai")
        if not any(part.startswith("._") for part in path.parts)
    )

    def digest(path):
        return hashlib.sha256(path.read_bytes()).hexdigest()

    before = {str(path): digest(path) for path in guarded}
    rows = []
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    for module in MODULES:
        source = output / (module + ".jai")
        source.write_text(f'#import "{module}";\nmain :: () {{}}\n')
        for target_os, cpu in TARGETS:
            target = target_os + ("-" + cpu if cpu else "")
            key = module + " " + target
            command = [
                str(compiler),
                str(source),
                "-check",
                "-no_dce",
                "-os",
                target_os,
            ]
            if cpu:
                command += ["-cpu", cpu]
            row = {
                "module": module,
                "target": target,
                "command": command,
                "kind": "required-negative" if key in expected else "required-positive",
            }
            try:
                result = subprocess.run(
                    command,
                    cwd=ROOT / "stdlib",
                    env=env,
                    capture_output=True,
                    text=True,
                    timeout=45,
                )
                actual = first_error(result.stderr) if result.returncode else None
                row.update(
                    code=result.returncode,
                    stdout=result.stdout,
                    stderr=result.stderr,
                    actual=actual,
                    expected=expected.get(key),
                    passed=(result.returncode != 0 and actual == expected[key])
                    if key in expected
                    else result.returncode == 0,
                )
            except subprocess.TimeoutExpired:
                row.update(code=None, passed=False, error="required check timed out")
            rows.append(row)
            (output / "results.json").write_text(json.dumps(rows, indent=2) + "\n")
    drift = [str(path) for path in guarded if digest(path) != before[str(path)]]
    (output / "source-guard.json").write_text(
        json.dumps({"before": before, "drift": drift}, indent=2) + "\n"
    )
    print(
        f"{sum(row['passed'] for row in rows)}/{len(rows)} required target checks; source drift={len(drift)}"
    )
    return int(bool(drift) or not all(row["passed"] for row in rows))


if __name__ == "__main__":
    raise SystemExit(main())
