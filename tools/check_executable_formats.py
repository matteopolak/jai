"""Run original object/container tests with source-built tools; no reference corpus."""
from pathlib import Path
import json
import os
import platform
import subprocess

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "target/executable-verification"
SOURCES = ["executable-objects", "executable-bitfields", "executable-relocations", "executable-archive"]


def run(command):
    return subprocess.run([str(part) for part in command], cwd=ROOT, capture_output=True, text=True, timeout=120)


def require(command, expected=None):
    result = run(command)
    if result.returncode or (expected is not None and (result.stdout != expected or result.stderr)):
        raise RuntimeError(f"{command!r}: {result.returncode}\n{result.stdout}{result.stderr}")
    return result


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    binaries = Path(os.environ["CARGO_TARGET_DIR"]) / "debug"
    compiler = binaries / "jaic"
    require(["python3", "tools/build_executable_fixtures.py"])
    require(["python3", "tools/build_portable_archive_fixtures.py"])
    report = dict(host=platform.platform(), compiler=str(compiler), native=[], cross_checks={})
    for name in SOURCES:
        source = ROOT / "tests/portable-stdlib" / (name + ".jai")
        expected = "ok\n"
        if name == "executable-relocations":
            expected = "COFF relocation rejected: invalid, unsupported or unresolved relocation\nok\n"
        require([compiler, "-interp", source], expected)
        for optimization in ["-O0", "-O2"]:
            executable = OUT / (name + optimization)
            require([compiler, source, optimization, "-exe", executable])
            require([executable], expected)
        report["native"].append(dict(source=name, interpreter="pass", O0="pass", O2="pass"))
    owned = sorted((ROOT / "stdlib/internal/executable").glob("*.jai"))
    require([binaries / "jailint", "-D", "warnings", ROOT / "stdlib/executable_formats/module.jai",
             *owned, *[ROOT / "tests/portable-stdlib" / (name + ".jai") for name in SOURCES]])
    require([ROOT / "target/jaifmt", "--check", ROOT / "stdlib/executable_formats/module.jai",
             *[path for path in owned if path.name != "archive.jai"],
             *[ROOT / "tests/portable-stdlib" / (name + ".jai") for name in SOURCES if name != "executable-archive"]])
    for target in ["linux", "windows"]:
        result = run([compiler, "-check", "-os", target, "-cpu", "x64", ROOT / "tests/portable-stdlib/executable-objects.jai"])
        report["cross_checks"][target] = dict(kind="type check only; no target execution", returncode=result.returncode,
                                             stdout=result.stdout, stderr=result.stderr)
    (OUT / "results.json").write_text(json.dumps(report, indent=2) + "\n")
    print("Object/archive tests: interpreter and native Mac O0/O2 pass; warnings-denied lint and formatting pass.")
    for target, result in report["cross_checks"].items():
        print(f"{target} x64 cross type check: {'pass' if result['returncode'] == 0 else 'blocked (see results.json)'}; not executed")


if __name__ == "__main__":
    main()
