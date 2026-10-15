#!/usr/bin/env python3
"""Run the actual Cocoa backend unit on a unique pasteboard, never generalPasteboard.

The root-authorized disabled test configuration changes only Basic's existing
default. Public system-clipboard round trips are not claimed by this SDK unit.
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
    work = Path(tempfile.mkdtemp(prefix="clipboard-cocoa-", dir=target))
    disabled, captured = disabled_default_copy(ROOT, work)
    compiler = target / "debug/jaic"
    sdk = Path(subprocess.check_output(["xcrun", "--show-sdk-path"], text=True).strip())
    headers = [sdk / "System/Library/Frameworks/AppKit.framework/Headers" / name
               for name in ["NSPasteboard.h", "NSApplication.h"]]
    identity = dict(
        shared_head=subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT, text=True).strip(),
        source_hashes={name: hashlib.sha256(body).hexdigest() for name, body in captured.items()},
        compiler_sha256=hashlib.sha256(compiler.read_bytes()).hexdigest(),
        sdk_headers={str(path): hashlib.sha256(path.read_bytes()).hexdigest() for path in headers},
        configuration_changes=["Basic/module.jai"],
        configuration_diff="Basic/module.jai existing default ENABLE_ASSERT true -> false",
        scope="Actual Cocoa helper SDK unit with unique pasteboard; no general clipboard data accessed.",
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
        source = library / "Clipboard/tests/cocoa-operations.jai"
        run(mode + ":interp", [compiler, source, "-interp", "--", mode], env, "ok\n")
        for optimization in ["O0", "O2"]:
            executable = work / (mode + "-" + optimization)
            if run(mode + ":" + optimization + ":build",
                   [compiler, source, "-" + optimization, "-exe", executable], env, ""):
                run(mode + ":" + optimization, [executable, mode], env, "ok\n")
    owned = ["Basic/module.jai", "internal/clipboard/cocoa.jai", "Clipboard/tests/cocoa-operations.jai"]
    assert all((ROOT / "stdlib" / name).read_bytes() == captured[name] for name in owned), "owned source changed"
    assert all((disabled / name).read_bytes() == body for name, body in captured.items()
               if name != "Basic/module.jai"), "disabled source copy changed"
    print("receipt:", work, flush=True)
    raise SystemExit(0 if all(row["passed"] for row in rows) else 1)


if __name__ == "__main__":
    main()
