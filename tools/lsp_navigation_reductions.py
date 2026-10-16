#!/usr/bin/env python3
"""Bounded native navigation oracles; never execute the documents as programs."""
import argparse
import json
from pathlib import Path

from lsp_basic_resolution import Server, position


def run(binary, stdlib, fixtures, output):
    output.mkdir(parents=True, exist_ok=True)
    reports = []
    for name in ("procedure-type-parameters", "named-generic-callback", "inherited-member-default"):
        fixture = fixtures / name
        text = (fixture / "main.jai").read_text()
        oracles = json.loads((fixture / "expected.json").read_text())["oracles"]
        directory = output / name
        directory.mkdir(exist_ok=True)
        document = directory / "main.jai"
        document.write_text(text)
        server = Server(binary, stdlib, document)
        report = dict(case=name, phases=[], failures=[])
        try:
            server.request("initialize", dict(rootUri=directory.as_uri(), capabilities={}))
            server.send("initialized", {})
            server.send("textDocument/didOpen", dict(textDocument=dict(
                uri=document.as_uri(), languageId="jai", version=1, text=text)))
            for version, label in ((1, "complete"), (2, "unrelated-incomplete-suffix"), (3, "restored")):
                if version > 1:
                    suffix = "\n// 😀 UTF-16 edit\nunrelated :: ("
                    start = position(text, len(text))
                    end = start if version == 2 else position(text + suffix, len(text + suffix))
                    server.send("textDocument/didChange", dict(textDocument=dict(
                        uri=document.as_uri(), version=version), contentChanges=[dict(
                            range=dict(start=start, end=end), text=suffix if version == 2 else "")]))
                diagnostics = server.diagnostics(version)
                errors = [d for d in diagnostics if d.get("severity") == 1]
                if (version != 2 and errors) or (version == 2 and not errors) or any(
                        d["range"]["start"]["line"] < len(text.splitlines()) for d in errors):
                    report["failures"].append(dict(phase=label, diagnostics=errors))
                phase = dict(label=label, diagnostics=diagnostics, queries=[])
                for oracle in oracles:
                    params = dict(textDocument=dict(uri=document.as_uri()), position=dict(
                        line=oracle["line"], character=oracle["character"]))
                    hover = server.request("textDocument/hover", params)
                    definitions = server.request("textDocument/definition", params)
                    actual = [dict(uri=d["uri"], **d["range"]["start"]) for d in definitions or []]
                    expected = [dict(uri=document.as_uri(), line=d["line"], character=d["character"])
                                for d in oracle["definitions"]]
                    query = dict(position=params["position"], hover=hover,
                                 definitions=definitions, expected=expected)
                    phase["queries"].append(query)
                    if not hover or actual != expected:
                        report["failures"].append(dict(phase=label, **query))
                report["phases"].append(phase)
            server.close()
        finally:
            server.abort()
            report["events"] = server.events
            (directory / "capture.json").write_text(json.dumps(report, indent=2) + "\n")
        reports.append(report)
    summary = dict(cases=len(reports), phases=sum(len(r["phases"]) for r in reports),
                   failures=sum(len(r["failures"]) for r in reports))
    (output / "summary.json").write_text(json.dumps(summary, indent=2) + "\n")
    print(json.dumps(summary))
    return summary["failures"] == 0


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    for key in ("binary", "stdlib", "fixtures", "output"):
        parser.add_argument("--" + key, type=Path, required=True)
    args = parser.parse_args()
    namespace = Path("/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/integration").resolve()
    if any(not path.resolve().is_relative_to(namespace) for path in (args.binary, args.output)):
        parser.error("binary and captures must stay in the assigned T7 LSP namespace")
    raise SystemExit(0 if run(**vars(args)) else 1)
