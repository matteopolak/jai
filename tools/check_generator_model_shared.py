#!/usr/bin/env python3
"""Verify a complete immutable capture of current shared model inputs."""

import hashlib
import importlib.util
import json
import os
from pathlib import Path
import tempfile

from native_bindings.shared_snapshot import capture, unchanged

ROOT = Path(__file__).resolve().parents[1]
TARGET = Path(os.environ["CARGO_TARGET_DIR"]).resolve()


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    snapshot, identity = capture(
        TARGET / "immutable-runs",
        [
            "tests/developer-tools",
            "jaifmt.toml",
            "Cargo.toml",
            "Cargo.lock",
            "crates",
            "tools/check_generator_model.py",
            "tools/check_generator_model_shared.py",
            "tools/native_bindings/shared_snapshot.py",
        ],
    )
    # The shared snapshot utility preserves bytes but makes all files read-only.
    # Retain execution on native tools that were executable in the actual input.
    for name in identity["files"]:
        if (ROOT / name).stat().st_mode & 0o111:
            (snapshot / name).chmod(0o555)
    outputs = Path(tempfile.mkdtemp(prefix="model-outputs-", dir=TARGET))
    (outputs / "debug").mkdir()
    binaries = [TARGET / "debug/jaic", TARGET / "debug/jailint", TARGET / "jaifmt"]
    binary_identity = {str(path): digest(path) for path in binaries}
    for path in binaries:
        destination = (
            outputs / ("debug" if path.parent.name == "debug" else "") / path.name
        )
        destination.symlink_to(path)
    spec = importlib.util.spec_from_file_location(
        "model_checks", snapshot / "tools/check_generator_model.py"
    )
    checks = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(checks)
    checks.ROOT = snapshot
    checks.TARGET = outputs
    checks.JAIC = TARGET / "debug/jaic"
    checks.ENV = dict(os.environ, JAIC_STDLIB=str(snapshot / "stdlib"))
    receipt = dict(
        snapshot=str(snapshot),
        outputs=str(outputs),
        input_identity=identity,
        binaries=binary_identity,
        passed=False,
    )
    generated_lint_failures = []
    try:
        native = outputs / "native"
        native.mkdir()
        checks.run(
            [
                "cc",
                "-Wall",
                "-Wextra",
                "-Werror",
                "-O2",
                "-dynamiclib",
                snapshot
                / "stdlib/internal/developer-tools/generator-platform-native.c",
                "-o",
                native / "libgenerator_platform.dylib",
            ]
        )
        for optimization in [0, 2]:
            checks.run(
                [
                    "cc",
                    "-Wall",
                    "-Wextra",
                    "-Werror",
                    f"-O{optimization}",
                    "-dynamiclib",
                    snapshot / "tests/developer-tools/generator-run-library.c",
                    "-o",
                    native / f"library-O{optimization}.dylib",
                ]
            )
        checks.ENV["JAIC_NATIVE_LIBS"] = (
            str(native)
            + os.pathsep
            + checks.ENV.get(
                "JAIC_NATIVE_LIBS", str(snapshot / "artifacts/native-libs/macos-arm64")
            )
        )
        checks.ENV["LIBRARY_PATH"] = (
            str(native) + os.pathsep + checks.ENV.get("LIBRARY_PATH", "")
        )
        receipt["native_override"] = checks.ENV["JAIC_NATIVE_LIBS"]
        receipt["native_helper_development_only"] = True
        receipt["native_setup_commands"] = list(checks.evidence)
        checks.main()
        # Unchanged tools-owner assertions exercise the original integration failure.
        for name in ["bindings-template-arguments", "bindings-template-printing"]:
            source = snapshot / f"tests/developer-tools/{name}.jai"
            arguments = [outputs] if name == "bindings-template-printing" else []
            checks.run(
                [checks.JAIC, source, "-interp", "-I", outputs, "--", *arguments],
                "ok\n",
            )
            for optimization in [0, 2]:
                exe = outputs / f"{name}-O{optimization}"
                checks.run(
                    [
                        checks.JAIC,
                        source,
                        f"-O{optimization}",
                        "-exe",
                        exe,
                        "-I",
                        outputs,
                    ]
                )
                checks.run([exe, *arguments], "ok\n")
        generated = outputs / "developer-tools-templates-generated.jai"
        checks.run([TARGET / "jaifmt", "--config", snapshot / "jaifmt.toml", generated])
        consumer = (
            snapshot / "tests/developer-tools/bindings-template-printing-roundtrip.jai"
        )
        checks.run(
            [
                TARGET / "debug/jailint",
                "-D",
                "warnings",
                "-I",
                outputs,
                consumer,
                generated,
            ]
        )
        checks.run([checks.JAIC, consumer, "-interp", "-I", outputs], "ok\n")
        for optimization in [0, 2]:
            exe = outputs / f"template-consumer-O{optimization}"
            checks.run(
                [checks.JAIC, consumer, f"-O{optimization}", "-exe", exe, "-I", outputs]
            )
            checks.run([exe], "ok\n")
        for name in [
            "toplevel",
            "pipeline",
            "failures",
            "libraries",
            "macro-print",
            "record-intake",
            "view",
            "model-diagnostic",
        ]:
            source = snapshot / f"tests/developer-tools/generator-run-{name}.jai"
            args = [native / "library-O0.dylib"] if name == "libraries" else []
            checks.run([checks.JAIC, source, "-interp", "--", *args], name + " ok\n")
            for optimization in [0, 2]:
                exe = outputs / f"generator-run-{name}-O{optimization}"
                checks.run([checks.JAIC, source, f"-O{optimization}", "-exe", exe])
                native_args = (
                    [native / f"library-O{optimization}.dylib"]
                    if name == "libraries"
                    else []
                )
                checks.run([exe, *native_args], name + " ok\n")
        for name, generated_name, library in [
            (
                "canonical-printing",
                "developer-tools-canonical-generated",
                "canonical_printing",
            ),
            (
                "anonymous-bitfields",
                "developer-tools-anonymous-bits-generated",
                "anonymous_bitfields",
            ),
        ]:
            source = snapshot / f"tests/developer-tools/bindings-{name}.jai"
            checks.run([checks.JAIC, source, "-interp", "--", outputs], "ok\n")
            emitted = outputs / (generated_name + ".jai")
            expected = digest(emitted)
            for optimization in [0, 2]:
                exe = outputs / f"emitter-{name}-O{optimization}"
                checks.run([checks.JAIC, source, f"-O{optimization}", "-exe", exe])
                checks.run([exe, outputs], "ok\n")
                if digest(emitted) != expected:
                    raise RuntimeError(
                        "Emitter modes produced different binding text: " + name
                    )
            checks.run(
                [TARGET / "jaifmt", "--config", snapshot / "jaifmt.toml", emitted]
            )
            consumer = snapshot / f"tests/developer-tools/bindings-{name}-roundtrip.jai"
            try:
                checks.run(
                    [
                        TARGET / "debug/jailint",
                        "-D",
                        "warnings",
                        "-I",
                        outputs,
                        emitted,
                        consumer,
                    ]
                )
            except RuntimeError:
                # Keep the strict lint gate red while measuring independent
                # native consumers; never turn a failed check into a pass.
                generated_lint_failures.append(checks.evidence[-1])
            for optimization in [0, 2]:
                checks.run(
                    [
                        "cc",
                        "-std=c11",
                        "-Wall",
                        "-Wextra",
                        "-Werror",
                        f"-O{optimization}",
                        "-dynamiclib",
                        snapshot / f"tests/developer-tools/bindings-{name}-native.c",
                        "-o",
                        native / f"lib{library}.dylib",
                    ]
                )
                if optimization == 0:
                    checks.run(
                        [checks.JAIC, consumer, "-interp", "-I", outputs], "ok\n"
                    )
                exe = outputs / f"consumer-{name}-O{optimization}"
                checks.run(
                    [
                        checks.JAIC,
                        consumer,
                        f"-O{optimization}",
                        "-I",
                        outputs,
                        "-exe",
                        exe,
                    ]
                )
                checks.run([exe], "ok\n")
        # Exercise the unchanged public header-only workflow in the SAME
        # capture as model/run ownership and generated consumers.
        producer = snapshot / "tests/developer-tools/bindings-canonical-driver.jai"
        consumer = (
            snapshot / "tests/developer-tools/bindings-canonical-driver-roundtrip.jai"
        )
        generated = outputs / "developer-tools-driver-generated.jai"
        checks.run([checks.JAIC, producer, "-check"])
        checks.run([checks.JAIC, producer, "-interp", "--", outputs], "ok\n")
        expected = digest(generated)
        for optimization in [0, 2]:
            exe = outputs / f"header-only-producer-O{optimization}"
            checks.run([checks.JAIC, producer, f"-O{optimization}", "-exe", exe])
            checks.run([exe, outputs], "ok\n")
            if digest(generated) != expected:
                raise RuntimeError("Header-only producer modes emitted different text")
        checks.run([checks.JAIC, consumer, "-check", "-I", outputs])
        checks.run([checks.JAIC, consumer, "-interp", "-I", outputs], "ok\n")
        for optimization in [0, 2]:
            exe = outputs / f"header-only-consumer-O{optimization}"
            checks.run(
                [checks.JAIC, consumer, f"-O{optimization}", "-I", outputs, "-exe", exe]
            )
            checks.run([exe], "ok\n")
        checks.run([TARGET / "jaifmt", "--config", snapshot / "jaifmt.toml", generated])
        checks.run(
            [
                TARGET / "debug/jailint",
                "-D",
                "warnings",
                "-I",
                outputs,
                generated,
                producer,
                consumer,
            ]
        )
        # Exact generic RED producer plus an independently organized generated
        # 128-bit/native-layout consumer share this immutable source identity.
        for name, producer_name, emitted_name, consumer_name, fixture, library in [
            (
                "generic-original",
                "bindings-generic-driver",
                "generic-original-consumer",
                None,
                "bindings-generic-native.cpp",
                "generic_fixture",
            ),
            (
                "model-defaults",
                "generator-model-default-emission",
                "generator-model-defaults-generated",
                "generator-model-default-roundtrip",
                "generator-model-defaults-native.cpp",
                "model_defaults",
            ),
        ]:
            producer = snapshot / f"tests/developer-tools/{producer_name}.jai"
            emitted = outputs / f"{emitted_name}.jai"
            argument = emitted if consumer_name is None else outputs
            checks.run([checks.JAIC, producer, "-check"])
            checks.run([checks.JAIC, producer, "-interp", "--", argument], "ok\n")
            expected = digest(emitted)
            for optimization in [0, 2]:
                exe = outputs / f"{name}-producer-O{optimization}"
                checks.run([checks.JAIC, producer, f"-O{optimization}", "-exe", exe])
                checks.run([exe, argument], "ok\n")
                if digest(emitted) != expected:
                    raise RuntimeError("Generic producer modes emitted different text")
            consumer = (
                emitted
                if consumer_name is None
                else snapshot / f"tests/developer-tools/{consumer_name}.jai"
            )
            checks.run(
                [TARGET / "jaifmt", "--config", snapshot / "jaifmt.toml", emitted]
            )
            checks.run(
                [
                    TARGET / "debug/jailint",
                    "-D",
                    "warnings",
                    "-I",
                    outputs,
                    emitted,
                    consumer,
                    producer,
                ]
            )
            checks.run([checks.JAIC, consumer, "-check", "-I", outputs])
            for optimization in [0, 2]:
                checks.run(
                    [
                        "/opt/homebrew/opt/llvm/bin/clang++",
                        "-std=c++17",
                        "-Wall",
                        "-Wextra",
                        "-Werror",
                        f"-O{optimization}",
                        "-DMODEL_DEFAULT_LIBRARY",
                        "-dynamiclib",
                        snapshot / f"tests/developer-tools/{fixture}",
                        "-o",
                        native / f"lib{library}.dylib",
                    ]
                )
                if optimization == 0:
                    checks.run(
                        [checks.JAIC, consumer, "-interp", "-I", outputs], "ok\n"
                    )
                exe = outputs / f"{name}-consumer-O{optimization}"
                checks.run(
                    [
                        checks.JAIC,
                        consumer,
                        f"-O{optimization}",
                        "-I",
                        outputs,
                        "-exe",
                        exe,
                    ]
                )
                checks.run([exe], "ok\n")
        receipt["inputs_unchanged"] = unchanged(snapshot, identity)
        receipt["generated_native_sha256"] = {
            str(path): digest(path) for path in native.glob("*.dylib")
        }
        receipt["binaries_unchanged"] = all(
            digest(Path(name)) == value for name, value in binary_identity.items()
        )
        receipt["generated_lint_failures"] = generated_lint_failures
        if generated_lint_failures:
            raise RuntimeError("Generated root lint failed; exact diagnostics retained")
        if not receipt["inputs_unchanged"] or not receipt["binaries_unchanged"]:
            raise RuntimeError(
                "Captured source/native inputs or own source-built tools changed"
            )
        receipt["passed"] = True
    finally:
        receipt["inputs_unchanged"] = unchanged(snapshot, identity)
        receipt["binaries_unchanged"] = all(
            digest(Path(name)) == value for name, value in binary_identity.items()
        )
        receipt["generated_native_sha256"] = {
            str(path): digest(path) for path in native.glob("*.dylib")
        }
        (outputs / "generator-model-evidence.json").write_text(
            json.dumps(checks.evidence, indent=2) + "\n"
        )
        (outputs / "verification.json").write_text(json.dumps(receipt, indent=2) + "\n")
        print(f"Immutable model receipt: {outputs / 'verification.json'}", flush=True)


if __name__ == "__main__":
    main()
