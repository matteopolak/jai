#!/usr/bin/env python3
"""Pool value ownership and Unix Thread assertion-configuration regressions.

Compose NEW producers only under target/. Peer checkouts are read-only. Changing
both staged Basic parameter defaults tests Thread's default import instance;
changing only the audio caller's specialization does not change that instance.
"""
import os
from pathlib import Path
import shutil
import subprocess
import check_portable_time_foundation as foundation

ROOT = Path(__file__).resolve().parents[1]
COMPILER = ROOT / "target/compiler/debug/jaic"
LIBRARY = foundation.LIBRARY
OUTPUT = ROOT / "target/portable-lifecycles"


def compose(enabled):
    foundation.compose()
    for name in ["Pool", "Thread", "internal/allocation", "internal/thread"]:
        shutil.copytree(ROOT / "stdlib" / name, LIBRARY / name, dirs_exist_ok=True)
    for name in ["Basic/module.jai", "internal/basic/module.jai"]:
        path = LIBRARY / name
        text = path.read_text()
        if text.count("ENABLE_ASSERT := true") != 1:
            raise RuntimeError(f"unexpected NEW Basic parameter shape: {path}")
        path.write_text(text.replace("ENABLE_ASSERT := true", f"ENABLE_ASSERT := {str(enabled).lower()}"))
    return dict(os.environ, JAIC_STDLIB=str(LIBRARY))


def run(source, env, expected):
    for mode in ["interp", "O0", "O2", "x64-O0", "x64-O2"]:
        command = [str(COMPILER), "-interp", str(source)]
        if mode != "interp":
            executable = OUTPUT / (source.stem + "-" + mode)
            cpu = ["-target", "x86_64-apple-darwin"] if mode.startswith("x64-") else []
            optimization = mode.split("-")[-1]
            subprocess.run([str(COMPILER), str(source), "-" + optimization, *cpu, "-exe", str(executable)],
                           env=env, cwd=ROOT, check=True, timeout=120)
            command = [str(executable)]
        result = subprocess.run(command, env=env, cwd=ROOT, capture_output=True, text=True, timeout=30)
        if result.returncode or result.stdout != expected or result.stderr:
            raise RuntimeError(f"{command!r}: exit={result.returncode}\n{result.stdout}{result.stderr}")
        print(f"passed {source.name} {mode}", flush=True)


def main():
    import argparse
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--only", choices=["pool", "thread"])
    args = parser.parse_args()
    OUTPUT.mkdir(parents=True, exist_ok=True)
    if args.only != "thread":
        env = compose(True)
        for source in [ROOT / "tests/portable-stdlib/pool-value-lifetime.jai",
                       ROOT.parent / "foundations/tests/portable-stdlib/basic-leak-reports.jai",
                       ROOT / "tests/portable-stdlib/pool-unmapping.jai",
                       ROOT / "tests/portable-stdlib/pool-size-limits.jai"]:
            run(source, env, "ok\n")
    if args.only != "pool":
        for enabled in [True, False]:
            env = compose(enabled)
            print(f"Thread default Basic ENABLE_ASSERT={enabled}", flush=True)
            run(ROOT.parent / "audio/tests/audio/dependencies/thread-no-assert.jai", env,
                "semaphore-after-init-signal: SUCCESS\n")
            run(ROOT / "tests/portable-stdlib/thread-configured/optional-assert.jai", env, "ok\n")
            run(ROOT / "tests/portable-stdlib/thread-configured/error-retention.jai", env, "ok\n")
            subprocess.run([str(ROOT / "target/compiler/debug/jailint"), "-D", "warnings",
                            str(LIBRARY / "Pool/module.jai"), str(LIBRARY / "internal/allocation/pool.jai"),
                            str(LIBRARY / "Thread/module.jai"), str(LIBRARY / "internal/thread"),
                            str(ROOT / "tests/portable-stdlib/pool-value-lifetime.jai"),
                            str(ROOT / "tests/portable-stdlib/pool-unmapping.jai"),
                            str(ROOT / "tests/portable-stdlib/thread-configured")],
                           env=env, cwd=ROOT, check=True, timeout=120)
            for cpu in ["x64", "arm64"]:
                subprocess.run([str(COMPILER), "-check", "-os", "linux", "-cpu", cpu,
                                str(ROOT / "tests/portable-stdlib/thread-configured/optional-assert.jai")],
                               env=env, cwd=ROOT, check=True, timeout=120)
            print("focused strict lint and Linux x64/ARM64 source checks passed", flush=True)


if __name__ == "__main__":
    main()
