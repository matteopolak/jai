#!/usr/bin/env python3
"""Controlled close failure around a REAL SDK device; audio assertions disabled.

This is fault injection, not evidence of a physical disconnect or SDK fault.
"""
import json
import os
from pathlib import Path
import shutil
import subprocess

from audio_verify_no_assert import ROOT, stage_audio


def main():
    native = ROOT / "target/audio-native"
    metadata = json.loads((native / "audio-build.json").read_text())
    target = metadata["platform"]
    plan = json.loads((ROOT / "tools/audio_native_plan.json").read_text())["platforms"][target]
    out = ROOT / "target/audio-failure-tests"
    out.mkdir(parents=True, exist_ok=True)
    windows = plan["os"] == "windows"
    macos = plan["os"] == "macos"
    libraries = ([part for name in plan["libraries"] for part in ("-framework", name)]
                 if macos else ["-l" + name for name in plan["libraries"]])
    cc = metadata["compiler"]
    flags = ["-std=c11", "-O2", "-Wall", "-Wextra", "-Werror"]
    if macos:
        flags += ["-arch", plan["arch"], "-mmacosx-version-min=11.0"]
    if not windows:
        flags += ["-fPIC"]

    def command(args, expect=None, env=None):
        result = subprocess.run(list(map(str, args)), env=env, cwd=ROOT / "tests/audio",
                                capture_output=True, text=True, timeout=60)
        if result.returncode or result.stderr or (expect is not None and result.stdout != expect):
            raise RuntimeError(f"failure preservation test failed: exit {result.returncode}; {result.stderr[:1200]}")

    obj = out / "adapter.o"
    command([*cc, *flags, "-c", ROOT / "tests/audio/failure-injection/adapter.c", "-o", obj])
    objects = [obj, *([native / "focus.o"] if macos else [])]
    sdk_test = out / ("sdk-close" + (".exe" if windows else ""))
    command([*cc, *flags, "-DNDEBUG", ROOT / "tests/audio/failure-injection/sdk-close.c",
             *([native / "focus.o"] if macos else []), "-o", sdk_test, *libraries])
    command([sdk_test], "ok\n")
    archive = out / "libjai_audio_output.a"
    archive.unlink(missing_ok=True)
    command(["ar", "rcs", archive, *objects])
    shared = out / ("jai_audio_output.dll" if windows else
                    "libjai_audio_output." + ("dylib" if macos else "so"))
    command([*cc, *flags, "-dynamiclib" if macos else "-shared", *objects, "-o", shared, *libraries])
    for name in metadata["artifacts"]:
        if "stb_vorbis" in name:
            shutil.copy2(native / name, out / name)
    modules = stage_audio()
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"), JAIC_NATIVE_LIBS=str(out))
    base = [ROOT / "target/compiler/debug/jaic", ROOT / "tests/audio/failure-injection/lifetime.jai",
            "-import_dir", modules]
    command([*base, "-interp"], "ok\n", env)
    for optimization in ("-O0", "-O2"):
        executable = out / ("lifetime" + optimization + (".exe" if windows else ""))
        command([*base, optimization, "-exe", executable], env=env)
        command([executable], "ok\n", env)
    for osname in ("macos", "windows", "linux"):
        for cpu in ("x64", "arm64"):
            command([*base, "-check", "-os", osname, "-cpu", cpu], env=env)
    (out / "result.json").write_text(json.dumps({"kind": "controlled close-boundary failure with real SDK device",
        "platform": target, "audio_assertions": False, "modes": ["interpreter", "native-O0", "native-O2"],
        "device_open_required": True, "SDK_boundary_injection": "compiled/run with NDEBUG",
        "physical_or_SDK_generated_failure": False}, indent=2) + "\n")
    print("real SDK handle retained across injected close failure; retry/disposal passed interpreter/native O0/O2")


if __name__ == "__main__":
    try:
        main()
    finally:
        shutil.rmtree(ROOT / "stdlib/Sound_Player/test-stage", ignore_errors=True)
