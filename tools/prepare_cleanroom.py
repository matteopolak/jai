#!/usr/bin/env python3
"""Prepare a source-only, history-independent repository for clean-room work."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import shutil
import subprocess


def run(*args: str, cwd: Path) -> str:
    return subprocess.check_output(args, cwd=cwd, text=True).strip()


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("destination", type=Path)
    parser.add_argument("--source", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--roles", nargs="+", choices=("compiler", "stdlib", "bindings", "numerics"),
                        default=("compiler", "stdlib"))
    args = parser.parse_args()
    source = args.source.resolve()
    destination = args.destination.resolve()
    inside_source = source in destination.parents
    if (destination.exists() or source == destination
            or (inside_source and source / "artifacts" not in destination.parents)):
        parser.error("destination must be new and either outside the source repository or inside artifacts/")
    if inside_source:
        ignored = subprocess.run(["git", "check-ignore", "-q", str(destination / "snapshot.json")],
                                 cwd=source)
        if ignored.returncode != 0:
            parser.error("an in-repository destination must be ignored by Git")

    # A spec may describe behavior but must not ship source bodies to implementers.
    checker_path = source / "tools/stdlib-api-audit/audit.py"
    checker_spec = importlib.util.spec_from_file_location("cleanroom_spec_checks", checker_path)
    checker = importlib.util.module_from_spec(checker_spec)
    checker_spec.loader.exec_module(checker)
    spec_issues = {alias: issues for alias, page in checker.spec_modules(source / "docs/specs/stdlib/README.md")
                   if any((issues := checker.aggregate_structure_issues(page)).values())}
    if spec_issues:
        raise SystemExit("Specification review required before snapshot: " + json.dumps(spec_issues))

    tracked = subprocess.check_output(["git", "ls-files", "-z"], cwd=source).decode().split("\0")
    paths = set(filter(None, tracked))
    paths.update({"tools/prepare_cleanroom.py", "docs/tools/cleanroom-workspaces.md"})
    # Specifications are deliberately included from the working tree, including new pages.
    paths.update(str(p.relative_to(source)) for p in (source / "docs/specs").rglob("*") if p.is_file())
    for folder in ("tests/stdlib-contract", "tests/cleanroom-language", "docs/extensions"):
        paths.update(str(p.relative_to(source)) for p in (source / folder).rglob("*") if p.is_file())
    paths.add("docs/tools/stdlib-integration-decisions.md")
    excluded = []
    hashes = {}
    base = destination / "base"
    base.mkdir(parents=True)
    for name in sorted(paths):
        parts = Path(name).parts
        if (parts[0] in {"reference", ".git", "artifacts"}
                or name.startswith("docs/stdlib/")
                or name.startswith("tools/stdlib-api-audit/")
                or (parts[0] == "stdlib" and parts[1:2] != ("Extensions",))):
            excluded.append(name)
            continue
        original = source / name
        if not original.exists():
            continue
        if original.is_symlink():
            raise SystemExit(f"Refusing symlink in clean source snapshot: {name}")
        copied = base / name
        copied.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(original, copied)
        hashes[name] = hashlib.sha256(copied.read_bytes()).hexdigest()

    # Remove the audit tool's workspace membership; its source-scanning role stays outside
    # the implementers' repository. The source repository itself is never edited here.
    cargo = base / "Cargo.toml"
    if cargo.exists():
        cargo.write_text("\n".join(line for line in cargo.read_text().splitlines()
                                   if "tools/stdlib-api-audit" not in line) + "\n")
        hashes["Cargo.toml"] = hashlib.sha256(cargo.read_bytes()).hexdigest()
    (base / "AGENTS.md").write_text(
        "# Clean-room implementation workspace\n\n"
        "Implement from docs/specs and this sanitized source snapshot only. Do not seek "
        "another source checkout, reference distribution, old stdlib implementation, agent "
        "transcripts, or upstream Jai implementation. External native library public headers "
        "and official documentation may be used for bindings. Never execute a supplied "
        "reference compiler or other supplied reference binaries.\n\n"
        "Keep stdlib/Extensions intact. Put newly designed stdlib internals in stdlib/internal, "
        "public compatibility facades in module folders, and bootstrap definitions in the "
        "single stdlib/prelude location. Retain exact public compatibility signatures. "
        "Do not infer a private implementation from a public declaration.\n\n"
        "Maintain docs/ for meaningful functionality and update docs/README.md. "
        "Record unresolved behavior in docs/specs questions without inventing answers. "
        "Use the repository's own compiler and tests; no reference binaries. "
        "Do not publish, push, retag, or manage releases from this workspace.\n"
    )
    run("git", "init", "-b", "baseline", cwd=base)
    run("git", "config", "user.name", "Clean-room integration", cwd=base)
    run("git", "config", "user.email", "cleanroom@localhost", cwd=base)
    run("git", "config", "commit.gpgsign", "false", cwd=base)
    run("git", "add", "--all", cwd=base)
    run("git", "commit", "-m", "Prepare independent source baseline", cwd=base)
    for role in dict.fromkeys(args.roles):
        run("git", "worktree", "add", "-b", f"codex/{role}", str(destination / role), cwd=base)

    manifest = {"source_commit": run("git", "rev-parse", "HEAD", cwd=source),
                "sanitized_commit": run("git", "rev-parse", "HEAD", cwd=base),
                "files": hashes, "excluded": excluded}
    (destination / "snapshot.json").write_text(json.dumps(manifest, indent=2) + "\n")

    # Use an isolated home for the harness, with authentication copied without printing it.
    harness = destination / "harness"
    harness.mkdir(mode=0o700)
    auth = Path.home() / ".codex/auth.json"
    if auth.is_file():
        shutil.copyfile(auth, harness / "auth.json")
        os.chmod(harness / "auth.json", 0o600)
    (destination / "tmp").mkdir()
    private_paths = [str(Path.home() / ".codex"),
                     "/private/tmp/jai-cleanroom-compiler", "/private/tmp/jai-cleanroom-stdlib"]
    private_filters = " ".join(f"(subpath {json.dumps(p)})" for p in private_paths)
    source_filter = f"(subpath {json.dumps(str(source))})"
    if inside_source:
        source_filter = (f"(require-all {source_filter} "
                         f"(require-not (subpath {json.dumps(str(destination))})))")
    profile = ("(version 1)\n(allow default)\n"
               f"(deny file-read* {source_filter} {private_filters})\n"
               "(deny file-read-data (require-all (subpath \"/private/tmp\") "
               f"(require-not (subpath {json.dumps(str(destination))}))))\n"
               f"(deny file-read* (literal {json.dumps(str(destination / 'snapshot.json'))}))\n"
               f"(deny file-write* {source_filter})\n")
    (destination / "isolation.sb").write_text(profile)
    print(json.dumps({"workspace": str(destination), "files": len(hashes),
                      "excluded": len(excluded), "sanitized_commit": manifest["sanitized_commit"]}))


if __name__ == "__main__":
    main()
