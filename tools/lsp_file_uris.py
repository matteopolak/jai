#!/usr/bin/env python3
"""Native LSP file-URI checks with an independently produced configured stdlib.

Runs source-built jailsp only, analyzes documents, and never executes Jai programs.
This worker runner writes exclusively to its assigned T7 namespace. Native Windows
confirmation belongs to the coordinator; portable codec tests are separate evidence.
"""
import argparse
import json
import sys
from pathlib import Path
from urllib.parse import unquote, urlparse

sys.dont_write_bytecode = True
from lsp_basic_resolution import Server, position

STORAGE = Path("/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/integration")


def run(binary, stdlib, output):
    output.mkdir(parents=True, exist_ok=False)
    text_original = 'main :: () {\n    /* 😀é */ print("hello world\\n");\n    target();\n}\ntarget :: () {}\n#import "Basic";\n'
    document = output / "main # % é.jai"
    failures = []
    phases = []
    for fresh_damaged in [False, True]:
        text = text_original
        damage = "    damaged := (\n"
        if fresh_damaged:
            text = text.replace("    /*", damage + "    /*", 1)
        document.write_text(text)
        server = Server(binary, stdlib, document)
        version = 1
        try:
            server.request("initialize", dict(rootUri=output.as_uri(), workspaceFolders=[dict(uri=output.as_uri(), name="encoded root")], capabilities={}))
            server.send("initialized", {})
            uri = document.as_uri()
            server.send("textDocument/didOpen", dict(textDocument=dict(uri=uri, languageId="jai", version=version, text=text)))

            def check(label, damaged):
                diagnostics = server.diagnostics(version)
                phase = dict(label=label, diagnostics=diagnostics)
                phases.append(phase)
                errors = [d for d in diagnostics if d.get("severity") == 1]
                if (not damaged and errors) or (damaged and (not errors or any(d["range"]["start"]["line"] != 1 for d in errors))):
                    failures.append(f"{label}: diagnostics {errors}")
                use = text.index("print(")
                params = dict(textDocument=dict(uri=uri), position=position(text, use + 2))
                phase["hover"] = server.request("textDocument/hover", params)
                phase["definition"] = server.request("textDocument/definition", params)
                phase["completion"] = server.request("textDocument/completion", params)
                phase["hierarchy"] = server.request("textDocument/prepareCallHierarchy", params)
                phase["links"] = server.request("textDocument/documentLink", dict(textDocument=dict(uri=uri)))
                params["position"] = position(text, text.index("target();") + 2)
                phase["localDefinition"] = server.request("textDocument/definition", params)
                if not phase["hover"]:
                    failures.append(f"{label}: missing print hover")
                if not phase["definition"]:
                    failures.append(f"{label}: missing print definition")
                for definition in phase["definition"]:
                    destination = Path(unquote(urlparse(definition["uri"]).path))
                    if not destination.is_relative_to(stdlib) or not destination.is_file():
                        failures.append(f"{label}: wrong/unreadable stdlib destination {definition}")
                    if any(char in definition["uri"] for char in ["#", " "]):
                        failures.append(f"{label}: unencoded destination {definition}")
                items = phase["completion"]["items"]
                if not any(item["label"] == "print" for item in items):
                    failures.append(f"{label}: missing print expression completion")
                if not phase["hierarchy"]:
                    failures.append(f"{label}: missing print hierarchy")
                if not phase["links"]:
                    failures.append(f"{label}: missing configured Basic import link")
                for link in phase["links"]:
                    destination = Path(unquote(urlparse(link["target"]).path))
                    if not destination.is_relative_to(stdlib) or not destination.is_file():
                        failures.append(f"{label}: wrong import link {link}")
                if not phase["localDefinition"] or phase["localDefinition"][0]["uri"] != uri:
                    failures.append(f"{label}: wrong encoded local definition {phase['localDefinition']}")

            check("fresh-damaged" if fresh_damaged else "fresh-clean", fresh_damaged)
            if not fresh_damaged:
                at = text.index("    /*")
                change = dict(range=dict(start=position(text, at), end=position(text, at)), text=damage)
                version += 1
                server.send("textDocument/didChange", dict(textDocument=dict(uri=uri, version=version), contentChanges=[change]))
                text = text[:at] + damage + text[at:]
                check("incremental-damage", True)
                change = dict(range=dict(start=position(text, at), end=position(text, at + len(damage))), text="")
                version += 1
                server.send("textDocument/didChange", dict(textDocument=dict(uri=uri, version=version), contentChanges=[change]))
                text = text_original
                check("incremental-repair", False)
            server.close()
        finally:
            server.abort()
            suffix = "damaged" if fresh_damaged else "clean"
            (output / f"transport-{suffix}.json").write_text(json.dumps(server.events, indent=2) + "\n")
            (output / f"stderr-{suffix}.txt").write_text("".join(server.stderr))
    (output / "report.json").write_text(json.dumps(dict(binary=str(binary), stdlib=str(stdlib), phases=phases, failures=failures), indent=2) + "\n")
    if failures:
        raise AssertionError("\n".join(failures))
    print(f"PASS: {len(phases)} native phases, 2 fresh servers, 24 feature requests, configured production stdlib and encoded destinations")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--binary", type=Path, required=True)
    parser.add_argument("--stdlib", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    for path in (args.binary, args.stdlib, args.output):
        if not path.resolve().is_relative_to(STORAGE):
            parser.error(f"path must be inside assigned T7 LSP namespace: {path}")
    run(args.binary.resolve(), args.stdlib.resolve(), args.output.resolve())


if __name__ == "__main__":
    main()
