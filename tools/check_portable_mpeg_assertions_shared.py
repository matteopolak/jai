#!/usr/bin/env python3
"""Exercise MPEG with current shared sources and an isolated Basic test setting.

Only the disabled test copy changes Basic's existing default. No production
configuration, shared fixture, source overlay, or copied binary is installed.
Run after source-building jaic in this worker's assigned CARGO_TARGET_DIR.
"""
import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile
from portable_assertion_test_config import disabled_default_copy

ROOT = Path(__file__).resolve().parents[1]


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    compiler = target / "debug/jaic"
    work = Path(tempfile.mkdtemp(prefix="mpeg-assertions-", dir=target))
    fixture = ROOT / "tests/native-regressions/pl-mpeg-clip.mpg"
    source = ROOT / "tests/portable-stdlib/mpeg-default-assertions.jai"
    library = ROOT / "stdlib"
    disabled, captured = disabled_default_copy(ROOT, work)
    identity = {
        "shared_head": subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT, text=True).strip(),
        "compiler_sha256": digest(compiler), "test_sha256": digest(source),
        "fixture_sha256": digest(fixture),
        "source_hashes": {name: hashlib.sha256(body).hexdigest() for name, body in captured.items()},
        "configuration_changes": ["Basic/module.jai"],
        "configuration_diff": "Basic/module.jai: ENABLE_ASSERT := true -> ENABLE_ASSERT := false",
        "policy": "Current clean shared Jai source copy only; no copied binaries. Default Basic identity is checked by the test.",
    }
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
        run(mode + ":interp", [compiler, source, "-interp", "--", mode, fixture], env, "ok\n")
        for optimization in ["O0", "O2"]:
            executable = work / (mode + "-" + optimization)
            if run(mode + ":" + optimization + ":build",
                   [compiler, source, "-" + optimization, "-exe", executable], env, ""):
                run(mode + ":" + optimization, [executable, mode, fixture], env, "ok\n")
    assert digest(fixture) == identity["fixture_sha256"], "immutable MPEG fixture changed"
    assert digest(source) == identity["test_sha256"], "test changed during verification"
    owned = ["Basic/module.jai", "pl_mpeg/module.jai"]
    owned.extend(name for name in captured if name.startswith("internal/media/mpeg/"))
    assert all((library / name).read_bytes() == captured[name] for name in owned), "owned source changed during verification"
    assert all((disabled / name).read_bytes() == body for name, body in captured.items()
               if name != "Basic/module.jai"), "disabled source copy changed"
    print("receipt:", work, flush=True)
    raise SystemExit(0 if all(row["passed"] for row in rows) else 1)


if __name__ == "__main__":
    main()
