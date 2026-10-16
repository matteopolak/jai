#!/usr/bin/env python3
"""Actual native LSP requests against an explicitly source-built clean candidate.

Analyzes original documents and reviewed public Basic.print; never executes Jai programs.
The caller supplies explicit tool, stdlib and output paths.
"""

import argparse
import hashlib
import importlib
import json
import sys
from pathlib import Path

# Importing transport helpers must not write caches into the source input.
sys.dont_write_bytecode = True
_transport = importlib.import_module("lsp_basic_resolution")
Server, position = _transport.Server, _transport.position


def offset(text, point):
    lines = text.splitlines(keepends=True)
    start = sum(len(line) for line in lines[: point["line"]])
    remaining = point["character"]
    for i, char in enumerate(text[start:]):
        if remaining == 0:
            return start + i
        remaining -= len(char.encode("utf-16-le")) // 2
        assert remaining >= 0, point
    assert remaining == 0, point
    return len(text)


def parameters(items):
    return [item for item in items if item.get("detail", "").startswith("parameter ")]


def run(binary, stdlib, output):
    output.mkdir(parents=True, exist_ok=False)
    # These modules are independently authored test documents, not production replacements.
    module = output / "modules" / "NamedFixture"
    module.mkdir(parents=True)
    (module / "module.jai").write_text(
        "visible :: (public_option := false) {}\n#scope_file\nhidden :: (private_option := false) {}\n"
    )
    document = output / "main.jai"
    decl = "f :: (first: int, second := 2, third := 3) {}\n"
    cases = [
        (
            "production-basic",
            '#import "Basic";\nmain :: () { print("hello", to_sta|); }',
            ["to_standard_error"],
        ),
        (
            "production-qualified",
            'Basic :: #import "Basic";\nmain :: () { Basic.print("hello", to_sta|); }',
            ["to_standard_error"],
        ),
        (
            "incomplete-utf16",
            '#import "Basic";\nmain :: () { marker := "😀é"; print("hello", to_sta|\n}',
            ["to_standard_error"],
        ),
        ("supplied", decl + "main :: () { f(1, se|, third = 3); }", ["second"]),
        (
            "positional-after-named",
            decl + "main :: () { f(second = 2, 3, |); }",
            ["first"],
        ),
        (
            "overloads",
            "f :: (value: int, integer_option := false) {}\nf :: (value: string, string_option := false) {}\nmain :: () { f(|); }",
            ["integer_option", "string_option", "value"],
        ),
        (
            "typed-overloads",
            "f :: (value: int, option_integer := false) {}\nf :: (value: string, option_string := false) {}\nmain :: () { f(1, opt|); }",
            ["option_integer"],
        ),
        (
            "nested",
            "f :: (outer: int) {}\ng :: (inner: int) -> int { return inner; }\nmain :: () { f(g(in|)); }",
            ["inner"],
        ),
        (
            "method",
            "Tools :: struct { emit :: (option := false) {} }\nmain :: () { Tools.emit(op|); }",
            ["option"],
        ),
        (
            "callback-no-fabrication",
            "Holder :: struct { callback: (value: int, option := false) -> int; }\nmain :: () { holder: Holder; holder.callback(op|); }",
            [],
        ),
        (
            "callback-no-leak",
            "Holder :: struct { callback: (public_option := false) -> int; }\nOther :: struct { callback: (private_option := false) -> int; }\nmain :: () { h: Holder; other: Other; h.callback(|); }",
            [],
        ),
        (
            "import",
            'M :: #import "NamedFixture";\nmain :: () { M.visible(pub|); }',
            ["public_option"],
        ),
        ("private", 'M :: #import "NamedFixture";\nmain :: () { M.hidden(pri|); }', []),
        (
            "existing-equals",
            '#import "Basic";\nmain :: () { print("hello", to_sta|ndard_error = true); }',
            ["to_standard_error"],
        ),
        (
            "colon",
            '#import "Basic";\nmain :: () { print("hello", to_sta|ndard_error: true); }',
            ["to_standard_error"],
        ),
        (
            "colon-equals",
            '#import "Basic";\nmain :: () { print("hello", to_sta|ndard_error:= true); }',
            ["to_standard_error"],
        ),
        (
            "value",
            '#import "Basic";\nmain :: () { print("hello", to_standard_error = tr|); }',
            [],
        ),
    ]
    phases = []
    servers = []
    # Reopening each original fixture exercises shared-server cache invalidation. Basic is
    # repeated on a fresh server so a preceding fixture cannot accidentally supply facts.
    for round_cases in [cases, [cases[0]]]:
        server = Server(binary, stdlib, document)
        servers.append(server)
        try:
            server.request("initialize", dict(rootUri=output.as_uri(), capabilities={}))
            server.send("initialized", {})
            version = 0
            for label, marked, expected in round_cases:
                text = marked.replace("|", "")
                cursor = marked.index("|")
                document.write_text(text)
                version += 1
                uri = document.as_uri()
                server.send(
                    "textDocument/didOpen",
                    dict(
                        textDocument=dict(
                            uri=uri, languageId="jai", version=version, text=text
                        )
                    ),
                )
                diagnostics = server.diagnostics(version)
                params = dict(
                    textDocument=dict(uri=uri), position=position(text, cursor)
                )
                result = server.request("textDocument/completion", params)
                items = result["items"] if isinstance(result, dict) else result
                named = parameters(items)
                assert sorted(i["label"] for i in named) == expected, (
                    label,
                    named,
                    diagnostics,
                )
                phase = dict(label=label, diagnostics=diagnostics, parameters=named)
                phases.append(phase)
                if label in {
                    "production-basic",
                    "production-qualified",
                    "existing-equals",
                    "colon",
                    "colon-equals",
                }:
                    edit = named[0]["textEdit"]
                    start = offset(text, edit["range"]["start"])
                    end = offset(text, edit["range"]["end"])
                    value = (
                        ""
                        if label in {"existing-equals", "colon", "colon-equals"}
                        else "true"
                    )
                    insertion = edit["newText"] + value
                    repaired = text[:start] + insertion + text[end:]
                    assert (
                        "to_standard_error = " in repaired
                        and ":=" not in repaired
                        and "==" not in repaired
                    ), repaired
                    version += 1
                    server.send(
                        "textDocument/didChange",
                        dict(
                            textDocument=dict(uri=uri, version=version),
                            contentChanges=[dict(range=edit["range"], text=insertion)],
                        ),
                    )
                    phase["acceptedDiagnostics"] = server.diagnostics(version)
                    assert not any(
                        d.get("severity") == 1 for d in phase["acceptedDiagnostics"]
                    ), phase
                    use = repaired.index("print(")
                    params["position"] = position(repaired, use + 2)
                    phase["hover"] = server.request("textDocument/hover", params)
                    phase["definition"] = server.request(
                        "textDocument/definition", params
                    )
                    assert phase["hover"] and phase["definition"], phase
                if label == "incomplete-utf16":
                    # Ranged edits on the same line after a non-BMP character; reuse an open
                    # server but change the real callee, then restore it and its parameter set.
                    start = text.index("print(")
                    for replacement, wanted in [
                        ("sprint", []),
                        ("print", ["to_standard_error"]),
                    ]:
                        old = "print" if replacement == "sprint" else "sprint"
                        change = dict(
                            range=dict(
                                start=position(text, start),
                                end=position(text, start + len(old)),
                            ),
                            text=replacement,
                        )
                        version += 1
                        server.send(
                            "textDocument/didChange",
                            dict(
                                textDocument=dict(uri=uri, version=version),
                                contentChanges=[change],
                            ),
                        )
                        text = text[:start] + replacement + text[start + len(old) :]
                        cursor += len(replacement) - len(old)
                        server.diagnostics(version)
                        params["position"] = position(text, cursor)
                        result = server.request("textDocument/completion", params)
                        assert (
                            sorted(i["label"] for i in parameters(result["items"]))
                            == wanted
                        ), result
                server.send("textDocument/didClose", dict(textDocument=dict(uri=uri)))
                # Consume the close publication; versions restart only after this barrier.
                server.receive(
                    lambda m: m.get("method") == "textDocument/publishDiagnostics"
                    and m["params"].get("uri") == uri
                )
            server.close()
        finally:
            server.abort()
            (output / f"transport-{len(servers)}.json").write_text(
                json.dumps(server.events, indent=2) + "\n"
            )
            (output / f"stderr-{len(servers)}.txt").write_text("".join(server.stderr))
    report = dict(
        binary=str(binary),
        binary_sha256=hashlib.sha256(binary.read_bytes()).hexdigest(),
        stdlib=str(stdlib),
        servers=len(servers),
        phases=phases,
    )
    (output / "report.json").write_text(json.dumps(report, indent=2) + "\n")
    print(
        f"PASS: {len(phases)} original-document phases, {len(servers)} fresh servers, production Basic, accepted edits and UTF-16 incremental callee changes"
    )


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--binary", type=Path, required=True)
    parser.add_argument("--stdlib", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    stdlib, output = args.stdlib.resolve(), args.output.resolve()
    if stdlib == output or stdlib in output.parents or output in stdlib.parents:
        parser.error("output must not overlap the stdlib input")
    run(args.binary.resolve(), args.stdlib.resolve(), args.output.resolve())


if __name__ == "__main__":
    main()
