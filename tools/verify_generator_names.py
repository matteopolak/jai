"""Verify only the independently implemented generator naming subset."""

import json
import os
from pathlib import Path
import subprocess


def main():
    root = Path(__file__).resolve().parents[1]
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    artifacts = target / "generator-names-verification"
    artifacts.mkdir(parents=True, exist_ok=True)
    env = dict(os.environ, CARGO_BUILD_JOBS="2", JAIC_STDLIB=str(root / "stdlib"))
    jaic = str(target / "debug/jaic")
    jailint = str(target / "debug/jailint")
    formatter = str(artifacts / "jaifmt")
    fixture = "tests/generator-names/selector.jai"
    sources = [
        "stdlib/Bindings_Generator/naming-helpers.jai",
        "stdlib/internal/developer-tools/generator-names-private.jai",
        fixture,
    ]
    results = []

    def run(name, kind, command):
        completed = subprocess.run(
            command, cwd=root, env=env, capture_output=True, text=True, timeout=180
        )
        output = completed.stdout + completed.stderr
        (artifacts / f"{name}.log").write_text(output)
        results.append(
            dict(name=name, kind=kind, command=command, exit_code=completed.returncode)
        )
        print(f"{name}: exit {completed.returncode}", flush=True)
        if completed.returncode:
            print(output, flush=True)
        (artifacts / "results.json").write_text(json.dumps(results, indent=2) + "\n")
        return completed.returncode == 0

    if not run("build-tools", "build", ["cargo", "build", "-p", "jaic-cli", "-p", "jailint"]):
        return 1
    if not run("build-formatter", "build", [jaic, "jaifmt/main.jai", "-O2", "-exe", formatter]):
        return 1
    run("format", "format", [formatter, "--check", *sources])
    run("interpreter", "execution", [jaic, fixture, "-interp"])
    for optimization in ("O0", "O2"):
        binary = str(artifacts / f"selector-{optimization}")
        if run(f"mac-arm64-{optimization}-build", "native-build", [jaic, fixture, f"-{optimization}", "-exe", binary]):
            run(f"mac-arm64-{optimization}-run", "execution", [binary])
    for os_name, cpu in (("macos", "arm64"), ("macos", "x64"), ("linux", "x64"), ("windows", "x64"), ("windows", "arm64")):
        flags = ["-os", os_name, "-cpu", cpu]
        run(f"{os_name}-{cpu}-check", "source-only", [jaic, fixture, "-check", *flags])
        run(f"{os_name}-{cpu}-lint", "source-only-lint", [jailint, *flags, "-D", "warnings", "--context", fixture, *sources])
    return int(any(result["exit_code"] for result in results))


if __name__ == "__main__":
    raise SystemExit(main())
