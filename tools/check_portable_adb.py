#!/usr/bin/env python3
"""ADB host process/protocol regression; no actual server/device/auth commands."""
import os
import platform
from pathlib import Path
import shutil
import subprocess
from portable_android_stage import compose, LIBRARY

ROOT = Path(__file__).resolve().parents[1]


def main():
    output = ROOT / "target/portable-adb"
    output.mkdir(parents=True, exist_ok=True)
    fixture = output / "sdk protocol fixture"
    subprocess.run(["clang", "-std=c11", "-O2", "-Wall", "-Wextra", "-Werror",
                    str(ROOT / "tests/portable-stdlib/native/adb-protocol.c"), "-o", str(fixture)], check=True)
    shutil.copy2(fixture, output / "malformed SDK fixture")
    for name in ["SDK space", "SDK alt", "start failure SDK"]:
        sdk_bin = output / name / "platform-tools"
        sdk_bin.mkdir(parents=True, exist_ok=True)
        shutil.copy2(fixture, sdk_bin / "adb")
    (output / "SDK empty").mkdir(parents=True, exist_ok=True)
    compose()
    library = LIBRARY
    env = dict(os.environ, JAIC_STDLIB=str(library), ANDROID_HOME=str(output / "SDK space"),
               ANDROID_SDK_ROOT="", ANDROID_SDK_HOME="", JAI_ADB_PROTOCOL_LOG=str(output / "commands.log"))
    compiler = ROOT / "target/compiler/debug/jaic"
    source = ROOT / "tests/portable-stdlib/android-adb/main.jai"
    targets = [([], "host")]
    if platform.system() == "Darwin" and platform.machine() == "arm64":
        targets.append((["-target", "x86_64-apple-darwin"], "x64"))
    for fixture_source in [source, source.with_name("sdk-cache.jai")]:
        commands = [[str(compiler), "-interp", str(fixture_source)]]
        for flags, label in targets:
            for optimization in ["-O0", "-O2"]:
                executable = output / (fixture_source.stem + label + optimization)
                subprocess.run([str(compiler), str(fixture_source), *flags, optimization, "-exe", str(executable)],
                               env=env, check=True, timeout=90)
                commands.append([str(executable)])
        for command in commands:
            (output / "commands.log").write_text("")
            result = subprocess.run(command, env=env, text=True, capture_output=True, timeout=45)
            if result.returncode or result.stdout != "ok\n" or result.stderr:
                raise RuntimeError(f"{command!r}\n{result.stdout}{result.stderr}")
            verify_startup(output, failed_last=fixture_source.stem == "sdk-cache")
    verbose_source = source.with_name("verbosity.jai")
    for mode in ["interp", "O0", "O2"]:
        command = [str(compiler), "-interp", str(verbose_source)]
        if mode != "interp":
            executable = output / ("verbosity-" + mode)
            subprocess.run([str(compiler), str(verbose_source), "-" + mode, "-exe", str(executable)], env=env, check=True)
            command = [str(executable)]
        (output / "commands.log").write_text("")
        result = subprocess.run(command, env=env, capture_output=True, text=True, timeout=45)
        if result.returncode or result.stdout != "echo-args\nvisible\nok\n" or result.stderr:
            raise RuntimeError(f"verbosity: {result.stdout}{result.stderr}")
        verify_startup(output)
    for cpu in ["x64", "arm64"]:
        for fixture_source in [source, source.with_name("sdk-cache.jai")]:
            subprocess.run([str(compiler), "-check", "-os", "linux", "-cpu", cpu, str(fixture_source)], env=env, check=True)
    optional = source.with_name("startup-optional-assert.jai")
    try:
        for enabled in [True, False]:
            compose()
            for relative in ["Basic/module.jai", "internal/basic/module.jai"]:
                staged = library / relative
                text = staged.read_text()
                if text.count("ENABLE_ASSERT := true") != 1:
                    raise RuntimeError(f"unexpected staged Basic default shape: {staged}")
                staged.write_text(text.replace("ENABLE_ASSERT := true", "ENABLE_ASSERT := " + str(enabled).lower()))
            commands = [[str(compiler), "-interp", str(optional), "--"]]
            for flags, label in targets:
                for optimization in ["-O0", "-O2"]:
                    executable = output / ("optional-" + str(enabled) + label + optimization)
                    subprocess.run([str(compiler), str(optional), *flags, optimization, "-exe", str(executable)], env=env, check=True)
                    commands.append([str(executable)])
            for command in commands:
                (output / "commands.log").write_text("")
                result = subprocess.run(command + ([] if enabled else ["disabled"]), env=env,
                                        capture_output=True, text=True, timeout=45)
                if result.returncode or result.stdout != "ok\n" or result.stderr:
                    raise RuntimeError(f"startup optional assertions={enabled}: {result.stdout}{result.stderr}")
                verify_startup(output, failed_last=True)
            subprocess.run([str(ROOT / "target/compiler/debug/jailint"), "-D", "warnings",
                            str(library / "Android/Toolchain/module.jai"),
                            str(library / "internal/android-toolchain/adb-process.jai"), str(optional)], env=env, check=True)
    finally:
        compose()
    subprocess.run([str(ROOT / "target/compiler/debug/jailint"), "-D", "warnings",
                    str(library / "Android/Toolchain/module.jai"),
                    str(library / "internal/android-toolchain/adb-types.jai"),
                    str(library / "internal/android-toolchain/adb-process.jai"),
                    str(library / "internal/android-toolchain/adb-transfer.jai"),
                    str(library / "internal/android-toolchain/adb-apps.jai"),
                    str(library / "internal/android-toolchain/java-discovery.jai"),
                    str(library / "internal/android-toolchain/sdk-discovery.jai"), str(source.parent)],
                   env=env, check=True, timeout=90)
    print("ADB native CLI protocol fixture passes interpreter/native O0/O2, Linux both-CPU checking and strict lint; SDK/device integration remains pending")


def verify_startup(output, failed_last=False):
    commands = (output / "commands.log").read_text().splitlines()
    if failed_last:
        if not commands or commands.pop() != "start-server":
            raise RuntimeError("failed startup must be the final invocation, with no command execution")
    if not commands or len(commands) % 2 or any(commands[index] != "start-server" or
                                               commands[index + 1] == "start-server"
                                               for index in range(0, len(commands), 2)):
        raise RuntimeError(f"essential per-call server startup sequence incorrect: {commands!r}")


if __name__ == "__main__":
    main()
