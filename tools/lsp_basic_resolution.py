#!/usr/bin/env python3
"""Source-build an authorized clean candidate and investigate Basic LSP resolution.

Only three explicit Rust source packages and the independent production stdlib
are read. No other checkout data, Git history, corpus vendors or supplied binaries
are used. The original Jai documents are analyzed, never executed.
"""
import argparse
import hashlib
import json
from pathlib import Path
import queue
import shutil
import subprocess
import threading
from urllib.parse import unquote, urlparse
import os

ROOT = Path(__file__).resolve().parents[1]


def snapshot(candidate, destination):
    destination.mkdir(parents=True, exist_ok=False)
    roots = [candidate / "crates" / package / "src" for package in ("jaic", "jailint", "jai-language-server")]
    # A dependency snapshot must never follow a link to another source tree.
    for source in roots:
        if source.is_symlink() or any(path.is_symlink() for path in source.rglob("*")):
            raise RuntimeError(f"refusing source symlink below {source}")
    stdlib = candidate / "stdlib"
    if stdlib.is_symlink():
        raise RuntimeError(f"refusing source symlink {stdlib}")
    excluded_links = []
    for source in stdlib.rglob("*"):
        if source.is_symlink():
            if source.suffix == ".jai":
                raise RuntimeError(f"refusing Jai source symlink {source}")
            # Only .jai source is staged. Non-source native SDK links are neither
            # followed nor copied; any required missing source remains a real error.
            excluded_links.append(str(source.relative_to(stdlib)))
    for name in ("Cargo.toml", "Cargo.lock", "jailint.toml"):
        if (candidate / name).is_symlink():
            raise RuntimeError(f"refusing source symlink {name}")
        shutil.copy2(candidate / name, destination / name)
    manifest = (destination / "Cargo.toml").read_text()
    start = manifest.index("members = [")
    end = manifest.index("]", start) + 1
    manifest = manifest[:start] + 'members = ["crates/jaic", "crates/jailint", "crates/jai-language-server"]' + manifest[end:]
    (destination / "Cargo.toml").write_text(manifest)
    for package in ("jaic", "jailint", "jai-language-server"):
        target = destination / "crates" / package
        target.mkdir(parents=True)
        shutil.copy2(candidate / "crates" / package / "Cargo.toml", target / "Cargo.toml")
        shutil.copytree(candidate / "crates" / package / "src", target / "src")
    for source in (candidate / "stdlib").rglob("*.jai"):
        target = destination / "stdlib" / source.relative_to(candidate / "stdlib")
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, target)
    hashes = {
        str(path.relative_to(destination)): hashlib.sha256(path.read_bytes()).hexdigest()
        for path in sorted(destination.rglob("*")) if path.is_file()
    }
    (destination / "source-hashes.json").write_text(json.dumps(hashes, indent=2) + "\n")
    (destination / "excluded-non-source-links.json").write_text(json.dumps(excluded_links, indent=2) + "\n")
    return hashlib.sha256(json.dumps(hashes, sort_keys=True).encode()).hexdigest()


def apply_ide_patch(destination, patch):
    prefix = str(destination.relative_to(ROOT))
    command = ["git", "apply", "--directory", prefix]
    subprocess.run([*command, "--check", str(patch)], cwd=ROOT, check=True)
    subprocess.run([*command, str(patch)], cwd=ROOT, check=True)
    hashes = json.loads((destination / "source-hashes.json").read_text())
    effective = {name: hashlib.sha256((destination / name).read_bytes()).hexdigest() for name in hashes}
    (destination / "effective-source-hashes.json").write_text(json.dumps(effective, indent=2) + "\n")
    return hashlib.sha256(json.dumps(effective, sort_keys=True).encode()).hexdigest()


def build(destination, target):
    # Independently copied workspaces contain identical package identities and
    # preserved source mtimes. Keep their build metadata apart from the older
    # isolated worker/compiler and from other captured candidates.
    candidate_target = target / "basic-resolution" / hashlib.sha256(str(destination).encode()).hexdigest()
    (destination / "build-target.txt").write_text(str(candidate_target) + "\n")
    env = dict(os.environ, CARGO_TARGET_DIR=str(candidate_target))
    result = subprocess.run(
        ["cargo", "build", "--manifest-path", str(destination / "Cargo.toml"),
         "-p", "jai-language-server", "--bin", "jailsp", "--message-format=json"],
        cwd=ROOT, env=env, capture_output=True, text=True,
    )
    (destination / "build.stdout.jsonl").write_text(result.stdout)
    (destination / "build.stderr.txt").write_text(result.stderr)
    if result.returncode:
        raise RuntimeError(f"candidate source build failed ({result.returncode}); see {destination}")
    for line in result.stdout.splitlines():
        message = json.loads(line)
        if message.get("reason") == "compiler-artifact" and message.get("target", {}).get("name") == "jailsp" and message.get("executable"):
            binary = destination / "jailsp-source-built"
            shutil.copy2(message["executable"], binary)
            return binary
    raise RuntimeError("cargo did not report a source-built jailsp")


class Server:
    def __init__(self, binary, stdlib, document):
        self.events = []
        self.incoming = queue.Queue()
        self.next_id = 0
        self.process = subprocess.Popen(
            [str(binary), "--stdio"], stdin=subprocess.PIPE, stdout=subprocess.PIPE,
            stderr=subprocess.PIPE, env=dict(os.environ, JAIC_STDLIB=str(stdlib)),
        )
        self.document = document
        self.stderr = []
        self.readers = [threading.Thread(target=self.read, daemon=True),
                        threading.Thread(target=self.read_errors, daemon=True)]
        for reader in self.readers:
            reader.start()

    def read(self):
        try:
            while True:
                headers = {}
                while True:
                    line = self.process.stdout.readline()
                    if not line:
                        raise EOFError("server stdout ended")
                    if line == b"\r\n":
                        break
                    key, value = line.decode("ascii").strip().split(":", 1)
                    headers[key.lower()] = value.strip()
                length = int(headers["content-length"])
                body = self.process.stdout.read(length)
                if len(body) != length:
                    raise EOFError("incomplete LSP response")
                self.incoming.put(json.loads(body))
        except Exception as error:
            self.incoming.put(error)

    def read_errors(self):
        for line in self.process.stderr:
            self.stderr.append(line.decode("utf-8", errors="replace"))

    def send(self, method, params=None, request=False):
        message = dict(jsonrpc="2.0", method=method)
        if params is not None:
            message["params"] = params
        if request:
            self.next_id += 1
            message["id"] = self.next_id
        self.events.append(dict(direction="sent", message=message))
        body = json.dumps(message).encode()
        self.process.stdin.write(f"Content-Length: {len(body)}\r\n\r\n".encode() + body)
        self.process.stdin.flush()
        return message.get("id")

    def receive(self, predicate):
        while True:
            message = self.incoming.get(timeout=60)
            if isinstance(message, Exception):
                raise message
            self.events.append(dict(direction="received", message=message))
            if predicate(message):
                return message

    def request(self, method, params=None):
        ident = self.send(method, params, request=True)
        response = self.receive(lambda message: message.get("id") == ident)
        if "error" in response:
            raise AssertionError(f"{method}: {response['error']}")
        return response["result"]

    def diagnostics(self, version):
        def matches(message):
            return (message.get("method") == "textDocument/publishDiagnostics"
                    and message["params"].get("uri") == self.document.as_uri()
                    and message["params"].get("version") == version)
        for event in reversed(self.events):
            if event["direction"] == "received" and matches(event["message"]):
                return event["message"]["params"]["diagnostics"]
        return self.receive(matches)["params"]["diagnostics"]

    def close(self):
        try:
            self.request("shutdown")
            self.send("exit")  # LSP transport shutdown; never a Jai exit call.
            self.process.wait(timeout=10)
            if self.process.returncode:
                raise AssertionError(f"server exited {self.process.returncode}")
        finally:
            self.abort()

    def abort(self):
        if self.process.poll() is None:
            self.process.kill()
        self.process.wait()
        for reader in self.readers:
            reader.join(timeout=2)
        for pipe in (self.process.stdin, self.process.stdout, self.process.stderr):
            pipe.close()


def position(text, offset):
    prefix = text[:offset]
    return dict(line=prefix.count("\n"), character=len(prefix.rsplit("\n", 1)[-1].encode("utf-16-le")) // 2)


def queries(server, text, qualified, stdlib, names=("temp", "exit")):
    results = {}
    for name in names:
        use = ("Basic." if qualified else "") + name
        start = text.index(use, text.index("main ::")) + (6 if qualified else 0)
        params = dict(textDocument=dict(uri=server.document.as_uri()), position=position(text, start + 1))
        hover = server.request("textDocument/hover", params)
        definitions = server.request("textDocument/definition", params)
        params["position"] = position(text, start + 2)
        completion = server.request("textDocument/completion", params)
        items = completion.get("items", []) if isinstance(completion, dict) else completion
        results[name] = dict(hover=hover, definitions=definitions,
                             completion=[item for item in items if item["label"] == name])
        type_name = "Allocator" if name == "temp" else "s32"
        try:
            assert hover and type_name in hover["contents"]["value"], "missing typed hover"
            assert "Source syntax declaration" not in hover["contents"]["value"], "syntax-only hover"
            assert any(type_name in item.get("detail", "") for item in results[name]["completion"]), "missing typed completion"
            assert definitions, "no definition target"
            for definition in definitions:
                target = Path(unquote(urlparse(definition["uri"]).path)).resolve()
                assert target.is_relative_to(stdlib), definition
                # Only the authorized independent production stdlib is inspected.
                line = target.read_text().splitlines()[definition["range"]["start"]["line"]]
                column = definition["range"]["start"]["character"]
                prefix = line.encode("utf-16-le")[:column * 2].decode("utf-16-le")
                assert line[len(prefix):].startswith(name), definition
        except AssertionError as error:
            results[name]["failure"] = str(error)
    return results


def investigate(binary, stdlib, directory, qualified, initially_damaged):
    directory.mkdir()
    document = directory / "main.jai"
    prefix = "Basic." if qualified else ""
    allocator_line = "    /* 😀é */ allocator"
    source = ('Basic :: #import "Basic";\n' if qualified else '#import "Basic";\n') + (
        f"main :: () {{\n{allocator_line} := {prefix}temp;\n    {prefix}exit(1);\n}}\n"
        "unaffected :: () { value := 42; result := value + 1; }\n"
    )
    damage = "    damaged := (\n"
    text = source.replace(allocator_line, damage + allocator_line) if initially_damaged else source
    document.write_text(text)
    server = Server(binary, stdlib, document)
    report = dict(qualified=qualified, initially_damaged=initially_damaged, phases=[], failures=[])
    version = 1
    try:
        server.request("initialize", dict(rootUri=directory.as_uri(), capabilities={}))
        server.send("initialized", {})
        server.send("textDocument/didOpen", dict(textDocument=dict(uri=document.as_uri(), languageId="jai", version=version, text=text)))

        def check(label, damaged):
            diagnostics = server.diagnostics(version)
            phase = dict(label=label, version=version, diagnostics=diagnostics)
            report["phases"].append(phase)
            errors = [d for d in diagnostics if d.get("severity") == 1]
            if damaged:
                assert errors and all(d["range"]["start"]["line"] == 2 for d in errors), diagnostics
            else:
                assert not errors, diagnostics
            phase["queries"] = queries(server, text, qualified, stdlib)
            for name, result in phase["queries"].items():
                if "failure" in result:
                    report["failures"].append(f"{label}: {name}: {result['failure']}")

        def edit(start, end, replacement):
            nonlocal text, version
            change = dict(range=dict(start=position(text, start), end=position(text, end)),
                          rangeLength=len(text[start:end].encode("utf-16-le")) // 2, text=replacement)
            version += 1
            text = text[:start] + replacement + text[end:]
            server.send("textDocument/didChange", dict(textDocument=dict(uri=document.as_uri(), version=version), contentChanges=[change]))

        check("fresh", initially_damaged)
        if initially_damaged:
            start = text.index(damage)
            edit(start, start + len(damage), "")
            check("repair fresh damage", False)
        else:
            start = text.index(allocator_line)
            edit(start, start, damage)
            check("incremental unrelated partial expression", True)
            edit(start, start + len(damage), "")
            check("restore", False)
        # Exercise a genuine ranged edit of the reported call, without executing it.
        start = text.index("exit(1)") + len("exit(")
        edit(start, start + 1, "2")
        check("exit argument edit", False)
        edit(start, start + 1, "1")
        check("restore exit(1)", False)
        for name, type_name, expected_line in [("temp", "Allocator", 2), ("exit", "s32", 3)]:
            start = text.index(prefix + name, text.index("main ::")) + len(prefix)
            tail = name[-1:]
            edit(start + len(name) - 1, start + len(name), "")
            diagnostics = server.diagnostics(version)
            phase = dict(label=f"partial {name} identifier", version=version, diagnostics=diagnostics)
            report["phases"].append(phase)
            errors = [d for d in diagnostics if d.get("severity") == 1]
            assert errors and all(d["range"]["start"]["line"] == expected_line for d in errors), diagnostics
            completion = server.request("textDocument/completion", dict(
                textDocument=dict(uri=document.as_uri()), position=position(text, start + len(name) - 1)))
            items = completion.get("items", []) if isinstance(completion, dict) else completion
            phase["completion"] = [item for item in items if item["label"] == name]
            assert any(type_name in item.get("detail", "") for item in phase["completion"]), phase
            unaffected = ("exit",) if name == "temp" else ("temp",)
            phase["queries"] = queries(server, text, qualified, stdlib, unaffected)
            for symbol, result in phase["queries"].items():
                if "failure" in result:
                    report["failures"].append(f"partial {name}: {symbol}: {result['failure']}")
            edit(start + len(name) - 1, start + len(name) - 1, tail)
            check(f"restore {name} identifier", False)
        server.send("textDocument/didClose", dict(textDocument=dict(uri=document.as_uri())))
        version += 1
        server.send("textDocument/didOpen", dict(textDocument=dict(uri=document.as_uri(), languageId="jai", version=version, text=text)))
        check("reopen", False)
        server.close()
    except Exception as error:
        report["failures"].append(f"{type(error).__name__}: {error}")
        server.abort()
    report["server_stderr"] = "".join(server.stderr)
    (directory / "requests-responses.json").write_text(json.dumps(server.events, indent=2) + "\n")
    (directory / "report.json").write_text(json.dumps(report, indent=2) + "\n")
    return report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--candidate", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    parser.add_argument("--target-dir", required=True, type=Path)
    parser.add_argument("--ide-patch", type=Path, help="owned IDE-only patch applied to the local snapshot, never to the candidate checkout")
    args = parser.parse_args()
    destination = args.output.resolve()
    if not destination.is_relative_to(ROOT / "artifacts"):
        parser.error("output must be a new durable directory under this worker's artifacts/")
    fingerprint = snapshot(args.candidate.resolve(), destination)
    effective_fingerprint = apply_ide_patch(destination, args.ide_patch.resolve()) if args.ide_patch else fingerprint
    binary = build(destination, args.target_dir.resolve())
    stdlib = destination / "stdlib"
    reports = []
    for qualified in (False, True):
        for damaged in (False, True):
            label = ("qualified" if qualified else "unqualified") + ("-fresh-damaged" if damaged else "-incremental")
            report = investigate(binary, stdlib, destination / label, qualified, damaged)
            reports.append(report)
            print(label, "FAIL" if report["failures"] else "PASS", flush=True)
    result = dict(source_fingerprint=fingerprint, binary_sha256=hashlib.sha256(binary.read_bytes()).hexdigest(),
                  effective_source_fingerprint=effective_fingerprint,
                  ide_patch_sha256=hashlib.sha256(args.ide_patch.read_bytes()).hexdigest() if args.ide_patch else None,
                  candidate=str(args.candidate.resolve()), final_merged_verification_required=True, runs=reports)
    (destination / "report.json").write_text(json.dumps(result, indent=2) + "\n")
    return int(any(report["failures"] for report in reports))


if __name__ == "__main__":
    raise SystemExit(main())
