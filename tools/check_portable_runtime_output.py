#!/usr/bin/env python3
"""Real host byte sinks verify Runtime discard and unchanged ordinary output."""
import os
from pathlib import Path
import shutil
import subprocess
import check_portable_time_foundation as foundation

ROOT = Path(__file__).resolve().parents[1]


def main():
    foundation.compose()
    library = foundation.LIBRARY
    for relative in ["Runtime_Support", "internal/runtime"]:
        shutil.copytree(ROOT / "stdlib" / relative, library / relative, dirs_exist_ok=True)
    env = dict(os.environ, JAIC_STDLIB=str(library))
    binaries = Path(os.environ["CARGO_TARGET_DIR"]) / "debug"
    compiler = str(binaries / "jaic")
    output = ROOT / "target/portable-runtime-output"
    output.mkdir(parents=True, exist_ok=True)
    original = ROOT / "tests/portable-stdlib/runtime-output-discard/main.jai"
    test_module = library / "Runtime_Output_Test/module.jai"
    test_module.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(original, test_module)
    if test_module.read_bytes() != original.read_bytes():
        raise RuntimeError("private Runtime fixture must be byte-identical")
    # A test-only library module exercises its private dependency through normal
    # module privacy. The external program only invokes the test's entry point.
    source = output / "main.jai"
    source.write_text('Test :: #import "Runtime_Output_Test";\nmain :: () { Test.main(); }\n')
    for mode in [[], ["--check"]]:
        subprocess.run([str(ROOT / "target/jaifmt"), "--config", str(ROOT / "jaifmt.toml"),
                        *mode, str(source), str(test_module)], check=True)
    if test_module.read_bytes() != original.read_bytes():
        raise RuntimeError("private Runtime fixture formatting changed its authoritative bytes")
    commands = [[compiler, "-interp", str(source)]]
    for mode in ["-O0", "-O2"]:
        executable = output / ("discard" + mode)
        subprocess.run([compiler, str(source), mode, "-exe", str(executable)], env=env, check=True)
        commands.append([str(executable)])
    expected = "desktop immediate\nretained line\npartial done\n" + "A" * 8192 + "\nend\n"
    for command in commands:
        result = subprocess.run(command, env=env, capture_output=True, text=True, timeout=60)
        if result.returncode or result.stdout != expected or result.stderr != "stderr line\n":
            raise RuntimeError(f"{command!r}: status={result.returncode}, stdout length={len(result.stdout)}, stderr={result.stderr!r}")
    subprocess.run([str(binaries / "jailint"), "-D", "warnings",
                    str(library / "Runtime_Support/module.jai"),
                    str(library / "internal/runtime/module.jai"),
                    str(library / "internal/runtime/output-lock"),
                    str(library / "internal/runtime/android-output"), str(test_module), str(source)], env=env, check=True)
    print("Runtime pending-output discard: actual stdout/stderr suppression, partial/line/forced/capacity flush, unchanged desktop writes pass interpreter/native O0/O2 and strict lint; Android SDK/device execution pending")


if __name__ == "__main__":
    main()
