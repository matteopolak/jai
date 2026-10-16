#!/usr/bin/env python3
"""Current shared SPSC channel: real local and separate-process mappings."""

import ctypes
import errno
import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile
import time
from portable_assertion_test_config import disabled_default_copy

ROOT = Path(__file__).resolve().parents[1]


def main():
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    work = Path(tempfile.mkdtemp(prefix="channel-lifecycle-", dir=target))
    disabled, captured = disabled_default_copy(ROOT, work)
    compiler = target / "debug/jaic"
    source = ROOT / "tests/portable-stdlib/channel-lifecycle.jai"
    source_hash = hashlib.sha256(source.read_bytes()).hexdigest()
    identity = dict(
        shared_head=subprocess.check_output(
            ["git", "rev-parse", "HEAD"], cwd=ROOT, text=True
        ).strip(),
        compiler_sha256=hashlib.sha256(compiler.read_bytes()).hexdigest(),
        source_hashes={
            name: hashlib.sha256(body).hexdigest() for name, body in captured.items()
        },
        test_sha256=source_hash,
        configuration_changes=["Basic/module.jai"],
    )
    (work / "identity.json").write_text(json.dumps(identity, indent=2) + "\n")
    rows = []

    def record(name, command, result, expected=""):
        passed = (
            result.returncode == 0 and result.stdout == expected and not result.stderr
        )
        rows.append(
            dict(
                name=name,
                command=list(map(str, command)),
                exit=result.returncode,
                stdout=result.stdout,
                stderr=result.stderr,
                passed=passed,
            )
        )
        (work / "results.json").write_text(json.dumps(rows, indent=2) + "\n")
        print(name, "PASS" if passed else "FAIL", flush=True)
        return passed

    def run(name, command, env, expected=""):
        result = subprocess.run(
            list(map(str, command)),
            cwd=ROOT,
            env=env,
            capture_output=True,
            text=True,
            timeout=120,
        )
        return record(name, command, result, expected)

    serial = 0
    libc = ctypes.CDLL(None, use_errno=True)
    libc.shm_unlink.argtypes = [ctypes.c_char_p]
    libc.shm_unlink.restype = ctypes.c_int
    for mode, library in [("enabled", ROOT / "stdlib"), ("disabled", disabled)]:
        env = dict(os.environ, JAIC_STDLIB=str(library))
        commands = [("interp", [compiler, source, "-interp", "--"])]
        for optimization in ["O0", "O2"]:
            executable = work / (mode + "-" + optimization)
            if run(
                mode + ":" + optimization + ":build",
                [compiler, source, "-" + optimization, "-exe", executable],
                env,
            ):
                commands.append((optimization, [executable]))
        for execution, base in commands:
            serial += 1
            name = (
                "cr-ipc-"
                + hashlib.sha256(str(work).encode()).hexdigest()[:10]
                + "-"
                + str(serial)
            )
            ready = work / (mode + "-" + execution + "-ready")
            label = mode + ":" + execution
            try:
                run(
                    label + ":local",
                    base + ["local", name, "unused", mode],
                    env,
                    "ok\n",
                )
                reader_cmd = list(map(str, base + ["reader", name, ready, mode]))
                reader = subprocess.Popen(
                    reader_cmd,
                    cwd=ROOT,
                    env=env,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                    text=True,
                )
                try:
                    deadline = time.monotonic() + 10
                    while (
                        (not ready.exists() or ready.read_bytes() != b"ready")
                        and reader.poll() is None
                        and time.monotonic() < deadline
                    ):
                        time.sleep(0.02)
                    if ready.exists() and ready.read_bytes() == b"ready":
                        run(
                            label + ":writer-process",
                            base + ["writer", name, "unused", mode],
                            env,
                            "ok\n",
                        )
                    stdout, stderr = reader.communicate(timeout=15)
                    result = subprocess.CompletedProcess(
                        reader_cmd, reader.returncode, stdout, stderr
                    )
                    record(label + ":reader-process", reader_cmd, result, "ok\n")
                finally:
                    if reader.poll() is None:
                        reader.kill()
                        reader.wait()
            finally:
                # Only this runner's exact unique name; failed tests never leave named objects behind.
                ctypes.set_errno(0)
                status = libc.shm_unlink(("/" + name).encode())
                error = ctypes.get_errno() if status == -1 else 0
                passed = status == 0 or (status == -1 and error == errno.ENOENT)
                rows.append(
                    dict(
                        name=label + ":cleanup",
                        sdk_result=status,
                        errno=error,
                        passed=passed,
                    )
                )
                (work / "results.json").write_text(json.dumps(rows, indent=2) + "\n")
                print(label + ":cleanup", "PASS" if passed else "FAIL", flush=True)
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    run("fixture-lint", [target / "debug/jailint", "-D", "warnings", source], env)
    owned = [
        "Shared_Memory_Channel/module.jai",
        "internal/ipc/channel-types.jai",
        "internal/ipc/channel.jai",
    ]
    for platform in ["macos", "linux", "windows"]:
        for cpu in ["x64", "arm64"]:
            run(
                platform + ":" + cpu + ":source",
                [compiler, source, "-check", "-os", platform, "-cpu", cpu],
                env,
            )
            backend = (
                "internal/ipc/channel-windows.jai"
                if platform == "windows"
                else "internal/ipc/channel-posix.jai"
            )
            run(
                platform + ":" + cpu + ":owned-lint",
                [
                    target / "debug/jailint",
                    "-D",
                    "warnings",
                    "-os",
                    platform,
                    "-cpu",
                    cpu,
                    "--context",
                    source,
                    "--manifest",
                    work / (platform + "-" + cpu + "-lint.json"),
                    *[ROOT / "stdlib" / name for name in owned + [backend]],
                ],
                env,
            )
    for path in [
        source,
        *[
            ROOT / "stdlib" / name
            for name in owned
            + ["internal/ipc/channel-posix.jai", "internal/ipc/channel-windows.jai"]
        ],
    ]:
        run("format:" + path.name, [target / "jaifmt", "--check", path], env)
    for name in owned + [
        "Basic/module.jai",
        "internal/ipc/channel-posix.jai",
        "internal/ipc/channel-windows.jai",
    ]:
        assert (ROOT / "stdlib" / name).read_bytes() == captured[name], (
            "owned source changed"
        )
    assert hashlib.sha256(source.read_bytes()).hexdigest() == source_hash, (
        "test changed"
    )
    assert all(
        (disabled / name).read_bytes() == body
        for name, body in captured.items()
        if name != "Basic/module.jai"
    ), "disabled source copy changed"
    print("receipt:", work, flush=True)
    raise SystemExit(0 if all(row["passed"] for row in rows) else 1)


if __name__ == "__main__":
    main()
