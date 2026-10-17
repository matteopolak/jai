#!/usr/bin/env python3
"""Source-matched required C-model producers and actual generated consumers."""

import hashlib
import json
import os
from pathlib import Path
import shutil
import signal
import subprocess
import sys
import tempfile
import time

import build_developer_bindings as sdk

ROOT = Path(__file__).resolve().parents[1]
BASE = Path(
    "/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/generator-platform/resolved-contract-fixtures-03"
)
TARGET = BASE.parent / "runtime-ci-ac174e80/target"
TOOLS = [
    "build_developer_bindings.py",
    "build_generator_platform.py",
    "developer_native_runtime.py",
    "check_generator_contract_fixtures.py",
]


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    BASE.mkdir(parents=True, exist_ok=True)
    out = Path(tempfile.mkdtemp(prefix="capture-", dir=BASE))
    source = out / "source"
    paths = [
        ROOT / n for n in ["Cargo.toml", "Cargo.lock", "jaifmt.toml", "jailint.toml"]
    ]
    for directory in ["stdlib", "crates", "jaifmt", "tests/developer-tools"]:
        paths.extend(
            p
            for p in (ROOT / directory).rglob("*")
            if p.is_file()
            # These concurrently edited, unrelated modules are not dependencies
            # of any selected root. Actual checked-file manifests guard closure.
            and not (
                directory == "stdlib"
                and p.relative_to(ROOT / "stdlib").parts[0] == "Input"
            )
            and not (
                directory == "stdlib"
                and p.relative_to(ROOT / "stdlib").parts[:2] == ("Extensions", "Http")
            )
            and p.suffix not in {".dylib", ".so", ".dll", ".a", ".lib", ".pyc"}
            and "__pycache__" not in p.parts
            and not p.name.startswith("._")
            and p.name
            not in {
                "developer-tools-clang",
                "compiler-path.txt",
                "runtime-sdk.json",
                "generator-platform-nm.txt",
            }
        )
    paths.extend(ROOT / "tools" / n for n in TOOLS)
    identity = {str(p.relative_to(ROOT)): sha(p) for p in paths}
    (out / "capture-inputs.json").write_text(json.dumps(identity, indent=2) + "\n")
    for p in paths:
        dest = source / p.relative_to(ROOT)
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(p, dest)
        dest.chmod(0o444)
    changed = [
        n for n, h in identity.items() if sha(ROOT / n) != h or sha(source / n) != h
    ]
    if changed:
        (out / "capture-input-failure.json").write_text(
            json.dumps({"changed": changed, "passed": False}, indent=2) + "\n"
        )
        with (ROOT / "docs/worker-inbox.md").open("a") as inbox:
            inbox.write(
                "\n\n## Generator contract capture-only slot RELEASED\n"
                "Shared source changed during capture; rejected before children ran. "
                + str(out / "capture-input-failure.json")
                + "\n"
            )
        raise RuntimeError(f"Shared source changed during capture: {changed}")
    env = dict(
        os.environ,
        CARGO_TARGET_DIR=str(TARGET),
        JAIC_STDLIB=str(source / "stdlib"),
        TMPDIR=str(out),
        PYTHONDONTWRITEBYTECODE="1",
    )
    for n in [
        "JAIC_NATIVE_LIBS",
        "LIBRARY_PATH",
        "DYLD_LIBRARY_PATH",
        "LD_LIBRARY_PATH",
    ]:
        env.pop(n, None)
    receipt = {"source": str(source), "source_identity": identity, "commands": []}
    deadline = time.monotonic() + 600

    def save():
        (out / "verification.json").write_text(json.dumps(receipt, indent=2) + "\n")

    def run(argv, label, expected=None, timeout=90):
        remaining = deadline - time.monotonic()
        if remaining <= 0:
            raise RuntimeError("Bounded600-second source/build/runtime slot exhausted")
        timeout = min(timeout, remaining)
        process = subprocess.Popen(
            [str(x) for x in argv],
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
        if expected is not None:
            passed = passed and not stderr
        receipt["commands"].append(
            dict(
                label=label,
                argv=[str(x) for x in argv],
                exit=process.returncode,
                stdout=stdout,
                stderr=stderr,
                passed=passed,
            )
        )
        save()
        print(label + (": PASS" if passed else ": FAIL"), flush=True)
        if not passed:
            raise RuntimeError(f"{label}\n{stdout}\n{stderr}\nReceipt: {out}")

    try:
        run(
            [
                "cargo",
                "build",
                "--locked",
                "--offline",
                "-p",
                "jaic-cli",
                "-p",
                "jailint",
            ],
            "source-matched compiler/linter build",
            timeout=240,
        )
        debug = source / "target/debug"
        debug.mkdir(parents=True)
        for name in ["jaic", "jailint"]:
            shutil.copyfile(TARGET / "debug" / name, debug / name)
            (debug / name).chmod(0o755)
        jaic = debug / "jaic"
        receipt["compiler_sha256"] = sha(jaic)
        prefix = sdk.llvm_prefix()
        flags = sdk.shared_flags()
        run(
            [
                sys.executable,
                "tools/build_developer_bindings.py",
                "--llvm-prefix",
                prefix,
            ],
            "official SDK/libclang preparation",
        )
        run(
            [
                sys.executable,
                "tools/build_generator_platform.py",
                "--llvm-prefix",
                prefix,
            ],
            "real canonical platform provider preparation",
        )

        def native_image(name, input_path, optimization=2):
            run(
                [
                    prefix / "bin/clang",
                    "-std=c11",
                    f"-O{optimization}",
                    "-Wall",
                    "-Wextra",
                    "-Werror",
                    *flags,
                    input_path,
                    "-o",
                    sdk.shared_library(name, source / "target"),
                ],
                f"real native {name} SDK O{optimization}",
                "",
            )

        for name, input_name in [
            ("bindings", "input"),
            ("properties", "model-properties"),
            ("macros", "macro-values"),
            ("merge", "macro-merge"),
        ]:
            native_image(
                "developer_tools_" + name,
                f"tests/developer-tools/bindings-{input_name}.c",
            )

        def exercise(name, expected="ok\n", include=False, collect_failures=False):
            fixture = source / "tests/developer-tools" / (name + ".jai")
            includes = ["-I", source / "target"] if include else []
            failures = []

            def attempt(argv, label, expected, timeout=90):
                try:
                    run(argv, label, expected, timeout=timeout)
                    return True
                except RuntimeError:
                    if not collect_failures:
                        raise
                    failures.append(label)
                    return False

            attempt(
                [jaic, fixture, "-interp", *includes], name + " interpreter", expected
            )
            for optimization in [0, 2]:
                executable = source / f"target/{name}-o{optimization}"
                built = attempt(
                    [jaic, fixture, f"-O{optimization}", "-exe", executable, *includes],
                    name + f" O{optimization} build",
                    "",
                )
                if built:
                    attempt(
                        [executable],
                        name + f" O{optimization} runtime",
                        expected,
                        timeout=30,
                    )
            if failures:
                raise RuntimeError(f"Required modes failed: {failures}")

        original_failures = []
        for name in [
            "bindings-custom",
            "bindings-model-properties",
            "bindings-macro-custom",
            "bindings-macro-enums",
            "bindings-macro-merge",
        ]:
            try:
                expected = "ok\n"
                if name == "bindings-custom":
                    expected = "Bindings_Generator: omitted forward_call: missing foreign library\nok\n"
                exercise(name, expected, include=True, collect_failures=True)
            except RuntimeError:
                original_failures.append(name)
        receipt["required_original_failures"] = original_failures
        save()
        consumer_failures = []
        for name in [
            "bindings-custom-roundtrip",
            "bindings-model-properties-roundtrip",
            "bindings-macro-custom-roundtrip",
            "bindings-macro-enums-roundtrip",
            "bindings-macro-merge-roundtrip",
            "bindings-macro-mixed-values",
        ]:
            try:
                exercise(name, include=True, collect_failures=True)
            except RuntimeError:
                consumer_failures.append(name)
        receipt["required_consumer_failures"] = consumer_failures
        save()
        formatter = source / "target/jaifmt"
        run(
            [jaic, source / "jaifmt/main.jai", "-O0", "-exe", formatter],
            "source-matched formatter build",
            "",
        )
        checked_roots = [
            "bindings-custom",
            "bindings-model-properties",
            "bindings-macro-custom",
            "bindings-macro-enums",
            "bindings-macro-merge",
            "bindings-custom-roundtrip",
            "bindings-model-properties-roundtrip",
            "bindings-macro-custom-roundtrip",
            "bindings-macro-enums-roundtrip",
            "bindings-macro-merge-roundtrip",
            "bindings-macro-mixed-values",
        ]
        source_failures = []
        for name in checked_roots:
            fixture = source / "tests/developer-tools" / (name + ".jai")
            try:
                run(
                    [
                        debug / "jailint",
                        "-D",
                        "warnings",
                        "-I",
                        source / "target",
                        "--checked-files",
                        out / (name + "-checked.txt"),
                        "--manifest",
                        out / (name + "-lint.json"),
                        fixture,
                    ],
                    name + " strict lint",
                    "",
                )
                checked = (out / (name + "-checked.txt")).read_text().splitlines()
                assert checked and all(
                    (source / p).resolve().is_relative_to(source) for p in checked
                ), "Checked source escaped the immutable capture"
            except RuntimeError:
                source_failures.append(name)
        run(
            [
                formatter,
                "--config",
                source / "jaifmt.toml",
                "--check",
                source / "tests/developer-tools/bindings-custom.jai",
                source / "tests/developer-tools/bindings-macro-enums.jai",
                source / "tests/developer-tools/bindings-macro-mixed-values.jai",
            ],
            "owned fixture source format",
            "",
        )
        receipt["required_source_failures"] = source_failures
        receipt["native_artifacts"] = {
            str(p.relative_to(source)): {
                "sha256": sha(p),
                "header": p.read_bytes()[:4].hex(),
            }
            for p in (source / "target").iterdir()
            if p.is_file() and p.suffix in {".dylib", ".so"}
        }
        save()
        if original_failures or consumer_failures or source_failures:
            raise RuntimeError(
                f"Required generator failures: producers={original_failures}; consumers={consumer_failures}; source={source_failures}; receipt: {out}"
            )
    finally:
        receipt["source_drift"] = [
            n for n, h in identity.items() if sha(source / n) != h
        ]
        save()
        with (ROOT / "docs/worker-inbox.md").open("a") as inbox:
            inbox.write(
                "\n\n## Generator contract fixtures runtime slot RELEASED\nAll bounded own children reaped; receipt "
                + str(out / "verification.json")
                + ". Required failure rows remain failures; no implied full CI acceptance.\n"
            )
    assert not receipt["source_drift"]
    print("Receipt: " + str(out / "verification.json"))


if __name__ == "__main__":
    main()
