#!/usr/bin/env python3
"""Actual reassigned helper effects; reviewed-contract gaps remain explicit."""
import hashlib
import json
import platform

from check_generator_platform import ROOT, PREFIX, run


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
                "contract_status": "independent policies pending reviewed answers",
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
    files = [facade, private, pure, native]
    run([ROOT / "target/jaifmt", "--check", *files], "")
    checked = ROOT / "target/generator-emission-checked.txt"
    checked.write_text("\n".join(str(path) for path in files) + "\n")
    run([ROOT / "target/debug/jailint", "-D", "warnings", "--checked-files", checked,
         ROOT / "stdlib/Bindings_Generator/module.jai", pure, native])
    evidence["oracle_stdout"] = outputs[0]
    evidence["source_checked_only"] = ["Linux x64/arm64", "Windows x64/arm64", "Mac x64"]
    evidence["strict_lint_and_format"] = "passed"
    (ROOT / "docs/native/generator-emission-evidence.json").write_text(json.dumps(evidence, indent=2) + "\n")
    print("Generator emission behavior and official SDK cursor oracle passed Mac interpreter/O0/O2")


if __name__ == "__main__":
    main()
