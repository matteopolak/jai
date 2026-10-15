#!/usr/bin/env python3
"""Real fresh fixture EC/RSA keys; inspect with native tool, never user stores."""
import os
from pathlib import Path
import shutil
import stat
import subprocess
from portable_android_stage import compose

ROOT = Path(__file__).resolve().parents[1]


def main():
    library = compose()
    env = dict(os.environ, JAIC_STDLIB=str(library))
    binaries = Path(os.environ["CARGO_TARGET_DIR"]) / "debug"
    compiler = str(binaries / "jaic")
    output = ROOT / "target/portable-direct-key"
    output.mkdir(parents=True, exist_ok=True)
    source = ROOT / "tests/portable-stdlib/android-direct-key/main.jai"
    commands = [([compiler, "-interp", str(source), "--"], "interp")]
    for level in ["-O0", "-O2"]:
        executable = output / ("generate" + level)
        subprocess.run([compiler, str(source), level, "-exe", str(executable)], env=env, check=True)
        commands.append(([str(executable)], level))
    for command, mode in commands:
        directory = output / ("fixtures" + mode)
        if directory.exists():
            shutil.rmtree(directory)  # Only this runner's generated fixture keys.
        result = subprocess.run([*command, str(directory)], env=env, capture_output=True, text=True, timeout=90)
        if result.returncode or result.stderr:
            raise RuntimeError(f"{command!r}: {result.stdout}{result.stderr}")
        paths = list(map(Path, result.stdout.splitlines()))
        if len(paths) != 4 or any(not path.is_relative_to(directory) for path in paths):
            raise RuntimeError(f"invalid owned output paths: {result.stdout}")
        for cert, key, bits in [(paths[0], paths[1], 256), (paths[2], paths[3], 2048)]:
            if stat.S_IMODE(key.stat().st_mode) != 0o600 or stat.S_IMODE(key.parent.stat().st_mode) != 0o700:
                raise RuntimeError("generated private key permissions are not private")
            if set(path.suffix for path in key.parent.iterdir()) != {".der"}:
                raise RuntimeError("intermediate key/config files were retained")
            cert_public = subprocess.check_output(["openssl", "x509", "-inform", "DER", "-in", str(cert), "-pubkey", "-noout"])
            key_public = subprocess.check_output(["openssl", "pkey", "-inform", "DER", "-in", str(key), "-pubout"])
            if cert_public != key_public:
                raise RuntimeError("generated certificate/private key mismatch")
            key_info = subprocess.check_output(["openssl", "pkey", "-inform", "DER", "-in", str(key), "-text", "-noout"], text=True)
            if f"{bits} bit" not in key_info and f"{bits} bit".replace(" bit", "-bit") not in key_info:
                raise RuntimeError("generated key size differs from reviewed fixed policy")
            cert_pem = directory / (cert.stem + "-verification.pem")
            subprocess.run(["openssl", "x509", "-inform", "DER", "-in", str(cert), "-out", str(cert_pem)], check=True)
            subprocess.run(["openssl", "verify", "-CAfile", str(cert_pem), str(cert_pem)], check=True, capture_output=True)
        subject = subprocess.check_output(["openssl", "x509", "-inform", "DER", "-in", str(paths[0]), "-subject", "-noout"], text=True)
        if "Test/Slash" not in subject or "Portable & Test" not in subject:
            raise RuntimeError(f"subject escaping mismatch: {subject}")
        failed_directory = output / ("failed" + mode)
        if failed_directory.exists():
            shutil.rmtree(failed_directory)
        result = subprocess.run([*command, str(failed_directory), "bad-country"], env=env, capture_output=True, text=True, timeout=90)
        if result.returncode or "rejected\n" not in result.stdout or "Native crypto key-generation command failed" not in result.stdout + result.stderr:
            raise RuntimeError(f"SDK failure was not returned/diagnosed: {result.stdout}{result.stderr}")
        if list(failed_directory.iterdir()):
            raise RuntimeError("SDK failure left generated private material")
    subprocess.run([str(binaries / "jailint"), "-D", "warnings", str(library / "Android/Toolchain/module.jai"),
                    str(library / "internal/android-toolchain/direct-key.jai"), str(source)], env=env, check=True)
    print("Direct signing keys: actual EC/P256/fixed RSA2048, ignored key_size, DER certificate/key match, self-signature/subjects/private permissions, distinct repeated outputs, DSA rejection and real SDK-error cleanup pass interpreter/native O0/O2 and strict lint; native crypto CLI required")


if __name__ == "__main__":
    main()
