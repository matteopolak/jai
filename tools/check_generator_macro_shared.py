#!/usr/bin/env python3
"""Verify the seven macro/expression APIs against current shared production."""
import hashlib
import json
import os
from pathlib import Path
import platform
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
PROGRAMS = ["tokens", "calls", "invalid", "state", "consumer"]
OWNED = [ROOT / "stdlib/Bindings_Generator/macro-expressions.jai",
         ROOT / "stdlib/internal/developer-tools/generator-macro-expressions.jai",
         ROOT / "stdlib/Bindings_Generator/tests/generator-macro-shared-state.jai"]
OWNED += [ROOT / "tests/developer-tools" / ("generator-macro-shared-" + name + ".jai")
          for name in PROGRAMS]


def hashes():
    paths = [ROOT / "Cargo.toml", ROOT / "Cargo.lock", ROOT / "rust-toolchain.toml"]
    for folder in ["crates", "stdlib", "jaifmt"]:
        paths.extend(p for p in (ROOT / folder).rglob("*")
                     if p.is_file() and not p.name.startswith(".")
                     and p.suffix in [".jai", ".rs", ".toml", ".c", ".h"])
    paths.extend(OWNED)
    paths.append(ROOT / "tests/developer-tools/generator-macro-shared-state.h")
    return {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest()
            for p in sorted(set(paths))}


def main():
    if platform.system() != "Darwin":
        raise SystemExit("Actual Mac host required; other native platforms are separate gates")
    assigned = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    if not assigned.is_relative_to(Path("/Volumes/T7")) or "portable-asn1-socket" not in assigned.parts:
        raise SystemExit("Use this worker's assigned T7 target")
    facade = (ROOT / "stdlib/Bindings_Generator/module.jai").read_text()
    if facade.count('#load "macro-expressions.jai";') != 1:
        raise SystemExit("Integration-owned single macro facade load is required; runner never rewrites it")
    output = Path(tempfile.mkdtemp(prefix="generator-macro-verify-", dir=assigned))
    environment = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"), TMPDIR=str(output),
                       PYTHONDONTWRITEBYTECODE="1")
    receipt = {"root": str(ROOT), "head": subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT, text=True).strip(),
               "output": str(output), "host": platform.platform(), "source_sha256": hashes(), "commands": []}
    failures = []
    blocked = []

    def run(command, label, expected=None, android=False):
        command = list(map(str, command))
        result = subprocess.run(command, cwd=ROOT if label == "source-build" else output,
                                env=environment, capture_output=True, text=True, timeout=180)
        (output / (label + ".stdout")).write_text(result.stdout)
        (output / (label + ".stderr")).write_text(result.stderr)
        pending = android and result.returncode == 2 and "unknown OS `android`" in result.stderr
        passed = result.returncode == 0 and (expected is None or (result.stdout == expected and not result.stderr))
        receipt["commands"].append({"label": label, "argv": command, "returncode": result.returncode,
                                    "status": "pass" if passed else "blocked" if pending else "fail"})
        if not passed:
            (blocked if pending else failures).append(label)
        (output / "receipt.json").write_text(json.dumps(receipt, indent=2) + "\n")
        print(label + ": " + receipt["commands"][-1]["status"].upper(), flush=True)
        return passed

    compiler_dir = output / "compiler"
    # Fresh output directory; compiler/library inputs never come from an old
    # clone, archive overlay, peer staging helper or a prebuilt reference tool.
    if not run(["cargo", "build", "--manifest-path", ROOT / "Cargo.toml", "--locked", "--offline",
                "--target-dir", compiler_dir, "-p", "jaic-cli", "-p", "jailint"], "source-build"):
        raise SystemExit("Source build failed; evidence: " + str(output))
    compiler = compiler_dir / "debug/jaic"
    lint = compiler_dir / "debug/jailint"
    for name in PROGRAMS:
        source = ROOT / "tests/developer-tools" / ("generator-macro-shared-" + name + ".jai")
        run([compiler, "-interp", source], name + "-interp", name + " ok\n")
        for optimization in ["-O0", "-O2"]:
            program = output / (name + optimization)
            if run([compiler, source, optimization, "-exe", program], name + optimization + "-build"):
                run([program], name + optimization + "-native", name + " ok\n")
    run([lint, "-D", "warnings", "--manifest", output / "lint.json", "--checked-files", output / "lint.files",
         ROOT / "stdlib/Bindings_Generator", *OWNED], "strict-lint")
    formatter = output / "jaifmt"
    if run([compiler, ROOT / "jaifmt/main.jai", "-O0", "-exe", formatter], "formatter-build"):
        run([formatter, "--config", ROOT / "jaifmt.toml", "--check", *OWNED], "owned-format")
    for os_name in ["macos", "linux", "windows"]:
        for cpu in ["x64", "arm64"]:
            for name in PROGRAMS:
                source = ROOT / "tests/developer-tools" / ("generator-macro-shared-" + name + ".jai")
                run([compiler, "-check", "-os", os_name, "-cpu", cpu, source], f"{name}-{os_name}-{cpu}")
    run([compiler, "-check", "-os", "android", ROOT / "tests/cleanroom-language/android-target-minimal.jai"],
        "android-target-minimal", android=True)
    after = hashes()
    before = receipt["source_sha256"]
    changed = sorted(k for k in before.keys() | after.keys() if before.get(k) != after.get(k))
    receipt["source_changes"] = changed
    receipt["immutable_header_unchanged"] = before["tests/developer-tools/generator-macro-shared-state.h"] == after["tests/developer-tools/generator-macro-shared-state.h"]
    (output / "receipt.json").write_text(json.dumps(receipt, indent=2) + "\n")
    print("Evidence: " + str(output), flush=True)
    if changed:
        raise SystemExit("Shared source snapshot changed; rerun fresh: " + ", ".join(changed))
    if failures:
        raise SystemExit("Failed gates: " + ", ".join(failures))
    if blocked:
        raise SystemExit(2)


if __name__ == "__main__":
    main()
