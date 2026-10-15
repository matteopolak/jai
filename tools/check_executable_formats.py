"""Run original object/container tests with source-built tools; no reference corpus."""
from pathlib import Path
import json
import os
import platform
import re
import subprocess

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "target/executable-verification"
SOURCES = ["executable-objects", "executable-bitfields", "executable-relocations", "executable-archive",
           "executable-lexer", "executable-lexer-errors", "executable-tbd", "executable-tbd-errors"]


def run(command):
    return subprocess.run([str(part) for part in command], cwd=ROOT, capture_output=True, text=True, timeout=120)


def require(command, expected=None):
    result = run(command)
    if result.returncode or (expected is not None and (result.stdout != expected or result.stderr)):
        raise RuntimeError(f"{command!r}: {result.returncode}\n{result.stdout}{result.stderr}")
    return result


def verify_tapi_symbols():
    fixtures = ROOT / "target/executable-text-fixtures"
    for label in ["original-v4", "original-v3", "sdk-objc", "sdk-system"]:
        oracle = {}
        architecture = None
        for line in (fixtures / (label + "-symbols.txt")).read_text().splitlines():
            match = re.search(r"\(for architecture ([^)]+)\):$", line)
            if match:
                architecture = match[1]
                oracle.setdefault(architecture, set())
            elif line.strip():
                assert architecture is not None
                oracle[architecture].add(line.strip())
        parsed = {}
        for line in (fixtures / (label + "-parsed-symbols.txt")).read_text().splitlines():
            target, symbol = line.split("|", 1)
            parsed.setdefault(target.split("-", 1)[0], set()).add(symbol)
        if parsed != oracle:
            differences = {arch: dict(missing=sorted(oracle.get(arch, set()) - parsed.get(arch, set())),
                                      extra=sorted(parsed.get(arch, set()) - oracle.get(arch, set())))
                           for arch in parsed.keys() | oracle.keys() if parsed.get(arch) != oracle.get(arch)}
            raise RuntimeError(f"Public TBD symbols disagree with Apple tapi for {label}: {differences}")


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    binaries = Path(os.environ["CARGO_TARGET_DIR"]) / "debug"
    compiler = binaries / "jaic"
    require(["python3", "tools/build_executable_fixtures.py"])
    require(["python3", "tools/build_portable_archive_fixtures.py"])
    require(["python3", "tools/build_executable_text_fixtures.py"])
    report = dict(host=platform.platform(), compiler=str(compiler), native=[], cross_checks={})
    for name in SOURCES:
        source = ROOT / "tests/portable-stdlib" / (name + ".jai")
        expected = "ok\n"
        if name == "executable-relocations":
            expected = "COFF relocation rejected: invalid, unsupported or unresolved relocation\nok\n"
        if name.endswith("-errors"):
            interpreted = require([compiler, "-interp", source])
            if interpreted.stderr or not interpreted.stdout.endswith("ok\n"):
                raise RuntimeError(interpreted.stdout + interpreted.stderr)
            diagnostics = interpreted.stdout.splitlines()[:-1]
            if name == "executable-lexer-errors":
                if len(diagnostics) != 16 or not all(re.fullmatch(r"lexer:\d+:\d+: (error|detail): .+", line) for line in diagnostics):
                    raise RuntimeError("Unexpected lexer diagnostics: " + interpreted.stdout)
            else:
                if len(diagnostics) < 100 or not all(re.fullmatch(r"TBD negative: (no documents|invalid UTF-8 input|invalid or unsupported input at byte \d+)|lexer:1:1: error: unterminated string", line) for line in diagnostics):
                    raise RuntimeError("Unexpected TBD diagnostics: " + interpreted.stdout)
            expected = interpreted.stdout
            (OUT / (name + "-diagnostics.txt")).write_text(expected)
        else:
            require([compiler, "-interp", source], expected)
        if name == "executable-tbd":
            verify_tapi_symbols()
        for optimization in ["-O0", "-O2"]:
            executable = OUT / (name + optimization)
            require([compiler, source, optimization, "-exe", executable])
            require([executable], expected)
            if name == "executable-tbd":
                verify_tapi_symbols()
        report["native"].append(dict(source=name, interpreter="pass", O0="pass", O2="pass"))
    owned = sorted((ROOT / "stdlib/internal/executable").glob("*.jai"))
    require([binaries / "jailint", "-D", "warnings", ROOT / "stdlib/executable_formats/module.jai",
             *owned, *[ROOT / "tests/portable-stdlib" / (name + ".jai") for name in SOURCES]])
    require([ROOT / "target/jaifmt", "--check", ROOT / "stdlib/executable_formats/module.jai",
             *[path for path in owned if path.name != "archive.jai"],
             *[ROOT / "tests/portable-stdlib" / (name + ".jai") for name in SOURCES if name != "executable-archive"]])
    for target in ["linux", "windows"]:
        checks = []
        for source_name in ["executable-objects", "executable-lexer", "executable-lexer-errors", "executable-tbd", "executable-tbd-errors"]:
            result = run([compiler, "-check", "-os", target, "-cpu", "x64", ROOT / "tests/portable-stdlib" / (source_name + ".jai")])
            checks.append(dict(source=source_name, returncode=result.returncode, stdout=result.stdout, stderr=result.stderr))
        report["cross_checks"][target] = dict(kind="type check only; no target execution",
                                             returncode=next((check["returncode"] for check in checks if check["returncode"]), 0), checks=checks)
    (OUT / "results.json").write_text(json.dumps(report, indent=2) + "\n")
    print("Executable-format tests: interpreter and native Mac O0/O2 pass, including lexer/TBD; warnings-denied lint and formatting pass.")
    for target, result in report["cross_checks"].items():
        print(f"{target} x64 cross type check: {'pass' if result['returncode'] == 0 else 'blocked (see results.json)'}; not executed")


if __name__ == "__main__":
    main()
