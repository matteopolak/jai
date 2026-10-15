#!/usr/bin/env python3
"""Exercise real Pool/Thread sources without library copies or default edits."""
import hashlib
import os
from pathlib import Path
import platform
import subprocess

ROOT = Path(__file__).resolve().parents[1]
JAIC = ROOT / "target/debug/jaic"
ENV = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
OUTPUT = ROOT / "target/integrated-lifecycles"


def checked(command, expected="ok\n"):
    result = subprocess.run(list(map(str, command)), cwd=ROOT, env=ENV,
                            capture_output=True, text=True, timeout=120)
    if result.returncode or result.stdout != expected or result.stderr:
        raise RuntimeError(f"{command!r}: exit={result.returncode}\n{result.stdout}{result.stderr}")


def fingerprints():
    return {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest()
            for p in (ROOT / "stdlib").rglob("*.jai")}


def main():
    OUTPUT.mkdir(parents=True, exist_ok=True)
    before = fingerprints()
    host = "arm64" if platform.machine().lower() in {"arm64", "aarch64"} else "x64"
    targets = [host]
    if platform.system() == "Darwin" and host == "arm64":
        targets.append("x64")
    cases = ["pool-value-lifetime", "basic-leak-reports", "pool-unmapping", "pool-size-limits"]
    executions = 0
    for case in cases:
        source = ROOT / "tests/portable-stdlib" / (case + ".jai")
        checked([JAIC, "-interp", source])
        executions += 1
        for cpu in targets:
            for mode in ["O0", "O2"]:
                executable = OUTPUT / (case + "-" + cpu + "-" + mode)
                target = ["-target", "x86_64-apple-darwin"] if platform.system() == "Darwin" and cpu == "x64" else ["-cpu", cpu]
                checked([JAIC, source, *target, "-" + mode, "-exe", executable], "")
                checked([executable])
                executions += 1
        print(f"PASS {case}: interpreter and {targets} native O0/O2", flush=True)

    context = ROOT / "tests/portable-stdlib/thread-configured/production-context.jai"
    cases = [ROOT / "tests/portable-stdlib/thread-configured" / (name + ".jai")
             for name in ["optional-assert", "error-retention"]]
    cases.append(ROOT / "tests/audio/dependencies/thread-no-assert.jai")
    for setting in ["enabled", "disabled"]:
        for source in cases:
            expected = "semaphore-after-init-signal: SUCCESS\n" if source.stem == "thread-no-assert" else "ok\n"
            executable = OUTPUT / (setting + "-" + source.stem)
            checked([JAIC, "-interp", context, "-", setting, source, executable, "interp", host], expected)
            executions += 1
            for cpu in targets:
                for mode in ["O0", "O2"]:
                    checked([JAIC, "-interp", context, "-", setting, source, executable, mode, cpu], "")
                    checked([executable], expected)
                    executions += 1
            print(f"PASS Thread {setting} {source.name}: interpreter and {targets} native O0/O2", flush=True)

    if fingerprints() != before:
        raise RuntimeError("production library source changed during verification")
    print(f"PASS {executions} lifecycle executions; production Jai sources unchanged; no overlay or default edits")


if __name__ == "__main__":
    main()
