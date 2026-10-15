#!/usr/bin/env python3
"""Build and validate the private, staged libclang C binding pipeline."""
import hashlib
import json
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
ENV = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))


def run(command, expected="", returncode=0, diagnostic=None):
    result = subprocess.run([str(x) for x in command], cwd=ROOT, env=ENV,
                            text=True, capture_output=True, timeout=60)
    if result.returncode != returncode or (expected is not None and result.stdout != expected):
        raise RuntimeError(f"{command}: exit {result.returncode}\n{result.stdout}\n{result.stderr}")
    if diagnostic is None and result.stderr:
        raise RuntimeError(result.stderr)
    if diagnostic is not None and diagnostic not in result.stderr:
        raise RuntimeError(f"Missing diagnostic {diagnostic}: {result.stderr}")
    return result.stdout


def main():
    prefix = Path(os.environ.get("DEVELOPER_TOOLS_LLVM_PREFIX", "/opt/homebrew/opt/llvm"))
    tool = ROOT / "target/developer-tools-clang"
    source = ROOT / "stdlib/internal/developer-tools/clang-bindings/main.c"
    run([prefix / "bin/clang", "-std=c11", "-O2", "-Wall", "-Wextra", "-Werror", "-I", prefix / "include",
         source, "-L", prefix / "lib", "-lclang", "-o", tool])
    output = ROOT / "target/developer-tools-generated.jai"
    header = ROOT / "tests/developer-tools/bindings-input.h"
    run([tool, header, output, "developer_tools_bindings"])
    before = output.read_bytes()
    run([tool, header, output, "developer_tools_bindings"])
    if output.read_bytes() != before:
        raise RuntimeError("Binding generation is not deterministic")
    run([prefix / "bin/clang", "-std=c11", "-Wall", "-Wextra", "-Werror", "-dynamiclib",
         ROOT / "tests/developer-tools/bindings-input.c", "-o", ROOT / "target/libdeveloper_tools_bindings.dylib"])
    jaic = ROOT / "target/debug/jaic"
    fixture = ROOT / "tests/developer-tools/bindings-roundtrip.jai"
    run([jaic, fixture, "-interp", "-I", ROOT / "target"], "ok\n")
    for optimization in [0, 2]:
        exe = ROOT / f"target/developer-tools-bindings-o{optimization}"
        run([jaic, fixture, f"-O{optimization}", "-exe", exe, "-I", ROOT / "target"])
        run([exe], "ok\n")
    rejected = ROOT / "target/developer-tools-rejected.jai"
    for case, reason in [("bitfield", "bitfield member"), ("malformed", "error:"),
                         ("macro", "macro generation is not supported")]:
        rejected.write_text("existing output must survive")
        run([tool, ROOT / f"tests/developer-tools/bindings-{case}.h", rejected, "native"],
            returncode=1, diagnostic=reason)
        if rejected.read_text() != "existing output must survive":
            raise RuntimeError(f"{case} replaced output despite generation failure")
    for triple, os_name, spelling in [("x86_64-unknown-linux-gnu", "linux", "NativeLong :: s64;"),
                                      ("x86_64-pc-windows-msvc", "windows", "NativeLong :: s32;")]:
        run([tool, header, output, "developer_tools_bindings", f"--target={triple}"])
        if spelling not in output.read_text():
            raise RuntimeError(f"Target-dependent C long ABI was not preserved: {triple}")
        run([jaic, fixture, "-check", "-os", os_name, "-cpu", "x64", "-I", ROOT / "target"])
    run([tool, header, output, "developer_tools_bindings"])
    run([ROOT / "target/jaifmt", "--config", ROOT / "jaifmt.toml", output, fixture])
    run([ROOT / "target/jaifmt", "--config", ROOT / "jaifmt.toml", "--check", output, fixture])
    run([ROOT / "target/debug/jailint", "-D", "warnings", "-I", ROOT / "target", output, fixture])
    inputs = {str(path): hashlib.sha256(path.read_bytes()).hexdigest()
              for path in [prefix / "include/clang-c/Index.h", prefix / "include/clang-c/CXString.h"]}
    metadata = {"scope": "private staged pipeline, not public Bindings_Generator compatibility",
                "sdk_headers_sha256": inputs, "clang_version": run([prefix / "bin/clang", "--version"], expected=None),
                "source_sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
                "tests": "interpreter/native O0/O2 call and mutation, callbacks, enum and record layout; rejection preserves output; Linux/Windows target-dependent long"}
    (ROOT / "docs/native/developer-tools-clang-evidence.json").write_text(json.dumps(metadata, indent=2) + "\n")
    print("Private libclang pipeline: C/Jai effects and callback round trips, rejection preservation, deterministic output and two target ABI checks passed")


if __name__ == "__main__":
    main()
