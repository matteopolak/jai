#!/usr/bin/env python3
"""Private portable linker logic + real missing-tool failure; no Windows SDK success claim."""

import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def main():
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    work = Path(tempfile.mkdtemp(prefix="linux-build-shared-", dir=target))
    compiler = target / "debug/jaic"
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"), LINUX_MULTIARCH_ROOT="")
    unit = ROOT / "stdlib/linux_build/tests/portable-contracts.jai"
    failure = ROOT / "stdlib/linux_build/tests/portable-custom-link-failure.jai"
    host = ROOT / "tests/portable-stdlib/negative/linux-build-host.jai"
    implementation = ROOT / "stdlib/internal/build/linux-link.jai"
    facade = ROOT / "stdlib/linux_build/module.jai"
    owned = [implementation, facade, unit, failure, host]
    hashes = {str(p): hashlib.sha256(p.read_bytes()).hexdigest() for p in owned}
    (work / "identity.json").write_text(
        json.dumps(
            dict(
                compiler_sha256=hashlib.sha256(compiler.read_bytes()).hexdigest(),
                stdlib=str(ROOT / "stdlib"),
                source_hashes=hashes,
            ),
            indent=2,
        )
        + "\n"
    )
    rows = []

    def run(name, command, status=0, exact=None, contains=None, extra_env=None):
        result = subprocess.run(
            list(map(str, command)),
            cwd=ROOT,
            env=dict(env, **(extra_env or {})),
            capture_output=True,
            text=True,
            timeout=120,
        )
        passed = (
            result.returncode == status
            and (exact is None or result.stdout == exact)
            and (contains is None or contains in result.stdout + result.stderr)
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

    default_output = "root=C:/UnrealToolchains/v21_clang-15.0.1-centos7\nlinux_build executable: target\nok\n"
    run("private:interp", [compiler, unit, "-interp"], exact=default_output)
    for mode in ["O0", "O2"]:
        executable = work / mode
        if run(
            mode + ":private-build", [compiler, unit, "-" + mode, "-exe", executable]
        ):
            run(mode + ":private-native", [executable], exact=default_output)
            run(
                mode + ":root-override",
                [executable],
                exact="root=C:/custom root\nlinux_build executable: target\nok\n",
                extra_env={"LINUX_MULTIARCH_ROOT": "C:\\custom root\\\\"},
            )
        run(
            mode + ":actual-missing-linker",
            [
                compiler,
                failure,
                "-" + mode,
                "-add",
                "#run,stallable run_missing_linker(" + json.dumps(str(work)) + ");",
            ],
            status=1,
            contains="missing linker failure observed\n",
            extra_env={"LINUX_MULTIARCH_ROOT": str(work / "absent SDK")},
        )
        row = rows[-1]
        row["passed"] = (
            row["passed"]
            and "FAILED_TO_LAUNCH" in row["stderr"]
            and "failed with exit code -1" in row["stderr"]
        )
        (work / "results.json").write_text(json.dumps(rows, indent=2) + "\n")
    for platform in ["macos", "linux", "windows"]:
        for cpu in ["x64", "arm64"]:
            name = platform + ":" + cpu
            run(
                name + ":source",
                [compiler, unit, "-check", "-os", platform, "-cpu", cpu],
            )
            run(
                name + ":lint",
                [
                    target / "debug/jailint",
                    "-D",
                    "warnings",
                    "-os",
                    platform,
                    "-cpu",
                    cpu,
                    "--context",
                    unit,
                    "--manifest",
                    work / (name.replace(":", "-") + "-lint.json"),
                    implementation,
                    unit,
                ],
            )
            run(
                name + ":host-rejection",
                [compiler, host, "-check", "-os", platform, "-cpu", cpu],
                status=1,
                contains="#assert failed: `WINDOWS_HOST` is false",
            )
    run(
        "negative-workflow-lint",
        [
            target / "debug/jailint",
            "-D",
            "warnings",
            "--context",
            failure,
            "--manifest",
            work / "negative-lint.json",
            implementation,
            failure,
        ],
    )
    for path in owned:
        run(
            "format:" + str(path.relative_to(ROOT)),
            [target / "jaifmt", "--check", path],
        )
    assert all(
        hashlib.sha256(Path(p).read_bytes()).hexdigest() == digest
        for p, digest in hashes.items()
    )
    print("receipt:", work, flush=True)
    raise SystemExit(0 if all(row["passed"] for row in rows) else 1)


if __name__ == "__main__":
    main()
