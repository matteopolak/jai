"""Root-authorized source-only default Basic configuration for scoped tests."""
from pathlib import Path


def disabled_default_copy(root: Path, work: Path):
    library = root / "stdlib"
    captured = {str(p.relative_to(library)): p.read_bytes() for p in library.rglob("*.jai")}
    disabled = work / "disabled-stdlib"
    for name, contents in captured.items():
        path = disabled / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(contents)
    basic = disabled / "Basic/module.jai"
    original = basic.read_bytes()
    assert original.count(b"ENABLE_ASSERT := true") == 1
    basic.write_bytes(original.replace(b"ENABLE_ASSERT := true", b"ENABLE_ASSERT := false", 1))
    changed = sorted(name for name, contents in captured.items()
                     if (disabled / name).read_bytes() != contents)
    assert changed == ["Basic/module.jai"], "test configuration must have exactly one change"
    return disabled, captured
