#!/usr/bin/env python3
"""Check the three reviewed MPEG helpers against current shared production."""
import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile
from portable_assertion_test_config import disabled_default_copy

ROOT = Path(__file__).resolve().parents[1]
CASES = ["mpeg-no-start-code.jai", "mpeg-block-set.jai", "mpeg-put-pixel.jai"]


def main():
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    work = Path(tempfile.mkdtemp(prefix="mpeg-public-macros-", dir=target))
    disabled, captured = disabled_default_copy(ROOT, work)
    compiler = target / "debug/jaic"
    tests = [ROOT / "tests/portable-stdlib" / name for name in CASES]
    test_hashes = {str(path): hashlib.sha256(path.read_bytes()).hexdigest() for path in tests}
    identity = dict(
        shared_head=subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT, text=True).strip(),
        compiler_sha256=hashlib.sha256(compiler.read_bytes()).hexdigest(),
        source_hashes={name: hashlib.sha256(data).hexdigest() for name, data in captured.items()},
        tests=test_hashes, configuration_changes=["Basic/module.jai"],
        configuration_diff="Basic/module.jai existing default ENABLE_ASSERT true -> false",
        scope="buffer_no_start_code, BLOCK_SET, PUT_PIXEL. Hash_Table.Walk_Table is separately compiler-blocked.",
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

    for mode, library in [("enabled", ROOT / "stdlib"), ("disabled", disabled)]:
        env = dict(os.environ, JAIC_STDLIB=str(library))
        for index, source in enumerate(tests):
            run(mode + ":" + source.name + ":interp", [compiler, source, "-interp"], env, "ok\n")
            for optimization in ["O0", "O2"]:
                executable = work / (mode + "-" + str(index) + "-" + optimization)
                if run(mode + ":" + source.name + ":" + optimization + ":build",
                       [compiler, source, "-" + optimization, "-exe", executable], env, ""):
                    run(mode + ":" + source.name + ":" + optimization, [executable], env, "ok\n")
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    for source in tests:
        run(source.name + ":lint", [target / "debug/jailint", "-D", "warnings", source], env, "")
        run(source.name + ":format", [target / "jaifmt", "--check", source], env, "")
    owned = ["Basic/module.jai", "internal/media/mpeg/buffer.jai", "internal/media/mpeg/motion.jai",
             "internal/media/mpeg/pixels.jai"]
    assert all((ROOT / "stdlib" / name).read_bytes() == captured[name] for name in owned), "owned source changed"
    assert all(hashlib.sha256(Path(path).read_bytes()).hexdigest() == value
               for path, value in test_hashes.items()), "test changed"
    assert all((disabled / name).read_bytes() == data for name, data in captured.items()
               if name != "Basic/module.jai"), "disabled source copy changed"
    print("receipt:", work, flush=True)
    raise SystemExit(0 if all(row["passed"] for row in rows) else 1)


if __name__ == "__main__":
    main()
