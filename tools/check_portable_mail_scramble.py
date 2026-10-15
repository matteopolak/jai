#!/usr/bin/env python3
"""Reviewed Mail public transform, with unchanged real SMTP regressions separate."""
import os
from pathlib import Path
import shutil
import subprocess
import check_portable_time_foundation as foundation

ROOT = Path(__file__).resolve().parents[1]


def main():
    foundation.compose()
    library = foundation.LIBRARY
    for relative in ["Mail", "internal/net/mail.jai", "internal/net/mail-scramble.jai"]:
        source = ROOT / "stdlib" / relative
        destination = library / relative
        if source.is_dir():
            shutil.copytree(source, destination, dirs_exist_ok=True)
        else:
            shutil.copyfile(source, destination)
    binaries = Path(os.environ["CARGO_TARGET_DIR"]) / "debug"
    compiler = str(binaries / "jaic")
    source = ROOT / "tests/portable-stdlib/mail-scramble/main.jai"
    env = dict(os.environ, JAIC_STDLIB=str(library))
    output = ROOT / "target/portable-mail-scramble"
    output.mkdir(parents=True, exist_ok=True)
    commands = [[compiler, "-interp", str(source), "--"]]
    for level in ["-O0", "-O2"]:
        executable = output / ("scramble" + level)
        subprocess.run([compiler, str(source), level, "-exe", str(executable)], env=env, check=True)
        commands.append([str(executable)])
    for command in commands:
        result = subprocess.run(command, env=env, capture_output=True, text=True, timeout=60)
        if result.returncode or result.stdout != "ok\n" or result.stderr:
            raise RuntimeError(f"{command!r}: {result.stdout}{result.stderr}")
        for failure in ["bad-text", "bad-secret", "empty-secret"]:
            result = subprocess.run([*command, failure], env=env, capture_output=True, text=True, timeout=60)
            if result.returncode == 0 or "scramble" not in result.stdout + result.stderr:
                raise RuntimeError(f"invalid input accepted: {command!r} {failure}: {result.stdout}{result.stderr}")
    subprocess.run([str(binaries / "jailint"), "-D", "warnings",
                    str(library / "Mail/module.jai"), str(library / "internal/net/mail-scramble.jai"),
                    str(source)], env=env, check=True)
    print("Mail scramble: all 64 secrets/full alphabet, reversible cyclic mapping, empty input and 9 assertion failures pass interpreter/native O0/O2 and strict lint")


if __name__ == "__main__":
    main()
