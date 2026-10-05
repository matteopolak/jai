#!/usr/bin/env python3
"""Flag stdlib code that resembles the reference Jai distribution.

stdlib/ must be written independently of reference/modules/. This checker looks for
three kinds of resemblance:

  runs      3+ consecutive matching significant lines (any reference module)
  procs     token-similar bodies of same-named procedures (same module)
  comments  fuzzy-matching comment lines (same module)

reference/ is gitignored, so the check is skipped (exit 0) when it is not present.
Only the stdlib side of a finding is printed in detail; the reference side is shown
as file:line so reference text never ends up in logs.
"""
import argparse
import difflib
import fnmatch
import os
import re
import subprocess
import sys
from dataclasses import dataclass, field
from pathlib import Path

RUN_LENGTH = 3
PROC_SIMILARITY = 0.85
PROC_MIN_LINES = 7
COMMENT_MIN_CHARS = 15
COMMENT_MIN_WORDS = 4
COMMENT_SIMILARITY = 0.8
CHECKS = ("runs", "procs", "comments")

IDENT = r"[A-Za-z_][A-Za-z0-9_]*"
TOKEN = re.compile(r'"(?:\\.|[^"\\])*"|[A-Za-z_][A-Za-z0-9_]*|0[xXbB][0-9A-Fa-f_]+|\d[\d_]*(?:\.\d+)?|\S')
PROC_DECL = re.compile(rf"^\s*(?:operator\s*\S+?|{IDENT})\s*::\s*(?:inline\s+|no_inline\s+)?\(")
TYPE_DECL = re.compile(rf"^\s*(?:using\s+)?{IDENT}\s*::\s*(?:struct|union|enum|enum_flags)\b")
OTHER_DECL = re.compile(rf"^\s*{IDENT}\s*::\s*(?:#type|#bake_arguments|#bake_constants|#library|#system_library|#foreign_library)\b")
DECLARATION = re.compile(rf"^\s*(?:#as\s+)?(?:using\s+)?{IDENT}(?:\s*,\s*{IDENT})*\s*:")
# Platform switches and assertions: every module that wraps a library has the same ones.
CONDITIONAL = re.compile(r"^\}?\s*(?:else\s*)?#(?:if|ifx|assert)\b|^\}?\s*else\s*\{?$")
DATA = re.compile(r"^[\s\d.,xXa-fA-F_+\-\[\]{}()]*$")
IMPORT = re.compile(r'^\s*(?:{IDENT}\s*::\s*)?#(?:import|load|scope_file|scope_module|scope_export|module_parameters|add_context)\b'.replace("{IDENT}", IDENT))


@dataclass
class Line:
    number: int
    code: str          # source with comments removed, string literals kept
    bare: str          # code with string and character literals blanked (for brace counting)
    comment: str       # text of any comment on this line


@dataclass
class Procedure:
    name: str
    line: int
    tokens: list
    lines: int


@dataclass
class Source:
    path: Path
    label: str
    lines: list
    significant: list = field(default_factory=list)   # (line number, normalized text)
    procedures: list = field(default_factory=list)
    comments: list = field(default_factory=list)      # (line number, normalized comment)


def scan(text):
    """Split Jai source into per-line code and comment text."""
    result = []
    depth = 0           # nested /* */ depth
    heredoc = None      # terminator of an open #string block
    for number, raw in enumerate(text.splitlines(), 1):
        if heredoc is not None:
            if raw.strip() == heredoc:
                heredoc = None
            result.append(Line(number, "", "", ""))
            continue
        code, bare, comment = [], [], []
        i = 0
        while i < len(raw):
            ch = raw[i]
            if depth:
                if raw.startswith("/*", i):
                    depth += 1
                    i += 2
                elif raw.startswith("*/", i):
                    depth -= 1
                    i += 2
                else:
                    comment.append(ch)
                    i += 1
                continue
            if raw.startswith("//", i):
                comment.append(raw[i + 2:])
                break
            if raw.startswith("/*", i):
                depth = 1
                i += 2
                continue
            if ch == '"':
                end = i + 1
                while end < len(raw) and raw[end] != '"':
                    end += 2 if raw[end] == "\\" else 1
                literal = raw[i:end + 1]
                code.append(literal)
                bare.append('""')
                i = end + 1
                continue
            match = re.match(rf"#string\s+({IDENT})\s*$", raw[i:])
            if match:
                heredoc = match.group(1)
                code.append("#string")
                bare.append("#string")
                break
            code.append(ch)
            bare.append(ch)
            i += 1
        result.append(Line(number, "".join(code), "".join(bare), " ".join(comment)))
    return result


def normalize(text):
    return " ".join(text.split())


def is_trivial(text):
    """Lines that match by necessity rather than by copying."""
    if CONDITIONAL.match(text) or DATA.match(text):
        return True
    if IMPORT.match(text) or PROC_DECL.match(text) or "#foreign" in text or TYPE_DECL.match(text) or OTHER_DECL.match(text):
        return True
    tokens = TOKEN.findall(text)
    words = [t for t in tokens if re.match(r"[A-Za-z_\d\"]", t)]
    if len(words) < 2 or len(text) < 12:
        return True
    return text.startswith("case ") and len(words) < 3


def analyze(path, label):
    source = Source(path, label, scan(path.read_text(errors="replace")))
    lines = source.lines
    blocks = []         # per open brace: True when it is a struct/union/enum body
    header = None       # (name, line index) of a procedure header awaiting its "{"
    bodies = []         # (name, header line index, depth outside the body)
    for index, line in enumerate(lines):
        text = normalize(line.code)
        if line.comment:
            comment = normalize_comment(line.comment)
            if len(comment) >= COMMENT_MIN_CHARS:
                source.comments.append((line.number, comment))
        in_type_body = bool(blocks) and blocks[-1]
        opens_type = bool(TYPE_DECL.match(text))
        proc = PROC_DECL.match(text)
        # Field lines (and their defaults) inside type bodies, and declarations outside any
        # procedure (constants, globals, aliases), are API rather than implementation.
        top_level_declaration = not bodies and bool(DECLARATION.match(text))
        if text and not in_type_body and not top_level_declaration and not is_trivial(text):
            source.significant.append((line.number, text))
        if proc and not in_type_body:
            header = (proc.group(0).split("::")[0].strip(), index)
        for ch in line.bare:
            if ch == "{":
                if header is not None:
                    bodies.append((header[0], header[1], len(blocks)))
                    header = None
                blocks.append(opens_type or in_type_body)
                opens_type = False
            elif ch == "}" and blocks:
                blocks.pop()
                if bodies and bodies[-1][2] == len(blocks):
                    name, start, _ = bodies.pop()
                    source.procedures.append(make_procedure(name, lines, start, index))
        # A header that ends without a body (#foreign, #type, forward declarations).
        if header is not None and line.bare.rstrip().endswith(";"):
            header = None
    return source


def make_procedure(name, lines, start, end):
    body = " ".join(lines[i].code for i in range(start + 1, end + 1))
    count = sum(1 for i in range(start + 1, end) if lines[i].code.strip())
    return Procedure(name, lines[start].number, TOKEN.findall(body), count)


def normalize_comment(text):
    return " ".join(re.sub(r"[^\w\s]", " ", text.lower()).split())


def module_name(relative):
    first = relative.parts[0]
    return first[:-4] if first.endswith(".jai") else first


def collect(root, label_root):
    files = {}
    for path in sorted(root.rglob("*.jai")):
        relative = path.relative_to(root)
        files[relative] = analyze(path, f"{label_root}/{relative.as_posix()}")
    return files


@dataclass
class Rule:
    pattern: str
    checks: set
    procs: set
    reason: str

    def covers(self, label, check, proc=None):
        if not fnmatch.fnmatch(label, self.pattern):
            return False
        if "all" in self.checks or check in self.checks:
            return True
        return check == "procs" and proc in self.procs


def load_allowlist(path):
    rules = []
    if not path.exists():
        return rules
    for number, raw in enumerate(path.read_text().splitlines(), 1):
        text = raw.strip()
        if not text or text.startswith("#"):
            continue
        parts = text.split(None, 2)
        if len(parts) < 3:
            raise SystemExit(f"{path}:{number}: expected '<glob> <checks> <reason>'")
        pattern, spec, reason = parts
        checks, procs = set(), set()
        for item in spec.split(","):
            if item.startswith("proc:"):
                procs.add(item[5:])
            elif item in CHECKS or item == "all":
                checks.add(item)
            else:
                raise SystemExit(f"{path}:{number}: unknown check '{item}'")
        rules.append(Rule(pattern, checks, procs, reason))
    return rules


def allowed(rules, label, check, proc=None):
    return any(rule.covers(label, check, proc) for rule in rules)


def find_runs(source, index):
    """Maximal runs of RUN_LENGTH+ significant lines that also occur consecutively in reference."""
    findings = []
    texts = [text for _, text in source.significant]
    i = 0
    while i + RUN_LENGTH <= len(texts):
        hits = index.get(tuple(texts[i:i + RUN_LENGTH]))
        if not hits:
            i += 1
            continue
        best_length, best_hit = 0, hits[0]
        for ref, position in hits:
            length = RUN_LENGTH
            while i + length < len(texts) and position + length < len(ref.significant) and ref.significant[position + length][1] == texts[i + length]:
                length += 1
            if length > best_length:
                best_length, best_hit = length, (ref, position)
        ref, position = best_hit
        start, end = source.significant[i][0], source.significant[i + best_length - 1][0]
        findings.append((start, f"{source.label}:{start}-{end}: {best_length} consecutive lines match {ref.label}:{ref.significant[position][0]}"))
        i += best_length
    return findings


def find_similar_procedures(source, references, rules):
    findings = []
    for proc in source.procedures:
        if proc.lines < PROC_MIN_LINES or allowed(rules, source.label, "procs", proc.name):
            continue
        best = (0.0, None)
        for ref in references:
            for other in ref.procedures:
                if other.name != proc.name:
                    continue
                matcher = difflib.SequenceMatcher(None, proc.tokens, other.tokens, autojunk=False)
                if matcher.real_quick_ratio() < PROC_SIMILARITY or matcher.quick_ratio() < PROC_SIMILARITY:
                    continue
                ratio = matcher.ratio()
                if ratio > best[0]:
                    best = (ratio, (ref, other))
        if best[0] >= PROC_SIMILARITY:
            ref, other = best[1]
            findings.append((proc.line, f"{source.label}:{proc.line}: procedure '{proc.name}' ({proc.lines} lines) is {best[0]:.2f} token-similar to {ref.label}:{other.line}"))
    return findings


def comment_blocks(source):
    """Merge adjacent comment lines: a reference sentence often wraps across lines."""
    blocks = []
    for number, text in source.comments:
        words = text.split()
        if blocks and blocks[-1][2] == number - 1:
            blocks[-1][1].extend((word, number) for word in words)
            blocks[-1][2] = number
        else:
            blocks.append([source, [(word, number) for word in words], number])
    return [(ref, entries, {word for word, _ in entries}) for ref, entries, _ in blocks]


def find_similar_comments(source, references):
    """Comment lines whose words appear, mostly in order, in one reference comment."""
    findings = []
    blocks = [block for ref in references for block in comment_blocks(ref)]
    for number, text in source.comments:
        words = text.split()
        if len(words) < COMMENT_MIN_WORDS:
            continue
        unique = set(words)
        best = (0.0, None)
        for ref, entries, vocabulary in blocks:
            if len(unique & vocabulary) < COMMENT_SIMILARITY * len(unique):
                continue
            other = [word for word, _ in entries]
            matcher = difflib.SequenceMatcher(None, words, other, autojunk=False)
            matched = [m for m in matcher.get_matching_blocks() if m.size]
            coverage = sum(m.size for m in matched) / len(words)
            if coverage > best[0]:
                best = (coverage, (ref, entries[matched[0].b][1]))
        if best[0] >= COMMENT_SIMILARITY:
            ref, ref_number = best[1]
            findings.append((number, f"{source.label}:{number}: comment {best[0]:.2f}-similar to {ref.label}:{ref_number}: //{text[:120]}"))
    return findings


def build_run_index(references):
    index = {}
    for ref in references:
        texts = [text for _, text in ref.significant]
        for position in range(len(texts) - RUN_LENGTH + 1):
            index.setdefault(tuple(texts[position:position + RUN_LENGTH]), []).append((ref, position))
    return index


def find_reference(repository, explicit):
    if explicit:
        return Path(explicit) if (Path(explicit) / "modules").is_dir() else None
    candidates = []
    if os.environ.get("JAI_REFERENCE"):
        candidates.append(Path(os.environ["JAI_REFERENCE"]))
    candidates.append(repository / "reference")
    try:
        common = subprocess.check_output(["git", "-C", str(repository), "rev-parse", "--path-format=absolute", "--git-common-dir"], text=True, stderr=subprocess.DEVNULL).strip()
        candidates.append(Path(common).parent / "reference")
    except (OSError, subprocess.CalledProcessError):
        pass
    for candidate in candidates:
        if (candidate / "modules").is_dir():
            return candidate
    return None


def check(stdlib, reference, rules, selected=None, checks=CHECKS):
    """Return sorted (label, line, message) findings for stdlib against reference/modules."""
    refs = collect(reference / "modules", "reference/modules")
    by_module = {}
    for relative, ref in refs.items():
        by_module.setdefault(module_name(relative), []).append(ref)
    run_index = build_run_index(refs.values()) if "runs" in checks else {}
    findings = []
    for path in sorted(stdlib.rglob("*.jai")):
        relative = path.relative_to(stdlib)
        label = f"stdlib/{relative.as_posix()}"
        if selected and not any(label == s or label.startswith(s.rstrip("/") + "/") for s in selected):
            continue
        source = analyze(path, label)
        same_module = by_module.get(module_name(relative), [])
        found = []
        if "runs" in checks and not allowed(rules, label, "runs"):
            found += find_runs(source, run_index)
        if "procs" in checks:
            found += find_similar_procedures(source, same_module, rules)
        if "comments" in checks and not allowed(rules, label, "comments"):
            found += find_similar_comments(source, same_module)
        findings += [(label, line, message) for line, message in found]
    return sorted(findings, key=lambda f: (f[0], f[1]))


def main(argv=None):
    repository = Path(__file__).resolve().parent.parent
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("paths", nargs="*", help="limit to these stdlib paths (e.g. stdlib/Basic or stdlib/Sort.jai)")
    parser.add_argument("--reference", help="reference distribution root (default: reference/ in this or the main checkout, or $JAI_REFERENCE)")
    parser.add_argument("--stdlib", default=str(repository / "stdlib"))
    parser.add_argument("--allow", default=str(repository / "tools/reference_resemblance_allow.txt"))
    parser.add_argument("--only", choices=CHECKS, action="append", help="run only this check (repeatable)")
    args = parser.parse_args(argv)

    reference = find_reference(repository, args.reference)
    if reference is None:
        print("check_reference_resemblance: reference/ not found; skipping (it is gitignored and only exists locally)")
        return 0
    rules = load_allowlist(Path(args.allow))
    selected = [p.rstrip("/") for p in args.paths]
    findings = check(Path(args.stdlib), reference, rules, selected, tuple(args.only or CHECKS))
    for _, _, message in findings:
        print(message)
    if findings:
        files = len({label for label, _, _ in findings})
        print(f"\n{len(findings)} finding(s) in {files} file(s). Rewrite the code independently, or add a justified entry to {Path(args.allow).name}.")
        return 1
    print("check_reference_resemblance: no resemblance found")
    return 0


if __name__ == "__main__":
    sys.exit(main())
