"""One owned Android/Toolchain source closure with NEW foundation dependencies.

Only target/ is written. Do not replace missing public APIs with fixture shims.
Explicit owned paths include cross-subsystem #load dependencies, so an older
baseline cannot silently retain an outdated codec or miss a newly loaded file.
"""
from pathlib import Path
import shutil
import check_portable_time_foundation as foundation

ROOT = Path(__file__).resolve().parents[1]
LIBRARY = foundation.LIBRARY
OWNED_PATHS = ["Android/Toolchain", "internal/android-toolchain", "internal/crypto/sha.jai",
               "internal/archive/android-zip-wire.jai"]


def compose():
    baseline = foundation.BASELINE
    if not (baseline / "prelude/module.jai").is_file():
        raise RuntimeError("initialize the approved portable baseline with check_portable_stdlib.py and NEW POSIX/Hash producer roots first")
    for relative in OWNED_PATHS:
        source = ROOT / "stdlib" / relative
        destination = baseline / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        if source.is_dir():
            shutil.copytree(source, destination, dirs_exist_ok=True)
        else:
            shutil.copyfile(source, destination)
    foundation.compose()
    return LIBRARY
