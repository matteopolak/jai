#!/usr/bin/env python3
"""Verify a complete immutable capture of current shared model inputs."""
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import tempfile

from native_bindings.shared_snapshot import capture, unchanged

ROOT = Path(__file__).resolve().parents[1]
TARGET = Path(os.environ["CARGO_TARGET_DIR"]).resolve()


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    snapshot, identity = capture(TARGET / "immutable-runs", [
        "tests/developer-tools", "jaifmt.toml", "Cargo.toml", "Cargo.lock", "crates",
        "tools/check_generator_model.py", "tools/check_generator_model_shared.py",
        "tools/native_bindings/shared_snapshot.py",
    ])
    # The shared snapshot utility preserves bytes but makes all files read-only.
    # Retain execution on native tools that were executable in the actual input.
    for name in identity["files"]:
        if (ROOT / name).stat().st_mode & 0o111:
            (snapshot / name).chmod(0o555)
    outputs = Path(tempfile.mkdtemp(prefix="model-outputs-", dir=TARGET))
    (outputs / "debug").mkdir()
    binaries = [TARGET / "debug/jaic", TARGET / "debug/jailint", TARGET / "jaifmt"]
    binary_identity = {str(path): digest(path) for path in binaries}
    for path in binaries:
        destination = outputs / ("debug" if path.parent.name == "debug" else "") / path.name
        destination.symlink_to(path)
    spec = importlib.util.spec_from_file_location("model_checks", snapshot / "tools/check_generator_model.py")
    checks = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(checks)
    checks.ROOT = snapshot
    checks.TARGET = outputs
    checks.JAIC = TARGET / "debug/jaic"
    checks.ENV = dict(os.environ, JAIC_STDLIB=str(snapshot / "stdlib"))
    receipt = dict(snapshot=str(snapshot), outputs=str(outputs), input_identity=identity,
                   binaries=binary_identity, passed=False)
    try:
        checks.main()
        # Unchanged tools-owner assertions exercise the original integration failure.
        for name in ["bindings-template-arguments", "bindings-template-printing"]:
            source = snapshot / f"tests/developer-tools/{name}.jai"
            arguments = [outputs] if name == "bindings-template-printing" else []
            checks.run([checks.JAIC, source, "-interp", "-I", outputs, "--", *arguments], "ok\n")
            for optimization in [0, 2]:
                exe = outputs / f"{name}-O{optimization}"
                checks.run([checks.JAIC, source, f"-O{optimization}", "-exe", exe, "-I", outputs])
                checks.run([exe, *arguments], "ok\n")
        generated = outputs / "developer-tools-templates-generated.jai"
        checks.run([TARGET / "jaifmt", "--config", snapshot / "jaifmt.toml", generated])
        consumer = snapshot / "tests/developer-tools/bindings-template-printing-roundtrip.jai"
        checks.run([TARGET / "debug/jailint", "-D", "warnings", "-I", outputs, consumer, generated])
        checks.run([checks.JAIC, consumer, "-interp", "-I", outputs], "ok\n")
        for optimization in [0, 2]:
            exe = outputs / f"template-consumer-O{optimization}"
            checks.run([checks.JAIC, consumer, f"-O{optimization}", "-exe", exe, "-I", outputs])
            checks.run([exe], "ok\n")
        receipt["inputs_unchanged"] = unchanged(snapshot, identity)
        receipt["binaries_unchanged"] = all(digest(Path(name)) == value for name, value in binary_identity.items())
        if not receipt["inputs_unchanged"] or not receipt["binaries_unchanged"]:
            raise RuntimeError("Captured source/native inputs or own source-built tools changed")
        receipt["passed"] = True
    finally:
        (outputs / "generator-model-evidence.json").write_text(json.dumps(checks.evidence, indent=2) + "\n")
        (outputs / "verification.json").write_text(json.dumps(receipt, indent=2) + "\n")
        print(f"Immutable model receipt: {outputs / 'verification.json'}", flush=True)


if __name__ == "__main__":
    main()
