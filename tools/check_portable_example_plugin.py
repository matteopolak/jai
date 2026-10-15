#!/usr/bin/env python3
"""Example_Plugin reviewed record/options/callbacks and actual default build usage."""
import os
from pathlib import Path
import shutil
import subprocess
from check_portable_default_metaprogram import compose, ROOT, CASE, OUTPUT


def main():
    library = compose()
    shutil.copytree(ROOT / "stdlib/Example_Plugin", library / "Example_Plugin", dirs_exist_ok=True)
    OUTPUT.mkdir(parents=True, exist_ok=True)
    binaries = Path(os.environ["CARGO_TARGET_DIR"]) / "debug"
    compiler = str(binaries / "jaic")
    env = dict(os.environ, JAIC_STDLIB=str(library))
    fixture = ROOT / "tests/portable-stdlib/example-plugin/main.jai"

    def run(command, cwd=ROOT):
        result = subprocess.run(command, cwd=cwd, env=env, capture_output=True, text=True, timeout=90)
        if result.returncode or result.stderr:
            raise RuntimeError(f"{command!r}\n{result.stdout}{result.stderr}")
        return result.stdout

    expected = run([compiler, "-interp", str(fixture)])
    assert "observed 3 messages" in expected and "test-program" in expected
    assert expected.endswith("ok\n")
    for optimization in ["-O0", "-O2"]:
        program = OUTPUT / ("example-plugin" + optimization)
        run([compiler, str(fixture), optimization, "-exe", str(program)])
        assert run([str(program)]) == expected
        target = OUTPUT / ("example-target" + optimization)
        target_optimization = "-very_debug" if optimization == "-O0" else "-od"
        text = run([compiler, str(CASE / "build.jai"), optimization, "-add", "#run,stallable run_build();", "-", target_optimization, "-no_check", "target.jai",
                    "-exe", target.name, "-output_path", str(OUTPUT),
                    "+Example_Plugin", "-option", "hello"], cwd=CASE)
        assert "Example_Plugin option: hello" in text
        assert "Example_Plugin executable:" in text
        assert "Example_Plugin complete:" in text
        assert "Example_Plugin: observed " in text
        assert text.endswith("Example_Plugin: releasing plugin.\n")
        assert run([str(target)]) == "target ok\n"
    subprocess.run([str(binaries / "jailint"), "-D", "warnings",
                    str(library / "Example_Plugin"), str(fixture)], env=env, cwd=ROOT, check=True)
    print("Example_Plugin public record/options/callbacks: interpreter and native O0/O2; actual compiler workspace builds/plugin shutdown and strict lint pass")


if __name__ == "__main__":
    main()
