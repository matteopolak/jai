#!/usr/bin/env python3
"""Focused developer tooling evidence from this checkout's source-built tools."""
import os
from pathlib import Path
import re
import subprocess
import shutil
import check_developer_bindings
import build_developer_debug

ROOT = Path(__file__).resolve().parents[1]
ENV = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
JAIC = ROOT / "target/debug/jaic"


def run(command, *, output=None, error=""):
    result = subprocess.run([str(x) for x in command], cwd=ROOT, env=ENV,
                            text=True, capture_output=True, timeout=60)
    if result.returncode or (output is not None and result.stdout != output) or result.stderr != error:
        raise RuntimeError(f"{command}: exit {result.returncode}\n{result.stdout}\n{result.stderr}")
    return result.stdout


def main():
    check_developer_bindings.main()
    build_developer_debug.main()
    prefix = Path(os.environ.get("DEVELOPER_TOOLS_LLVM_PREFIX", "/opt/homebrew/opt/llvm"))
    run([prefix / "bin/clang", "-target", "x86_64-unknown-linux-gnu", "-g", "-fno-omit-frame-pointer",
         "-c", "tests/developer-tools/dwarf-native.c", "-o", "target/developer-tools-dwarf.o"])
    run([prefix / "bin/llvm-objcopy", "--dump-section", ".eh_frame=target/developer-tools-eh-frame.bin",
         "target/developer-tools-dwarf.o"])
    cases = ["c-header", "c-header-roundtrip", "c-header-reject", "print-vars", "rewrite", "dwarf-cfa", "debug-native"]
    run([JAIC, "tests/developer-tools/c-header.jai", "-interp"], output="ok\n")
    run(["clang", "-std=c11", "-Wall", "-Wextra", "-Werror", "-dynamiclib", "-I", "target",
         "tests/developer-tools/point.c", "-o", "target/libdeveloper_tools_point.dylib"])
    for case in cases:
        source = ROOT / f"tests/developer-tools/{case}.jai"
        error = "C header: procedure must have the C calling convention" if case == "c-header-reject" else ""
        if case == "debug-native":
            error = "native debug output\n"
        expected = "x = 7 (s32)\nok\n" if case == "print-vars" else "ok\n"
        run([JAIC, source, "-interp"], output=expected, error=error)
        for optimization in [0, 2]:
            exe = ROOT / f"target/developer-tools-{case}-o{optimization}"
            run([JAIC, source, f"-O{optimization}", "-exe", exe])
            run([exe], output=expected, error=error)
    for optimization in [0, 2]:
        exe = ROOT / f"target/developer-tools-performance-o{optimization}"
        report = run([JAIC, "tests/developer-tools/performance-target.jai", f"-O{optimization}",
                      "-exe", exe, "+Performance_Report"])
        for required in ["Compiler performance report", "#run time:", "Bytecode instructions:",
                         "Calls:", "Polymorph solves:", "work:"]:
            if required not in report:
                raise RuntimeError(f"Missing measured report section {required}")
        rows = [float(x) for x in re.findall(r"^  .*: ([0-9.e+-]+) seconds,", report, re.MULTILINE)]
        if not rows or rows != sorted(rows, reverse=True) or not any(x > 0 for x in rows):
            raise RuntimeError("Run records must contain actual positive timings in descending order")
        run([exe], output="ok\n")
    run(["clang", "-std=c11", "-Wall", "-Wextra", "-Werror", "tests/developer-tools/debug-protection.c",
         ROOT / "stdlib/internal/developer-tools/debug-native/libdeveloper_tools_debug.dylib",
         "-o", "target/developer-tools-debug-protection"])
    run([ROOT / "target/developer-tools-debug-protection"])
    abort_source = ROOT / "tests/developer-tools/debug-abort.jai"
    abort_commands = [[JAIC, abort_source, "-interp"]]
    for optimization in [0, 2]:
        exe = ROOT / f"target/developer-tools-debug-abort-o{optimization}"
        run([JAIC, abort_source, f"-O{optimization}", "-exe", exe])
        abort_commands.append([exe])
    for command in abort_commands:
        aborted = subprocess.run([str(x) for x in command], cwd=ROOT, env=ENV,
                                 text=True, capture_output=True, timeout=60)
        if aborted.returncode != 2 or aborted.stdout or aborted.stderr:
            raise RuntimeError("Debug.abort did not terminate with Exit_Code.Abort")
    missing = subprocess.run([str(JAIC), "tests/developer-tools/performance-missing.jai", "-check"],
                             cwd=ROOT, env=ENV, text=True, capture_output=True, timeout=60)
    if missing.returncode or "warning: Performance_Report: compiler did not provide a performance report" not in missing.stderr:
        raise RuntimeError("Missing performance message did not produce its diagnostic")
    rewritten = ROOT / "target/developer-tools-rewrite-program.jai"
    shutil.copyfile(ROOT / "tests/developer-tools/rewrite-input.jai", rewritten)
    rewrite_report = run([JAIC, "tests/developer-tools/rewrite-driver.jai", "-check"])
    if " -> (pointer).*" not in rewrite_report or "<<pointer" in rewritten.read_text():
        raise RuntimeError("Actual compiler-message rewrite did not replace the deprecated expression")
    run([JAIC, rewritten, "-interp"], output="ok\n")
    for optimization in [0, 2]:
        exe = ROOT / f"target/developer-tools-rewritten-o{optimization}"
        run([JAIC, rewritten, f"-O{optimization}", "-exe", exe])
        run([exe], output="ok\n")
    paths = [ROOT / "stdlib/Generate_C_Header/module.jai",
             ROOT / "stdlib/Performance_Report/module.jai",
             ROOT / "stdlib/Print_Vars/module.jai",
             ROOT / "stdlib/Rewrite/module.jai",
             ROOT / "stdlib/Debug_Info/module.jai",
             ROOT / "stdlib/Debug/module.jai",
             *sorted((ROOT / "stdlib/internal/developer-tools").glob("*.jai")),
             *sorted((ROOT / "tests/developer-tools").glob("*.jai"))]
    run([ROOT / "target/jaifmt", "--config", ROOT / "jaifmt.toml", "--check", *paths])
    shutil.copyfile(ROOT / "tests/developer-tools/rewrite-input.jai", rewritten)
    run([ROOT / "target/debug/jailint", "-D", "warnings", "-I", ROOT / "target", *paths])
    for os_name, cpu in [("linux", "x64"), ("windows", "x64"), ("wasm", "x64")]:
        run([JAIC, "tests/developer-tools/c-header.jai", "-check", "-os", os_name, "-cpu", cpu])
        run([JAIC, "tests/developer-tools/debug-target.jai", "-check", "-os", os_name, "-cpu", cpu])
    print("Header round trips/rejection and real performance plugin reports passed; interpreter/native O0/O2, scoped formatting/lint and three target checks")


if __name__ == "__main__":
    main()
