"""Verify independent binary Android manifests without SDK/device tools."""
import json
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
TARGET = Path(os.environ["CARGO_TARGET_DIR"])
FILES = ["stdlib/Android/Toolchain/manifest-types.jai", "stdlib/Android/Toolchain/manifest-api.jai",
         "stdlib/internal/android-toolchain/android-manifest.jai",
         "stdlib/internal/android-toolchain/android-manifest-writer.jai",
         "stdlib/internal/android-toolchain/android-manifest-inflate.jai",
         "tests/android-project/manifest.jai", "tests/android-project/fixtures/embedded.jai"]


def main():
    source = "tests/android-project/manifest.jai"
    output = TARGET / "android-manifest-verification"
    output.mkdir(exist_ok=True)
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"), CARGO_BUILD_JOBS="2")
    compiler = str(TARGET / "debug/jaic")
    lint = str(TARGET / "debug/jailint")
    formatter = str(TARGET / "generator-names-verification/jaifmt")
    results = []

    def run(label, kind, command):
        result = subprocess.run(command, cwd=ROOT, env=env, text=True, capture_output=True, timeout=120)
        (output / f"{label}.log").write_text(result.stdout + result.stderr)
        results.append(dict(name=label, kind=kind, command=command, exit_code=result.returncode))
        (output / "results.json").write_text(json.dumps(results, indent=2) + "\n")
        print(f"{label}: {result.returncode}", flush=True)
        if result.returncode:
            print(result.stdout + result.stderr)
        return result.returncode == 0

    run("format", "format", [formatter, "--check", *FILES])
    run("interpreter", "execution", [compiler, source, "-interp"])
    for optimization in ["O0", "O2"]:
        executable = str(output / optimization)
        if run(f"{optimization}-build", "native-build", [compiler, source, f"-{optimization}", "-exe", executable]):
            run(f"{optimization}-run", "execution", [executable])
    for system, cpu in [("macos", "arm64"), ("macos", "x64"), ("linux", "x64"), ("windows", "x64"), ("windows", "arm64")]:
        flags = ["-os", system, "-cpu", cpu]
        run(f"{system}-{cpu}-check", "source-only", [compiler, source, "-check", *flags])
        run(f"{system}-{cpu}-lint", "source-only-lint", [lint, *flags, "-D", "warnings", "--context", source, *FILES])
    (ROOT / "tests/android-project/independent.axml").unlink(missing_ok=True)
    return int(any(r["exit_code"] for r in results))


if __name__ == "__main__":
    raise SystemExit(main())
