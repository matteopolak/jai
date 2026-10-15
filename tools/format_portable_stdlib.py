#!/usr/bin/env python3
"""Format this worker's explicit Jai scope with source-built repository jaifmt.

Extensions, peer-owned modules and public/legacy tests are never input paths.
Both jaifmt and jailint use repository configuration.
"""
import argparse
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
RESERVED = {
    "Extensions", "Compiler", "Jai_Lexer", "Code_Visit", "Program_Print", "Math",
    "Sloppy_Math", "Float16", "Color_Interpolation", "GetRect", "GetRect_LeftHanded",
    "Android", "Curl", "d3d11", "d3d12", "d3d_compiler", "dxc_compiler", "dxgi",
    "freetype", "GL", "ImGui", "iOS", "Linux", "lz4", "macOS", "meshoptimizer",
    "Metal", "MojoShader", "nvidia_aftermath", "nvtt", "Objective_C", "POSIX",
    "rpmalloc", "SDL", "stb_image", "stb_image_resize", "stb_image_write",
    "stb_vorbis", "telemetry3", "Vulkan", "Windows", "X11", "xxHash",
    "Window_Creation", "Window_Type", "Input", "Keymap", "Gamepad", "Simp", "Srgb", "Clipboard", "File",
    "Sound_Player", "Bindings_Generator", "Generate_C_Header", "Check", "Codex",
    "Debug", "Debug_Info", "Print_Vars", "Iprof", "Performance_Report", "Rewrite", "Hash",
}
RESERVED_FOLDED = {name.casefold() for name in RESERVED}
RESERVED_INTERNAL = {"bindings", "numerics", "compiler-api", "jai-lexer", "code-visit", "program-print",
                     "window", "rendering", "input", "gamepad", "clipboard", "file", "audio", "profiling"}


def owned_paths():
    paths = []
    for path in (ROOT / "stdlib").rglob("*.jai"):
        relative = path.relative_to(ROOT / "stdlib")
        if relative.parts[0].casefold() in RESERVED_FOLDED:
            continue
        if relative.parts[0] == "internal" and relative.parts[1] in RESERVED_INTERNAL:
            continue
        if relative == Path("internal/files/file.jai"):
            continue  # File backend completion is now platform-io ownership.
        if relative == Path("internal/hash/module.jai"):
            continue  # Scalar Hash completion/shared facade are foundations ownership.
        paths.append(path)
    for path in (ROOT / "tests/portable-stdlib").rglob("*.jai"):
        relative = path.relative_to(ROOT / "tests/portable-stdlib")
        if relative.parts[0] == "performance-report" or relative.name in {
            "sound-samples.jai", "sound-channels.jai", "sound-magic.jai"
        }:
            continue
        paths.append(path)
    return sorted(paths)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--lint", action="store_true", help="run source-built jailint -D warnings on the same owned scope")
    args = parser.parse_args()
    binary = ROOT / "target/jaifmt"
    command = [str(binary), "--config", str(ROOT / "jaifmt.toml")]
    if args.check:
        command.append("--check")
    paths = owned_paths()
    if args.lint:
        library = ROOT / "target/portable-integration-stdlib"
        configured_test = ROOT / "tests/portable-stdlib/time-configured/main.jai"
        checked_paths = []
        for path in paths:
            if path == configured_test:
                continue  # Checked below against its required NEW foundation composition.
            if path.is_relative_to(ROOT / "stdlib"):
                candidate = library / path.relative_to(ROOT / "stdlib")
                if not candidate.is_file() or candidate.read_bytes() != path.read_bytes():
                    raise RuntimeError(f"restage current owned source before strict lint: {path}")
                checked_paths.append(candidate)
            else:
                checked_paths.append(path)
        env = dict(os.environ, JAIC_STDLIB=str(library))
        subprocess.run([str(ROOT / "target/compiler/debug/jailint"), "-D", "warnings",
                        *[str(path) for path in checked_paths]], cwd=ROOT, env=env, check=True)
        foundation_library = ROOT / "target/portable-time-foundation/stdlib"
        for filename in ["apollo.jai", "time-errors.jai", "clock-calendar.jai",
                         "filetime.jai", "windows-clock.jai", "elapsed-time.jai"]:
            if (foundation_library / "internal/basic" / filename).read_bytes() != (ROOT / "stdlib/internal/basic" / filename).read_bytes():
                raise RuntimeError("regenerate the NEW foundation time composition before lint")
        for filename in ["counter.jai", "filetime.jai"]:
            if (foundation_library / "internal/time" / filename).read_bytes() != (ROOT / "stdlib/internal/time" / filename).read_bytes():
                raise RuntimeError("regenerate the NEW foundation time kernels before lint")
        foundation_env = dict(os.environ, JAIC_STDLIB=str(foundation_library))
        subprocess.run([str(ROOT / "target/compiler/debug/jailint"), "-D", "warnings",
                        str(foundation_library / "Basic/module.jai"),
                        str(foundation_library / "internal/basic/module.jai"), str(configured_test)],
                       cwd=ROOT, env=foundation_env, check=True)
        print(f"Source-built jailint checked {len(paths)} owned Jai files")
        return
    subprocess.run(command + [str(path) for path in paths], cwd=ROOT, check=True)
    print(f"Source-built jaifmt {'checked' if args.check else 'formatted'} {len(paths)} owned Jai files")


if __name__ == "__main__":
    main()
