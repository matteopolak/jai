#!/usr/bin/env python3
"""Current shared provider red/green loop and immutable logical-name verification."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
TARGET = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
PREFIX = Path(os.environ.get("DEVELOPER_TOOLS_LLVM_PREFIX", "/opt/homebrew/opt/llvm"))
FIXTURES = [
    "generator-platform-logical.jai",
    "generator-platform-logical.c",
    "generator-platform-logical-consumer.jai",
    "generator-platform-logical-oracle.c",
    "generator-platform-logical.h",
    "generator-platform-logical-output.jai",
    "generator-platform-logical-roundtrip.jai",
    "generator-platform-logical-target.jai",
]


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def capture(output):
    paths = [
        ROOT / name
        for name in ["Cargo.toml", "Cargo.lock", "rust-toolchain.toml", "jaifmt.toml"]
    ]
    for folder in ["stdlib", "crates", "jaifmt"]:
        paths.extend(path for path in (ROOT / folder).rglob("*") if path.is_file())
    paths.extend(ROOT / "tests/developer-tools" / name for name in FIXTURES)
    paths.append(Path(__file__).resolve())
    before = {str(path.relative_to(ROOT)): digest(path) for path in paths}
    destination = output / "source"
    for path in paths:
        target = destination / path.relative_to(ROOT)
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(path, target)
        target.chmod(0o444)
    if any(
        digest(ROOT / name) != value or digest(destination / name) != value
        for name, value in before.items()
    ):
        raise RuntimeError(
            "Current source changed during capture; retry on a coherent source"
        )
    return destination, before


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--fast", action="store_true")
    args = parser.parse_args()
    TARGET.mkdir(parents=True, exist_ok=True)
    output = Path(
        tempfile.mkdtemp(
            prefix="logical-fast-" if args.fast else "logical-immutable-", dir=TARGET
        )
    )
    source, identity = (ROOT, {}) if args.fast else capture(output)
    work = output / "work"
    images = work / "provider/images"
    images.mkdir(parents=True)
    native = output / "native"
    native.mkdir()
    environment = dict(
        os.environ,
        JAIC_STDLIB=str(source / "stdlib"),
        CARGO_TARGET_DIR=str(TARGET),
        JAIC_NATIVE_LIBS=str(native),
        LIBRARY_PATH=str(native),
        TMPDIR=str(output),
    )
    receipt = {
        "source": str(source),
        "source_identity": identity,
        "commands": [],
        "fast": args.fast,
    }

    def run(command, label, expected="", cwd=None, allow_stderr=False):
        result = subprocess.run(
            [str(value) for value in command],
            cwd=cwd or work,
            env=environment,
            capture_output=True,
            text=True,
            timeout=120,
        )
        passed = (
            result.returncode == 0
            and (expected is None or result.stdout == expected)
            and (allow_stderr or not result.stderr)
        )
        receipt["commands"].append(
            {
                "label": label,
                "argv": [str(value) for value in command],
                "exit": result.returncode,
                "stdout": result.stdout,
                "stderr": result.stderr,
                "passed": passed,
            }
        )
        (output / "verification.json").write_text(json.dumps(receipt, indent=2) + "\n")
        print(label + (": PASS" if passed else ": FAIL"), flush=True)
        if not passed:
            raise RuntimeError(
                f"{label}: {result.stdout}\n{result.stderr}\nreceipt: {output}"
            )
        return result.stdout

    if not args.fast:
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
            "current-captured-Rust-build",
            expected=None,
            cwd=source,
            allow_stderr=True,
        )
    compiler = TARGET / "debug/jaic"
    lint = TARGET / "debug/jailint"
    receipt["compiler_sha256"] = digest(compiler)
    clang = PREFIX / "bin/clang"
    run(
        [
            clang,
            "-O2",
            "-Wall",
            "-Wextra",
            "-Werror",
            "-dynamiclib",
            source / "stdlib/internal/developer-tools/generator-platform-native.c",
            "-o",
            native / "libgenerator_platform.dylib",
        ],
        "current-native-provider-build",
    )
    c_source = source / "tests/developer-tools/generator-platform-logical.c"
    run(
        [clang, "-dynamiclib", c_source, "-o", images / "liboriginal_resolved.dylib"],
        "SDK-shared-image",
    )
    shutil.copyfile(
        images / "liboriginal_resolved.dylib", work / "liboriginal_resolved.dylib"
    )
    other = work / "provider/other"
    other.mkdir()
    run(
        [
            clang,
            "-dynamiclib",
            "-DIMAGE_VALUE=73",
            c_source,
            "-o",
            other / "liboriginal_resolved.dylib",
        ],
        "SDK-distinct-native-identity",
    )
    for filename in [
        "libOriginal-Resolved.native",
        "liboriginal_version.1.2.dylib",
        "liboriginal_elf.so.3.4",
    ]:
        shutil.copyfile(images / "liboriginal_resolved.dylib", images / filename)
    run(
        [clang, "-DSTATIC_VIEW", "-c", c_source, "-o", images / "original.o"],
        "SDK-static-object",
    )
    run(
        [
            PREFIX / "bin/llvm-ar",
            "rcs",
            images / "original_archive.a",
            images / "original.o",
        ],
        "SDK-static-archive",
    )
    shutil.copyfile(images / "original_archive.a", images / "original_custom.archive")
    for optimization in [0] if args.fast else [0, 2]:
        sdk_control = work / f"sdk-control-o{optimization}"
        run(
            [
                clang,
                f"-O{optimization}",
                source / "tests/developer-tools/generator-platform-logical-oracle.c",
                "-L",
                work,
                "-loriginal_resolved",
                "-Wl,-rpath," + str(work),
                "-o",
                sdk_control,
            ],
            f"SDK-O{optimization}-positive-link",
        )
        run([sdk_control], f"SDK-O{optimization}-positive-execution")
    shutil.copyfile(source / "tests/developer-tools" / FIXTURES[4], work / FIXTURES[4])
    programs = [FIXTURES[2], FIXTURES[0], FIXTURES[5], FIXTURES[6]]
    for name in programs:
        fixture = (work / "provider" if name == FIXTURES[0] else work) / name
        shutil.copyfile(source / "tests/developer-tools" / name, fixture)
        run(
            [compiler, fixture, "-I", work, "-check"],
            name + ": fast-source",
            cwd=fixture.parent,
        )
        run(
            [compiler, fixture, "-I", work, "-interp"],
            name + ": interpreter",
            "ok\n",
            cwd=fixture.parent,
        )
        if not args.fast:
            for optimization in [0, 2]:
                executable = work / (fixture.stem + f"-o{optimization}")
                run(
                    [
                        compiler,
                        fixture,
                        "-I",
                        work,
                        f"-O{optimization}",
                        "-exe",
                        executable,
                    ],
                    name + f": O{optimization}-build",
                )
                run(
                    [executable],
                    name + f": O{optimization}-execute",
                    "ok\n",
                    cwd=fixture.parent,
                )
    if not args.fast:
        formatter = output / "jaifmt"
        run(
            [compiler, source / "jaifmt/main.jai", "-O0", "-exe", formatter],
            "formatter-source-build",
        )
        owned = [
            source / "stdlib/internal/developer-tools/generator-platform.jai",
            *(
                source / "tests/developer-tools" / name
                for name in FIXTURES
                if name.endswith(".jai")
            ),
        ]
        run(
            [formatter, "--config", source / "jaifmt.toml", "--check", *owned], "format"
        )
        run(
            [
                lint,
                "-D",
                "warnings",
                "-I",
                work,
                source / "stdlib/Bindings_Generator/module.jai",
                work / "provider" / FIXTURES[0],
                *(work / name for name in programs if name != FIXTURES[0]),
            ],
            "strict-full-context-lint",
            expected=None,
        )
        for os_name in ["macos", "linux", "windows"]:
            for cpu in ["x64", "arm64"]:
                run(
                    [
                        compiler,
                        source / "tests/developer-tools" / FIXTURES[7],
                        "-check",
                        "-os",
                        os_name,
                        "-cpu",
                        cpu,
                    ],
                    f"source-{os_name}-{cpu}",
                )
        receipt["source_unchanged"] = all(
            digest(source / name) == value for name, value in identity.items()
        )
        if not receipt["source_unchanged"]:
            raise RuntimeError("Immutable input was modified")
    (output / "verification.json").write_text(json.dumps(receipt, indent=2) + "\n")
    print("Receipt: " + str(output / "verification.json"))


if __name__ == "__main__":
    main()
