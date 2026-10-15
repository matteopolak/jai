#!/usr/bin/env python3
"""Reviewed default build contract; real compiler workspaces and target artifacts.

Uses the committed production library; no peer reads, overlays or source repair.
"""
import os
from pathlib import Path
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[1]
CASE = ROOT / "tests/portable-stdlib/default-metaprogram"
OUTPUT = ROOT / "target/portable-default-metaprogram"
OWNED = ["Default_Metaprogram", "internal/build"]


OPTIMIZATIONS = ["-" + value for value in os.environ.get("JAIC_TEST_OPTIMIZATIONS", "O0,O2").split(",")]
if not OPTIMIZATIONS or any(value not in {"-O0", "-O2"} for value in OPTIMIZATIONS) or len(set(OPTIMIZATIONS)) != len(OPTIMIZATIONS):
    raise ValueError("JAIC_TEST_OPTIMIZATIONS must select O0 and/or O2 once each")


def compose():
    library = ROOT / "stdlib"
    if not (library / "prelude/module.jai").is_file():
        raise RuntimeError("production canonical prelude is missing")
    return library


def main():
    OUTPUT.mkdir(parents=True, exist_ok=True)
    library = compose()
    compiler_root = Path(os.environ["CARGO_TARGET_DIR"]) / "debug"
    compiler = str(compiler_root / "jaic")
    env = dict(os.environ, JAIC_STDLIB=str(library))

    def run(arguments, status=0, contains=None):
        result = subprocess.run(arguments, cwd=CASE, env=env, capture_output=True,
                                text=True, timeout=90)
        text = result.stdout + result.stderr
        if result.returncode != status or (contains is not None and contains not in text):
            raise RuntimeError(f"{arguments!r}\nstatus={result.returncode}\n{text}")
        return text

    path_case = CASE / "paths.jai"
    assert run([compiler, "-interp", str(path_case)]) == "ok\n"
    for optimization in OPTIMIZATIONS:
        executable = OUTPUT / ("paths" + optimization)
        run([compiler, str(path_case), optimization, "-exe", str(executable)])
        assert run([str(executable)]) == "ok\n"

    def build(arguments, status=0, contains=None, optimization="-O0"):
        return run([compiler, str(CASE / "build.jai"), optimization, "-", *arguments], status, contains)

    target = OUTPUT / "target-program"
    common = ["-no_check", "target.jai", "-exe", target.name,
              "-output_path", str(OUTPUT)]
    for optimization in OPTIMIZATIONS:
        build(common, optimization=optimization)
        assert run([str(target)]) == "target ok\n"
    inferred_source = OUTPUT / "inferred.jai"
    shutil.copyfile(CASE / "target.jai", inferred_source)
    build(["-no_check", str(inferred_source)])
    assert run([str(OUTPUT / "inferred")]) == "target ok\n"
    build(["-no_check", "import-target.jai", "-import_dir", "dependency-modules",
           "-exe", target.name, "-output_path", str(OUTPUT)])
    assert run([str(target)]) == "import ok\n"
    build(["-no_check", "-help"], contains="Default build:")
    build(["-no_check", "-?"], contains="Default build:")
    build(["-no_check", "-version"], contains="jaic")
    build(["-no_check"], status=1, contains="Provide a source file")
    build(["-no_check", "-unknown"], status=1, contains="Unknown option")
    build(["-no_check", "-exe"], status=1, contains="Missing value")
    build(["-no_check", "invalid-target.jai", "-exe", "invalid", "-output_path", str(OUTPUT)],
          status=1, contains="missing_target_procedure")
    build(["-no_check", "-help", "+Workflow_Probe", "-fail"], contains="Plugin initialization failed")
    build(["-no_check", "-help", "+Workflow_Probe", "value"], contains="help A")

    callbacks = ("init A 2\ninit B 1\nprepare A\nprepare B\nsource A\nsource B\n"
                 "complete A\ncomplete B\nfinish A\nfinish B\nshutdown A\nshutdown B\n")
    flags = ["-o", "-no_inline", "-no_dce", "-no_split", "-no_color", "-msvc_format",
             "-debug_for", "-quiet", "-no_backtrace_on_crash", "-context_size", "8192"]
    build([*common, "-natvis"], status=1, contains="Natvis-compatible type emission is unavailable")
    plugin_args = ["+Workflow_Probe", "-options", "value", '+Workflow_Probe(TAG="B")',
                   "value", "-", "first", "-literal"]
    for optimization in OPTIMIZATIONS:
        assert build([*common, *flags, *plugin_args], optimization=optimization) == callbacks
        assert run([str(target)]) == "target ok\n"
    replay = run([compiler, str(CASE / "build-twice.jai"), "-", *common,
                  "+Workflow_Probe", "value"])
    single = "init A 1\nprepare A\nsource A\ncomplete A\nfinish A\nshutdown A\n"
    assert replay == single * 2
    build([*common, "-context_size", "invalid"], contains="Ignoring invalid context size")
    for alias in ["-release", "-release_debug"]:
        warning = build([*common, alias])
        assert warning.count("is deprecated;") == 1, warning
    build(["-no_check", "-add", 'main :: () {}', "-exe", "added", "-output_path", str(OUTPUT)])
    build(["-no_check", "-run", 'print("run ok\\n")', "-add", 'using #import "Basic"',
           "-add", 'main :: () {}', "-exe", "run-added", "-output_path", str(OUTPUT)], contains="run ok")
    print(f"Default_Metaprogram behavior cases pass interpreter/native {OPTIMIZATIONS}; required strict lint follows", flush=True)
    subprocess.run([str(compiler_root / "jailint"), "-D", "warnings", "-I", str(CASE / "dependency-modules"),
                    str(library / "Default_Metaprogram"),
                    *[str(library / "internal/build" / name) for name in
                      ["default-options.jai", "default-workspace.jai", "default-plugins.jai"]],
                    *[str(CASE / name) for name in ["paths.jai", "build.jai", "build-twice.jai", "target.jai", "import-target.jai"]],
                    str(CASE / "modules/Workflow_Probe/module.jai")], env=env, cwd=ROOT, check=True)


if __name__ == "__main__":
    main()
