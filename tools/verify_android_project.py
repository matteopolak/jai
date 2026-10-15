"""Source-built host Android orchestration checks; no SDK/device success simulation."""

import json
import os
from pathlib import Path
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
FIXTURE_ROOT = ROOT / "tests/android-project"


def main():
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    output = target / "android-project-verification"
    output.mkdir(parents=True, exist_ok=True)
    previous_results = output / "results.json"
    if previous_results.exists():
        previous = json.loads(previous_results.read_text())
        if any(result["exit_code"] for result in previous):
            shutil.copyfile(previous_results, output / "host-actions-cross-target-failures.json")
    compiler = str(target / "debug/jaic")
    lint = str(target / "debug/jailint")
    formatter = str(output / "jaifmt")
    fixture_tools = FIXTURE_ROOT / "generated-host-tools"
    ndk = fixture_tools / "ndk"
    prebuilt = ndk / "toolchains/llvm/prebuilt/darwin-x86_64"
    (prebuilt / "bin").mkdir(parents=True, exist_ok=True)
    (prebuilt / "sysroot/usr/include/aarch64-linux-android").mkdir(parents=True, exist_ok=True)
    (prebuilt / "sysroot/usr/lib/aarch64-linux-android").mkdir(parents=True, exist_ok=True)
    (prebuilt / "lib64").mkdir(parents=True, exist_ok=True)
    (prebuilt / "lib64/libclang.dylib").write_text("path-discovery fixture, not a library")
    (prebuilt / "sysroot/usr/lib/aarch64-linux-android/libc++_shared.so").write_text("controlled library payload")
    command_log = fixture_tools / "commands.jsonl"
    command_log.write_text("")
    script = (
        f"#!{sys.executable}\nimport json,sys\n"
        f"with open({str(command_log)!r}, 'a') as f: f.write(json.dumps(sys.argv)+'\\n')\n"
        "if len(sys.argv)>1 and sys.argv[1]=='start-server': raise SystemExit(0)\n"
        "if 'install' in sys.argv and sys.argv[-1].endswith('mismatch.apk'):\n print('INSTALL_FAILED_UPDATE_INCOMPATIBLE'); raise SystemExit(42)\n"
        "print('controlled host command failure')\nraise SystemExit(42)\n"
    )
    fake_clang = prebuilt / "bin/clang"
    fake_adb = fixture_tools / "adb-command-fixture"
    for executable in (fake_clang, fake_adb):
        executable.write_text(script)
        executable.chmod(0o755)
    env = dict(os.environ, CARGO_BUILD_JOBS="2", JAIC_STDLIB=str(ROOT / "stdlib"),
               JAIC=compiler, ANDROID_NDK_HOME=str(ndk))
    results = []

    def run(name, kind, command, cwd=ROOT):
        result = subprocess.run(command, cwd=cwd, env=env, capture_output=True, text=True, timeout=180)
        (output / f"{name}.log").write_text(result.stdout + result.stderr)
        results.append(dict(name=name, kind=kind, command=command, exit_code=result.returncode))
        (output / "results.json").write_text(json.dumps(results, indent=2) + "\n")
        print(f"{name}: exit {result.returncode}", flush=True)
        if result.returncode:
            print(result.stdout + result.stderr, flush=True)
        return result.returncode == 0

    if not run("build-tools", "build", ["cargo", "build", "-p", "jaic-cli", "-p", "jailint"]):
        return 1
    if not run("build-formatter", "build", [compiler, "jaifmt/main.jai", "-O2", "-exe", formatter]):
        return 1
    public_names = ["module", "project-types", "project-api", "manifest-types", "manifest-api",
                    "sdk-api", "device-api", "helper-api", "gradle-api"]
    private_names = ["android-project", "android-manifest", "android-manifest-writer",
                     "android-manifest-inflate", "android-sdk", "android-device", "android-helper", "android-gradle"]
    helpers = [f"stdlib/Android/Toolchain/{name}.jai" for name in public_names]
    helpers += [f"stdlib/internal/android-toolchain/{name}.jai" for name in private_names]
    stems = ["project", "parameters", "manifest", "sdk", "device", "helper", "gradle"]
    sources = [f"tests/android-project/{stem}.jai" for stem in stems]
    run("format", "format", [formatter, "--check", *helpers, *sources, "tests/android-project/helper-source.jai", "tests/android-project/fixtures/embedded.jai"])
    for stem, source in zip(stems, sources):
        args = [str(ndk)] if stem == "sdk" else [str(fake_adb)] if stem == "device" else []
        run(f"{stem}-interp", "host-execution", [compiler, source, "-interp", "--", *args])
        for optimization in ("O0", "O2"):
            binary = str(output / f"{stem}-{optimization}")
            if run(f"{stem}-{optimization}-build", "host-native-build", [compiler, source, f"-{optimization}", "-exe", binary]):
                run(f"{stem}-{optimization}-run", "host-execution", [binary, *args], cwd=FIXTURE_ROOT)
        for system, cpu in (("macos", "arm64"), ("macos", "x64"), ("linux", "x64"), ("windows", "x64"), ("windows", "arm64")):
            flags = ["-os", system, "-cpu", cpu]
            check_source = "tests/android-project/helper-source.jai" if stem == "helper" else source
            run(f"{stem}-{system}-{cpu}-check", "source-only", [compiler, check_source, "-check", *flags])
            context_sources = [*helpers, check_source]
            if stem == "manifest":
                context_sources.append("tests/android-project/fixtures/embedded.jai")
            run(f"{stem}-{system}-{cpu}-lint", "source-only-lint", [lint, *flags, "-D", "warnings", "--context", check_source, *context_sources])
    calls = [json.loads(line)[1:] for line in command_log.read_text().splitlines()]
    install = [call for call in calls if "install" in call and call[-1] == "an apk with spaces.apk"]
    assert len(install) == 3 and all(call == ["-s", "host-fixture-serial", "install", "-r", "-t", "-d", "an apk with spaces.apk"] for call in install)
    links = [call for call in calls if "--controlled-test" in call]
    assert len(links) == 3 and all("aarch64-linux-android34" in call and "-shared" in call for call in links)
    uninstalls = [call for call in calls if "uninstall" in call]
    assert len(uninstalls) == 3 and all(call == ["-s", "host-fixture-serial", "uninstall", "jai.host.fixture"] for call in uninstalls)
    (output / "host-command-arguments.json").write_text(json.dumps(calls, indent=2) + "\n")
    # Only the runner's generated paths are removed; original fixtures stay intact.
    for directory in ("generated-host-tools", "generated-helper", "generated-invalid-helper", "generated-inner-helper", "generated-sdk-output", "generated-device", "target", "tests"):
        shutil.rmtree(FIXTURE_ROOT / directory, ignore_errors=True)
    (FIXTURE_ROOT / "independent.axml").unlink(missing_ok=True)
    return int(any(result["exit_code"] for result in results))


if __name__ == "__main__":
    raise SystemExit(main())
