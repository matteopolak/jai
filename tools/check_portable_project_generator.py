#!/usr/bin/env python3
"""Reviewed singleton collection and actual compiler-driven VS artifact workflow."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import xml.etree.ElementTree as ET
from check_portable_default_metaprogram import compose, ROOT

OUTPUT = ROOT / "target/portable-project-generator"
NS = {"m": "http://schemas.microsoft.com/developer/msbuild/2003"}


def main():
    OUTPUT.mkdir(parents=True, exist_ok=True)
    library = compose()
    shutil.copytree(ROOT / "stdlib/Project_Generator", library / "Project_Generator", dirs_exist_ok=True)
    shutil.copytree(ROOT / "stdlib/internal/build", library / "internal/build", dirs_exist_ok=True)
    shutil.copyfile(ROOT / "stdlib/internal/crypto/sha.jai", library / "internal/crypto/sha.jai")
    env = dict(os.environ, JAIC_STDLIB=str(library))
    binaries = Path(os.environ["CARGO_TARGET_DIR"]) / "debug"
    compiler = str(binaries / "jaic")
    case = ROOT / "tests/portable-stdlib/project-generator/collection.jai"

    def run(command):
        result = subprocess.run(command, env=env, cwd=OUTPUT, capture_output=True, text=True, timeout=90)
        if result.returncode or result.stderr:
            raise RuntimeError(f"{command!r}\n{result.stdout}{result.stderr}")
        return result.stdout

    assert run([compiler, "-interp", str(case)]) == "ok\n"
    for optimization in ["-O0", "-O2"]:
        executable = OUTPUT / ("collection" + optimization)
        run([compiler, str(case), optimization, "-exe", str(executable)])
        assert run([str(executable)]) == "ok\n"

    source = OUTPUT / "app.jai"
    source.write_text('using #import "Basic"; main :: () { print("built app\\n"); }\n')
    driver = OUTPUT / "build.jai"
    driver.write_text(
        'P :: #import "Project_Generator"; C :: #import "Compiler"; using #import "Basic";\n'
        '#run,stallable {\n'
        'args := C.get_toplevel_command_line(); defer array_free(args);\n'
        'options := C.get_build_options();\n'
        'if args.count > 0 && args[0] == "optimized" C.set_optimization(*options, .VERY_OPTIMIZED);\n'
        'else C.set_optimization(*options, .DEBUG);\n'
        'C.set_build_options(options);\n'
        'P.Project_Generator.add_file("dir/sub/a & b.jai", false);\n'
        'P.Project_Generator.add_file("c:/external/../other.jai", false);\n'
        f'P.Project_Generator.build({json.dumps(str(source))});\n'
        'assert(P.Project_Generator.project_name == "app");\n'
        'assert(P.Project_Generator.debug_command == "app.exe");\n'
        'assert(P.Project_Generator.project_files.count == 0);\n'
        'P.Project_Generator.reset(); assert(P.Project_Generator.project_name == "app");\n}\n')
    for optimization in ["-O0", "-O2"]:
        run([compiler, str(driver), optimization, "-", "optimized" if optimization == "-O2" else "debug"])
        assert run([str(OUTPUT / "app")]) == "built app\n"
        verify_artifacts("app", default=True)
    paths = [OUTPUT / ("app" + suffix) for suffix in [".sln", ".vcxproj", ".vcxproj.filters", ".vcxproj.user"]]
    for path in paths:
        os.utime(path, ns=(1_500_000_000_000_000_000, 1_500_000_000_000_000_000))
    before = [(path.read_bytes(), path.stat().st_mtime_ns) for path in paths]
    run([compiler, str(driver)])
    assert before == [(path.read_bytes(), path.stat().st_mtime_ns) for path in paths]

    custom = OUTPUT / "custom.jai"
    custom.write_text(
        'P :: #import "Project_Generator"; using #import "Basic";\n#run,stallable {\n'
        'P.Project_Generator.project_name = "custom & project";\n'
        'P.Project_Generator.output_directory = "ignored/missing";\n'
        'P.Project_Generator.build_cmd = "C:/compiler directory/jaic.exe";\n'
        'P.Project_Generator.build_args = "source.jai -o";\n'
        'P.Project_Generator.debug_command = "custom.exe";\n'
        'P.Project_Generator.working_directory = "relative/work";\n'
        'P.Project_Generator.run_arguments = "quote \\\" & <value>";\n'
        'P.Project_Generator.add_file("dir/sub/a & b.jai", false);\n'
        'P.Project_Generator.add_file("c:/external/../other.jai", false);\n'
        f'P.Project_Generator.build({json.dumps(str(source))});\n'
        'assert(P.Project_Generator.project_name == "custom & project");\n}\n')
    run([compiler, str(custom)])
    verify_artifacts("custom & project", default=False)
    assert not (OUTPUT / "ignored").exists()
    broken = OUTPUT / "broken.jai"
    broken.write_text('P :: #import "Project_Generator";\n#run,stallable {\n'
                      'P.Project_Generator.project_name = "uncreated/target";\n'
                      f'P.Project_Generator.build({json.dumps(str(source))});\n}}\n')
    failure = subprocess.run([compiler, str(broken)], env=env, cwd=OUTPUT,
                             capture_output=True, text=True, timeout=90)
    if failure.returncode == 0 or "output file could not be written" not in failure.stdout + failure.stderr:
        raise RuntimeError(f"Missing write failure: {failure.stdout}{failure.stderr}")
    for generated in [driver, custom]:
        for mode in [[], ["--check"]]:
            subprocess.run([str(ROOT / "target/jaifmt"), "--config", str(ROOT / "jaifmt.toml"),
                            *mode, str(generated)], check=True)
    print("Project_Generator behavior passes collection interpreter/native O0/O2, actual target O0/O2/four artifacts, XML/filters/defaults/persistence/unchanged mtimes and real write failure; strict lint follows", flush=True)
    subprocess.run([str(binaries / "jailint"), "-D", "warnings",
                    str(library / "Project_Generator"), str(case), str(driver), str(custom),
                    *[str(library / "internal/build" / file) for file in
                      ["project-collection.jai", "project-documents.jai"]]], env=env, cwd=OUTPUT, check=True)
    print("Project_Generator strict lint passes")


def verify_artifacts(name, default):
    solution = (OUTPUT / (name + ".sln")).read_text()
    assert "Release|x64" in solution and f'"{name}.vcxproj"' in solution
    project = ET.parse(OUTPUT / (name + ".vcxproj"))
    filters = ET.parse(OUTPUT / (name + ".vcxproj.filters"))
    user = ET.parse(OUTPUT / (name + ".vcxproj.user"))
    files = [node.attrib["Include"] for node in project.findall(".//m:ItemGroup/*", NS)
             if node.tag.endswith("None") or node.tag.endswith("Natvis")]
    assert files == sorted(files)
    assert "app.jai" in files and "dir\\sub\\a & b.jai" in files
    assert "C:\\external\\..\\other.jai" in files
    assert any(path.endswith("jai.natvis") for path in files)
    filtered = {node.attrib["Include"]: node.find("m:Filter", NS) for node in
                filters.findall(".//m:None", NS)}
    assert filtered["dir\\sub\\a & b.jai"].text == "dir\\sub"
    assert filtered["C:\\external\\..\\other.jai"] is None
    folders = [node.attrib["Include"] for node in filters.findall("./m:ItemGroup/m:Filter", NS)]
    assert "dir" in folders and "dir\\sub" in folders and not any(".." in item for item in folders)
    command = project.find(".//m:NMakeBuildCommandLine", NS).text
    assert command
    if default:
        assert user.find(".//m:LocalDebuggerCommand", NS).text == "app.exe"
    else:
        assert command == '"C:/compiler directory/jaic.exe" source.jai -o'
        assert user.find(".//m:LocalDebuggerCommandArguments", NS).text == 'quote " & <value>'
        assert user.find(".//m:LocalDebuggerWorkingDirectory", NS).text == "$(SolutionDir)relative\\work"


if __name__ == "__main__":
    main()
