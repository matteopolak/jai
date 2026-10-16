#!/usr/bin/env python3
"""Real offscreen Mac SDK operations; no user windows, fake GL results or overlays."""

import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile
from portable_assertion_test_config import disabled_default_copy

ROOT = Path(__file__).resolve().parents[1]
OWNED = [
    "internal/rendering/gl-textures.jai",
    "internal/rendering/gl-pixel-read.jai",
    "internal/rendering/window-contexts.jai",
    "Simp/tests/context-default-assertions.jai",
]


def main():
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    work = Path(tempfile.mkdtemp(prefix="gl-assertions-final-", dir=target))
    disabled, captured = disabled_default_copy(ROOT, work)
    compiler = target / "debug/jaic"
    fixture = ROOT / "tests/portable-stdlib/gl-default-assertions.jai"
    projection = ROOT / "tests/portable-stdlib/gl-projection.jai"
    helper = ROOT / "tests/window-render/gl-context.m"
    observer = ROOT / "tests/portable-stdlib/native/gl-side-effects.c"
    hashes = {
        str(path): hashlib.sha256(path.read_bytes()).hexdigest()
        for path in [fixture, projection, helper, observer]
    }
    (work / "identity.json").write_text(
        json.dumps(
            dict(
                shared_head=subprocess.check_output(
                    ["git", "rev-parse", "HEAD"], cwd=ROOT, text=True
                ).strip(),
                compiler_sha256=hashlib.sha256(compiler.read_bytes()).hexdigest(),
                source_hashes={
                    name: hashlib.sha256(body).hexdigest()
                    for name, body in captured.items()
                },
                tests=hashes,
                configuration_changes=["Basic/module.jai"],
                scope="Real offscreen NSOpenGL4.1 SDK; unmap observer delegates exact target/result unchanged. Custom SDK helper requires native execution; no interpreter GPU claim.",
            ),
            indent=2,
        )
        + "\n"
    )
    rows = []

    def run(name, command, env, expected=""):
        result = subprocess.run(
            list(map(str, command)),
            cwd=ROOT,
            env=env,
            capture_output=True,
            text=True,
            timeout=120,
        )
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

    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    if not run(
        "native-sdk-helper",
        [
            "clang",
            "-Wall",
            "-Wextra",
            "-Werror",
            "-dynamiclib",
            "-fPIC",
            "-framework",
            "AppKit",
            "-framework",
            "OpenGL",
            helper,
            observer,
            "-o",
            work / "libportable_gl_probe.dylib",
        ],
        env,
    ):
        raise SystemExit(1)

    def wrapper(path, source):
        path.write_text(
            "GL_PROBE :: #library "
            + json.dumps(str(work / "portable_gl_probe"))
            + ";\n#load "
            + json.dumps(str(source))
            + ";\n"
        )
        return path

    for mode, library in [("enabled", ROOT / "stdlib"), ("disabled", disabled)]:
        env = dict(os.environ, JAIC_STDLIB=str(library))
        source = wrapper(work / (mode + "-main.jai"), fixture)
        restore = wrapper(
            work / (mode + "-restore.jai"),
            library / "Simp/tests/context-default-assertions.jai",
        )
        for optimization in ["O0", "O2"]:
            executable = work / (mode + "-" + optimization)
            if run(
                mode + ":" + optimization + ":build",
                [compiler, source, "-" + optimization, "-exe", executable],
                env,
            ):
                for case in ["realloc", "unmap", "projection", "failure"]:
                    run(
                        mode + ":" + optimization + ":" + case,
                        [executable, mode, case],
                        env,
                        "ok\n",
                    )
            executable = work / (mode + "-restore-" + optimization)
            if run(
                mode + ":restore:" + optimization + ":build",
                [compiler, restore, "-" + optimization, "-exe", executable],
                env,
            ):
                run(mode + ":restore:" + optimization, [executable, mode], env, "ok\n")
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    run("projection:interp", [compiler, projection, "-interp"], env, "ok\n")
    for optimization in ["O0", "O2"]:
        executable = work / ("projection-" + optimization)
        if run(
            "projection:" + optimization + ":build",
            [compiler, projection, "-" + optimization, "-exe", executable],
            env,
        ):
            run("projection:" + optimization, [executable], env, "ok\n")
    source = work / "enabled-main.jai"
    for platform in ["macos", "linux", "windows"]:
        for cpu in ["x64", "arm64"]:
            run(
                platform + ":" + cpu + ":source",
                [compiler, source, "-check", "-os", platform, "-cpu", cpu],
                env,
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
                    *[ROOT / "stdlib" / name for name in OWNED[:3]],
                ],
                env,
            )
    run(
        "private-restore-lint",
        [target / "debug/jailint", "-D", "warnings", work / "enabled-restore.jai"],
        env,
    )
    for path in [fixture, projection, *[ROOT / "stdlib" / name for name in OWNED]]:
        run("format:" + path.name, [target / "jaifmt", "--check", path], env)
    for name in [*OWNED, "Basic/module.jai", "GL/declarations.jai", "GL/wrappers.jai"]:
        assert (ROOT / "stdlib" / name).read_bytes() == captured[name], (
            "owned/GL dependency source changed"
        )
    assert all(
        hashlib.sha256(Path(path).read_bytes()).hexdigest() == digest
        for path, digest in hashes.items()
    ), "test/helper changed"
    assert all(
        (disabled / name).read_bytes() == body
        for name, body in captured.items()
        if name != "Basic/module.jai"
    ), "disabled source copy changed"
    print("receipt:", work, flush=True)
    raise SystemExit(0 if all(row["passed"] for row in rows) else 1)


if __name__ == "__main__":
    main()
