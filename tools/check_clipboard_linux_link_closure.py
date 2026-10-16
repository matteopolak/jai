#!/usr/bin/env python3
"""Capture real Jai link inputs; never link or execute a Linux native program."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import platform
import shlex
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--x11-cflags",
        help="explicit installed X11 SDK flags; otherwise query pkg-config",
    )
    args = parser.parse_args()
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    work = Path(tempfile.mkdtemp(prefix="clipboard-link-proof-", dir=target))
    native = work / "native"
    native.mkdir()
    temporary = work / "tmp"
    temporary.mkdir()
    env = dict(
        os.environ,
        CARGO_TARGET_DIR=str(target),
        TMPDIR=str(temporary),
        JAIC_STDLIB=str(ROOT / "stdlib"),
        JAIC_NATIVE_LIBS=str(native),
        RUSTUP_AUTO_INSTALL="0",
    )
    inputs = [
        ROOT / "stdlib/internal/clipboard/linux.jai",
        ROOT / "tools/build_portable_clipboard.py",
        ROOT / "tests/portable-stdlib/clipboard-linux-roundtrip.jai",
        Path(__file__),
    ]
    inputs += list((ROOT / "stdlib/internal/clipboard/native").glob("*.c"))
    inputs += list((ROOT / "stdlib/internal/clipboard/native").glob("*.h"))
    before = {str(p.relative_to(ROOT)): sha(p) for p in inputs}
    rows = []

    def run(name, command, expected=0):
        command = list(map(str, command))
        try:
            result = subprocess.run(
                command, cwd=ROOT, env=env, capture_output=True, text=True, timeout=240
            )
            row = dict(
                name=name,
                command=command,
                exit=result.returncode,
                stdout=result.stdout,
                stderr=result.stderr,
                passed=result.returncode == expected,
            )
        except (OSError, subprocess.TimeoutExpired) as error:
            row = dict(name=name, command=command, error=str(error), passed=False)
        rows.append(row)
        (work / "commands.json").write_text(json.dumps(rows, indent=2) + "\n")
        print(name, "PASS" if row["passed"] else "FAIL", flush=True)
        return row

    compiler = target / "debug/jaic"
    lint = target / "debug/jailint"
    built = run(
        "source-build",
        ["cargo", "build", "--locked", "--offline", "-p", "jaic-cli", "-p", "jailint"],
    )["passed"]
    flags = (
        run("configured-X11-SDK-flags", ["pkg-config", "--cflags", "x11"])
        if args.x11_cflags is None
        else None
    )
    source = ROOT / "stdlib/internal/clipboard/native"
    archive = native / "libportable_clipboard.a"
    objects_ready = flags["passed"] if flags else True
    sdk_flags = shlex.split(flags["stdout"] if flags else args.x11_cflags)
    if objects_ready:
        for name in ["data", "x11"]:
            result = run(
                "host-SDK-object:" + name,
                [
                    os.environ.get("CC", "cc"),
                    "-std=c11",
                    "-O2",
                    "-fPIC",
                    "-fvisibility=hidden",
                    "-Wall",
                    "-Wextra",
                    "-Werror",
                    "-pthread",
                    *sdk_flags,
                    "-c",
                    source / (name + ".c"),
                    "-o",
                    native / (name + ".o"),
                ],
            )
            objects_ready = objects_ready and result["passed"]
    if objects_ready:
        objects_ready = run(
            "host-real-source-archive",
            [
                os.environ.get("AR", "ar"),
                "rcs",
                archive,
                native / "data.o",
                native / "x11.o",
            ],
        )["passed"]
    # A diagnostic linker, never a fake successful linker/provider. A host SDK
    # archive may have a different object format than the Linux target; it is
    # used ONLY to exercise actual file selection/ordering before this sentinel.
    recorder = work / "linker-recorder"
    recorder.write_text(
        "#!/usr/bin/env python3\nimport json,os,sys\nfrom pathlib import Path\nPath(os.environ['CLIPBOARD_LINK_CAPTURE']).write_text(json.dumps(sys.argv[1:],indent=2)+'\\n')\nsys.exit(73)\n"
    )
    recorder.chmod(0o755)
    if built and objects_ready:
        env["JAIC_LINKER"] = str(recorder)
        for cpu, triple in [
            ("x64", "x86_64-unknown-linux-gnu"),
            ("arm64", "aarch64-unknown-linux-gnu"),
        ]:
            run(
                "source:" + cpu,
                [
                    compiler,
                    ROOT / "tests/portable-stdlib/clipboard-linux-roundtrip.jai",
                    "-check",
                    "-target",
                    triple,
                ],
            )
            run(
                "strict-lint:" + cpu,
                [
                    lint,
                    "-D",
                    "warnings",
                    "-target",
                    triple,
                    "--context",
                    ROOT / "tests/portable-stdlib/clipboard-linux-roundtrip.jai",
                    ROOT / "stdlib/internal/clipboard/linux.jai",
                ],
            )
            for optimization in ["-O0", "-O2"]:
                capture = work / ("argv-" + cpu + optimization + ".json")
                env["CLIPBOARD_LINK_CAPTURE"] = str(capture)
                result = run(
                    "link-argv-capture:" + cpu + optimization,
                    [
                        compiler,
                        ROOT / "tests/portable-stdlib/clipboard-linux-roundtrip.jai",
                        "-target",
                        triple,
                        optimization,
                        "-exe",
                        work / ("NOT-LINKED-" + cpu + optimization),
                    ],
                    expected=1,
                )
                valid = False
                indices = {}
                if result["passed"] and capture.exists() and "73" in result["stderr"]:
                    argv = json.loads(capture.read_text())
                    for library in ["X11", "pthread"]:
                        matches = [
                            i
                            for i, arg in enumerate(argv)
                            if arg == "-l" + library
                            or Path(arg).name.startswith("lib" + library + ".")
                        ]
                        if matches:
                            indices[library] = min(matches)
                    if str(archive) in argv and len(indices) == 2:
                        indices["archive"] = argv.index(str(archive))
                        valid = (
                            indices["archive"] < indices["X11"]
                            and indices["archive"] < indices["pthread"]
                            and not any("--no-as-needed" in arg for arg in argv)
                        )
                rows.append(
                    dict(
                        name="required-static-closure:" + cpu + optimization,
                        indices=indices,
                        passed=valid,
                        native_linked=False,
                        native_executed=False,
                    )
                )
                print(
                    "required-static-closure:" + cpu + optimization,
                    "PASS" if valid else "FAIL",
                    flush=True,
                )
    after = {str(p.relative_to(ROOT)): sha(p) for p in inputs}
    drift = [p for p in before if before[p] != after[p]]
    receipt = dict(
        commands=rows,
        source_inputs=before,
        source_drift=drift,
        compiler_sha256=sha(compiler) if compiler.exists() else None,
        archive_sha256=sha(archive) if archive.exists() else None,
        archive_host=platform.platform(),
        sdk_flags_source="pkg-config"
        if flags
        else "explicit --x11-cflags (verified by real C compilation)",
        qualification="Host SDK archive only for real linker input selection. Recorder deliberately exits73. No Linux native link, interpreter, X11/display, GUI or executable run.",
        native_verified=False,
        passed=not drift and all(row["passed"] for row in rows),
    )
    (work / "summary.json").write_text(json.dumps(receipt, indent=2) + "\n")
    print(work / "summary.json", flush=True)
    return 0 if receipt["passed"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
