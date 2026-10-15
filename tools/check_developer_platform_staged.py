#!/usr/bin/env python3
"""Stage exact authorized NEW platform helpers without changing shared facades."""
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
SOURCES = ROOT / "tests/developer-tools/staged/platform-current"


def prepare():
    manifest = json.loads((SOURCES / "source-manifest.json").read_text())
    for name, expected in manifest["sha256"].items():
        if hashlib.sha256((SOURCES / name).read_bytes()).hexdigest() != expected:
            raise RuntimeError("Exact NEW producer staging hash changed: " + name)
    candidate = ROOT / "target/developer-tools-platform-current"
    if candidate.exists():
        shutil.rmtree(candidate)
    library = candidate / "stdlib"
    library.mkdir(parents=True)
    for source in (ROOT / "stdlib").iterdir():
        if source.name not in {"Bindings_Generator", "internal"}:
            (library / source.name).symlink_to(source, target_is_directory=source.is_dir())
    shutil.copytree(ROOT / "stdlib/Bindings_Generator", library / "Bindings_Generator")
    (library / "internal").mkdir()
    for source in (ROOT / "stdlib/internal").iterdir():
        if source.name != "developer-tools":
            (library / "internal" / source.name).symlink_to(source, target_is_directory=source.is_dir())
    private = library / "internal/developer-tools"
    private.mkdir()
    for source in (ROOT / "stdlib/internal/developer-tools").iterdir():
        (private / source.name).symlink_to(source, target_is_directory=source.is_dir())
    for name in manifest["sha256"]:
        if not name.startswith("stdlib/"):
            continue
        target = candidate / name
        if target.parent.is_symlink():
            target.parent.unlink()
        if target.is_symlink():
            target.unlink()
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(SOURCES / name, target)
    facade = library / "Bindings_Generator/module.jai"
    with facade.open("a") as stream:
        stream.write('\n#load "platform-helpers.jai";\n#load "emission-helpers.jai";\n'
                     '#load "../internal/developer-tools/generator-active-state.jai";\n')
    return library


def main():
    library = prepare()
    environment = dict(os.environ, JAIC_STDLIB=str(library))
    prefix = Path(os.environ.get("DEVELOPER_TOOLS_LLVM_PREFIX", "/opt/homebrew/opt/llvm"))
    private = library / "internal/developer-tools"
    native = private / "libgenerator_platform.dylib"
    if native.is_symlink():
        native.unlink()
    subprocess.run([str(prefix / "bin/clang"), "-std=c11", "-O2", "-Wall", "-Wextra", "-Werror",
                    "-dynamiclib", str(SOURCES / "stdlib/internal/developer-tools/generator-platform-native.c"),
                    "-o", str(native)], check=True)
    candidate = library.parent
    source_fixture = SOURCES / "tests/developer-tools/generator-platform-copy.jai"
    fixture = candidate / "tests/developer-tools/generator-platform-copy.jai"
    fixture.parent.mkdir(parents=True)
    shutil.copy2(source_fixture, fixture)
    work = candidate / "target/generator-platform-copy-work"
    inputs = candidate / "target/generator-platform-copy-source"
    work.mkdir(parents=True)
    inputs.mkdir()
    source = inputs / "original.bin"
    destination = work / source.name
    commands = [[ROOT / "target/debug/jaic", fixture, "-interp"]]
    for optimization in [0, 2]:
        executable = candidate / f"copy-o{optimization}"
        subprocess.run([str(ROOT / "target/debug/jaic"), str(fixture), f"-O{optimization}",
                        "-exe", str(executable)], check=True, env=environment, cwd=ROOT)
        commands.append([executable])
    timestamp = 1700000000000000000
    cases = [(None, 0, b"abcd"), (b"WXYZ", timestamp - 1, b"abcd"),
             (b"WXYZ", timestamp, b"WXYZ"), (b"WXYZ", timestamp + 1, b"WXYZ"),
             (b"!", timestamp + 1, b"abcd")]
    for command in commands:
        for initial, modified, expected in cases:
            source.write_bytes(b"abcd")
            os.utime(source, ns=(timestamp, timestamp))
            destination.unlink(missing_ok=True)
            if initial is not None:
                destination.write_bytes(initial)
                os.utime(destination, ns=(modified, modified))
            effect = subprocess.run([str(item) for item in command], cwd=ROOT, env=environment,
                                    capture_output=True, text=True, timeout=60)
            if effect.returncode or effect.stderr or effect.stdout != "ok\n" or destination.read_bytes() != expected:
                raise RuntimeError("Current platform copy contract failed: " + str(effect.returncode))
        copied = work / "libclang.dylib"
        if hashlib.sha256(copied.read_bytes()).digest() != hashlib.sha256((private / "clang-bindings/libclang.dylib").read_bytes()).digest():
            raise RuntimeError("Current default copy helper did not select the bundled runtime")
        source.unlink()
        failure = subprocess.run([str(item) for item in command], cwd=ROOT, env=environment,
                                 capture_output=True, text=True, timeout=60)
        if failure.returncode == 0 or "missing libclang source" not in failure.stderr + failure.stdout:
            raise RuntimeError("Current missing-source assertion did not diagnose the actual unavailable input")
    paths = [fixture, *[candidate / name for name in json.loads((SOURCES / "source-manifest.json").read_text())["sha256"]
                       if name.endswith(".jai") and name.startswith("stdlib/")]]
    subprocess.run([str(ROOT / "target/jaifmt"), "--config", str(ROOT / "jaifmt.toml"), "--check",
                    *[str(path) for path in paths]], check=True, env=environment, cwd=ROOT)
    print("Exact current platform copy effects passed interpreter/native Mac O0/O2; bundled source, nanosecond mtime and size verified")
    lint = subprocess.run([str(ROOT / "target/debug/jailint"), "-D", "warnings",
                           *[str(path) for path in paths]], env=environment, cwd=ROOT,
                          capture_output=True, text=True, timeout=90)
    if lint.returncode:
        print("Required staged strict lint failed (not suppressed):")
        print("\n".join((lint.stderr or lint.stdout).splitlines()[:3]))
    # This required producer request must remain red with the temporary void
    # protocol; staging it is not acceptance of that public type mismatch.
    result = subprocess.run([str(ROOT / "target/debug/jaic"),
                             str(ROOT / "tests/developer-tools/producer-requests/generator-typed-context.jai"),
                             "-check"], cwd=ROOT, env=environment, capture_output=True, text=True, timeout=60)
    if result.returncode == 0:
        raise RuntimeError("Temporary void context unexpectedly satisfies reviewed typed public field")
    diagnostic = (result.stderr or result.stdout).splitlines()
    print("Exact81c8217b platform dependency staged; typed-context producer remains a required failure:")
    print("\n".join(diagnostic[:3]))
    # Do not claim the rest of the stage valid if name/type resolution fails.
    return result.returncode or lint.returncode


if __name__ == "__main__":
    sys.exit(main())
