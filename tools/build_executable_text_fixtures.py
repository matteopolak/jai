"""Original TBD data validated by Apple's SDK tapi; SDK samples remain untracked."""
from pathlib import Path
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "target/executable-text-fixtures"
V4 = """--- !tapi-tbd
tbd-version: 4
targets: [ arm64-macos, x86_64-macos ]
install-name: '/usr/lib/libIndependent4.dylib'
current-version: 1.2.3
exports:
  - targets: [ arm64-macos, x86_64-macos ]
    symbols: [ _one,
               '_two', _hash#Symbol, "_\\xE9" ]
    weak-symbols: [ _weak ]
    thread-local-symbols: [ _tls ]
    objc-classes: [ Widget ]
    objc-ivars: [ Widget.field ]
reexported-libraries:
  - targets: [ arm64-macos, x86_64-macos ]
    libraries: [ '/usr/lib/libSystem.B.dylib' ]
--- !tapi-tbd
tbd-version: 4
targets: [ arm64-macos, x86_64-macos ]
install-name: /usr/lib/lib#Child.dylib
exports:
  - targets: [ arm64-macos, x86_64-macos ]
    symbols: [ _child ]
...
"""
V3 = """--- !tapi-tbd-v3
archs: [ x86_64, arm64 ]
platform: macosx
install-name: '/usr/lib/libIndependent3.dylib'
exports:
  - archs: [ x86_64, arm64 ]
    symbols: [ _three ]
    weak-def-symbols: [ _weak3 ]
    objc-classes: [ Widget3 ]
...
"""


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    sdk = Path(subprocess.check_output(["xcrun", "--show-sdk-path"], text=True).strip())
    for label, content in [("original-v4", V4), ("original-v3", V3)]:
        (OUT / (label + ".tbd")).write_text(content)
    for label, filename in [("sdk-objc", "libobjc.A.tbd"), ("sdk-system", "libSystem.tbd")]:
        shutil.copyfile(sdk / "usr/lib" / filename, OUT / (label + ".tbd"))
    for label in ["original-v4", "original-v3", "sdk-objc", "sdk-system"]:
        path = OUT / (label + ".tbd")
        for option, suffix in [("--info", "info"), ("--list-symbols", "symbols")]:
            result = subprocess.run(["xcrun", "tapi", "archive", option, str(path)],
                                    text=True, capture_output=True, check=True)
            (OUT / (label + "-" + suffix + ".txt")).write_text(result.stdout)
        symbols = (OUT / (label + "-symbols.txt")).read_text()
        if label == "original-v4":
            assert "_one" in symbols and "_two" in symbols and "_OBJC_CLASS_$_Widget" in symbols
            assert "_hash#Symbol" in symbols and "_é" in symbols
        if label == "original-v3":
            assert "_three" in symbols and "_weak3" in symbols and "_OBJC_CLASS_$_Widget3" in symbols
    print("Original TBD v3/v4 and SDK samples accepted by Apple's tapi oracle")


if __name__ == "__main__":
    main()
