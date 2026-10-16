#!/usr/bin/env python3
"""Native filesystem-alias request regressions; analyzes original documents only."""
import argparse
import json
import sys
from pathlib import Path
from urllib.parse import unquote, urlparse

sys.dont_write_bytecode = True
from lsp_basic_resolution import Server, position

STORAGE = Path("/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/integration")
TEXT = '''#scope_file
Unique_Secret :: 42;
main :: () {
    /* 😀é */ local := 1;
    value := local;
    private_value := Unique_Secret;
    count: s64 = 0;
    #asm {
        r: gpr;
        popcnt r, co
    }
}
'''


def run(binary, stdlib, output):
    output.mkdir(parents=True, exist_ok=False)
    # An explicitly unavailable prelude exercises supported syntax fallbacks, while
    # the second server uses current independent production dependencies.
    unavailable = output / "unavailable stdlib"
    unavailable.mkdir()
    phases, failures = [], []
    for lexical in [True, False]:
        folder = output / ("lexical" if lexical else "production")
        folder.mkdir()
        native = folder / "actual # % é.jai"
        stored = folder / "Alias # % é.jai"
        native.write_text(TEXT)
        stored.symlink_to(native.name)
        server = Server(binary, unavailable if lexical else stdlib, stored)
        text, version = TEXT, 1
        try:
            server.request("initialize", dict(rootUri=folder.as_uri(), workspaceFolders=[dict(uri=folder.as_uri(), name="alias")], capabilities={}))
            server.send("initialized", {})
            server.send("textDocument/didOpen", dict(textDocument=dict(uri=stored.as_uri(), languageId="jai", version=version, text=text)))

            def check(label):
                phase = dict(label=label, lexical=lexical, diagnostics=server.diagnostics(version))
                phases.append(phase)
                phase["configurationWarnings"] = "".join(server.stderr)
                if lexical and "cannot find the standard library" not in phase["configurationWarnings"]:
                    failures.append(f"{label}: unavailable prelude must retain its explicit configuration warning")
                for name, needle in [("declaration", "Unique_Secret ::"), ("local", "local;"), ("private", "Unique_Secret;")]:
                    params = dict(textDocument=dict(uri=native.as_uri()), position=position(text, text.index(needle) + 2))
                    hover = server.request("textDocument/hover", params)
                    definitions = server.request("textDocument/definition", params)
                    phase[name] = dict(hover=hover, definitions=definitions)
                    if not hover or (lexical and "Source syntax declaration." not in hover["contents"]["value"]):
                        failures.append(f"{label}: {name} missing required hover {hover}")
                    if len(definitions) != 1 or Path(unquote(urlparse(definitions[0]['uri']).path)).resolve() != native.resolve():
                        failures.append(f"{label}: {name} wrong definition {definitions}")
                    if lexical and definitions and definitions[0]["uri"] != stored.as_uri():
                        failures.append(f"{label}: lexical definition lost stored filename spelling")
                params = dict(textDocument=dict(uri=native.as_uri()), position=position(text, text.index(", co") + 4))
                phase["assembly"] = server.request("textDocument/completion", params)
                if not any(i["label"] == "count" for i in phase["assembly"]["items"]):
                    failures.append(f"{label}: assembly lost count")
                params["position"] = position(text, text.index("Unique_Secret;") + 5)
                phase["privateCompletion"] = server.request("textDocument/completion", params)
                if not any(i["label"] == "Unique_Secret" for i in phase["privateCompletion"]["items"]):
                    failures.append(f"{label}: own private completion lost")
                phase["symbols"] = server.request("textDocument/documentSymbol", dict(textDocument=dict(uri=native.as_uri())))
                if not phase["symbols"]:
                    failures.append(f"{label}: missing document symbols")
                phase["workspace"] = server.request("workspace/symbol", dict(query="Unique_Secret"))
                if len(phase["workspace"]) != 1 or phase["workspace"][0]["location"]["uri"] != stored.as_uri():
                    failures.append(f"{label}: duplicate/wrong workspace symbol {phase['workspace']}")

            check("fresh-lexical" if lexical else "fresh-production")
            at = text.index("local := 1") + len("local := ")
            change = dict(range=dict(start=position(text, at), end=position(text, at + 1)), rangeLength=1, text="99")
            version += 1
            server.send("textDocument/didChange", dict(textDocument=dict(uri=native.as_uri(), version=version), contentChanges=[change]))
            text = text[:at] + "99" + text[at + 1:]
            check("incremental-lexical" if lexical else "incremental-production")
            server.close()
        except Exception as error:
            failures.append(f"server {'lexical' if lexical else 'production'}: {error}")
        finally:
            server.abort()
            (folder / "transport.json").write_text(json.dumps(server.events, indent=2) + "\n")
            (folder / "stderr.txt").write_text("".join(server.stderr))
    (output / "report.json").write_text(json.dumps(dict(binary=str(binary), stdlib=str(stdlib), phases=phases, failures=failures), indent=2) + "\n")
    if failures:
        raise AssertionError("\n".join(failures))
    print(f"PASS: {len(phases)} phases, 2 fresh servers, 40 feature requests; explicit missing-prelude fallback and production dependencies")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ["binary", "stdlib", "output"]:
        parser.add_argument(f"--{name}", type=Path, required=True)
    args = parser.parse_args()
    for path in [args.binary, args.stdlib, args.output]:
        if not path.resolve().is_relative_to(STORAGE):
            parser.error(f"path outside assigned storage: {path}")
    run(args.binary.resolve(), args.stdlib.resolve(), args.output.resolve())


if __name__ == "__main__":
    main()
