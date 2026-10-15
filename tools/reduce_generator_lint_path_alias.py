#!/usr/bin/env python3
"""Independent compile-time file identity reduction; records actual tool outcomes."""
import json
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
TARGET = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
if (ROOT / "target").resolve() != TARGET:
    raise RuntimeError("Use this worker's assigned target symlink and CARGO_TARGET_DIR")
WORK = ROOT / ".work/generator-lint-path-alias"
WORK.mkdir(parents=True, exist_ok=True)
ENV = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))


def source(write_path, read_path):
    return f'''#import "Basic";
#import "File";
#run {{
    assert(write_entire_file({json.dumps(str(write_path))}, "new"));
    data, ok := read_entire_file({json.dumps(str(read_path))});
    defer free(data);
    assert(ok && data == "new");
}}
main :: () {{}}
'''


def main():
    alias = ROOT / "target/generator-model-sandbox-alias.txt"
    actual = alias.resolve()
    evidence = []
    for label, read_path, tool in [
        ("native_alias", alias, [TARGET / "debug/jaic", "-check"]),
        ("lint_same_path", actual, [TARGET / "debug/jailint", "-D", "warnings"]),
        ("lint_alias", alias, [TARGET / "debug/jailint", "-D", "warnings"]),
    ]:
        actual.write_text("old")
        path = WORK / f"{label}.jai"
        path.write_text(source(actual, read_path))
        result = subprocess.run([str(tool[0]), str(path), *tool[1:]],
                                cwd=ROOT, env=ENV, capture_output=True, text=True, timeout=60)
        evidence.append(dict(case=label, source=path.read_text(), exit=result.returncode,
                             stdout=result.stdout, stderr=result.stderr,
                             disk_content=actual.read_text()))
        print(f"{label}: exit {result.returncode}; disk {actual.read_text()!r}")
    (TARGET / "generator-lint-path-alias-evidence.json").write_text(json.dumps(evidence, indent=2) + "\n")


if __name__ == "__main__":
    main()
