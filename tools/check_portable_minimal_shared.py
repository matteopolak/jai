#!/usr/bin/env python3
"""Reviewed Minimal workflow using real compiler workspaces and native child output."""

import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def main():
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    work = Path(tempfile.mkdtemp(prefix="minimal-shared-", dir=target))
    compiler = target / "debug/jaic"
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    fixture = ROOT / "tests/portable-stdlib/minimal-path-contracts.jai"
    meta = ROOT / "tests/portable-stdlib/minimal-build-contracts.jai"
    owned = [
        ROOT / "stdlib/Minimal_Metaprogram/module.jai",
        ROOT / "stdlib/internal/build/minimal.jai",
        fixture,
        meta,
    ]
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

    def run(name, command, cwd=work, status=0, contains=None, exact=None):
        result = subprocess.run(
            list(map(str, command)),
            cwd=cwd,
            env=env,
            capture_output=True,
            text=True,
            timeout=120,
        )
        passed = (
            result.returncode == status
            and (contains is None or contains in result.stdout + result.stderr)
            and (exact is None or result.stdout == exact)
        )
        rows.append(
            dict(
                name=name,
                command=list(map(str, command)),
                cwd=str(cwd),
                exit=result.returncode,
                stdout=result.stdout,
                stderr=result.stderr,
                passed=passed,
            )
        )
        (work / "results.json").write_text(json.dumps(rows, indent=2) + "\n")
        print(name, "PASS" if passed else "FAIL", flush=True)
        return passed

    def condition(name, passed):
        rows.append(dict(name=name, passed=passed))
        (work / "results.json").write_text(json.dumps(rows, indent=2) + "\n")
        print(name, "PASS" if passed else "FAIL", flush=True)

    child = (
        '#import "Basic"; C :: #import "Compiler";\n'
        '#run { o:=C.get_build_options(); print("child=%,%,%\\n",'
        "o.backend,o.llvm_options.bitcode_optimization_setting,o.stack_trace); }\n"
        'main :: () { if supplemental() != 37 exit(2); write_string("child ok\\n"); }\n'
    )
    support = "supplemental :: () -> s64 { return 37; }\n"
    for mode in ["O0", "O2"]:
        run(mode + ":predicate-interp", [compiler, fixture, "-interp"])
        binary = work / ("predicate-" + mode)
        if run(
            mode + ":predicate-build", [compiler, fixture, "-" + mode, "-exe", binary]
        ):
            run(mode + ":predicate-run", [binary], exact="ok\n")
        for name, flags, first, expected_cwd, options in [
            ("default", [], "unit.jai", "", "child=LLVM,UNSET,true"),
            (
                "unknown-empty",
                ["", "-unknown"],
                "unit.jai",
                "",
                "child=LLVM,UNSET,true",
            ),
            ("backend-uncommitted", ["-x64"], "unit.jai", "", "child=LLVM,UNSET,true"),
            ("directory", [], "src/unit.jai", "src", "child=LLVM,UNSET,true"),
            ("no-cwd", ["-no_cwd"], "src/unit.jai", "", "child=LLVM,UNSET,true"),
            (
                "release",
                ["-release", "-llvm"],
                "src/unit.jai",
                "src",
                "child=LLVM,O2,false",
            ),
            (
                "backend-last",
                ["-release", "-x64", "-llvm"],
                "src/unit.jai",
                "src",
                "child=LLVM,O2,false",
            ),
        ]:
            case = work / (mode + "-" + name)
            (case / "src").mkdir(parents=True)
            local_meta = case / "build.jai"
            local_meta.write_bytes(meta.read_bytes())
            (case / first).write_text(child)
            (case / "support.jai").write_text(support)
            source_arguments = [first, "support.jai"]
            if name == "no-cwd":
                # Reviewed call-site rule: no_cwd preserves paths, so the
                # successful external-source case must supply absolute paths.
                source_arguments = [str(case / value) for value in source_arguments]
            command = [
                compiler,
                local_meta,
                "-" + mode,
                "-",
                *flags,
                *source_arguments,
            ]
            if run(
                mode + ":" + name + ":build", command, cwd=case, contains="child=LLVM"
            ):
                condition(
                    mode + ":" + name + ":child-options", options in rows[-1]["stdout"]
                )
                condition(
                    mode + ":" + name + ":cwd",
                    "cwd=" + str(case / expected_cwd) + "\n" in rows[-2]["stdout"],
                )
                output = case / ("src" if "/" in first else "") / "unit"
                run(mode + ":" + name + ":native", [output], exact="child ok\n")
                condition(
                    mode + ":" + name + ":no-parent-output",
                    not (case / "build").exists(),
                )
        relative = work / (mode + "-no-cwd-relative")
        (relative / "src").mkdir(parents=True)
        relative_meta = relative / "build.jai"
        relative_meta.write_bytes(meta.read_bytes())
        (relative / "src/unit.jai").write_text(child)
        run(
            mode + ":no-cwd-relative-callsite-negative",
            [compiler, relative_meta, "-" + mode, "-", "-no_cwd", "src/unit.jai"],
            cwd=relative,
            status=1,
            contains=str(ROOT / "stdlib/internal/build/src/unit.jai"),
        )
        empty = work / (mode + "-empty")
        empty.mkdir()
        local_meta = empty / "build.jai"
        local_meta.write_bytes(meta.read_bytes())
        run(
            mode + ":empty",
            [compiler, local_meta, "-" + mode, "-", "", "-unknown"],
            cwd=empty,
        )
        condition(
            mode + ":empty-no-output",
            {p for p in empty.iterdir() if not p.name.startswith("._")} == {local_meta},
        )
        run(
            mode + ":missing-source",
            [compiler, local_meta, "-" + mode, "-", "absent.jai"],
            cwd=empty,
            status=1,
            contains="absent.jai",
        )
    for platform in ["macos", "linux", "windows"]:
        for cpu in ["x64", "arm64"]:
            run(
                platform + ":" + cpu + ":source",
                [compiler, fixture, "-check", "-os", platform, "-cpu", cpu],
            )
    for context in [meta, fixture]:
        run(
            "strict-lint:" + context.name,
            [
                target / "debug/jailint",
                "-D",
                "warnings",
                "--context",
                context,
                "--manifest",
                work / (context.stem + "-lint.json"),
                *owned[:2],
                context,
            ],
        )
    for path in owned:
        run("format:" + path.name, [target / "jaifmt", "--check", path])
    assert all(
        hashlib.sha256(Path(p).read_bytes()).hexdigest() == digest
        for p, digest in hashes.items()
    )
    print("receipt:", work, flush=True)
    raise SystemExit(0 if all(row["passed"] for row in rows) else 1)


if __name__ == "__main__":
    main()
