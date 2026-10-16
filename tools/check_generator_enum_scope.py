#!/usr/bin/env python3
"""Pinned SDK/model enum-scope reduction and required C-model runtime controls."""

import argparse
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import shutil
import signal
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
BASE = Path(
    "/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/generator-model/shared-target/enum-scope"
)
BUILDERS = [
    "build_developer_bindings.py",
    "build_generator_platform.py",
    "developer_native_runtime.py",
    "check_developer_cpp_custom.py",
    "check_generator_enum_scope.py",
]


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--diagnose", action="store_true")
    args = parser.parse_args()
    BASE.mkdir(parents=True, exist_ok=True)
    out = Path(tempfile.mkdtemp(prefix="capture-", dir=BASE))
    source = out / "source"
    paths = [
        ROOT / n for n in ["Cargo.toml", "Cargo.lock", "jaifmt.toml", "jailint.toml"]
    ]
    for folder in ["stdlib", "crates", "jaifmt", "tests/developer-tools"]:
        paths.extend(
            p
            for p in (ROOT / folder).rglob("*")
            if p.is_file()
            and p.suffix not in [".dylib", ".so", ".dll", ".a", ".lib", ".pyc"]
            and "__pycache__" not in p.parts
            and p.name
            not in [
                "developer-tools-clang",
                "compiler-path.txt",
                "runtime-sdk.json",
                "generator-platform-nm.txt",
            ]
        )
    paths.extend(ROOT / "tools" / n for n in BUILDERS)
    identity = {str(p.relative_to(ROOT)): sha(p) for p in paths}
    for path in paths:
        dest = source / path.relative_to(ROOT)
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(path, dest)
        dest.chmod(0o444)
    assert all(
        sha(ROOT / n) == h and sha(source / n) == h for n, h in identity.items()
    ), "Source changed while capturing"
    env = dict(
        os.environ,
        CARGO_TARGET_DIR=str(BASE / "target"),
        JAIC_STDLIB=str(source / "stdlib"),
        TMPDIR=str(out),
    )
    for key in [
        "JAIC_NATIVE_LIBS",
        "LIBRARY_PATH",
        "DYLD_LIBRARY_PATH",
        "LD_LIBRARY_PATH",
    ]:
        env.pop(key, None)
    receipt = dict(
        source=str(source), source_identity=identity, commands=[], passed=False
    )

    def save():
        (out / "verification.json").write_text(json.dumps(receipt, indent=2) + "\n")

    def run(
        argv,
        label,
        expected=None,
        expect_failure=None,
        timeout=60,
        setup=False,
        marker=None,
    ):
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
        # SDK relocation re-signs copied images after install_name_tool warns.
        # Retain setup output; source/runtime commands require empty stderr.
        passed = process.returncode == 0 and (setup or not stderr)
        if expected is not None:
            passed = passed and stdout == expected
        if marker is not None:
            passed = passed and stdout.endswith(marker)
        if expect_failure:
            passed = process.returncode != 0 and expect_failure in stdout + stderr
        receipt["commands"].append(
            dict(
                argv=[str(x) for x in argv],
                label=label,
                exit=process.returncode,
                stdout=stdout,
                stderr=stderr,
                passed=passed,
                expected_failure=expect_failure,
            )
        )
        save()
        print(f"{label}: {'PASS' if passed else 'FAIL'}", flush=True)
        if not passed:
            raise RuntimeError(f"{label}\n{stdout}\n{stderr}")

    try:
        # Cargo warnings/build progress are ordinary stderr, retained separately.
        command = [
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
        ]
        result = subprocess.run(
            [str(x) for x in command],
            cwd=source,
            env=env,
            capture_output=True,
            text=True,
            timeout=300,
        )
        receipt["build"] = dict(
            argv=[str(x) for x in command],
            exit=result.returncode,
            stdout=result.stdout,
            stderr=result.stderr,
        )
        save()
        assert result.returncode == 0, result.stderr
        debug = source / "target/debug"
        debug.mkdir(parents=True)
        for name in ["jaic", "jailint"]:
            shutil.copyfile(BASE / "target/debug" / name, debug / name)
            (debug / name).chmod(0o555)
        compiler = debug / "jaic"
        receipt["compiler_sha256"] = sha(compiler)
        receipt["binaries"] = {
            str(debug / name): sha(debug / name) for name in ["jaic", "jailint"]
        }
        prefix = Path("/opt/homebrew/opt/llvm")
        for builder in ["build_developer_bindings.py", "build_generator_platform.py"]:
            run(
                [sys.executable, source / "tools" / builder, "--llvm-prefix", prefix],
                builder,
                setup=True,
            )
        for name, stem in [
            ("bindings", "input"),
            ("properties", "model-properties"),
            ("macros", "macro-values"),
            ("merge", "macro-merge"),
        ]:
            run(
                [
                    prefix / "bin/clang",
                    "-std=c11",
                    "-O2",
                    "-Wall",
                    "-Wextra",
                    "-Werror",
                    "-dynamiclib",
                    source / f"tests/developer-tools/bindings-{stem}.c",
                    "-o",
                    source / f"target/libdeveloper_tools_{name}.dylib",
                ],
                f"actual C input {name}",
            )
        for optimization in [0, 2]:
            oracle = out / f"enum-sdk-O{optimization}"
            run(
                [
                    prefix / "bin/clang",
                    "-std=c11",
                    f"-O{optimization}",
                    "-Wall",
                    "-Wextra",
                    "-Werror",
                    "-I",
                    prefix / "include",
                    source / "tests/developer-tools/generator-model-enum-scope-sdk.c",
                    "-L",
                    prefix / "lib",
                    f"-Wl,-rpath,{prefix / 'lib'}",
                    "-lclang",
                    "-o",
                    oracle,
                ],
                f"SDK enum oracle O{optimization} build",
            )
            run(
                [oracle, source / "tests/developer-tools/bindings-input.h"],
                f"SDK enum underlying/value O{optimization}",
            )
            run(
                [oracle, source / "tests/developer-tools/bindings-model-input.h"],
                f"SDK forward/incomplete O{optimization}",
            )
        reduction = source / "tests/developer-tools/generator-model-enum-scope.jai"
        run(
            [compiler, reduction, "-interp"],
            "canonical enum diagnostic",
            timeout=30,
            marker="ok\n",
        )
        run(
            [compiler, reduction, "-interp", "--", "require"],
            "canonical named enum requirement",
            expect_failure="assertion failed" if args.diagnose else None,
            timeout=30,
            marker=None if args.diagnose else "ok\n",
        )
        if args.diagnose:
            run(
                [
                    compiler,
                    source / "tests/developer-tools/bindings-custom.jai",
                    "-interp",
                    "-I",
                    source / "target",
                ],
                "unchanged required custom RED",
                expect_failure="change_type_to_enum",
                timeout=30,
            )
            raise RuntimeError("Required enum conversion RED retained; diagnostic only")
        for optimization in [0, 2]:
            executable = out / f"enum-model-O{optimization}"
            run(
                [compiler, reduction, f"-O{optimization}", "-exe", executable],
                f"canonical enum O{optimization} build",
            )
            run(
                [executable, "require"],
                f"canonical enum O{optimization}",
                timeout=30,
                marker="ok\n",
            )
        spec = importlib.util.spec_from_file_location(
            "required_c_model", source / "tools/check_developer_cpp_custom.py"
        )
        checks = importlib.util.module_from_spec(spec)
        sys.path.insert(0, str(source / "tools"))
        spec.loader.exec_module(checks)
        checks.run = lambda argv, expected="": run(
            argv,
            "required " + Path(argv[1] if len(argv) > 1 else argv[0]).name,
            expected=expected,
        )
        required_error = None
        try:
            checks.check_c_model_regressions()
        except RuntimeError as error:
            required_error = str(error)
        receipt["required_c_model_passed"] = required_error is None
        receipt["required_c_model_error"] = required_error
        consumer = source / "tests/developer-tools/generator-model-enum-roundtrip.jai"
        tree = source / "tests/developer-tools/bindings-tree.jai"
        forward = source / "tests/developer-tools/generator-model-forward-scope.jai"
        for fixture in [consumer, tree, forward]:
            run(
                [compiler, fixture, "-interp", "-I", source / "target"],
                f"{fixture.stem} interpreter",
                expected=None if fixture == forward else "ok\n",
                timeout=30,
                marker="ok\n",
            )
            for optimization in [0, 2]:
                executable = out / f"{fixture.stem}-O{optimization}"
                run(
                    [
                        compiler,
                        fixture,
                        f"-O{optimization}",
                        "-I",
                        source / "target",
                        "-exe",
                        executable,
                    ],
                    f"{fixture.stem} O{optimization} build",
                )
                run(
                    [executable],
                    f"{fixture.stem} O{optimization}",
                    expected=None if fixture == forward else "ok\n",
                    timeout=30,
                    marker="ok\n",
                )
        formatter = source / "target/jaifmt"
        run(
            [compiler, source / "jaifmt/main.jai", "-O0", "-exe", formatter],
            "source formatter build",
        )
        owned = [
            source / "stdlib/internal/developer-tools/binding-tree.jai",
            reduction,
            consumer,
            forward,
        ]
        run(
            [formatter, "--config", source / "jaifmt.toml", "--check", *owned], "format"
        )
        run(
            [
                debug / "jailint",
                "-D",
                "warnings",
                "-I",
                source / "target",
                "--manifest",
                out / "lint.json",
                source / "stdlib/Bindings_Generator/module.jai",
                reduction,
                consumer,
                forward,
            ],
            "strict complete module and consumers",
        )
        receipt["scoped_model_proof_passed"] = True
        if required_error:
            raise RuntimeError(
                "Required unchanged C-model gate remains RED: " + required_error
            )
        receipt["passed"] = True
    finally:
        receipt["inputs_unchanged"] = all(
            sha(source / n) == h for n, h in identity.items()
        )
        receipt["binaries_unchanged"] = all(
            sha(Path(n)) == h for n, h in receipt.get("binaries", {}).items()
        )
        if not receipt["inputs_unchanged"] or not receipt["binaries_unchanged"]:
            receipt["passed"] = False
            receipt["scoped_model_proof_passed"] = False
        receipt["live_source_drift"] = [
            n for n, h in identity.items() if sha(ROOT / n) != h
        ]
        save()
        print(f"Enum scope receipt: {out / 'verification.json'}", flush=True)
        with (ROOT / "docs/worker-inbox.md").open("a") as inbox:
            inbox.write(
                "\n\n## Generator-model enum native slot RELEASED\n\n"
                f"Bounded own children reaped; receipt {out / 'verification.json'}. "
                "Source/runtime result remains exactly recorded; no implied CI waiver.\n"
            )
        if not receipt["inputs_unchanged"] or not receipt["binaries_unchanged"]:
            raise RuntimeError("Pinned source or own tools changed during verification")


if __name__ == "__main__":
    main()
