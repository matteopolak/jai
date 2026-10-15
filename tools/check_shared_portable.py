#!/usr/bin/env python3
"""Check the combined production library, without source or facade overlays.

The private diagnostic fixtures in producer runners remain separate coverage.
This native ARM64 baseline deliberately uses O0 only; other targets are not credited.
"""
import hashlib
import json
import os
from pathlib import Path
import subprocess
import time

from portable_toolchain import assigned_target
from check_portable_jks_crypto import fixtures
from build_portable_apk_signing_fixtures import build
from build_portable_apk_signing_native_vectors import build as build_native, verify_generated

ROOT = Path(__file__).resolve().parents[1]
WORK = ROOT / "artifacts/shared-integration/portable"


def main():
    WORK.mkdir(parents=True, exist_ok=True)
    compiler = assigned_target() / "debug/jaic"
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
    jks = WORK / "jks"
    fixtures(jks)
    apk = WORK / "apk"
    build(apk)
    build_native(apk)
    inputs = {p: hashlib.sha256(p.read_bytes()).hexdigest()
              for directory in [jks, apk] for p in directory.iterdir() if p.is_file()}
    rows = []

    def check(name, command, expected="ok\n", failure=None):
        start = time.monotonic()
        try:
            result = subprocess.run(list(map(str, command)), cwd=ROOT, env=env,
                                    capture_output=True, text=True, timeout=180)
            passed = (result.returncode == 0 and result.stdout == expected and not result.stderr
                      if failure is None else result.returncode == 1 and failure in result.stderr)
            row = dict(name=name, command=list(map(str, command)), passed=passed,
                       exit=result.returncode, stdout=result.stdout, stderr=result.stderr)
        except subprocess.TimeoutExpired:
            row = dict(name=name, command=list(map(str, command)), passed=False,
                       classification="timeout", timeout_seconds=180)
        row["seconds"] = time.monotonic() - start
        changed = [str(p) for p, digest in inputs.items()
                   if not p.is_file() or hashlib.sha256(p.read_bytes()).hexdigest() != digest]
        if changed:
            row.update(passed=False, classification="input_corruption", changed_inputs=changed)
        rows.append(row)
        print(name, "PASS" if row["passed"] else "FAIL", flush=True)
        (WORK / "report.json").write_text(json.dumps(dict(
            snapshot=subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT, text=True).strip(),
            production_dirty=subprocess.run(["git", "diff", "--quiet", "HEAD", "--", "stdlib", "crates"], cwd=ROOT).returncode != 0,
            command="python3 -B tools/check_shared_portable.py",
            passed=sum(r["passed"] for r in rows), failed=sum(not r["passed"] for r in rows),
            ignored=0, results=rows), indent=2) + "\n")
        return row["passed"]

    cases = [("socket-descriptor-domain.jai", [], []), ("socket-select.jai", [], []),
             ("socket-cmsg-layout.jai", [], []), ("android-asn1-closure/hex.jai", [], []),
             ("android-asn1-closure/views.jai", [], []),
             ("../stdlib/socket-loopback.jai", [], []),
             ("android-jks-crypto.jai", ["-add", "FIXTURE_ROOT :: " + json.dumps(str(jks)) + ";"], []),
             ("android-jks-crypto-failures.jai", ["-add", "FIXTURE_ROOT :: " + json.dumps(str(jks)) + ";"], []),
             ("android-apk-signing/crypto.jai", [], [str(apk)])]
    for index, (name, flags, arguments) in enumerate(cases):
        source = ROOT / "tests/portable-stdlib" / name
        for mode in ["interp", "native"]:
            label = name + ":" + mode
            if mode == "interp":
                passed = check(label, [compiler, source, *flags, "-interp", "--", *arguments])
            else:
                executable = WORK / f"case-{index}"
                built = check(label + ":build", [compiler, source, *flags, "-O0", "-exe", executable], expected="")
                passed = built and check(label, [executable, *arguments])
            if passed and name == "android-apk-signing/crypto.jai":
                # These outputs are independently checked by the native SDK.
                verify_generated(apk)
                verify_generated(apk, "jks")
    check("private-provider-rejected", [compiler, "-check", ROOT / "tests/portable-stdlib/negative/android-crypto-private-provider.jai"],
          failure="EVP_PKEY_free")
    raise SystemExit(0 if all(row["passed"] for row in rows) else 1)


if __name__ == "__main__":
    main()
