#!/usr/bin/env python3
"""Use only this clean clone, its named compiler archive and assigned T7 target."""
import os
import json
from pathlib import Path
import shutil
import subprocess

from build_portable_apk_signing_fixtures import build
from build_portable_apk_signing_native_vectors import build as build_native, verify_generated

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "artifacts/verification-base-934a6918/stdlib"
CRYPTO = ROOT / "artifacts/crypto-dependency-d16943e/stdlib/internal/android-toolchain"
PROVIDER_FILES = ["crypto-provider.jai", "jks-reader.jai", "jks-decryption.jai"]
OWN_FILES = [f"apk-signing-{part}.jai" for part in ["model", "framing", "digest", "assembly", "orchestration"]]


def run(command, env, expected=None):
    print("+", *map(str, command), flush=True)
    result = subprocess.run(list(map(str, command)), cwd=ROOT, env=env,
                            capture_output=True, text=True, timeout=120)
    if result.stdout:
        print(result.stdout, end="")
    if result.stderr:
        print(result.stderr, end="")
    result.check_returncode()
    if expected is not None and (result.stdout != expected or result.stderr):
        raise RuntimeError(f"unexpected runtime output: {result.stdout!r} {result.stderr!r}")


def main():
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    work = target / "apk-signing"
    fixtures = work / "fixtures"
    library = work / "stdlib"
    work.mkdir(parents=True, exist_ok=True)
    compiler = target / "debug/jaic"
    formatter = work / "jaifmt"
    authored = [ROOT / "stdlib/internal/android-toolchain" / name for name in OWN_FILES]
    authored += list((ROOT / "tests/portable-stdlib/android-apk-signing").glob("*.jai"))
    if not (BASE / "internal/compiler-api/runtime-config.jai").is_file() and not (BASE / "internal/compiler-api/runtime-config/module.jai").is_file():
        raise RuntimeError("named clean verification closure 934a6918 is missing runtime-config")
    own_env = dict(os.environ, JAIC_STDLIB=str(BASE))
    run([compiler, ROOT / "jaifmt/main.jai", "-O2", "-exe", formatter], own_env)
    run([formatter, "--config", ROOT / "jaifmt.toml", *authored], own_env)
    run([formatter, "--config", ROOT / "jaifmt.toml", "--check", *authored], own_env)
    # Named authorized dependency closure; overlay only assigned production files.
    if library.exists():
        shutil.rmtree(library)
    shutil.copytree(BASE, library)
    for name in OWN_FILES:
        shutil.copyfile(ROOT / "stdlib/internal/android-toolchain" / name,
                        library / "internal/android-toolchain" / name)
    for name in PROVIDER_FILES:
        shutil.copyfile(CRYPTO / name, library / "internal/android-toolchain" / name)
    native_directory = library / "internal/android-toolchain/android-crypto"
    native_directory.mkdir(exist_ok=True)
    if shutil.which("pkg-config"):
        installed = Path(subprocess.check_output(["pkg-config", "--variable=libdir", "libcrypto"], text=True).strip())
    else:
        installed = Path(subprocess.check_output(["brew", "--prefix", "openssl@3"], text=True).strip()) / "lib"
    assert installed.is_dir()
    for name in ["libcrypto.a", "libcrypto.dylib", "libcrypto.3.dylib"]:
        shutil.copyfile(installed / name, native_directory / name)
    facade = library / "Android/Toolchain/module.jai"
    text = facade.read_text()
    loads = "\n".join(f'#load "../../internal/android-toolchain/{name}";' for name in PROVIDER_FILES + OWN_FILES)
    loads += '\n#load "apk-signing-test-body.jai";\n'
    assert text.count("#scope_file\n") == 1
    facade.write_text(text.replace("#scope_file\n", loads + "\n#scope_file\n"))
    test = ROOT / "tests/portable-stdlib/android-apk-signing/main.jai"
    shutil.copyfile(test, facade.parent / "apk-signing-test-body.jai")
    build(fixtures)
    build_native(fixtures)
    env = dict(os.environ, JAIC_STDLIB=str(library))
    source = ROOT / "tests/portable-stdlib/android-apk-signing/run.jai"
    run([compiler, "-interp", source, "--", fixtures], env, expected="ok\n")
    for optimization in ["-O0", "-O2"]:
        executable = work / f"apk-signing{optimization}"
        run([compiler, source, optimization, "-exe", executable], env)
        run([executable, fixtures], env, expected="ok\n")
    crypto_source = ROOT / "tests/portable-stdlib/android-apk-signing/crypto.jai"
    run([compiler, "-interp", crypto_source, "--", fixtures], env, expected="ok\n")
    verify_generated(fixtures)
    verify_generated(fixtures, "jks")
    for optimization in ["-O0", "-O2"]:
        executable = work / f"apk-crypto{optimization}"
        run([compiler, crypto_source, optimization, "-exe", executable], env)
        run([executable, fixtures], env, expected="ok\n")
        verify_generated(fixtures)
        verify_generated(fixtures, "jks")
    checked = [library / "internal/android-toolchain" / name for name in OWN_FILES]
    checked += [facade.parent / "apk-signing-test-body.jai", source]
    run([target / "debug/jailint", "-D", "warnings", "--context", source,
         "--manifest", work / "lint.json", *checked], env)
    manifest = json.loads((work / "lint.json").read_text())
    assert not manifest["incomplete"] and not manifest["unvisited_files"]
    assert all(context["complete"] for context in manifest["contexts"])
    run([target / "debug/jailint", "-D", "warnings", "--context", crypto_source,
         "--manifest", work / "crypto-lint.json", crypto_source,
         *[library / "internal/android-toolchain" / name for name in OWN_FILES]], env)
    crypto_manifest = json.loads((work / "crypto-lint.json").read_text())
    assert not crypto_manifest["incomplete"] and not crypto_manifest["unvisited_files"]
    for target_os in ["linux", "windows"]:
        for cpu in ["x64", "arm64"]:
            run([compiler, "-check", "-os", target_os, "-cpu", cpu, crypto_source], env)
    print("APK framing/digest/sign/JKS/verify checks passed; Android SDK/device/native Windows/Linux remain separate.")


if __name__ == "__main__":
    main()
