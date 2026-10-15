"""Declaration coverage audit against reviewed specs, not proof of semantics."""
from pathlib import Path
import argparse
import json
import re
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def compact(value):
    return re.sub(r"\s+", "", value).rstrip(";")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--state", choices=["draft", "committed"], default="draft")
    args = parser.parse_args()
    spec = (ROOT / "docs/specs/stdlib/modules/executable-formats.md").read_text()
    declarations = re.findall(r"^- `([^`]+)`", spec.split("## Public type members")[0], re.M)
    declarations += [f"Elf_Segment_Flags.{name} :: (1 << {bit});" for bit, name in enumerate(["EXEC", "WRITE", "READ"])]
    exports = {}
    changed = set()
    status = subprocess.run(["git", "status", "--porcelain", "--untracked-files=all", "--", "stdlib/internal/executable"],
                            cwd=ROOT, text=True, capture_output=True, check=True)
    for line in status.stdout.splitlines():
        changed.add(line[3:])
    for path in sorted((ROOT / "stdlib/internal/executable").glob("*.jai")):
        source = path.read_text().split("#scope_file")[0]
        for match in re.finditer(r"^(\w+)\s*::\s*([^\n{]+)", source, re.M):
            exports.setdefault(match[1], []).append((match[2].strip(), path.relative_to(ROOT).as_posix()))
    remaining = []
    committed_count = 0
    draft_count = 0
    for declaration in declarations:
        name, shape = [s.strip() for s in declaration.split("::", 1)]
        candidates = exports.get(name, [])
        if name.startswith("Elf_Segment_Flags."):
            source = (ROOT / "stdlib/internal/executable/abi.jai").read_text()
            body = re.search(r"Elf_Segment_Flags :: enum_flags u32 \{(.*?)\}", source, re.S)[1]
            implemented = compact(name.split(".")[1] + " :: " + shape) in compact(body)
        elif shape.startswith(("(", "inline (")):
            candidates = [(c, path) for c, path in candidates if compact(c.split("->")[0]) == compact(shape.split("->")[0])]
            implemented = bool(candidates)
        else:
            implemented = bool(candidates)
        if not implemented:
            remaining.append(dict(module="executable_formats", name=name,
                                  declaration=declaration, condition="", status="missing",
                                  source_state=args.state))
        else:
            if name.startswith("Elf_Segment_Flags."):
                committed = "stdlib/internal/executable/abi.jai" not in changed
            else:
                committed = any(path not in changed for _, path in candidates)
            if args.state == "committed" or committed:
                committed_count += 1
            else:
                draft_count += 1
    result = dict(module="executable_formats", independent_base="ad575d16",
                  reviewed_row_count=len(declarations), original_reviewed_row_count=507,
                  refinement="Arch_File adds one reviewed row; counts include types and constants",
                  implemented_row_count=len(declarations) - len(remaining),
                  committed_implemented_row_count=committed_count, draft_implemented_row_count=draft_count,
                  implementation_source_state=args.state, remaining_row_count=len(remaining),
                  audit_kind="declaration coverage; semantic support and verification in portable-executable-formats.md",
                  remaining=remaining)
    (ROOT / "docs/implementation-scope.json").write_text(json.dumps(result, indent=2) + "\n")
    print(f"executable_formats: {result['implemented_row_count']}/{len(declarations)} declared; {len(remaining)} remaining ({args.state})")


if __name__ == "__main__":
    main()
