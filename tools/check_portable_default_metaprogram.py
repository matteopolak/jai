#!/usr/bin/env python3
"""Reviewed default build contract; real compiler workspaces and target artifacts.

No peer writes. Dependency composition is a staging check, not combined integration.
"""
import os
from pathlib import Path
import shutil
import subprocess
import check_portable_time_foundation as foundation
from portable_file_stage import compose_into as compose_file

ROOT = Path(__file__).resolve().parents[1]
CASE = ROOT / "tests/portable-stdlib/default-metaprogram"
OUTPUT = ROOT / "target/portable-default-metaprogram"
OWNED = ["Default_Metaprogram", "internal/build"]


def compose():
    foundation.compose()
    library = foundation.LIBRARY
    # File facade and its backend are one producer closure. Foundation's
    # File_Utilities filesystem helpers remain separate owned dependencies.
    compose_file(library)
    for relative in OWNED:
        shutil.copytree(ROOT / "stdlib" / relative, library / relative, dirs_exist_ok=True)
    for relative in ["Compiler", "internal/compiler-api"]:
        shutil.copytree(ROOT.parent / "compiler/stdlib" / relative,
                        library / relative, dirs_exist_ok=True)
    shutil.copytree(ROOT.parent / "stdlib-tools/stdlib/Check", library / "Check", dirs_exist_ok=True)
    for relative in ["check-engine", "porting-check.jai", "check-bindings.jai"]:
        source = ROOT.parent / "stdlib-tools/stdlib/internal/developer-tools" / relative
        destination = library / "internal/developer-tools" / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        if source.is_dir():
            shutil.copytree(source, destination, dirs_exist_ok=True)
        else:
            shutil.copyfile(source, destination)
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
    for optimization in ["-O0", "-O2"]:
        executable = OUTPUT / ("paths" + optimization)
        run([compiler, str(path_case), optimization, "-exe", str(executable)])
        assert run([str(executable)]) == "ok\n"

    def build(arguments, status=0, contains=None, optimization="-O0"):
        return run([compiler, str(CASE / "build.jai"), optimization, "-add", "#run,stallable run_build();", "-", *arguments], status, contains)

    target = OUTPUT / "target-program"
    common = ["-no_check", "target.jai", "-exe", target.name,
              "-output_path", str(OUTPUT)]
    for optimization in ["-O0", "-O2"]:
        build(common, optimization=optimization)
        assert run([str(target)]) == "target ok\n"
    default_common = common[1:]
    for binding_flag in [[], ["-no_check_bindings"], ["-check_bindings"]]:
        build([*default_common, *binding_flag])
        assert run([str(target)]) == "target ok\n"
    build(["-help"], contains="Default build:")
    build(["-version"], contains="jaic")
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
    build([], status=1, contains="Provide a source file")
    build(["-no_check", "-unknown"], status=1, contains="Unknown option")
    build(["-no_check", "-exe"], status=1, contains="Missing value")
    build(["-no_check", "invalid-target.jai", "-exe", "invalid", "-output_path", str(OUTPUT)],
          status=1, contains="missing_target_procedure")
    build(["-no_check", "-help", "+Workflow_Probe", "-fail"], contains="Plugin initialization failed")
    build(["-no_check", "-help", "+Workflow_Probe", "value"], contains="help A")

    callbacks = ("init A 2\ninit B 1\nprepare A\nprepare B\nsource A\nsource B\n"
                 "complete A\ncomplete B\nfinish A\nfinish B\nshutdown A\nshutdown B\n")
    flags = ["-o", "-no_inline", "-no_dce", "-no_split", "-no_color", "-msvc_format",
             "-natvis", "-debug_for", "-quiet", "-no_backtrace_on_crash", "-context_size", "8192"]
    plugin_args = ["+Workflow_Probe", "-options", "value", '+Workflow_Probe(TAG="B")',
                   "value", "-", "first", "-literal"]
    for optimization in ["-O0", "-O2"]:
        assert build([*common, *flags, *plugin_args], optimization=optimization) == callbacks
        assert run([str(target)]) == "target ok\n"
    replay = run([compiler, str(CASE / "build-twice.jai"), "-add", "#run,stallable run_build_twice();", "-", *common,
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
    print("Default_Metaprogram: paths interpreter/native O0/O2; real builds, option projection, plugin parameters/order, help/version and failures pass", flush=True)
    subprocess.run([str(compiler_root / "jailint"), "-D", "warnings", "-I", str(CASE / "dependency-modules"),
                    str(library / "Default_Metaprogram"),
                    *[str(library / "internal/build" / name) for name in
                      ["default-options.jai", "default-workspace.jai", "default-plugins.jai"]],
                    *[str(CASE / name) for name in ["paths.jai", "build.jai", "build-twice.jai", "target.jai", "import-target.jai"]],
                    str(CASE / "modules/Workflow_Probe/module.jai")], env=env, cwd=ROOT, check=True)
    print("Default_Metaprogram ordinary Check-enabled builds/binding flags, no_check/custom plugins/replay/error paths and full owned strict lint pass", flush=True)


if __name__ == "__main__":
    main()
