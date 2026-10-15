#!/usr/bin/env python3
"""Build owned public parser fixtures with the official SDK and this compiler only."""
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[1]
TARGET = ROOT / "target"
ENV = dict(os.environ, JAIC_STDLIB=str(ROOT / "stdlib"))
JAIC = Path(os.environ["CARGO_TARGET_DIR"]) / "debug/jaic"
LINT = JAIC.with_name("jailint")
LLVM = Path(os.environ.get("DEVELOPER_TOOLS_LLVM_PREFIX", "/opt/homebrew/opt/llvm")) / "bin"


def run(args):
    result = subprocess.run([str(x) for x in args], cwd=ROOT, env=ENV,
                            text=True, capture_output=True, timeout=60)
    if result.returncode:
        raise RuntimeError(f"{args}\n{result.stdout}\n{result.stderr}")
    return result.stdout, result.stderr


def dwarf_fixtures():
    oracle = ["check_sdk_units :: () {"]
    evidence = []
    linker = shutil.which("ld.lld")
    if not linker:
        raise RuntimeError("Official ld.lld is required to apply ELF debug relocations")
    for architecture, triple in [("x86", "i386-unknown-linux-gnu"),
                                 ("x64", "x86_64-unknown-linux-gnu"),
                                 ("arm64", "aarch64-unknown-linux-gnu")]:
        for optimization in [0, 2]:
            stem = TARGET / f"debug-info-{architecture}-o{optimization}"
            run([LLVM / "clang", "-target", triple, "-std=c11", "-gdwarf-4", "-g",
                 f"-O{optimization}", "-Wall", "-Wextra", "-Werror", "-c",
                 "tests/developer-tools/dwarf-types-native.c", "-o", stem.with_suffix(".o")])
            run([linker, "--entry=original_debug_types", stem.with_suffix(".o"), "-o", stem.with_suffix(".elf")])
            sections = {name: Path(f"{stem}-{name}.bin") for name in ["info", "abbrev", "line", "str"]}
            run([LLVM / "llvm-objcopy", *[arg for name, path in sections.items()
                 for arg in ["--dump-section", f".debug_{name}={path}"]], stem.with_suffix(".elf")])
            dump, _ = run([LLVM / "llvm-dwarfdump", "--debug-info", stem.with_suffix(".elf")])
            Path(f"{stem}-sdk.txt").write_text(dump)
            types = []
            for record in re.finditer(r"^0x([0-9a-f]+):\s+DW_TAG_([a-z0-9_]+)\n(.*?)(?=^0x[0-9a-f]+:|\Z)", dump, re.M | re.S):
                offset, tag, attrs = record.groups()
                if not (tag.endswith("_type") or tag == "typedef"):
                    continue
                name = re.search(r'DW_AT_name\s+\("([^"\n]*)"\)', attrs)
                size = re.search(r"DW_AT_byte_size\s+\((0x[0-9a-f]+|[0-9]+)\)", attrs)
                encoding = re.search(r"DW_AT_encoding\s+\(DW_ATE_([a-z_]+)\)", attrs)
                types.append(dict(offset=int(offset, 16), tag=tag.upper(), name=name[1] if name else "",
                                  size=int(size[1], 0) if size else 0, encoding=encoding[1].upper() if encoding else None))
            if len(types) < 7:
                raise RuntimeError("SDK fixture lacks the expected type coverage")
            oracle += ["    {", f"        info := load_bytes({json.dumps(str(sections['info']))});",
                       f"        abbrev := load_bytes({json.dumps(str(sections['abbrev']))});",
                       f"        lines := load_bytes({json.dumps(str(sections['line']))});",
                       f"        strings := load_bytes({json.dumps(str(sections['str']))});",
                       "        defer free(info.data); defer free(abbrev.data); defer free(lines.data); defer free(strings.data);",
                       "        parsed, ok := D.parse_dwarf_debug_info(info, abbrev, lines, strings);",
                       "        assert(ok && parsed.compilation_units.count == 1);",
                       "        defer release_info(*parsed);", "        unit := parsed.compilation_units[0];",
                       f"        assert(unit.types.count == {len(types)});"]
            for item in types:
                encoding = "." + item["encoding"] if item["encoding"] else "cast(D.Dwarf_Base_Type) 0"
                oracle += ["        {", f"            actual := D.get_type(unit, {item['offset']});",
                           f"            assert(actual != null && actual.tag == .{item['tag']} && actual.name == {json.dumps(item['name'])});",
                           f"            assert(actual.size == {item['size']} && actual.base_type == {encoding});", "        }"]
            oracle += ["        check_unit(unit);", "    }"]
            evidence.append(dict(architecture=architecture, optimization=optimization, types=types,
                                 sections={name: hashlib.sha256(path.read_bytes()).hexdigest() for name, path in sections.items()}))
            if architecture == "x64" and optimization == 0:
                for name, path in sections.items():
                    shutil.copyfile(path, TARGET / f"debug-info-{name}.bin")
    oracle += ["}"]
    (TARGET / "debug-info-sdk.jai").write_text("\n".join(oracle) + "\n")
    return evidence


def main():
    TARGET.mkdir(exist_ok=True)
    evidence = dwarf_fixtures()
    # Original PDB producer and official SDK stream exports; no supplied binaries.
    import check_developer_msf
    check_developer_msf.main()
    owned = [ROOT / path for path in ["stdlib/Debug_Info/module.jai",
             "stdlib/internal/developer-tools/dwarf-public.jai", "stdlib/internal/developer-tools/msf-streams.jai",
             "stdlib/internal/developer-tools/msf-wire.jai", "stdlib/internal/developer-tools/msf-page-bits.jai",
             "tests/developer-tools/dwarf-public.jai", "tests/developer-tools/msf-parser.jai"]]
    run([TARGET / "jaifmt", "--config", ROOT / "jaifmt.toml", TARGET / "debug-info-sdk.jai"])
    run([TARGET / "jaifmt", "--config", ROOT / "jaifmt.toml", "--check", *owned, TARGET / "debug-info-sdk.jai"])
    run([LINT, "-D", "warnings", ROOT / "stdlib/Debug_Info/module.jai",
         ROOT / "tests/developer-tools/dwarf-public.jai", ROOT / "tests/developer-tools/msf-parser.jai"])
    for name in ["dwarf-public", "msf-parser"]:
        fixture = ROOT / f"tests/developer-tools/{name}.jai"
        stdout, stderr = run([JAIC, fixture, "-interp"])
        if stdout != "ok\n" or stderr:
            raise RuntimeError(f"Unexpected interpreter diagnostics: {stdout}\n{stderr}")
        for optimization in [0, 2]:
            exe = TARGET / f"{name}-o{optimization}"
            run([JAIC, fixture, f"-O{optimization}", "-exe", exe])
            stdout, stderr = run([exe])
            if stdout != "ok\n" or stderr:
                raise RuntimeError(f"Unexpected native diagnostics: {stdout}\n{stderr}")
    (ROOT / "docs/native/debug-info-public-evidence.json").write_text(json.dumps({
        "scope": "public DWARF4 parser metadata compared with relocated original SDK objects; public MSF streams compared with SDK exports; Mac interpreter/native O0/O2", "dwarf": evidence,
        "verification": ["formatter", "strict lint", "interpreter", "native O0", "native O2"]}, indent=2) + "\n")
    print("Public Debug_Info parser checks passed")


if __name__ == "__main__":
    main()
