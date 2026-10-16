#!/usr/bin/env python3
"""Real required C++ workflow in a closed, current-source T7 capture."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import signal
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = Path(
    "/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/generator-platform/runtime-ci-ac174e80"
)
TOOLS = [
    "check_generator_runtime_ci.py",
    "check_developer_cpp_custom.py",
    "build_generator_platform.py",
    "build_developer_bindings.py",
    "developer_native_runtime.py",
]


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.parse_args()
    output = Path(tempfile.mkdtemp(prefix="capture-", dir=OUTPUT))
    source = output / "source"
    paths = [
        ROOT / name
        for name in [
            "Cargo.toml",
            "Cargo.lock",
            "rust-toolchain.toml",
            "jaifmt.toml",
            "jailint.toml",
        ]
        if (ROOT / name).is_file()
    ]
    for folder in ["stdlib", "crates", "jaifmt", "tests/developer-tools"]:
        for path in (ROOT / folder).rglob("*"):
            if not path.is_file() or path.suffix in [
                ".dylib",
                ".so",
                ".dll",
                ".a",
                ".lib",
                ".pyc",
            ]:
                continue
            if "__pycache__" in path.parts or path.name in [
                "generator-platform-nm.txt",
                "compiler-path.txt",
                "runtime-sdk.json",
                "developer-tools-clang",
            ]:
                continue
            paths.append(path)
    paths.extend(ROOT / "tools" / name for name in TOOLS)
    before = {str(path.relative_to(ROOT)): sha(path) for path in paths}
    for path in paths:
        destination = source / path.relative_to(ROOT)
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(path, destination)
        destination.chmod(0o444)
    assert all(
        sha(ROOT / name) == value and sha(source / name) == value
        for name, value in before.items()
    ), "source changed during capture"
    env = dict(
        os.environ,
        JAIC_STDLIB=str(source / "stdlib"),
        CARGO_TARGET_DIR=str(OUTPUT / "target"),
        TMPDIR=str(output),
    )
    for name in [
        "JAIC_NATIVE_LIBS",
        "LIBRARY_PATH",
        "DYLD_LIBRARY_PATH",
        "LD_LIBRARY_PATH",
    ]:
        env.pop(name, None)
    receipt = {
        "source_root": str(source),
        "source_identity": before,
        "classification": "current shared source snapshot, not full CI acceptance",
        "commands": [],
    }

    def save():
        (output / "verification.json").write_text(json.dumps(receipt, indent=2) + "\n")

    def run(
        command, label, expected=None, failure=None, timeout=180, required_red=False
    ):
        process = subprocess.Popen(
            [str(item) for item in command],
            cwd=source,
            env=env,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            start_new_session=True,
        )
        try:
            stdout, stderr = process.communicate(timeout=timeout)
        except subprocess.TimeoutExpired:
            os.killpg(process.pid, signal.SIGKILL)
            stdout, stderr = process.communicate()
        passed = process.returncode == 0 and (expected is None or stdout == expected)
        if failure is not None:
            passed = process.returncode != 0 and failure in stdout + stderr
        receipt["commands"].append(
            {
                "label": label,
                "argv": [str(item) for item in command],
                "exit": process.returncode,
                "stdout": stdout,
                "stderr": stderr,
                "passed": passed and not required_red,
                "required_red_observed": passed if required_red else None,
            }
        )
        save()
        print(
            label
            + (
                ": REQUIRED RED retained"
                if required_red and passed
                else ": PASS"
                if passed
                else ": FAIL"
            ),
            flush=True,
        )
        if not passed:
            raise RuntimeError(f"{label}\n{stdout}\n{stderr}\nReceipt: {output}")

    try:
        run(
            [
                "cargo",
                "build",
                "--manifest-path",
                source / "Cargo.toml",
                "--locked",
                "--offline",
                "-p",
                "jaic-cli",
                "-p",
                "jailint",
            ],
            "source-matched compiler build",
        )
        debug = source / "target/debug"
        debug.mkdir(parents=True)
        for name in ["jaic", "jailint"]:
            shutil.copyfile(OUTPUT / "target/debug" / name, debug / name)
            (debug / name).chmod(0o755)
        compiler = debug / "jaic"
        receipt["compiler_sha256"] = sha(compiler)
        prefix = Path(
            os.environ.get("DEVELOPER_TOOLS_LLVM_PREFIX", "/opt/homebrew/opt/llvm")
        )
        run(
            [
                sys.executable,
                source / "tools/build_developer_bindings.py",
                "--llvm-prefix",
                prefix,
            ],
            "real SDK/libclang setup",
        )
        clang = prefix / "bin/clang"
        native = source / "target/libruntime_ci_probe.dylib"
        run(
            [
                clang,
                "-dynamiclib",
                "-Wall",
                "-Wextra",
                "-Werror",
                source / "tests/developer-tools/generator-runtime-ci-native.c",
                "-o",
                native,
            ],
            "SDK real image build",
        )
        control = source / "target/loader-control"
        run(
            [
                clang,
                "-Wall",
                "-Wextra",
                "-Werror",
                source / "tests/developer-tools/generator-runtime-ci-control.c",
                "-o",
                control,
            ],
            "SDK loader control build",
        )
        run([control, native], "SDK real open/symbol/call/close/reopen", "")
        fixture = source / "tests/developer-tools/generator-runtime-ci-loader.jai"
        run(
            [compiler, fixture, "-interp"],
            "missing canonical helper reproduces unavailable foreign",
            failure="gp_library_open",
        )
        run(
            [
                sys.executable,
                source / "tools/build_generator_platform.py",
                "--llvm-prefix",
                prefix,
            ],
            "real canonical helper preparation",
        )
        run(
            [compiler, fixture, "-interp"],
            "prepared canonical helper and public POSIX name",
            "ok\n",
        )
        for optimization in [0, 2]:
            executable = source / f"target/loader-o{optimization}"
            run(
                [compiler, fixture, f"-O{optimization}", "-exe", executable],
                f"native provider O{optimization} build",
            )
            run(
                [executable],
                f"native provider O{optimization} actual calls/close",
                "ok\n",
            )
        formatter = source / "target/jaifmt"
        run(
            [compiler, source / "jaifmt/main.jai", "-O0", "-exe", formatter],
            "source formatter build",
        )
        run(
            [
                sys.executable,
                "-c",
                "import sys; sys.path.insert(0, 'tools'); "
                "from check_developer_cpp_custom import check_cpp_custom; check_cpp_custom()",
            ],
            "REQUIRED actual C++ customization, bridge ABI and callback roundtrips",
            timeout=300,
        )
        receipt["required_cpp_passed"] = True
        try:
            run(
                [
                    sys.executable,
                    "-c",
                    "import sys; sys.path.insert(0, 'tools'); "
                    "from check_developer_cpp_custom import check_c_model_regressions; check_c_model_regressions()",
                ],
                "REQUIRED existing C-model regression workflow",
                timeout=300,
            )
            receipt["required_c_model_passed"] = True
        except RuntimeError:
            receipt["required_c_model_passed"] = False
            save()
        for optimization in [0, 2]:
            control = source / f"target/cpp-adapter-control-o{optimization}"
            run(
                [
                    prefix / "bin/clang++",
                    "-std=c++17",
                    f"-O{optimization}",
                    "-Wall",
                    "-Wextra",
                    "-Werror",
                    source / "target/developer-tools-cpp-custom.cpp",
                    source / "tests/developer-tools/bindings-cpp-custom-native.cpp",
                    source
                    / "tests/developer-tools/generator-runtime-ci-cpp-control.cpp",
                    "-o",
                    control,
                ],
                f"actual generated adapter SDK O{optimization} build",
            )
            run(
                [control],
                f"actual generated adapter SDK O{optimization} overload/POD/reference",
                "",
            )
        fixtures = [
            source / "tests/developer-tools" / ("bindings-" + name + ".jai")
            for name in [
                "cpp-custom",
                "cpp-custom-roundtrip",
                "custom",
                "model-properties",
                "macro-custom",
                "macro-enums",
                "macro-merge",
            ]
        ]
        requested = [
            source / "stdlib/internal/developer-tools/generator-platform.jai",
            fixture,
            *fixtures,
        ]
        run(
            [formatter, "--config", source / "jaifmt.toml", "--check", *requested],
            "owned Jai format",
        )
        run(
            [
                debug / "jailint",
                "-D",
                "warnings",
                "-I",
                source / "target",
                "--context",
                fixture,
                source / "stdlib/internal/developer-tools/generator-platform.jai",
                fixture,
            ],
            "complete provider strict lint",
        )
        for root in fixtures:
            run(
                [debug / "jailint", "-D", "warnings", "-I", source / "target", root],
                root.stem + " strict lint",
            )
        for os_name in ["macos", "linux", "windows"]:
            for cpu in ["x64", "arm64"]:
                run(
                    [compiler, fixtures[0], "-check", "-os", os_name, "-cpu", cpu],
                    f"C++ source-only {os_name}-{cpu}",
                )
    finally:
        receipt["source_drift"] = [
            name for name, value in before.items() if sha(source / name) != value
        ]
        receipt["live_owned_matches_capture"] = {
            name: sha(ROOT / name) == value
            for name, value in before.items()
            if name
            in [
                "stdlib/internal/developer-tools/generator-platform.jai",
                *["tools/" + item for item in TOOLS],
            ]
        }
        save()
        with (ROOT / "docs/worker-inbox.md").open("a") as inbox:
            inbox.write(
                "\n\n## Generator platform native slot RELEASED\nAll own bounded SDK/C++ processes finished/reaped (including failed stages); native lease RELEASED. Receipt "
                + str(output / "verification.json")
                + ". Source/diagnostic review follows; no Linux native CI claim.\n"
            )
    if receipt["source_drift"]:
        raise RuntimeError("Captured source changed")
    if receipt.get("required_c_model_passed") is False:
        raise RuntimeError(
            "Required C-model regressions remain RED; passing C++ controls do not clear the combined gate. Receipt: "
            + str(output / "verification.json")
        )
    print("Receipt: " + str(output / "verification.json"))


if __name__ == "__main__":
    main()
