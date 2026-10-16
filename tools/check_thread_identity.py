#!/usr/bin/env python3
"""Check thread SDK storage and lifecycle; --native requires the serialized lease."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import platform
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
FIXTURES = [
    "tests/portable-stdlib/thread-pthread-layout.jai",
    "tests/portable-stdlib/thread-sdk-storage.jai",
    "tests/portable-stdlib/thread-native-identity.jai",
]
C_SOURCE = ROOT / "tests/portable-stdlib/thread-sdk-identity.c"


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def guard():
    paths = [ROOT / p for p in FIXTURES]
    paths += [C_SOURCE, Path(__file__)]
    paths += [ROOT / p for p in ["Cargo.toml", "Cargo.lock", "rust-toolchain.toml"]]
    for directory in ["stdlib", "crates", "jaifmt"]:
        paths += [
            p
            for p in (ROOT / directory).rglob("*")
            if p.is_file()
            and not p.name.startswith("._")
            and (p.suffix in {".jai", ".rs", ".c", ".h"} or p.name == "Cargo.toml")
        ]
    return {str(p.relative_to(ROOT)): digest(p) for p in sorted(set(paths))}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--linux-arm64-sysroot", type=Path, required=True)
    parser.add_argument("--native", action="store_true")
    args = parser.parse_args()
    if args.native and platform.system() not in {"Darwin", "Linux"}:
        parser.error("native POSIX controls require a real Mac/Linux host")
    base = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    work = Path(tempfile.mkdtemp(prefix="thread-identity-", dir=base))
    temporary = work / "tmp"
    temporary.mkdir()
    target = work / "tools"
    env = dict(
        os.environ,
        CARGO_TARGET_DIR=str(target),
        TMPDIR=str(temporary),
        JAIC_STDLIB=str(ROOT / "stdlib"),
        JAIC_NATIVE_LIBS=str(work),
        RUFF_CACHE_DIR=str(work / "ruff-cache"),
    )
    before = guard()
    rows = []

    def run(name, argv, stdout=None):
        result = subprocess.run(
            list(map(str, argv)),
            cwd=ROOT,
            env=env,
            capture_output=True,
            text=True,
            timeout=240,
        )
        passed = result.returncode == 0 and (stdout is None or result.stdout == stdout)
        rows.append(
            dict(
                name=name,
                argv=list(map(str, argv)),
                exit=result.returncode,
                stdout=result.stdout,
                stderr=result.stderr,
                passed=passed,
            )
        )
        (work / "commands.json").write_text(json.dumps(rows, indent=2) + "\n")
        print(name, "PASS" if passed else "FAIL", flush=True)
        return passed

    run(
        "Linux ARM64 real-header compilation (not execution)",
        [
            "clang",
            "--target=aarch64-linux-gnu",
            "--sysroot=" + str(args.linux_arm64_sysroot.resolve()),
            "-std=c11",
            "-Wall",
            "-Wextra",
            "-Werror",
            "-c",
            C_SOURCE,
            "-o",
            work / "thread-sdk-arm64.o",
        ],
    )
    if run(
        "fresh-tools",
        ["cargo", "build", "--locked", "--offline", "-p", "jaic-cli", "-p", "jailint"],
    ):
        compiler, lint = target / "debug/jaic", target / "debug/jailint"
        for system in ["windows", "linux", "macos"]:
            for cpu in ["x64", "arm64"]:
                fixtures = [FIXTURES[0]]
                if system != "windows":
                    fixtures += FIXTURES[1:]
                fixtures += [
                    "tests/platform-io/thread-contract.jai",
                    "tests/platform-io/thread-group-contract.jai",
                    "tests/portable-stdlib/thread-lifetime.jai",
                ]
                for fixture in fixtures:
                    run(
                        system + ":" + cpu + ":" + Path(fixture).name,
                        [
                            compiler,
                            ROOT / fixture,
                            "-check",
                            "-os",
                            system,
                            "-cpu",
                            cpu,
                        ],
                    )
                run(
                    "strict-lint:" + system + ":" + cpu,
                    [
                        lint,
                        "-D",
                        "warnings",
                        "-os",
                        system,
                        "-cpu",
                        cpu,
                        "--context",
                        ROOT / "tests/platform-io/thread-contract.jai",
                        "--manifest",
                        work / ("lint-" + system + "-" + cpu + ".json"),
                        ROOT / "stdlib/internal/thread/lifecycle.jai",
                        ROOT / "stdlib/internal/thread/types.jai",
                        *(
                            [ROOT / "stdlib/POSIX/declarations.jai"]
                            if system != "windows"
                            else []
                        ),
                    ],
                )
        formatter = work / "jaifmt"
        if run(
            "formatter-build",
            [compiler, ROOT / "jaifmt/main.jai", "-O2", "-exe", formatter],
        ):
            run("fixture-format", [formatter, "--check", *[ROOT / p for p in FIXTURES]])
        if args.native:
            archive = work / "libthread_sdk_identity.a"
            obj = work / "thread-sdk-host.o"
            if run(
                "host-sdk-build",
                [
                    "cc",
                    "-std=c11",
                    "-Wall",
                    "-Wextra",
                    "-Werror",
                    "-c",
                    C_SOURCE,
                    "-o",
                    obj,
                ],
            ):
                run("host-sdk-archive", ["ar", "rcs", archive, obj])
                exe = work / "sdk-control"
                if run(
                    "C-control-build",
                    [
                        "cc",
                        "-std=c11",
                        "-Wall",
                        "-Wextra",
                        "-Werror",
                        "-DTHREAD_SDK_MAIN=1",
                        C_SOURCE,
                        "-pthread",
                        "-o",
                        exe,
                    ],
                ):
                    run("C-control-run", [exe], "")
                for fixture in FIXTURES[1:]:
                    for mode in ["O0", "O2"]:
                        exe = work / (Path(fixture).stem + "-" + mode)
                        if run(
                            fixture + ":build:" + mode,
                            [compiler, ROOT / fixture, "-" + mode, "-exe", exe],
                        ):
                            run(fixture + ":native:" + mode, [exe], "ok\n")
    run("python-lint", ["ruff", "check", Path(__file__)])
    run("python-format", ["ruff", "format", "--check", Path(__file__)])
    after = guard()
    drift = sorted(
        k for k in before.keys() | after.keys() if before.get(k) != after.get(k)
    )
    report = dict(
        inputs=before,
        commands=rows,
        source_drift=drift,
        native_requested=args.native,
        host=platform.platform(),
        Linux_native_execution=args.native and platform.system() == "Linux",
        passed=not drift and all(r["passed"] for r in rows),
        compiler_sha256=digest(target / "debug/jaic")
        if (target / "debug/jaic").exists()
        else None,
    )
    (work / "summary.json").write_text(json.dumps(report, indent=2) + "\n")
    print(work / "summary.json", flush=True)
    return 0 if report["passed"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
