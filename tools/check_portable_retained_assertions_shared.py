#!/usr/bin/env python3
"""Check real default Basic settings for retained text and keymap operations.

The disabled configuration is a source-only copy of current shared stdlib with
one existing Basic default changed. Every generated file belongs to this run.
"""
import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile
from portable_assertion_test_config import disabled_default_copy

ROOT = Path(__file__).resolve().parents[1]


def main():
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    work = Path(tempfile.mkdtemp(prefix="retained-assertions-", dir=target))
    library = ROOT / "stdlib"
    disabled, captured = disabled_default_copy(ROOT, work)
    compiler = target / "debug/jaic"
    source = ROOT / "tests/portable-stdlib/retained-default-assertions.jai"
    identity = dict(
        shared_head=subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT, text=True).strip(),
        source_hashes={name: hashlib.sha256(data).hexdigest() for name, data in captured.items()},
        compiler_sha256=hashlib.sha256(compiler.read_bytes()).hexdigest(),
        test_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),
        configuration_changes=["Basic/module.jai"],
        configuration_diff="Basic/module.jai: ENABLE_ASSERT := true -> ENABLE_ASSERT := false",
        policy="Root-authorized TEST configuration only; no production default change or copied binary.",
    )
    (work / "identity.json").write_text(json.dumps(identity, indent=2) + "\n")
    rows = []

    def run(name, command, env, expected):
        result = subprocess.run(list(map(str, command)), cwd=ROOT, env=env,
                                capture_output=True, text=True, timeout=120)
        passed = result.returncode == 0 and result.stdout == expected and not result.stderr
        rows.append(dict(name=name, command=list(map(str, command)), exit=result.returncode,
                         stdout=result.stdout, stderr=result.stderr, passed=passed))
        (work / "results.json").write_text(json.dumps(rows, indent=2) + "\n")
        print(name, "PASS" if passed else "FAIL", flush=True)
        return passed

    for mode, current in [("enabled", library), ("disabled", disabled)]:
        env = dict(os.environ, JAIC_STDLIB=str(current))
        for case in ["text", "left", "set", "map"]:
            output = work / (mode + "-interp-" + case)
            output.mkdir()
            run(mode + ":interp:" + case,
                [compiler, source, "-interp", "--", mode, case, output], env, "ok\n")
        for optimization in ["O0", "O2"]:
            executable = work / (mode + "-" + optimization)
            if not run(mode + ":" + optimization + ":build",
                       [compiler, source, "-" + optimization, "-exe", executable], env, ""):
                continue
            for case in ["text", "left", "set", "map"]:
                output = work / (mode + "-" + optimization + "-" + case)
                output.mkdir()
                passed = run(mode + ":" + optimization + ":" + case,
                             [executable, mode, case, output], env, "ok\n")
                if passed and case in ["set", "map"]:
                    assert (output / (case + ".txt")).is_file(), "native keymap file absent"
    owned = ["Basic/module.jai", "GetRect/module.jai", "GetRect_LeftHanded/module.jai", "Keymap/module.jai",
             "internal/numerics/ui_text.jai", "internal/input/keymap-text.jai"]
    assert all((library / name).read_bytes() == captured[name] for name in owned), "owned source changed"
    assert hashlib.sha256(source.read_bytes()).hexdigest() == identity["test_sha256"], "test source changed"
    assert all((disabled / name).read_bytes() == data for name, data in captured.items()
               if name != "Basic/module.jai"), "disabled copy changed"
    print("receipt:", work, flush=True)
    raise SystemExit(0 if all(row["passed"] for row in rows) else 1)


if __name__ == "__main__":
    main()
