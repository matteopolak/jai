#!/usr/bin/env python3
"""Mac official SDK C global addresses vs canonical filtered public reexports."""
import json
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def main():
    output = ROOT / "target/portable-socket-storage"
    module = output / "modules/Socket_Storage_Bridge"
    module.mkdir(parents=True, exist_ok=True)
    library = ROOT / "target/portable-socket-resolver/stdlib"
    if not (library / "Socket/module.jai").is_file():
        raise RuntimeError("stage the genuine resolver candidate first with check_portable_socket_resolver.py")
    provider = output / "sdk-storage.dylib"
    subprocess.run(["clang", "-std=c11", "-Wall", "-Wextra", "-Werror", "-dynamiclib",
                    str(ROOT / "tests/portable-stdlib/native/socket-storage.c"), "-o", str(provider)], check=True)
    module.joinpath("module.jai").write_text(
        f"sdk :: #library {json.dumps(str(provider.with_suffix('')))};\n"
        "h_errno_address :: () -> *void #foreign sdk \"portable_h_errno_address\";\n"
        "any_address :: () -> *void #foreign sdk \"portable_any_address\";\n"
        "loopback_address :: () -> *void #foreign sdk \"portable_loopback_address\";\n"
        "h_errno_value :: () -> s32 #foreign sdk \"portable_h_errno_value\";\n")
    for mode in [[], ["--check"]]:
        subprocess.run([str(ROOT / "target/jaifmt"), "--config", str(ROOT / "jaifmt.toml"),
                        *mode, str(module)], check=True)
    env = dict(os.environ, JAIC_STDLIB=str(library))
    binaries = Path(os.environ["CARGO_TARGET_DIR"]) / "debug"
    compiler = str(binaries / "jaic")
    source = ROOT / "tests/portable-stdlib/socket-storage/main.jai"
    flags = ["-import_dir", str(output / "modules")]
    commands = [[compiler, "-interp", *flags, str(source)]]
    for optimization in ["-O0", "-O2"]:
        program = output / ("main" + optimization)
        subprocess.run([compiler, str(source), *flags, optimization, "-exe", str(program)], env=env, check=True)
        commands.append([str(program)])
    for command in commands:
        result = subprocess.run(command, env=env, capture_output=True, text=True, timeout=60)
        if result.returncode or result.stdout != "ok\n" or result.stderr:
            raise RuntimeError(f"{command!r}: {result.stdout}{result.stderr}")
    subprocess.run([str(binaries / "jailint"), "-D", "warnings", "-I", str(output / "modules"),
                    str(source), str(module)], env=env, check=True)
    print("Socket mutable globals: actual SDK C address equality, shared mutation/restoration, canonical field types pass interpreter/native O0/O2 and scoped strict lint")


if __name__ == "__main__":
    main()
