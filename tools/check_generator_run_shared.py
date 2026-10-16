#!/usr/bin/env python3
"""Focused current-source canonical runner verification, without facade edits."""

import hashlib
import json
import os
from pathlib import Path
import platform
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
PROGRAMS = [
    "toplevel",
    "pipeline",
    "failures",
    "libraries",
    "macro-print",
    "record-intake",
    "view",
    "model-diagnostic",
]
OWNED = [
    ROOT / "stdlib/Bindings_Generator/generator-run.jai",
    ROOT / "stdlib/internal/developer-tools/generator-run.jai",
    ROOT / "stdlib/Bindings_Generator/tests/generator-run-toplevel.jai",
    ROOT / "stdlib/Bindings_Generator/tests/generator-run-macro-print.jai",
]
OWNED.extend(
    ROOT / "tests/developer-tools" / ("generator-run-" + name + ".jai")
    for name in PROGRAMS
)
FIXTURES = [
    ROOT / "tests/developer-tools" / name
    for name in [
        "generator-run-main.hpp",
        "generator-run-system.h",
        "generator-run-sdk.c",
        "generator-run-pipeline.hpp",
        "generator-run-second.hpp",
        "generator-run-error.h",
        "generator-run-warning.h",
        "generator-run-unsupported.hpp",
        "generator-run-library.c",
        "generator-run-library.h",
        "generator-run-view.h",
        "generator-run-namespace-sdk.cpp",
        "generator-run-model-diagnostic.hpp",
    ]
]


def native_hashes():
    folder = ROOT / "stdlib/internal/developer-tools/clang-bindings"
    provenance = folder / "runtime-sdk.json"
    paths = [provenance]
    receipt = json.loads(provenance.read_text())
    for filename, entry in receipt.items():
        original = Path(entry["sdk_image"])
        staged = folder / filename
        for path, expected in [
            (original, entry["sdk_sha256"]),
            (staged, entry["staged_sha256"]),
        ]:
            with path.open("rb") as source:
                actual = hashlib.file_digest(source, "sha256").hexdigest()
            if actual != expected:
                raise SystemExit("Canonical SDK receipt mismatch: " + str(path))
            paths.append(path)
    paths.extend(sorted(Path("/opt/homebrew/opt/llvm/include/clang-c").glob("*.h")))
    result = {}
    for path in paths:
        with path.open("rb") as source:
            result[str(path)] = hashlib.file_digest(source, "sha256").hexdigest()
    return result


def hashes():
    paths = [ROOT / "Cargo.toml", ROOT / "Cargo.lock", ROOT / "rust-toolchain.toml"]
    for folder in ["crates", "stdlib", "jaifmt"]:
        paths.extend(
            p
            for p in (ROOT / folder).rglob("*")
            if p.is_file()
            and not p.name.startswith(".")
            and p.suffix in [".jai", ".rs", ".toml", ".c", ".h"]
        )
    paths.extend(OWNED + FIXTURES + [Path(__file__)])
    return {
        str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest()
        for p in sorted(set(paths))
    }


def main():
    if platform.system() != "Darwin":
        raise SystemExit(
            "Actual Mac host required; other native platforms remain separate gates"
        )
    assigned = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    if (
        not assigned.is_relative_to(Path("/Volumes/T7"))
        or "portable-asn1-socket" not in assigned.parts
    ):
        raise SystemExit("Use this worker's assigned T7 target")
    output = Path(tempfile.mkdtemp(prefix="generator-run-verify-", dir=assigned))
    environment = dict(
        os.environ,
        JAIC_STDLIB=str(ROOT / "stdlib"),
        TMPDIR=str(output),
        PYTHONDONTWRITEBYTECODE="1",
    )
    capture = ROOT / "generator-run-source-receipt.json"
    source_receipt = json.loads(capture.read_text()) if capture.exists() else None
    if source_receipt:
        if source_receipt["snapshot_root"] != str(ROOT):
            raise SystemExit("Snapshot receipt root mismatch")
        for name, expected in source_receipt["sha256"].items():
            with (ROOT / name).open("rb") as source:
                actual = hashlib.file_digest(source, "sha256").hexdigest()
            if actual != expected:
                raise SystemExit("Snapshot receipt hash mismatch: " + name)
    receipt = {
        "root": str(ROOT),
        "head": source_receipt["head"]
        if source_receipt
        else subprocess.check_output(
            ["git", "rev-parse", "HEAD"], cwd=ROOT, text=True
        ).strip(),
        "source_capture": source_receipt,
        "output": str(output),
        "host": platform.platform(),
        "source_sha256": hashes(),
        "native_sha256": native_hashes(),
        "commands": [],
        "status": "in_progress",
    }
    failures = []
    blocked = []

    def save():
        (output / "receipt.json").write_text(json.dumps(receipt, indent=2) + "\n")

    save()
    if (ROOT / "stdlib/Bindings_Generator/module.jai").read_text().count(
        '#load "generator-run.jai";'
    ) != 1:
        receipt["status"] = "blocked_integration_facade_load"
        save()
        raise SystemExit(
            "Integration single facade load pending; evidence: " + str(output)
        )

    def run(command, label, expected=None, android=False):
        command = list(map(str, command))
        result = subprocess.run(
            command,
            cwd=ROOT if label == "source-build" else output,
            env=environment,
            capture_output=True,
            text=True,
            timeout=180,
        )
        (output / (label + ".stdout")).write_text(result.stdout)
        (output / (label + ".stderr")).write_text(result.stderr)
        pending = (
            android
            and result.returncode == 2
            and "unknown OS `android`" in result.stderr
        )
        passed = result.returncode == 0 and (
            expected is None or (result.stdout == expected and not result.stderr)
        )
        receipt["commands"].append(
            {
                "label": label,
                "argv": command,
                "returncode": result.returncode,
                "status": "pass" if passed else "blocked" if pending else "fail",
            }
        )
        if not passed:
            (blocked if pending else failures).append(label)
        save()
        print(label + ": " + receipt["commands"][-1]["status"].upper(), flush=True)
        return passed

    compiler_dir = output / "compiler"
    if not run(
        [
            "cargo",
            "build",
            "--manifest-path",
            ROOT / "Cargo.toml",
            "--locked",
            "--offline",
            "--target-dir",
            compiler_dir,
            "-p",
            "jaic-cli",
            "-p",
            "jailint",
        ],
        "source-build",
    ):
        raise SystemExit("Source build failed; evidence: " + str(output))
    compiler = compiler_dir / "debug/jaic"
    lint = compiler_dir / "debug/jailint"
    # Source-build the canonical shared native dependency directly, without
    # peer staging helpers or changes to installed distribution assets. This
    # existing compiler override is verification input, not a new stdlib knob.
    native = output / "native"
    native.mkdir()
    if not run(
        [
            "cc",
            "-Wall",
            "-Wextra",
            "-Werror",
            "-O2",
            "-dynamiclib",
            ROOT / "stdlib/internal/developer-tools/generator-platform-native.c",
            "-o",
            native / "libgenerator_platform.dylib",
        ],
        "canonical-native-helper-build",
    ):
        raise SystemExit(
            "Canonical native helper build failed; evidence: " + str(output)
        )
    previous = environment.get(
        "JAIC_NATIVE_LIBS", str(ROOT / "artifacts/native-libs/macos-arm64")
    )
    environment["JAIC_NATIVE_LIBS"] = str(native) + (
        os.pathsep + previous if previous else ""
    )
    previous_link = environment.get("LIBRARY_PATH", "")
    environment["LIBRARY_PATH"] = str(native) + (
        os.pathsep + previous_link if previous_link else ""
    )
    receipt["verification_native_override"] = environment["JAIC_NATIVE_LIBS"]
    receipt["verification_link_library_path"] = environment["LIBRARY_PATH"]
    for level in ["O0", "O2"]:
        if not run(
            [
                "cc",
                "-Wall",
                "-Wextra",
                "-Werror",
                "-" + level,
                "-dynamiclib",
                ROOT / "tests/developer-tools/generator-run-library.c",
                "-o",
                native / ("library-" + level + ".dylib"),
            ],
            "fixture-library-" + level + "-build",
        ):
            raise SystemExit("Fixture library build failed; evidence: " + str(output))
    generated_native = {
        str(path): hashlib.sha256(path.read_bytes()).hexdigest()
        for path in native.glob("*.dylib")
    }
    receipt["generated_native_sha256"] = generated_native
    save()
    for name in PROGRAMS:
        source = ROOT / "tests/developer-tools" / ("generator-run-" + name + ".jai")
        arguments = ["--", native / "library-O0.dylib"] if name == "libraries" else []
        run([compiler, "-interp", source, *arguments], name + "-interp", name + " ok\n")
        for optimization in ["-O0", "-O2"]:
            program = output / (name + optimization)
            if run(
                [compiler, source, optimization, "-exe", program],
                name + optimization + "-build",
            ):
                if name == "libraries":
                    label = name + optimization + "-dependency-identity"
                    if run(["otool", "-L", program], label):
                        actual = (output / (label + ".stdout")).read_text()
                        if str(native / "libgenerator_platform.dylib") not in actual:
                            failures.append(label + "-wrong-helper")
                            receipt["native_helper_identity_failure"] = label
                            save()
                arguments = (
                    [native / ("library" + optimization + ".dylib")]
                    if name == "libraries"
                    else []
                )
                run(
                    [program, *arguments],
                    name + optimization + "-native",
                    name + " ok\n",
                )
    run(
        [
            lint,
            "-D",
            "warnings",
            "--manifest",
            output / "lint.json",
            "--checked-files",
            output / "lint.files",
            ROOT / "stdlib/Bindings_Generator",
            *OWNED,
        ],
        "strict-lint",
    )
    formatter = output / "jaifmt"
    if run(
        [compiler, ROOT / "jaifmt/main.jai", "-O0", "-exe", formatter],
        "formatter-build",
    ):
        run(
            [formatter, "--config", ROOT / "jaifmt.toml", "--check", *OWNED],
            "owned-format",
        )
    for optimization in ["-O0", "-O2"]:
        oracle = output / ("sdk" + optimization)
        if run(
            [
                "cc",
                "-Wall",
                "-Wextra",
                "-Werror",
                optimization,
                "-I/opt/homebrew/opt/llvm/include",
                ROOT / "tests/developer-tools/generator-run-sdk.c",
                "-L/opt/homebrew/opt/llvm/lib",
                "-Wl,-rpath,/opt/homebrew/opt/llvm/lib",
                "-lclang",
                "-o",
                oracle,
            ],
            "sdk" + optimization + "-build",
        ):
            run(
                [oracle, ROOT / "tests/developer-tools/generator-run-main.hpp"],
                "sdk" + optimization + "-native",
                "system=1/1 macros=2/2 functions=2 canonical=1 linkage=2 semantic_linkage=2 ancestor_tu=2 argument_system=0 predefined_system=1 overloads_distinct=1\n",
            )
        namespace = output / ("namespace-sdk" + optimization)
        if run(
            [
                "c++",
                "-Wall",
                "-Wextra",
                "-Werror",
                "-std=c++17",
                "-DRUN_ARGUMENT=40",
                optimization,
                ROOT / "tests/developer-tools/generator-run-namespace-sdk.cpp",
                "-o",
                namespace,
            ],
            "namespace-sdk" + optimization + "-build",
        ):
            run([namespace], "namespace-sdk" + optimization + "-native", "")
    for os_name in ["macos", "linux", "windows"]:
        for cpu in ["x64", "arm64"]:
            for name in PROGRAMS:
                source = (
                    ROOT / "tests/developer-tools" / ("generator-run-" + name + ".jai")
                )
                run(
                    [compiler, "-check", "-os", os_name, "-cpu", cpu, source],
                    f"{name}-{os_name}-{cpu}",
                )
    run(
        [
            compiler,
            "-check",
            "-os",
            "android",
            ROOT / "tests/cleanroom-language/android-target-minimal.jai",
        ],
        "android-target-minimal",
        android=True,
    )
    after = hashes()
    before = receipt["source_sha256"]
    changed = sorted(
        k for k in before.keys() | after.keys() if before.get(k) != after.get(k)
    )
    receipt["source_changes"] = changed
    native_after = native_hashes()
    native_before = receipt["native_sha256"]
    receipt["native_changes"] = sorted(
        k
        for k in native_before.keys() | native_after.keys()
        if native_before.get(k) != native_after.get(k)
    )
    changed.extend(receipt["native_changes"])
    receipt["generated_native_changes"] = [
        path
        for path, expected in generated_native.items()
        if hashlib.sha256(Path(path).read_bytes()).hexdigest() != expected
    ]
    changed.extend(receipt["generated_native_changes"])
    receipt["status"] = (
        "invalidated_source_drift"
        if changed
        else "failed"
        if failures
        else "supported_pass_android_blocked"
        if blocked
        else "passed"
    )
    save()
    print("Evidence: " + str(output), flush=True)
    if changed or failures:
        raise SystemExit(
            "Source drift: " + ", ".join(changed) + "; failed: " + ", ".join(failures)
        )
    if blocked:
        raise SystemExit(2)


if __name__ == "__main__":
    main()
