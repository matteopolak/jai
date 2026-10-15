#!/usr/bin/env python3
"""Actual reviewed reassigned helper effects and original official SDK oracles."""
import hashlib
import json
import platform
import subprocess

from check_generator_platform import ROOT, PREFIX, ENV, run


def main():
    if platform.system() != "Darwin":
        raise RuntimeError("Native evidence requires a real Mac host")
    facade = ROOT / "stdlib/Bindings_Generator/emission-helpers.jai"
    private = ROOT / "stdlib/internal/developer-tools/generator-emission.jai"
    pure = ROOT / "tests/developer-tools/generator-emission.jai"
    native = ROOT / "tests/developer-tools/generator-emission-native.jai"
    source = ROOT / "tests/developer-tools/generator-emission-oracle.c"
    header = ROOT / "tests/developer-tools/generator-emission.h"
    evidence = {"executed": ["Mac interpreter", "Mac native O0", "Mac native O2"],
                "contract_status": "all ten reassigned names implemented to the reviewed contracts",
                "sdk": run([PREFIX / "bin/clang", "--version"]).splitlines()[0],
                "original_header_sha256": hashlib.sha256(header.read_bytes()).hexdigest()}
    outputs = []
    for optimization in [0, 2]:
        oracle = ROOT / f"target/generator-emission-oracle-o{optimization}"
        run([PREFIX / "bin/clang", f"-O{optimization}", "-Wall", "-Wextra", "-Werror",
             "-I", PREFIX / "include", source, "-L", PREFIX / "lib", "-lclang",
             f"-Wl,-rpath,{PREFIX / 'lib'}", "-o", oracle], "")
        outputs.append(run([oracle, header]))
    if outputs[0] != outputs[1]:
        raise RuntimeError("Official SDK oracle differs across optimization levels")
    for fixture, expected in [(pure, "ok\n"), (native, outputs[0])]:
        run([ROOT / "target/debug/jaic", fixture, "-interp"], expected)
        for optimization in [0, 2]:
            executable = ROOT / f"target/{fixture.stem}-o{optimization}"
            run([ROOT / "target/debug/jaic", fixture, f"-O{optimization}", "-exe", executable], "")
            run([executable], expected)
    for os_name in ["macos", "linux", "windows"]:
        for cpu in ["x64", "arm64"]:
            run([ROOT / "target/debug/jaic", pure, "-check", "-os", os_name, "-cpu", cpu], "")
            run([ROOT / "target/debug/jaic", native, "-check", "-os", os_name, "-cpu", cpu], "")
    negative = [
        (ROOT / "tests/developer-tools/generator-emission-no-options.jai", "spacing requires active options"),
        (ROOT / "tests/developer-tools/generator-emission-negative-indent.jai", "negative indentation depth"),
    ]
    for fixture, message in negative:
        modes = [[ROOT / "target/debug/jaic", fixture, "-interp"]]
        for optimization in [0, 2]:
            executable = ROOT / f"target/{fixture.stem}-o{optimization}"
            run([ROOT / "target/debug/jaic", fixture, f"-O{optimization}", "-exe", executable], "")
            modes.append([executable])
        for mode in modes:
            result = subprocess.run([str(value) for value in mode], cwd=ROOT,
                                    env=ENV, text=True, capture_output=True, timeout=60)
            if result.returncode == 0 or message not in result.stdout + result.stderr:
                raise RuntimeError(f"Required helper diagnostic absent: {mode}\n{result.stdout}\n{result.stderr}")
    files = [facade, private, pure, native, *(fixture for fixture, _ in negative),
             ROOT / "stdlib/internal/developer-tools/generator-active-state.jai",
             ROOT / "stdlib/internal/developer-tools/generator-context/module.jai"]
    run([ROOT / "target/jaifmt", "--check", *files], "")
    checked = ROOT / "target/generator-emission-checked.txt"
    checked.write_text("\n".join(str(path) for path in files) + "\n")
    run([ROOT / "target/debug/jailint", "-D", "warnings", "--checked-files", checked,
         ROOT / "stdlib/Bindings_Generator/module.jai", pure, native,
         *(fixture for fixture, _ in negative)])
    evidence["oracle_stdout"] = outputs[0]
    evidence["source_checked_only"] = ["Linux x64/arm64", "Windows x64/arm64", "Mac x64"]
    evidence["strict_lint_and_format"] = "passed"
    evidence["negative_diagnostics"] = {"cases": [message for _, message in negative], "modes_per_case": 3}
    evidence["public_effects"] = [
        "space-separated prepending and borrowed standalone input",
        "location/newline prefix classification, per-line trim, trailing indentation and line-ending normalization",
        "eligible member/output-name alignment, qualifier widths, selector overload and extern exclusion",
        "both spacing overloads, always-updated location, source gaps/files, NO_SPACING and u32 boundary",
        "two configured instances and nested shared-options context restoration",
        "owned normalized cursor spelling, leading/trailing/absent native comments and preserved metadata",
        "unset source refresh, forward-declaration preservation and definition refresh",
        "descendant logging through caller context, root exclusion and depth against original SDK traversal",
    ]
    (ROOT / "docs/native/generator-emission-evidence.json").write_text(json.dumps(evidence, indent=2) + "\n")
    print("Generator emission behavior and official SDK cursor oracle passed Mac interpreter/O0/O2")


if __name__ == "__main__":
    main()
