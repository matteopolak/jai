#!/usr/bin/env python3
"""Conservative owned API inventory from reviewed declarations and new own source.

Presence alone never earns complete: only explicitly implemented module batches
are credited. Present names in partial modules remain partial pending finer audit.
Conditions/overloads are separate rows; record members are not extra API rows,
except reviewed nested procedures. This is implementation bookkeeping, not tests.
"""
import datetime
import json
from pathlib import Path
import re
import subprocess
from portable_api_spec import parse_spec
from generate_portable_missing_surface import MODULES

ROOT = Path(__file__).resolve().parents[1]
EXCLUDED = {"basic", "string", "hash", "file-utilities", "file", "sound-player", "preload",
            "ico-file", "icon", "windows-resources", "subtitles", "simple-package", "executable-formats"}
COMPLETE = set("adpcm atomics base64 bit-array bit-operations bucket-array command-line crc example-plugin introsort machine-x64 macos-bundler md5 memory meow-hash overwriting-allocator pcg pl-mpeg-public-tables pool project-generator protocol-for-memory-visualization radixsort random relative-pointers remap-context simd soa sort text-file-handler treemap unicode wav-file windows-registry windows-utf8 xar zip-file-directory".split())
TIME_NAMES = set("Apollo_Time Calendar_Time Calendar_Time_Type Time_Zone to_apollo seconds_since_init timespec_to_apollo to_timespec current_time_consensus current_time_monotonic to_calendar calendar_to_apollo filetime_to_apollo to_filetime calendar_to_string calendar_to_iso_string ConvertToApollo to_seconds to_milliseconds to_microseconds to_nanoseconds compare_apollo_times to_float64_seconds".split())
SPECIAL_PATHS = {"pl-mpeg-public-tables": "PL_MPEG"}
KNOWN = {slug: names for _, _, slug, names, _ in MODULES}


def source_text(path, seen=None):
    seen = set() if seen is None else seen
    path = path.resolve()
    if path in seen or not path.is_relative_to(ROOT / "stdlib") or not path.is_file():
        return ""
    seen.add(path)
    text = path.read_text()
    for loaded in re.findall(r'#load\s+"([^"]+\.jai)"', text):
        text += '\n' + source_text(path.parent / loaded, seen)
    return text


def operator_text(facade):
    if not facade.is_file():
        return ""
    text = source_text(facade)
    for imported in re.findall(r'#import\s+"(internal/[^"]+)"', text):
        path = ROOT / "stdlib" / imported
        candidate = path.with_suffix('.jai')
        if not candidate.is_file():
            candidate = path / 'module.jai'
        text += '\n' + source_text(candidate)
    return re.sub(r'\s+', '', text)


def main():
    head = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT, text=True).strip()
    notes = {}
    for line in (ROOT / "docs/portable-stdlib-ledger.md").read_text().splitlines():
        match = re.match(r'\| \[([^]]+)\]\([^)]*\) \| (.*) \|', line)
        if match and not match[2].startswith("Reserved") and match[1] not in EXCLUDED:
            notes[match[1]] = match[2]
    notes["basic"] = "Only portable-owned time/calendar APIs; remaining Basic belongs to foundations."
    counts = {"complete": 0, "partial": 0, "missing": 0}
    rows = []
    complete_names = {}
    counts_by_state = {state: {key: 0 for key in counts} for state in ['committed', 'draft']}
    modules = []
    socket_native = {(r['name'], r['condition']): r['status'] for r in
                     json.loads((ROOT / 'docs/socket-native-ledger.json').read_text())}
    transferred_android = set(json.loads((ROOT / 'docs/status/portable-scope-transfers.json').read_text())['Android/Toolchain']['excluded_names'])
    for slug, note in sorted(notes.items()):
        spec_path = ROOT / f"docs/specs/stdlib/modules/{slug}.md"
        spec_text = spec_path.read_text()
        spec = parse_spec(spec_text)
        name = SPECIAL_PATHS.get(slug, spec_text.splitlines()[0].removeprefix("# ").strip())
        facade = ROOT / "stdlib" / name / "module.jai"
        text = source_text(facade)
        module_counts = {key: 0 for key in counts}
        seen = set()
        declarations = [(d.name, d.code, d.condition) for d in spec.declarations]
        for shape in spec.shapes:
            for match in re.finditer(r'^\s*(\w+)\s*::\s*(\([^\n]+)', shape.code, re.MULTILINE):
                declarations.append((f"{shape.name}.{match[1]}", f"{match[1]} :: {match[2]}", shape.condition))
        for api, declaration, condition in declarations:
            if slug == 'android-toolchain' and api in transferred_android:
                continue
            if slug == "basic" and api not in TIME_NAMES:
                continue
            if slug in {"runtime-support", "runtime-support-crash-handler", "process", "system", "thread"} and "OS == .WINDOWS" in condition:
                continue
            identity = (api, declaration, condition)
            if identity in seen:
                continue
            seen.add(identity)
            leaf = api.rsplit('.', 1)[-1]
            present = bool(text) and re.search(r'\b' + re.escape(leaf) + r'\s*(?:::|:=|:)', text) is not None
            if leaf.startswith('operator'):
                present = re.sub(r'\s+', '', leaf) + '::' in operator_text(facade)
            if not present and facade.is_file():
                present = any(leaf in re.findall(r'\w+', group) for group in
                              re.findall(r'using,only\(([^)]+)\)', text))
            if slug in KNOWN:
                status = "complete" if api in KNOWN[slug] else "missing"
                if slug == "default-metaprogram" and api == "build":
                    status = "partial"
                if slug == "android-toolchain" and api == "android_generate_signing_key_direct":
                    status = "partial"  # Real POSIX backend; Windows explicitly unsupported.
            elif not present:
                status = "missing"
            elif slug in COMPLETE or slug == "basic":
                status = "complete"
            else:
                status = "partial"
            if slug == 'socket':
                native_status = socket_native.get((api, condition.replace('else branch', 'OS != .WINDOWS')), '')
                if native_status.startswith(('unresolved shape', 'reviewed shape candidate')):
                    status = 'missing'
                elif present and native_status.startswith(('native declaration;', 'authored native field',
                        'authored native TCP', 'authored shared TCP', 'authored native ancillary',
                        'authored native scope', 'native shape supplemented', 'incomplete reviewed literal resolved')):
                    status = 'complete'
            draft = False  # Runtime discard/source connection committed as ca8570d.
            row = {"module": name, "name": api, "declaration": declaration, "condition": condition,
                   "status": status, "source_state": "draft" if draft else "committed"}
            if status != "complete" or draft:
                rows.append(row)
            if status == 'complete':
                complete_names.setdefault(name, []).append({'name': api, 'condition': condition})
            counts[status] += 1
            counts_by_state[row['source_state']][status] += 1
            module_counts[status] += 1
        modules.append({"module": name, "spec": str(spec_path.relative_to(ROOT)), "counts": module_counts,
                        "status_basis": note})
    report = {
        "worker": "portable-stdlib", "generated_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
        "head_at_inventory": head,
        "count_unit": "unique reviewed declaration/overload/condition rows plus reviewed nested procedures",
        "policy": "Conservative source implementation classification, not conformance/test totals. Only explicitly completed module/API batches earn complete. Present declarations in partial modules remain partial until finer per-API audit; they are not all missing bodies. Native/platform/tool verification gaps remain separate. Complete supported-source does not claim every platform execution.",
        "scope_exclusions": "Ownership ledger reserved modules; Basic except time/calendar; String/Hash/File_Utilities/File; audio/tooling/data transfers; executable_formats transferred to object-formats2026-10-15 16:14; compiler bootstrap/Preload. Windows-specific Runtime/Process/System/Thread branches belong to platform-io. Extensions unchanged.",
        "counts": counts, "remaining": rows, "modules": modules,
        "counts_by_source_state": counts_by_state,
        "complete_names_by_module": complete_names,
        "total_reviewed_owned_api_rows": sum(counts.values()),
        "complete_source_percentage": round(100 * counts['complete'] / sum(counts.values()), 2),
        "private_handoffs": [{"name": "internal/runtime/android-output.discard_pending_output",
                              "source_state": "committed ca8570d", "status": "host interpreter/native O0/O2 and strict lint pass; binding patch/native adoption pending"}],
        "verification_gaps": [
            "Historical stable combined coordinator Mac baseline822 passed/7 failed. Latest filtered original-corpus compile-only run316 passed/84 failed on frozen older snapshot (execution run304/96); neither is a current full integration rerun by this worker.",
            "Default_Metaprogram real Check-enabled builds/configuration, plugins, failures and full owned strict lint pass; unsupported compiler backend/debugger and target argument readback remain separate dependencies.",
            "Metaprogram_Plugins parser passes; proper typed-placeholder deferred initializer staged, awaiting general compiler checkpoint. Rejected direct undeclared-call draft is not required semantics.",
            "Direct signing-key POSIX crypto CLI workflow and canonical hex formatter aliases pass interpreter/native O0/O2 and strict lint; Windows key backend/JKS remain pending, host Java absent.",
            "Private crash helper relocated-package native Mac ON/OFF tests pass after install-name fix0504879; production package inclusion/architecture/minimum deployment and Linux native gate pending.",
            "Selected-workspace Build_Options.compile_time_command_line readback fails in child #run. Original top-level getter scope expectation was unspecified; corrected reproducer uses get_build_options().",
            "Project_Generator real target/artifact/mtime tests pass; jailint SandboxHost lacks _NSGetExecutablePath. Natvis resource and actual VS execution pending.",
            "Active Mac addrinfo and hostent/netent/protoent/servent layouts and real resolver/database SDK calls pass interpreter/native ARM64/x64 O0/O2. CMSG/native global storage tests pass; whole binding lint remains blocked by general field-array-element type query.",
            "Android private discard kernel passes host tests; binding owner has not yet adopted hook, Android target/device and exact fine flush policy remain unverified.",
            "Native Linux/Windows/Android and full corpus/release verification remain coordinator/platform gates, not implied by source checking."
        ],
        "candidate_disjoint_transfer_batches": [
            {"batch": "Android project/config model, manifests and host packaging/NDK/helper orchestration",
             "status": "ALREADY TRANSFERRED to generator-names; exact excluded API names in portable-scope-transfers.json. Shared signing key types remain portable-owned and committed6f20c37."},
            {"batch": "Android APK v2/JKS/signing cryptography",
             "estimate": "large: 1-3 worker days plus SDK/crypto validation",
             "boundaries": "new private crypto/android-signing implementation; reuse committed ZIP/APK/ASN1/SHA; no duplicate parsers or models",
             "dependencies": "review SHA512/fixed32 digest result, parser cursor/framing, canonical EVP type provider and key encoding/ownership"},
            {"batch": "executable_formats entire scope", "status": "ALREADY TRANSFERRED to object-formats; excluded from this denominator, not completion credit"}
        ]
    }
    target = ROOT / "docs/status/implementation-remaining.json"
    target.write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps({"counts": counts, "modules": len(modules), "remaining_rows": len(rows)}))


if __name__ == "__main__":
    main()
