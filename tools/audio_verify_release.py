#!/usr/bin/env python3
"""Verify a relocated audio package using source-built jaic and owned artifacts.

Native execution is only claimed on the exact host. Cross target -check is
recorded separately and does not prove a linked or running target binary.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys

from audio_build_native import ROOT, PLAN, host_platform


def run(command, cwd=ROOT, env=None):
    result = subprocess.run(list(map(str, command)), cwd=cwd, env=env,
                            capture_output=True, text=True, timeout=60)
    if result.returncode or result.stderr:
        lines = [line for line in result.stderr.splitlines() if "error:" in line or "warning:" in line]
        raise RuntimeError(f"{Path(str(command[0])).name}: exit {result.returncode}; " + "; ".join(lines[:5]))
    return result.stdout


def imports(executable, osname):
    if osname == "macos":
        return run(["otool", "-L", executable]) + run(["otool", "-l", executable])
    if osname == "linux":
        return run(["ldd", executable])
    tool = shutil.which("llvm-readobj")
    if not tool:
        raise RuntimeError("Windows import inspection requires llvm-readobj from the public LLVM SDK")
    return run([tool, "--coff-imports", executable])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--artifacts", type=Path, default=ROOT / "target/audio-native")
    parser.add_argument("--compiler", type=Path, default=ROOT / "target/compiler/debug" / ("jaic.exe" if os.name == "nt" else "jaic"))
    parser.add_argument("--require-device", action="store_true")
    parser.add_argument("--check-targets", action="store_true")
    args = parser.parse_args()
    compiler = args.compiler.resolve()
    artifacts = args.artifacts.resolve()
    target = host_platform()
    metadata = json.loads((artifacts / "audio-build.json").read_text())
    if metadata["platform"] != target:
        raise RuntimeError("Artifact target differs from host; refusing to label cross artifacts as native execution")
    stage = ROOT / "target/audio-release-verification"
    stage.mkdir(parents=True, exist_ok=True)
    work = stage / "build"
    work.mkdir(exist_ok=True)
    install = stage / "install"
    relocated = stage / "moved-package"
    for directory in (install, relocated):
        if directory.exists():
            shutil.rmtree(directory)
    native = install / "native" / target
    native.mkdir(parents=True)
    for filename, digest in metadata["artifacts"].items():
        source = artifacts / filename
        if hashlib.sha256(source.read_bytes()).hexdigest() != digest:
            raise RuntimeError("Native artifact checksum does not match owned build record")
        shutil.copy2(source, native / filename)
    shutil.copytree(artifacts / "licenses", install / "licenses")
    shutil.copytree(ROOT / "tests/audio/fixtures", install / "share/fixtures")
    (install / "bin").mkdir()
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"), JAIC_NATIVE_LIBS=str(native))
    if args.check_targets:
        for name, entry in PLAN["platforms"].items():
            for case in ("signatures", "device-lifecycle", "entity-phase", "compressed-stream"):
                run([compiler, ROOT / "tests/audio" / (case + ".jai"), "-check",
                     "-os", entry["os"], "-cpu", entry["cpu"]], env=env)
            print(f"{name}: Jai source checks passed; no native link/runtime implied", flush=True)
    binaries = []
    for case in ("entity-phase", "compressed-stream"):
        for level in ("O0", "O2"):
            filename = case + "-" + level + (".exe" if os.name == "nt" else "")
            executable = work / filename
            run([compiler, ROOT / "tests/audio" / (case + ".jai"), "-" + level, "-exe", executable], env=env)
            dependency_text = imports(executable, PLAN["platforms"][target]["os"])
            if "jai_audio_output." in dependency_text or "stb_vorbis." in dependency_text:
                raise RuntimeError("Native executable retained an audio/decoder shared dependency")
            for forbidden in (str(ROOT), str(artifacts), str(native)):
                # otool prints the executable's own path as a heading.
                body = "\n".join(line for line in dependency_text.splitlines() if not line.endswith(":"))
                if forbidden in body:
                    raise RuntimeError("Runtime dependency/rpath contains a source or staging directory")
            shutil.copy2(executable, install / "bin" / filename)
            binaries.append(filename)
    shutil.move(install, relocated)
    runtime_env = dict(os.environ)
    for variable in ("JAIC_NATIVE_LIBS", "JAIC_STDLIB", "LD_LIBRARY_PATH", "DYLD_LIBRARY_PATH", "DYLD_FALLBACK_LIBRARY_PATH"):
        runtime_env.pop(variable, None)
    if os.name == "nt":
        system = Path(os.environ["SystemRoot"])
        runtime_env["PATH"] = os.pathsep.join(map(str, (relocated / "bin", system / "System32", system)))
    # Native audio and decoder must be embedded: omit even packaged shared files.
    # Keep their verified copies for interpreter distribution, but remove them
    # from this runtime-test package to make accidental dynamic loading fail.
    for library in (relocated / "native" / target).iterdir():
        if library.suffix in (".dylib", ".so", ".dll"):
            library.unlink()
    observed = []
    for filename in binaries:
        stdout = run([relocated / "bin" / filename], cwd=relocated / "share", env=runtime_env)
        marker = stdout.splitlines()[0] if stdout.splitlines() else ""
        if stdout not in ("native-device-opened\nok\n", "native-device-unavailable\nok\n"):
            raise RuntimeError("Unexpected relocated runtime output")
        if args.require_device and marker != "native-device-opened":
            raise RuntimeError("Required native device was unavailable; no playback pass recorded")
        observed.append({"binary": filename, "execution": marker})
        print(f"{target} relocated {filename}: {marker}; no audio/decoder shared dependency", flush=True)
    (stage / "result.json").write_text(json.dumps({"platform": target, "results": observed,
                                                "physical_hotplug": "not tested",
                                                "physical_speakers": "not tested"}, indent=2) + "\n")


if __name__ == "__main__":
    main()
