#!/usr/bin/env python3
"""Reviewed default build contract; real compiler workspaces and target artifacts.

Uses the actual production library without dependency overlays or source repairs.
"""
import os
import json
from pathlib import Path
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[1]
CASE = ROOT / "tests/portable-stdlib/default-metaprogram"
OUTPUT = ROOT / "target/portable-default-metaprogram"
OWNED = ["Default_Metaprogram", "Metaprogram_Plugins", "internal/build"]


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
        target_optimization = "-very_debug" if optimization == "-O0" else "-od"
        return run([compiler, str(CASE / "build.jai"), optimization, "-add", "#run,stallable run_build();", "-", target_optimization, *arguments], status, contains)

    target = OUTPUT / "target-program"
    common = ["-no_check", "target.jai", "-exe", target.name,
              "-output_path", str(OUTPUT)]
    for optimization in OPTIMIZATIONS:
        build(common, optimization=optimization)
        assert run([str(target)]) == "target ok\n"
    target.unlink()
    run([compiler, "-interp", str(CASE / "build.jai"), "-add", "#run,stallable run_build();", "-", *common])
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
             "-debug_for", "-quiet", "-no_backtrace_on_crash", "-context_size", "8192"]
    build([*common, "-natvis"], status=1, contains="Natvis-compatible type emission is unavailable")
    plugin_args = ["+Workflow_Probe", "-options", "value", '+Workflow_Probe(TAG="B")',
                   "value", "-", "first", "-literal"]
    for optimization in OPTIMIZATIONS:
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
    # The generic loader has a reviewed deferred-definition import obligation.
    # Supply a real empty initialization in the lint PROGRAM context, then lint
    # every original owned body; do not replace or filter failed definitions.
    warmup = '''Lint_Basic :: #import "Basic";
Lint_Compiler :: #import "Compiler";
Lint_Plugins :: #import "Metaprogram_Plugins";
#run,stallable {
    requests: [] Lint_Plugins.Plugin_To_Create;
    results: [..] *Lint_Compiler.Metaprogram_Plugin;
    success := Lint_Plugins.init_plugins(requests, *results, -1);
    Lint_Basic.assert(success && results.count == 0);
    Lint_Basic.array_free(results);
}
'''
    def write_lint_context(path, text):
        path.write_text(text)
        for mode in [[], ["--check"]]:
            subprocess.run([str(ROOT / "target/jaifmt"), "--config", str(ROOT / "jaifmt.toml"),
                            *mode, str(path)], check=True)
    context = OUTPUT / "lint-library.jai"
    write_lint_context(context, warmup + 'Lint_Default :: #import "Default_Metaprogram";\n#run Lint_Basic.assert(Lint_Default.is_absolute_path("/"));\n')
    lint = [str(compiler_root / "jailint"), "-D", "warnings", "-I", str(CASE / "dependency-modules")]
    subprocess.run([*lint, "--context", str(context), str(library / "Default_Metaprogram"),
                    *[str(library / "internal/build" / name) for name in
                      ["default-options.jai", "default-workspace.jai", "default-plugins.jai"]]], env=env, cwd=ROOT, check=True)
    for name in ["paths.jai", "build.jai", "build-twice.jai"]:
        context = OUTPUT / ("lint-" + name)
        write_lint_context(context, warmup + "#load " + json.dumps(str(CASE / name)) + ";\n")
        subprocess.run([*lint, "--context", str(context), str(CASE / name)], env=env, cwd=ROOT, check=True)
    subprocess.run([*lint, str(CASE / "target.jai"), str(CASE / "import-target.jai"),
                    str(CASE / "modules/Workflow_Probe/module.jai")], env=env, cwd=ROOT, check=True)
    print("Default_Metaprogram ordinary Check-enabled builds/binding flags, no_check/custom plugins/replay/error paths and full owned strict lint pass", flush=True)


if __name__ == "__main__":
    main()
