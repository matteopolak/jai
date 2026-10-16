#!/usr/bin/env python3
"""Default Runtime hooks and real emitted system-entry ordering, without insertion fiction."""

import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def main():
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    work = Path(tempfile.mkdtemp(prefix="runtime-hooks-shared-", dir=target))
    compiler = target / "debug/jaic"
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    fixture = ROOT / "tests/portable-stdlib/runtime-instrumentation-contracts.jai"
    no_entry = ROOT / "tests/portable-stdlib/runtime-instrumentation-no-entry.jai"
    owned = [ROOT / "stdlib/Runtime_Support/module.jai", fixture, no_entry]
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

    def record(row):
        rows.append(row)
        (work / "results.json").write_text(json.dumps(rows, indent=2) + "\n")
        print(row["name"], "PASS" if row["passed"] else "FAIL", flush=True)

    def run(name, command, exact=None):
        result = subprocess.run(
            list(map(str, command)),
            cwd=ROOT,
            env=env,
            capture_output=True,
            text=True,
            timeout=120,
        )
        passed = (
            result.returncode == 0
            and not result.stderr
            and (exact is None or result.stdout == exact)
        )
        record(
            dict(
                name=name,
                command=list(map(str, command)),
                exit=result.returncode,
                stdout=result.stdout,
                stderr=result.stderr,
                passed=passed,
            )
        )
        return passed

    run("interp", [compiler, fixture, "-interp"], exact="ok\n")
    for mode in ["O0", "O2"]:
        executable, ir = work / mode, work / (mode + ".ll")
        if run(
            mode + ":build",
            [compiler, fixture, "-" + mode, "-exe", executable, "-emit_ir", ir],
        ):
            run(mode + ":native", [executable], exact="ok\n")
            if mode == "O0":
                text = ir.read_text()
                body = re.search(
                    r"define i32 @main\([^\n]*\{(.*?)^\}", text, re.M | re.S
                )
                calls = re.findall(r"call [^\n]*@([^ (]+)", body[1]) if body else []
                required = [
                    "__jai_runtime_init",
                    "__instrumentation_first",
                    "__instrumentation_second",
                    "__entry_point",
                ]
                positions = [
                    next(
                        (
                            i
                            for i, call in enumerate(calls)
                            if call.startswith(name + ".")
                        ),
                        -1,
                    )
                    for name in required
                ]
                record(
                    dict(
                        name="O0:emitted-entry-order",
                        calls=calls,
                        positions=positions,
                        passed=all(p >= 0 for p in positions)
                        and positions == sorted(positions),
                    )
                )
        object_ir = work / ("no-entry-" + mode + ".ll")
        driver = work / ("object-driver-" + mode + ".jai")
        driver.write_text(
            'C :: #import "Compiler";\n#run,stallable {\n'
            ' w := C.compiler_create_workspace("no entry hook proof");\n'
            " o := C.get_build_options(w); o.output_type = .OBJECT_FILE;\n"
            " o.runtime_support_definitions = .ONLY_INIT; o.backtrace_on_crash = .OFF;\n"
            " C.set_optimization(*o, "
            + (".DEBUG" if mode == "O0" else ".OPTIMIZED")
            + ");\n"
            ' o.output_executable_name = "no-entry-' + mode + '";\n'
            " o.output_path = " + json.dumps(str(work)) + ";\n"
            " o.llvm_options.output_llvm_ir = true; C.set_build_options(o, w);\n"
            " C.add_build_file(" + json.dumps(str(no_entry)) + ", w);\n"
            " C.set_build_options_dc(.{do_output=false, write_added_strings=false});\n}\n"
        )
        if run(mode + ":object", [compiler, driver]):
            text = object_ir.read_text()
            record(
                dict(
                    name=mode + ":no-system-entry",
                    passed=not re.search(r"^define[^\n]*@main\(", text, re.M),
                )
            )
    for source in [fixture, no_entry]:
        for platform in ["macos", "linux", "windows"]:
            for cpu in ["x64", "arm64"]:
                run(
                    source.stem + ":" + platform + ":" + cpu,
                    [compiler, source, "-check", "-os", platform, "-cpu", cpu],
                )
        run(
            source.stem + ":lint",
            [
                target / "debug/jailint",
                "-D",
                "warnings",
                "--context",
                source,
                "--manifest",
                work / (source.stem + "-lint.json"),
                owned[0],
                source,
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
