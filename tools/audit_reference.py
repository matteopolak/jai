#!/usr/bin/env python3
"""Inspect executable bytes with trusted LLVM tools. Never load inspected code."""
import argparse
import collections
import hashlib
import gzip
import json
from pathlib import Path
import re
import shutil
import subprocess
import tempfile

RISK_NAMES = re.compile(r"(system|execv|spawn|CreateProcess|dlopen|dlLoadLibrary|LoadLibrary|GetProcAddress|unlink|DeleteFile|socket|connect|send|recv|Internet|WinHttp|ptrace|chmod)", re.I)


def command(args):
    p = subprocess.run(args, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if p.returncode:
        raise RuntimeError(f"inspection command failed: {args[0]}: {p.stderr[:1000]}")
    return p.stdout


def sha256(path):
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def disassemble(path, output):
    """Stream every executable section, keeping direct and unresolved call sites."""
    function = "<no-symbol>"
    functions = set()
    direct = indirect = instructions = invalid = 0
    # All output is stored as evidence; stripped functions retain address labels.
    with gzip.open(output, "wt") as edges, tempfile.TemporaryFile(mode="w+") as errors:
        edges.write("caller\taddress\tkind\ttarget\n")
        p = subprocess.Popen(
            ["llvm-objdump", "--no-debuginfod", "-d", "--no-show-raw-insn", str(path)],
            text=True, stdout=subprocess.PIPE, stderr=errors,
        )
        for line in p.stdout:
            header = re.match(r"^([0-9a-fA-F]+) <(.+)>:$", line.strip())
            if header:
                function = header[2]
                functions.add(function)
                continue
            instruction = re.match(r"^\s*([0-9a-fA-F]+):\s+(\S+)\s*(.*)$", line)
            if not instruction:
                continue
            instructions += 1
            address, mnemonic, operand = instruction.groups()
            if mnemonic in {"<unknown>", ".byte", ".word", ".long"}:
                invalid += 1
            if mnemonic in {"call", "callq", "bl", "blr", "blraa", "blrab", "blx"}:
                unresolved = mnemonic in {"blr", "blraa", "blrab"} or operand.startswith("*")
                if unresolved:
                    indirect += 1
                else:
                    direct += 1
                edges.write(f"{function}\t{address}\t{'indirect' if unresolved else 'direct'}\t{operand.strip()}\n")
            elif mnemonic in {"jmp", "jmpq", "b", "br", "braa", "brab"}:
                # Includes tail calls and intra-function jumps; preserve distinction.
                edges.write(f"{function}\t{address}\tbranch\t{operand.strip()}\n")
        code = p.wait()
        errors.seek(0)
        stderr = errors.read()
    if code:
        raise RuntimeError(f"disassembly failed: {stderr[:1000]}")
    return dict(function_symbols=len(functions), instructions=instructions,
                direct_calls=direct, indirect_calls=indirect,
                undecoded_instructions=invalid, warnings=stderr[:4000])


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--reference", type=Path, default=Path("reference"))
    parser.add_argument("--output", type=Path, default=Path("artifacts/audit"))
    parser.add_argument("--binary", action="append", help="Relative paths; default is six compiler/linker binaries")
    args = parser.parse_args()
    root = args.reference.resolve()
    out = args.output.resolve()
    if out == root or root in out.parents:
        raise ValueError("audit output must be outside the read-only reference")
    out.mkdir(parents=True, exist_ok=True)
    paths = args.binary or ["bin/jai-macos", "bin/jai-linux", "bin/jai.exe", "bin/lld-macos", "bin/lld-linux", "bin/lld.exe"]
    report = {"executed_reference_code": False, "binaries": [], "limitations": [
        "Static disassembly does not prove harmlessness or recover original source.",
        "Indirect calls, generated code, foreign libraries and runtime inputs can introduce behavior beyond this graph.",
        "Direct targets in stripped binaries may have no meaningful symbol names.",
        "A VM run is observational evidence, not a guarantee of safety.",
    ]}
    for relative in paths:
        original = (root / relative).resolve()
        if root not in original.parents or not original.is_file():
            raise ValueError(f"not a reference file: {relative}")
        description = command(["file", "-b", str(original)]).strip()
        entry = dict(path=relative, sha256=sha256(original), bytes=original.stat().st_size,
                     description=description, slices=[])
        with tempfile.TemporaryDirectory(prefix="jai-static-audit-") as temp:
            if "universal binary" in description:
                arches = command(["lipo", "-archs", str(original)]).split()
                slices = []
                for arch in arches:
                    thin = Path(temp) / arch
                    command(["lipo", str(original), "-thin", arch, "-output", str(thin)])
                    slices.append((arch, thin))
            else:
                slices = [("native-file", original)]
            for arch, path in slices:
                label = relative.replace("/", "_") + "_" + arch
                print(f"Reading all executable sections: {relative} ({arch})", flush=True)
                metadata = command(["llvm-readobj", "--file-headers", "--sections", "--needed-libs", "--coff-imports", str(path)])
                (out / f"{label}.headers.txt").write_text(metadata)
                symbols = command(["llvm-nm", "--undefined-only", str(path)]) if not relative.endswith(".exe") else ""
                (out / f"{label}.imports.txt").write_text(symbols)
                stats = disassemble(path, out / f"{label}.calls.tsv.gz")
                stats.update(architecture=arch, slice_sha256=sha256(path),
                             imported_capabilities=[s.strip() for s in (symbols + "\n" + metadata).splitlines() if RISK_NAMES.search(s)])
                entry["slices"].append(stats)
        report["binaries"].append(entry)
        (out / "report.json").write_text(json.dumps(report, indent=2) + "\n")
    lines = ["# Static reference binary inspection", "", "No reference code was executed.", "",
             "| Binary | Architecture | Function symbols | Direct calls | Indirect calls | Undecoded instructions |", "|---|---|---:|---:|---:|---:|"]
    for b in report["binaries"]:
        for s in b["slices"]:
            lines.append(f"| {b['path']} | {s['architecture']} | {s['function_symbols']} | {s['direct_calls']} | {s['indirect_calls']} | {s['undecoded_instructions']} |")
    lines += ["", "## Limits", ""] + ["- " + s for s in report["limitations"]]
    lines += ["", "Hashes, import candidates and tool warnings are in `report.json`. All observed calls and branch instructions are in the corresponding `.calls.tsv.gz` files.", ""]
    (out / "README.md").write_text("\n".join(lines))
    print(f"Wrote {out / 'README.md'}", flush=True)


if __name__ == "__main__":
    main()
