#!/usr/bin/env python3
"""Verify this audio worker's explicit scope using its own source-built tools."""
import os
import re
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
COMPILER = ROOT / "target/compiler/debug/jaic"
ENV = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"),
           JAIC_NATIVE_LIBS=str(ROOT / "target/audio-native"))
CASES = sorted((ROOT / "tests/audio").glob("*.jai"))
NEGATIVE = sorted((ROOT / "tests/audio/negative").glob("*.jai"))
OWNED = [ROOT / "stdlib/Sound_Player/module.jai"]
OWNED += sorted(p for p in (ROOT / "stdlib/internal/audio").glob("*.jai")
                if p.name != "wav.jai")
OWNED += CASES


def run(command, expected=None, cwd=ROOT):
    result = subprocess.run(list(map(str, command)), cwd=cwd, env=ENV,
                            capture_output=True, text=True, timeout=60)
    matches = expected(result.stdout) if callable(expected) else expected is None or result.stdout == expected
    if result.returncode or result.stderr or not matches:
        headlines = [line for line in (result.stderr + result.stdout).splitlines()
                     if "error:" in line or line.startswith("error[") or line.lstrip().startswith("-->")
                     or line.startswith("jailint:")]
        raise RuntimeError(f"{Path(str(command[0])).name}: exit {result.returncode}; "
                           + "; ".join(headlines[:8]) + ("; unexpected stdout" if not matches else ""))
    return result.stdout


def main():
    output = ROOT / "target/audio-tests"
    output.mkdir(parents=True, exist_ok=True)
    run([ROOT / "target/jaifmt", "--check", *OWNED, *NEGATIVE])
    windows_paths = [p for p in OWNED if p.stem == "windows-abi"]
    common_paths = [p for p in OWNED if p not in windows_paths]
    run([ROOT / "target/compiler/debug/jailint", "-D", "warnings", *common_paths])
    for cpu in ("x64", "arm64"):
        run([ROOT / "target/compiler/debug/jailint", "-D", "warnings", "--os", "windows", "--cpu", cpu,
             ROOT / "stdlib/Sound_Player/module.jai", *windows_paths])
    print("source-built jaifmt --check and warnings-denied jailint passed", flush=True)
    for case in CASES:
        if case.stem == "windows-abi":
            for cpu in ("x64", "arm64"):
                run([COMPILER, case, "-check", "-os", "windows", "-cpu", cpu], "")
            print("windows-abi.jai: Windows x64/ARM64 static ABI checks; native execution unavailable", flush=True)
            continue
        expected = (lambda out: out in {"native-device-opened\nok\n", "native-device-unavailable\nok\n"}) if case.stem in {"device-lifecycle", "streams", "compressed-stream"} else "ok\n"
        run([COMPILER, case, "-interp"], expected)
        for level in ("O0", "O2"):
            executable = output / f"{case.stem}-{level}"
            run([COMPILER, case, "-" + level, "-exe", executable], "")
            native_evidence = run([executable], expected, cwd=case.parent)
            if callable(expected):
                print(f"  {level}: {native_evidence.splitlines()[0]}", flush=True)
        for target_os in ("linux", "windows", "macos"):
            for cpu in ("x64", "arm64"):
                run([COMPILER, case, "-check", "-os", target_os, "-cpu", cpu], "")
        print(f"{case.name}: interpreter, native O0/O2 and six target checks passed", flush=True)
    for case in NEGATIVE:
        result = subprocess.run([COMPILER, case, "-check"], cwd=ROOT, env=ENV,
                                capture_output=True, text=True, timeout=60)
        expected = "sound_mutex" if case.stem == "private-mutex" else "lock_player"
        if result.returncode != 1 or f"unknown identifier `{expected}`" not in result.stderr:
            raise RuntimeError(f"{case.name}: expected private API rejection was not observed")
        print(f"{case.name}: expected private API rejection passed", flush=True)


if __name__ == "__main__":
    main()
