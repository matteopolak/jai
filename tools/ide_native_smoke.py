#!/usr/bin/env python3
"""Independent native LSP protocol verification using reviewed public Basic names.

Does not copy source trees, apply patches, or execute the Jai documents.
The supplied server must be source-built from the declared clean snapshot.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import queue
import subprocess
import threading


def position(text, needle):
    prefix = text[:text.index(needle)]
    return dict(line=prefix.count("\n"), character=len(prefix.rsplit("\n", 1)[-1].encode("utf-16-le")) // 2)


class Server:
    def __init__(self, executable, stdlib, directory):
        self.directory = directory
        directory.mkdir()
        self.stderr = (directory / "server.stderr").open("wb")
        self.child = subprocess.Popen([str(executable)], stdin=subprocess.PIPE, stdout=subprocess.PIPE,
                                      stderr=self.stderr, env=dict(os.environ, JAIC_STDLIB=str(stdlib)))
        self.messages = queue.Queue()
        self.sent = 0
        self.evidence = []
        threading.Thread(target=self.read, daemon=True).start()

    def read(self):
        try:
            while True:
                headers = {}
                while True:
                    line = self.child.stdout.readline()
                    if not line:
                        raise EOFError("server closed protocol channel")
                    if line == b"\r\n":
                        break
                    key, value = line.decode("ascii").split(":", 1)
                    headers[key.lower()] = value.strip()
                length = int(headers["content-length"])
                data = bytearray()
                while len(data) < length:
                    chunk = self.child.stdout.read(length - len(data))
                    if not chunk:
                        raise EOFError("truncated server response")
                    data.extend(chunk)
                self.messages.put(json.loads(data))
        except Exception as error:
            self.messages.put(error)

    def send(self, method, params=None, request=False):
        message = dict(jsonrpc="2.0", method=method)
        if params is not None:
            message["params"] = params
        if request:
            self.sent += 1
            message["id"] = self.sent
        data = json.dumps(message).encode()
        self.child.stdin.write(f"Content-Length: {len(data)}\r\n\r\n".encode() + data)
        self.child.stdin.flush()
        return self.sent

    def receive(self, predicate):
        while True:
            message = self.messages.get(timeout=30)
            if isinstance(message, Exception):
                raise message
            self.evidence.append(message)
            if predicate(message):
                return message

    def request(self, method, params=None):
        number = self.send(method, params, request=True)
        response = self.receive(lambda message: message.get("id") == number)
        assert "error" not in response, response
        return response["result"]

    def diagnostics(self, uri, version, errors):
        message = self.receive(lambda message: message.get("method") == "textDocument/publishDiagnostics"
                               and message["params"]["uri"] == uri
                               and message["params"].get("version") == version)
        actual = [d for d in message["params"]["diagnostics"] if d.get("severity") == 1]
        assert bool(actual) == errors, message
        assert all(d["range"]["start"]["line"] == 2 for d in actual), message

    def finish(self):
        self.request("shutdown")
        self.send("exit")
        self.child.stdin.close()
        assert self.child.wait(timeout=10) == 0
        self.stderr.close()
        assert not (self.directory / "server.stderr").read_bytes(), "unexpected native server stderr"

    def close(self):
        if self.child.poll() is None:
            self.child.kill()
            self.child.wait(timeout=10)
        self.stderr.close()
        (self.directory / "received.json").write_text(json.dumps(self.evidence, indent=2) + "\n")


def typed_completion(server, uri, text, needle, prefix, label, expected_type):
    at = position(text, needle)
    at["character"] += len(prefix)
    completion = server.request("textDocument/completion", dict(textDocument=dict(uri=uri), position=at))
    assert any(item["label"] == label and expected_type in item.get("detail", "")
               for item in completion["items"]), (label, completion)


def typed_queries(server, uri, text):
    names = [("temp;", "Allocator"), ("exit(1)", "s32")]
    for name, expected_type in names:
        params = dict(textDocument=dict(uri=uri), position=position(text, name))
        hover = server.request("textDocument/hover", params)
        assert hover and expected_type in hover["contents"]["value"], hover
        assert "Source syntax declaration" not in hover["contents"]["value"], hover
        targets = server.request("textDocument/definition", params)
        assert targets and all(target["uri"].startswith("file:") for target in targets), targets
        # Exact independently known local uses are covered by ide_audit_regressions;
        # production declarations here must resolve to real source, not guessed lines.
        label = "temp" if expected_type == "Allocator" else "exit"
        typed_completion(server, uri, text, name, label, label, expected_type)


def run_case(args, directory, qualified, damaged_start):
    server = Server(args.server, args.stdlib, directory)
    uri = (directory / "main.jai").as_uri()
    qualifier = "Basic." if qualified else ""
    text = f'using #import "Basic";\nBasic :: #import "Basic";\nmain :: () {{ note := "🦊"; allocator := {qualifier}temp; {qualifier}exit(1); }}\n'
    version = 1
    phases = 0
    try:
        server.request("initialize", dict(rootUri=directory.as_uri(), capabilities={}))
        server.send("initialized", {})
        initial = text.replace("temp;", "tem;") if damaged_start else text
        (directory / "main.jai").write_text(initial)
        server.send("textDocument/didOpen", dict(textDocument=dict(uri=uri, languageId="jai", version=version, text=initial)))
        server.diagnostics(uri, version, damaged_start)
        phases += 1
        if not damaged_start:
            typed_queries(server, uri, text)
        else:
            typed_completion(server, uri, initial, "tem;", "tem", "temp", "Allocator")
        for changed in [text, text.replace('"🦊"', '"🦊🌍"'), text.replace("exit(1)", 'exit("bad")'), text,
                        text.replace("temp;", "tem;"), text.replace("exit(1)", "exi(1)"), text]:
            version += 1
            server.send("textDocument/didChange", dict(textDocument=dict(uri=uri, version=version), contentChanges=[dict(text=changed)]))
            damaged = any(needle in changed for needle in ['exit("bad")', "tem;", "exi(1)"])
            server.diagnostics(uri, version, damaged)
            phases += 1
            if not damaged:
                typed_queries(server, uri, changed)
            elif "tem;" in changed:
                typed_completion(server, uri, changed, "tem;", "tem", "temp", "Allocator")
            elif "exi(1)" in changed:
                typed_completion(server, uri, changed, "exi(1)", "exi", "exit", "s32")
        # True ranged UTF16 edit replaces one supplementary-plane character.
        start = position(text, "🦊")
        end = dict(start, character=start["character"] + 2)
        version += 1
        server.send("textDocument/didChange", dict(textDocument=dict(uri=uri, version=version), contentChanges=[dict(range=dict(start=start, end=end), rangeLength=2, text="🌍🦊")]))
        server.diagnostics(uri, version, False)
        typed_queries(server, uri, text.replace("🦊", "🌍🦊"))
        phases += 1
        server.send("textDocument/didClose", dict(textDocument=dict(uri=uri)))
        # didClose may publish cleared diagnostics; the new version disambiguates.
        version += 1
        server.send("textDocument/didOpen", dict(textDocument=dict(uri=uri, languageId="jai", version=version, text=text)))
        server.diagnostics(uri, version, False)
        typed_queries(server, uri, text)
        phases += 1
        server.finish()
        return phases
    finally:
        server.close()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--server", required=True, type=Path)
    parser.add_argument("--stdlib", required=True, type=Path)
    parser.add_argument("--source-id", required=True)
    parser.add_argument("--stdlib-id", required=True)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    args.server = args.server.resolve(strict=True)
    args.stdlib = args.stdlib.resolve(strict=True)
    args.output = args.output.absolute()
    args.output.mkdir(parents=True, exist_ok=False)
    result = dict(accepted=False, source_id=args.source_id, stdlib_id=args.stdlib_id,
                  server_sha256=hashlib.sha256(args.server.read_bytes()).hexdigest(), native_host=True,
                  jai_documents_executed=False, phases=0, processes=0)
    try:
        for qualified in [False, True]:
            for damaged in [False, True]:
                result["phases"] += run_case(args, args.output / f"qualified-{qualified}-damaged-{damaged}", qualified, damaged)
                result["processes"] += 1
        result["accepted"] = True
    finally:
        (args.output / "summary.json").write_text(json.dumps(result, indent=2) + "\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
