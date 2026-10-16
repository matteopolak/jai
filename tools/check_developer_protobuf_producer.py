#!/usr/bin/env python3
"""Read-only authorized protobuf diagnosis with independently authored reductions."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
CASE_IDS = {
    "jai-protobuf-tests",
    "jai-protobuf-01-compiletime",
    "jai-protobuf-03-imports",
    "jai-protobuf-04-memory-allocation",
}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--application-corpus", type=Path, required=True)
    args = parser.parse_args()
    corpus = args.application_corpus.resolve()
    access = json.loads((corpus / "ACCESS.json").read_text())
    allowed = {row["path"]: row["sha256"] for row in access["files"]}
    inputs = {
        p: h for p, h in allowed.items() if p.startswith("segcore--jai-protobuf/")
    }
    for path, digest in inputs.items():
        if any(
            path == prefix or path.startswith(prefix + "/")
            for prefix in access["excluded_roots"]
        ):
            raise RuntimeError("Listed input overlaps an excluded root")
        if hashlib.sha256((corpus / path).read_bytes()).hexdigest() != digest:
            raise RuntimeError("Authorized input hash mismatch: " + path)
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    scratch = Path(tempfile.mkdtemp(prefix="protobuf-producer-", dir=target))
    compiler = target / "debug/jaic"
    formatter = target / "jaifmt"
    linter = target / "debug/jailint"
    env = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"), TMPDIR=str(scratch))
    own = ROOT / "tests/developer-tools/compiler-requests"
    module = corpus / "segcore--jai-protobuf"
    # These are new original diagnostic inputs, not copied application code.
    probe = """#import "Basic";
#import "File";
P :: #import,dir MODULE;
generated :: #run P.generate_jai(P.parse_proto_text("syntax = \\"proto3\\"; message Probe { int32 FIELD = 1; }"));
main :: () {
    schema, parsed := P.parse_proto_text("syntax = \\"proto3\\"; message Probe { int32 FIELD = 1; }");
    assert(parsed && schema.definitions.count == 1);
    fields := schema.definitions[0].fields;
    runtime := P.generate_jai(schema);
    assert(runtime == generated);
    assert(write_entire_file("OUTPUT", generated));
    assert(fields.count == 1 && fields[0].name == "FIELD");
    print("ok\\n");
}
""".replace("MODULE", json.dumps(str(module)))
    for name, field in [("plain", "count"), ("underscore", "item_count")]:
        (scratch / (name + ".jai")).write_text(
            probe.replace("FIELD", field).replace("OUTPUT", name + "-generated.jai")
        )
    consumer = """#import "Basic";
#import,dir MODULE;
#load "plain-generated.jai";
main :: () {
    value := Probe.{42};
    buffer: [64]u8;
    bytes, required := Serialize(value, array_view(buffer, 0));
    assert(bytes.count > 0 && required > 0);
    decoded: Probe;
    ok, used := Deserialize(*decoded, bytes);
    assert(ok && decoded.count == 42 && used == bytes.count);
    print("ok\\n");
}
""".replace("MODULE", json.dumps(str(module)))
    for name, field in [("plain", "count"), ("underscore", "item_count")]:
        (scratch / (name + "-consumer.jai")).write_text(
            consumer.replace("plain-generated", name + "-generated").replace(
                "decoded.count", "decoded." + field
            )
        )
    sources = list((ROOT / "stdlib/Basic").rglob("*.jai"))
    sources += list((ROOT / "stdlib/internal/basic").rglob("*.jai"))
    sources += list((ROOT / "stdlib/String").rglob("*.jai"))
    sources += list((ROOT / "stdlib/internal/string").rglob("*.jai"))
    sources += [
        Path(__file__),
        *own.glob("protobuf-*.jai"),
        own / "empty-generated-field.jai",
    ]

    def snapshot():
        return {
            str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest()
            for p in sorted(set(sources))
            if p.is_file()
        }

    before = snapshot()
    receipt = {
        "passed": False,
        "application_input_sha256": inputs,
        "source_sha256": before,
        "compiler_sha256": hashlib.sha256(compiler.read_bytes()).hexdigest(),
        "commands": [],
        "proto_assets": [p for p in inputs if p.endswith(".proto")],
        "ownership": "No application/compiler/Basic edits; compiler owns parser, stdlib owns predicates",
    }

    def run(command, category, expected="", diagnostic=None, observation=False):
        result = subprocess.run(
            [str(v) for v in command],
            cwd=scratch,
            env=env,
            capture_output=True,
            text=True,
            timeout=90,
        )
        if diagnostic:
            passed = result.returncode != 0 and diagnostic in result.stderr
        elif observation:
            passed = result.returncode == 0
        else:
            passed = (
                result.returncode == 0
                and result.stdout == expected
                and not result.stderr
            )
        index = len(receipt["commands"])
        (scratch / (str(index) + ".stdout.txt")).write_text(result.stdout)
        (scratch / (str(index) + ".stderr.txt")).write_text(result.stderr)
        receipt["commands"].append(
            {
                "command": [str(v) for v in command],
                "category": category,
                "exit": result.returncode,
                "passed": passed,
                "diagnostic_expected": diagnostic,
                "observation_only": observation,
                "controlled_observation": result.stdout if observation else None,
                "first_diagnostic": result.stderr.splitlines()[:1],
            }
        )
        return passed

    try:
        for case in json.loads((corpus / "configured-cases.json").read_text()):
            if case["id"] not in CASE_IDS:
                continue
            relative = str(Path(case["path"]).relative_to(corpus))
            if relative not in inputs:
                raise RuntimeError("Case outside hash-verified protobuf inputs")
            run(
                [compiler, corpus / relative, "-check"],
                "application:" + case["id"],
                observation=True,
            )
        for name, expected in [
            ("protobuf-format-field", "ok\n"),
            (
                "protobuf-identifier-classification",
                "underscore alpha=false alnum=true; letter alpha=true alnum=true; digit alpha=false alnum=true\n",
            ),
        ]:
            source = own / (name + ".jai")
            for mode in ["interp", "0", "2"]:
                if mode == "interp":
                    run(
                        [compiler, source, "-interp"],
                        name,
                        expected,
                        observation=expected is None,
                    )
                else:
                    binary = scratch / (name + "-o" + mode)
                    if run(
                        [compiler, source, "-O" + mode, "-exe", binary], name + ":build"
                    ):
                        run([binary], name, expected, observation=expected is None)
        run(
            [compiler, own / "empty-generated-field.jai", "-check"],
            "malformed_source_negative",
            diagnostic="expected expression",
        )
        for name in ["plain", "underscore"]:
            source = scratch / (name + ".jai")
            run([compiler, source, "-interp"], "application_producer:" + name, "ok\n")
        # The pre-fix underscore output was malformed; retain that historical receipt.
        # Both current outputs must now compile in their real protobuf import scope.
        for name in ["plain", "underscore"]:
            source = scratch / (name + "-consumer.jai")
            run([compiler, source, "-interp"], "generated_roundtrip:" + name, "ok\n")
            for optimization in [0, 2]:
                binary = scratch / (name + "-consumer-o" + str(optimization))
                if run(
                    [compiler, source, "-O" + str(optimization), "-exe", binary],
                    "generated_roundtrip:" + name + ":build",
                ):
                    run([binary], "generated_roundtrip:" + name, "ok\n")
        positives = [
            own / "protobuf-format-field.jai",
            own / "protobuf-identifier-classification.jai",
        ]
        run(
            [formatter, "--config", ROOT / "jaifmt.toml", "--check", *positives],
            "format",
        )
        run([linter, "-D", "warnings", *positives], "strict_lint")
        receipt["passed"] = all(row["passed"] for row in receipt["commands"])
    finally:
        receipt["source_unchanged"] = snapshot() == before
        receipt["application_unchanged"] = all(
            hashlib.sha256((corpus / p).read_bytes()).hexdigest() == h
            for p, h in inputs.items()
        )
        receipt["passed"] &= (
            receipt["source_unchanged"] and receipt["application_unchanged"]
        )
        (scratch / "verification.json").write_text(json.dumps(receipt, indent=2) + "\n")
    print(
        "Protobuf focused diagnosis "
        + ("PASS " if receipt["passed"] else "RED ")
        + str(scratch / "verification.json")
    )
    if not receipt["passed"]:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
