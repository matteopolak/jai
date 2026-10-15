#!/usr/bin/env python3
"""Inventory reviewed tooling declarations without reading corpus/native vendor inputs.

Presence is lexical evidence only, never a claim of behavioral or ABI coverage.
"""
import hashlib
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
MODULES = {
    "Bindings_Generator": "bindings-generator", "Generate_C_Header": "generate-c-header",
    "Check": "check", "Codex": "codex", "Debug": "debug", "Debug_Info": "debug-info",
    "Print_Vars": "print-vars", "Iprof": "iprof", "Performance_Report": "performance-report",
    "Rewrite": "rewrite",
}


def main():
    inventory = {}
    for module, slug in MODULES.items():
        spec = ROOT / f"docs/specs/stdlib/modules/{slug}.md"
        contents = spec.read_text()
        declarations = []
        members = []
        section = ""
        aggregate = ""
        in_members = False
        for line_number, line in enumerate(contents.splitlines(), 1):
            if line.startswith("## "):
                section = line[3:]
                in_members = "type members" in section or "aggregate shapes" in section
            elif line.startswith("### "):
                section = line[4:]
            if line.startswith("#### `") or (in_members and line.startswith("### `")):
                aggregate = line.split("`")[1]
            if not in_members and line.startswith("- ") and "`" in line:
                signature = line.split("`", 2)[1]
                name = re.match(r"([A-Za-z_][A-Za-z_0-9]*)\s*(?:::|:)", signature)
                if name:
                    declarations.append({"name": name[1], "declaration": signature,
                                         "section": section, "spec_line": line_number,
                                         "implementation": "pending"})
            if in_members and line.strip() and not line.startswith("#"):
                members.append({"aggregate": aggregate, "reviewed_text": line,
                                "section": section, "spec_line": line_number})
        if module == "Generate_C_Header":
            for item in declarations:
                item["implementation"] = "supported subset; see developer-tools-deviations.md"
        if module == "Performance_Report":
            for item in declarations:
                item["implementation"] = "implemented; measured native compiler plugin fixture"
        if module == "Print_Vars":
            for item in declarations:
                item["implementation"] = "implemented; original caller-code, formatting and logging fixture"
        inventory[module] = {"spec": str(spec.relative_to(ROOT)),
                             "spec_sha256": hashlib.sha256(contents.encode()).hexdigest(),
                             "declarations": declarations, "reviewed_members": members}
    destination = ROOT / "docs/developer-tools-api.json"
    destination.write_text(json.dumps(inventory, indent=2) + "\n")
    print(f"Inventoried {sum(len(x['declarations']) for x in inventory.values())} reviewed declaration variants across {len(inventory)} modules")


if __name__ == "__main__":
    main()
