#!/usr/bin/env python3
"""Scoped current-source emission effects; independent native fixtures, private outputs."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import platform
import subprocess

from build_developer_bindings import llvm_prefix

ROOT = Path(__file__).resolve().parents[1]
WORKFLOWS = {
    "bitfield-printers": ("bitfields", "bitfield_printers"),
    "linkage-emission": ("linkage", "linkage_emission"),
    "template-printing": ("templates", None),
    "enum-printers": ("enums", "enum_printers"),
    "signature-callback": ("signature", "signature_callback"),
}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("workflows", nargs="*", choices=list(WORKFLOWS))
    args = parser.parse_args()
    if platform.system() != "Darwin":
        raise RuntimeError("These native consumers currently require macOS")
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    compiler = target / "debug/jaic"
    formatter = target / "jaifmt"
    linter = target / "debug/jailint"
    prefix = llvm_prefix()
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    fixtures = ROOT / "tests/developer-tools"
    selected = args.workflows or list(WORKFLOWS)
    sources = list((ROOT / "stdlib/Bindings_Generator").rglob("*.jai"))
    sources += list((ROOT / "stdlib/internal/developer-tools").glob("binding*.jai"))
    sources += list((ROOT / "stdlib/internal/developer-tools").glob("generator*.jai"))
    sources += list((ROOT / "stdlib/internal/developer-tools/generator-session").glob("*.jai"))
    sources += [ROOT / "stdlib/internal/developer-tools/cpp-fragments.jai"]
    for name in selected:
        sources += list(fixtures.glob("bindings-" + name + "*"))

    def snapshot():
        return {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest()
                for p in sorted(set(sources)) if p.is_file()}

    before = snapshot()
    receipt = {"workflows": selected, "sdk": str(prefix), "source_sha256": before,
               "passed": False, "commands": [], "cross_target": "not run"}

    def run(command, expected=""):
        result = subprocess.run([str(v) for v in command], cwd=ROOT, env=env,
                                capture_output=True, text=True, timeout=90)
        receipt["commands"].append({"command": [str(v) for v in command],
                                    "exit": result.returncode,
                                    "stdout_match": result.stdout == expected,
                                    "stderr_empty": not result.stderr})
        if result.returncode or result.stdout != expected or result.stderr:
            raise RuntimeError("Scoped emission failure: " + (result.stderr or result.stdout)[:500])

    try:
        for name in selected:
            stem, library = WORKFLOWS[name]
            scratch = target / ("emission-" + name)
            scratch.mkdir(parents=True, exist_ok=True)
            emitter = fixtures / ("bindings-" + name + ".jai")
            consumer = fixtures / ("bindings-" + name + "-roundtrip.jai")
            generated = scratch / ("developer-tools-" + stem + "-generated.jai")
            for mode in ["interp", "0", "2"]:
                if mode == "interp":
                    run([compiler, emitter, "-interp", "--", scratch], "ok\n")
                else:
                    executable = scratch / ("emitter-o" + mode)
                    run([compiler, emitter, "-O" + mode, "-exe", executable])
                    run([executable, scratch], "ok\n")
                run([formatter, "--config", ROOT / "jaifmt.toml", generated])
                for optimization in [0, 2]:
                    if library:
                        run([prefix / "bin/clang", "-std=c11", "-O" + str(optimization),
                             "-Wall", "-Wextra", "-Werror", "-dynamiclib",
                             fixtures / ("bindings-" + name + "-native.c"),
                             "-o", scratch / ("lib" + library + ".dylib")])
                    run([compiler, consumer, "-interp", "-I", scratch], "ok\n")
                    executable = scratch / ("consumer-" + mode + "-o" + str(optimization))
                    run([compiler, consumer, "-O" + str(optimization), "-I", scratch,
                         "-exe", executable])
                    run([executable], "ok\n")
            run([formatter, "--config", ROOT / "jaifmt.toml", "--check", emitter, consumer, generated])
            run([linter, "-D", "warnings", "-I", scratch, emitter, consumer])
        run([linter, "-D", "warnings", ROOT / "stdlib/Bindings_Generator/module.jai"])
        receipt["passed"] = True
    finally:
        receipt["source_unchanged"] = before == snapshot()
        if not receipt["source_unchanged"]:
            receipt["passed"] = False
        (target / "emission-workflows-verification.json").write_text(json.dumps(receipt, indent=2) + "\n")
    if not receipt["source_unchanged"]:
        raise RuntimeError("Shared generator sources changed during verification; rerun required")
    print("Scoped generated emission workflows passed interpreter/native Mac O0/O2")


if __name__ == "__main__":
    main()
