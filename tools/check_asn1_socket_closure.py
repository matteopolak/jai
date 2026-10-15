#!/usr/bin/env python3
"""Scoped shared-tree verification with a fresh compiler and worker-only outputs."""
import argparse
import ast
import hashlib
import json
import os
from pathlib import Path
import platform
import random
import re
import subprocess
import struct
import tempfile

ROOT = Path(__file__).resolve().parents[1]
CHECKPOINT = "89560db9"
OWNED = ["asn1-identity.jai", "asn1-tags.jai", "asn1-values.jai",
         "asn1-records.jai", "asn1-diagnostics.jai", "byte-readers.jai", "asn1-hex.jai"]


def source_hashes():
    paths = [ROOT / "Cargo.toml", ROOT / "Cargo.lock", ROOT / "rust-toolchain.toml"]
    for directory in ["stdlib", "crates", "jaifmt"]:
        paths.extend(path for path in (ROOT / directory).rglob("*")
                     if path.is_file() and not path.name.startswith(".")
                     and path.suffix in [".jai", ".rs", ".toml"])
    return {str(path.relative_to(ROOT)): hashlib.sha256(path.read_bytes()).hexdigest()
            for path in sorted(paths)}


def assert_unchanged(receipt):
    current = source_hashes()
    previous = receipt["source_sha256"]
    changed = sorted(name for name in current.keys() | previous.keys()
                     if current.get(name) != previous.get(name))
    if changed:
        raise RuntimeError("Shared sources changed during verification; rebuild: " + ", ".join(changed))


def audit_loads():
    extension = ROOT / "stdlib/Android/Toolchain/asn1-extension.jai"
    loads = re.findall(r'^#load "([^"]+)";', extension.read_text(), re.M)
    expected = ["../../internal/android-toolchain/" + name for name in OWNED]
    if loads != expected:
        raise RuntimeError("extension must load each canonical owned file exactly once")
    for relative in loads:
        path = (extension.parent / relative).resolve(strict=True)
        if not path.is_relative_to(ROOT / "stdlib/internal/android-toolchain"):
            raise RuntimeError("extension escapes its owned canonical definitions")
    facade = ROOT / "stdlib/Android/Toolchain/module.jai"
    text = facade.read_text()
    direct = [f'#load "{relative}";' for relative in expected[:6]]
    if all(text.count(line) == 1 for line in direct) and '#load "asn1-extension.jai";' not in text:
        return "shared facade retains six direct loads; integrator replacement pending"
    if all(line not in text for line in direct) and text.count('#load "asn1-extension.jai";') == 1:
        return "shared facade uses extension exactly once"
    raise RuntimeError("shared facade has partial or duplicate ASN.1 integration")


def reviewed_printer_output():
    # Read a local fixture oracle without importing its peer-staging dependency.
    tree = ast.parse((ROOT / "tools/check_portable_asn1_printer.py").read_text())
    for node in tree.body:
        if isinstance(node, ast.Assign) and any(isinstance(t, ast.Name) and t.id == "EXPECTED" for t in node.targets):
            return ast.literal_eval(node.value)
    raise RuntimeError("local diagnostic fixture oracle is absent")


def asn1_vectors():
    rng = random.Random(80411)
    integers = list(range(256)) + [0, 2**63 - 1, 32767, 32768, 65535]
    integers += [rng.randrange(2**63) for _ in range(256)]
    wire = bytearray(struct.pack("<I", len(integers)))
    for value in integers:
        width = max(1, (value.bit_length() + 8) // 8)
        data = value.to_bytes(width, "big", signed=True)
        wire += struct.pack("<I", width) + data + struct.pack("<q", value)
    identifiers = [[0, 0], [0, 39], [1, 0], [1, 39], [2, 0], [2, 40], [2, 2**64 - 1]]
    identifiers += [[2, rng.randrange(2**64), *[rng.randrange(2**64) for _ in range(count - 2)]]
                    for count in range(2, 13) for _ in range(16)]
    wire += struct.pack("<I", len(identifiers))
    for arcs in identifiers:
        data = bytearray()
        for value in [arcs[0] * 40 + arcs[1], *arcs[2:]]:
            digits = [value & 127]
            value >>= 7
            while value:
                digits.append((value & 127) | 128)
                value >>= 7
            data.extend(reversed(digits))
        text = (".".join(map(str, arcs)) + ".").encode("ascii")
        wire += struct.pack("<I", len(data)) + data + struct.pack("<I", len(arcs))
        wire += b"".join(struct.pack("<Q", arc) for arc in arcs) + struct.pack("<I", len(text)) + text
    return wire


def check_targets(output):
    """Continue target gates only against an unchanged, source-built snapshot."""
    assigned = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    output = output.resolve(strict=True)
    if not output.is_relative_to(assigned):
        raise RuntimeError("verification directory escapes the assigned target")
    receipt = json.loads((output / "receipt.json").read_text())
    if receipt.get("source_mode") != "current-shared-tree":
        raise RuntimeError("verification directory is not a current shared-tree build")
    if not any(c["label"] == "source-build" and c["passed"] for c in receipt["commands"]):
        raise RuntimeError("verification directory has no successful source build")
    assert_unchanged(receipt)
    library = ROOT / "stdlib"
    compiler = output / "compiler/debug/jaic"
    lint = output / "compiler/debug/jailint"
    env = dict(os.environ, JAIC_STDLIB=str(library), TMPDIR=str(output))
    results = []

    def check(command, label, pending=False):
        result = subprocess.run(list(map(str, command)), cwd=ROOT, env=env, capture_output=True, text=True, timeout=180)
        (output / (label + ".stdout")).write_text(result.stdout)
        (output / (label + ".stderr")).write_text(result.stderr)
        passed = result.returncode == 0
        blocked = pending and result.returncode == 2 and "unknown OS" in result.stderr and "android" in result.stderr
        results.append({"label": label, "argv": list(map(str, command)), "returncode": result.returncode,
                        "status": "pass" if passed else "blocked" if blocked else "fail"})
        print(label + ": " + results[-1]["status"].upper(), flush=True)
        return passed

    for os_name in ["macos", "linux", "windows"]:
        for cpu in ["x64", "arm64"]:
            active = ["socket.jai", "socket-abi.jai", "socket-native-completions.jai"]
            if os_name == "windows":
                active += ["socket-windows.jai", "socket-fields-windows.jai", "scope-word.jai", "winsock-control.jai"]
            else:
                active += ["socket-posix.jai", "socket-cmsg.jai"]
                active += ["socket-fields-macos.jai"] if os_name == "macos" else ["socket-fields-tcp-unix.jai"]
            label = f"socket-lint-{os_name}-{cpu}"
            check([compiler, "-check", "-os", os_name, "-cpu", cpu,
                   ROOT / "tests/stdlib/socket-loopback.jai"], f"socket-comprehensive-{os_name}-{cpu}")
            check([compiler, "-check", "-os", os_name, "-cpu", cpu,
                   ROOT / "tests/portable-stdlib/socket-descriptor-domain.jai"], f"descriptor-domain-{os_name}-{cpu}")
            check([lint, "-D", "warnings", "-os", os_name, "-cpu", cpu,
                   "--manifest", output / (label + ".json"), "--checked-files", output / (label + ".files"),
                   library / "Socket", *[library / "internal/net" / name for name in active]], label)
            for name in ["views", "hex"]:
                check([compiler, "-check", "-os", os_name, "-cpu", cpu,
                       ROOT / "tests/portable-stdlib/android-asn1-closure" / (name + ".jai")], f"asn1-{name}-{os_name}-{cpu}")
            if os_name != "windows":
                check([compiler, "-check", "-os", os_name, "-cpu", cpu,
                       ROOT / "tests/portable-stdlib/socket-cmsg/compile-time.jai"], f"cmsg-{os_name}-{cpu}")
    android_available = check([compiler, "-check", "-os", "android", ROOT / "tests/cleanroom-language/android-target-minimal.jai"],
                              "android-target-minimal", pending=True)
    if android_available:
        for cpu in ["x64", "arm64"]:
            check([compiler, "-check", "-os", "android", "-cpu", cpu,
                   ROOT / "tests/portable-stdlib/android-socket/records.jai"], f"android-records-{cpu}")
            active = ["socket.jai", "socket-posix.jai", "socket-abi.jai", "socket-native-completions.jai",
                      "socket-cmsg.jai", "socket-fields-tcp-unix.jai"]
            check([lint, "-D", "warnings", "-os", "android", "-cpu", cpu,
                   library / "Socket", *[library / "internal/net" / name for name in active]], f"socket-lint-android-{cpu}")
    (output / "target-receipt.json").write_text(json.dumps(results, indent=2) + "\n")
    assert_unchanged(receipt)
    if any(r["status"] == "fail" for r in results):
        raise RuntimeError("Target checks failed; see target-receipt.json")
    if any(r["status"] == "blocked" for r in results):
        print("Supported-platform source gates pass; Android source closure remains BLOCKED", flush=True)
        raise SystemExit(2)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--audit-only", action="store_true", help="check load integration only; no runtime verification claim")
    parser.add_argument("--targets-only", type=Path, metavar="VERIFICATION_DIR", help="continue target gates against a source-identical verified build")
    args = parser.parse_args()
    print(audit_loads(), flush=True)
    if args.targets_only:
        check_targets(args.targets_only)
        return
    if args.audit_only:
        print("source load audit only; compiler/native/lint/format gates NOT RUN")
        return
    subprocess.run(["git", "merge-base", "--is-ancestor", CHECKPOINT, "HEAD"], cwd=ROOT, check=True)
    if platform.system() != "Darwin":
        raise SystemExit("This closure runner requires an actual Mac host; native platform gates must be run separately")
    assigned = os.environ.get("CARGO_TARGET_DIR", "")
    if not assigned or not Path(assigned).is_absolute():
        raise SystemExit("CARGO_TARGET_DIR must explicitly name the assigned absolute T7 target")
    target = Path(assigned).resolve()
    if not target.is_relative_to(Path("/Volumes/T7")) or "portable-asn1-socket" not in target.parts:
        raise SystemExit("CARGO_TARGET_DIR is outside this worker's assigned T7 tree")
    target.mkdir(parents=True, exist_ok=True)
    output = Path(tempfile.mkdtemp(prefix="asn1-socket-", dir=target))
    environment = dict(os.environ, TMPDIR=str(output), PYTHONDONTWRITEBYTECODE="1")
    receipt = {"checkpoint": CHECKPOINT, "head": subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT, text=True).strip(),
               "source_mode": "current-shared-tree",
               "output": str(output), "host": platform.platform(), "commands": [], "source_sha256": source_hashes()}
    failures = []

    def run(command, label, expected=None, cwd=ROOT, binary=False, failure_contains=None):
        result = subprocess.run(list(map(str, command)), cwd=cwd, env=environment, capture_output=True, text=not binary, timeout=600)
        for suffix, data in [("stdout", result.stdout), ("stderr", result.stderr)]:
            path = output / (label + "." + suffix)
            if binary:
                path.write_bytes(data)
            else:
                path.write_text(data)
        passed = result.returncode == 0 and (expected is None or (result.stdout == expected and not result.stderr))
        if failure_contains is not None:
            passed = result.returncode != 0 and failure_contains in result.stdout + result.stderr
        receipt["commands"].append({"label": label, "argv": list(map(str, command)), "returncode": result.returncode, "passed": passed})
        (output / "receipt.json").write_text(json.dumps(receipt, indent=2) + "\n")
        print(f'{label}: {"PASS" if passed else "FAIL"}', flush=True)
        if not passed:
            failures.append(label)
        return passed

    # Unique Cargo directory: no binaries from a different source snapshot.
    cargo_output = output / "compiler"
    if not run(["cargo", "build", "--locked", "--offline", "--target-dir", cargo_output,
                "-p", "jaic-cli", "-p", "jailint"], "source-build"):
        raise SystemExit(f"Source build failed; evidence: {output}")
    compiler = cargo_output / "debug/jaic"
    lint = cargo_output / "debug/jailint"
    library = ROOT / "stdlib"
    environment["JAIC_STDLIB"] = str(library)
    fixtures = [("tests/portable-stdlib/android-asn1.jai", "ok\n"),
                ("tests/portable-stdlib/android-asn1-closure/views.jai", "ok\n"),
                ("tests/portable-stdlib/android-asn1-closure/hex.jai", "ok\n"),
                ("tests/portable-stdlib/android-asn1/records.jai", "ok\n"),
                ("tests/portable-stdlib/android-asn1/failures.jai", "ok\n"),
                ("tests/portable-stdlib/android-oid.jai", "ok\n"),
                ("tests/portable-stdlib/android-asn1-printer/main.jai", reviewed_printer_output()),
                ("tests/portable-stdlib/android-asn1-printer/failures.jai", "NULL ok\n"),
                ("tests/portable-stdlib/android-asn1-printer/nesting.jai", "".join("    " * depth + "SEQUENCE\n" for depth in range(300)) + "    " * 300 + "NULL \n"),
                ("tests/portable-stdlib/socket-cmsg-layout.jai", "ok\n"),
                ("tests/portable-stdlib/socket-loopback.jai", "ok\n"),
                ("tests/portable-stdlib/socket-select.jai", "ok\n"),
                ("tests/portable-stdlib/socket-descriptor-domain.jai", "ok\n"),
                ("tests/stdlib/socket-loopback.jai", "ok\n")]
    (output / "asn1-vectors.bin").write_bytes(asn1_vectors())
    staged_vectors = output / "asn1-vectors.jai"
    vector_source = (ROOT / "tests/portable-stdlib/android-asn1/vectors.jai").read_text()
    anchor = 'filename := sprint("%/../../../target/portable-asn1/vectors.bin", S.path_strip_filename(#file));'
    if vector_source.count(anchor) != 1:
        raise RuntimeError("vector fixture path changed; retain assertions and review relocation")
    staged_vectors.write_text(vector_source.replace(anchor, 'filename := sprint("%", ' + json.dumps(str(output / "asn1-vectors.bin")) + ');'))
    fixtures.append((staged_vectors, "ok\n"))
    for optimization in ["-O0", "-O2"]:
        probe = output / ("sdk-cmsg" + optimization)
        if not run(["cc", "-std=c11", "-Wall", "-Wextra", "-Werror", optimization,
                    ROOT / "tests/portable-stdlib/native/socket-cmsg.c", "-o", probe], "sdk-build" + optimization):
            raise SystemExit("Actual host SDK probe failed to compile")
        if not run([probe], "sdk-vectors" + optimization, binary=True):
            raise SystemExit("Actual host SDK probe failed to execute")
    sdk = (output / "sdk-vectors-O0.stdout").read_bytes()
    if sdk != (output / "sdk-vectors-O2.stdout").read_bytes() or len(sdk) != 16 + 4097 * 32:
        raise RuntimeError("Actual host SDK vector shape/optimization mismatch")
    staged_cmsg = output / "socket-sdk-vectors.jai"
    vector_source = (ROOT / "tests/portable-stdlib/socket-cmsg/main.jai").read_text()
    anchor = 'filename := sprint("%/../../../target/portable-socket-cmsg/vectors.bin", P.path_strip_filename(#file));'
    if vector_source.count(anchor) != 1:
        raise RuntimeError("SDK vector fixture path changed; retain assertions and review relocation")
    staged_cmsg.write_text(vector_source.replace(anchor, 'filename := sprint("%", ' + json.dumps(str(output / "sdk-vectors-O0.stdout")) + ');'))
    fixtures.append((staged_cmsg, "ok\n"))
    for index, (relative, expected) in enumerate(fixtures):
        source = ROOT / relative
        receipt.setdefault("fixture_sha256", {})[str(relative)] = hashlib.sha256(source.read_bytes()).hexdigest()
        run([compiler, "-interp", source], f"fixture-{index}-interp", expected)
        for optimization in ["-O0", "-O2"]:
            program = output / f"fixture-{index}{optimization}"
            if run([compiler, source, optimization, "-exe", program], f"fixture-{index}{optimization}-build"):
                run([program], f"fixture-{index}{optimization}-native", expected)
    for name, message in [("socket-cmsg-negative", "ancillary size cannot be aligned"),
                          ("socket-cmsg-overflow", "ancillary length exceeds u32")]:
        source = ROOT / "tests/portable-stdlib/faults" / (name + ".jai")
        run([compiler, "-interp", source], name + "-interp", failure_contains=message)
        for optimization in ["-O0", "-O2"]:
            program = output / (name + optimization)
            if run([compiler, source, optimization, "-exe", program], name + optimization + "-build"):
                run([program], name + optimization + "-native", failure_contains=message)
    # Compile every active Socket body, not unrelated mail code or OS-inactive roots.
    socket_active = ["socket.jai", "socket-posix.jai", "socket-abi.jai", "socket-native-completions.jai",
                     "socket-cmsg.jai", "socket-fields-macos.jai"]
    run([lint, "-D", "warnings", library / "Socket",
         *[library / "internal/net" / name for name in socket_active]], "socket-full-active-macos-lint")
    run([lint, "-D", "warnings", ROOT / "tests/portable-stdlib/socket-descriptor-domain.jai",
         ROOT / "tests/portable-stdlib/socket-loopback.jai", ROOT / "tests/portable-stdlib/socket-select.jai",
         ROOT / "tests/portable-stdlib/socket-cmsg-layout.jai", ROOT / "tests/portable-stdlib/socket-cmsg",
         ROOT / "tests/stdlib/socket-loopback.jai"], "socket-fixture-lint")
    asn1_paths = [library / "internal/android-toolchain" / name for name in OWNED]
    run([lint, "-D", "warnings", library / "Android/Toolchain/asn1-extension.jai", *asn1_paths,
         ROOT / "tests/portable-stdlib/android-asn1-closure"], "asn1-lint")
    formatter = output / "jaifmt"
    if run([compiler, ROOT / "jaifmt/main.jai", "-O0", "-exe", formatter], "formatter-build"):
        run([formatter, "--config", ROOT / "jaifmt.toml", "--check", library / "Socket", library / "internal/net",
             library / "Android/Toolchain/asn1-extension.jai", *asn1_paths,
             ROOT / "tests/portable-stdlib/socket-descriptor-domain.jai", ROOT / "tests/stdlib/socket-loopback.jai",
             ROOT / "tests/portable-stdlib/android-asn1-closure"], "owned-format")
    assert_unchanged(receipt)
    for relative, digest in receipt["fixture_sha256"].items():
        if hashlib.sha256((ROOT / relative).read_bytes()).hexdigest() != digest:
            raise RuntimeError("Fixture changed during verification: " + relative)
    receipt["source_and_fixture_snapshot_unchanged"] = True
    (output / "receipt.json").write_text(json.dumps(receipt, indent=2) + "\n")
    print(f"Evidence: {output}")
    if failures:
        raise SystemExit("Failed gates: " + ", ".join(failures))
    print("Listed host gates pass; Android target checking and other native platforms remain separate")


if __name__ == "__main__":
    main()
