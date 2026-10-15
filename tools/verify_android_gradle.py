"""Verify integrated Gradle orchestration; fixture installs deliberately fail."""

import json
import os
from pathlib import Path
import subprocess


def main():
    root = Path(__file__).resolve().parents[1]
    target = Path(os.environ["CARGO_TARGET_DIR"])
    output = target / "android-gradle-verification"
    output.mkdir(parents=True, exist_ok=True)
    env = dict(os.environ, CARGO_BUILD_JOBS="2", JAIC_STDLIB=str(root / "stdlib"))
    compiler = str(target / "debug/jaic")
    linter = str(target / "debug/jailint")
    formatter = str(output / "jaifmt")
    fixture = "tests/android-project/gradle.jai"
    sources = [
        "stdlib/Android/Toolchain/gradle-api.jai",
        "stdlib/internal/android-toolchain/android-gradle.jai",
        fixture,
    ]
    results = []

    def run(name, kind, command):
        result = subprocess.run(command, cwd=root, env=env, capture_output=True,
                                text=True, timeout=180)
        (output / f"{name}.log").write_text(result.stdout + result.stderr)
        results.append(dict(name=name, kind=kind, command=command, exit_code=result.returncode))
        (output / "results.json").write_text(json.dumps(results, indent=2) + "\n")
        print(f"{name}: {result.returncode}", flush=True)
        if result.returncode:
            print(result.stdout + result.stderr, flush=True)
        return result.returncode == 0

    if not run("build-tools", "source-build", ["cargo", "build", "-p", "jaic-cli", "-p", "jailint"]):
        return 1
    if not run("build-formatter", "source-build", [compiler, "jaifmt/main.jai", "-O2", "-exe", formatter]):
        return 1
    run("format", "format", [formatter, "--check", *sources])
    run("interpreter", "execution", [compiler, fixture, "-interp"])
    for optimization in ("O0", "O2"):
        binary = str(output / f"gradle-{optimization}")
        if run(f"native-{optimization}-build", "native-build", [compiler, fixture, f"-{optimization}", "-exe", binary]):
            run(f"native-{optimization}-run", "execution", [binary])
    for os_name, cpu in (("macos", "arm64"), ("macos", "x64"), ("linux", "x64"),
                         ("windows", "x64"), ("windows", "arm64")):
        target_args = ["-os", os_name, "-cpu", cpu]
        run(f"{os_name}-{cpu}-check", "source-only", [compiler, fixture, "-check", *target_args])
        run(f"{os_name}-{cpu}-lint", "source-only-lint",
            [linter, *target_args, "-D", "warnings", "--context", fixture, *sources])
    return int(any(result["exit_code"] for result in results))


if __name__ == "__main__":
    raise SystemExit(main())
