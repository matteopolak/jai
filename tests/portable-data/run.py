"""Run only original portable-data tests against own source-built tools.

Native stb dependencies must be built separately using the repository's reviewed
native build tool. Nothing is fetched here; no shared manifests/staging are used.
"""
from pathlib import Path
import os
import subprocess
import sys

root = Path(__file__).resolve().parents[2]
output = root / "target/portable-data"
output.mkdir(parents=True, exist_ok=True)
env = dict(os.environ, JAIC_NATIVE_LIBS=str(output / "native"))
compiler = root / "target/debug/jaic"
formatter = root / "target/jaifmt"
linter = root / "target/debug/jailint"
sources = [
    "stdlib/Ico_File", "stdlib/Simple_Package", "stdlib/Subtitles",
    "stdlib/internal/resource-wire", "stdlib/internal/simple-package",
    "stdlib/internal/subtitles", "tests/portable-data",
]

def run(*args):
    print("+", *map(str, args), flush=True)
    subprocess.run(list(map(str, args)), cwd=root, env=env, check=True)

run(formatter, "--check", *sources)
run(linter, "-D", "warnings", *sources)
run(sys.executable, "tests/portable-data/wire_consumer.py", output, "fixtures")
for name in ("ico-wire", "ico-filename", "package-contract", "subtitles-contract"):
    source = f"tests/portable-data/{name}.jai"
    run(compiler, "-interp", source, "--", output)
    for mode in ("O0", "O2"):
        binary = output / f"{name}-{mode}"
        run(compiler, f"-{mode}", source, "-exe", binary)
        run(binary, output)
for name in ("ico-wire", "package-contract", "subtitles-contract"):
    source = f"tests/portable-data/{name}.jai"
    wasm = output / f"{name}.wasm"
    run(compiler, "-os", "wasm", "-O2", source, "-exe", wasm)
    run("node", "--no-warnings", "tools/wasi_run.mjs", wasm, output)
run(sys.executable, "tests/portable-data/wire_consumer.py", output)
for os_name in ("macos", "linux", "windows", "wasm"):
    run(linter, "-D", "warnings", "-os", os_name,
        "--manifest", output / f"lint-{os_name}.json", *sources)
    for name in ("ico-wire", "package-contract", "subtitles-contract"):
        run(compiler, "-check", "-no_dce", "-os", os_name,
            f"tests/portable-data/{name}.jai")
print("Scoped tests passed; native Windows resource effects remain unverified.")
