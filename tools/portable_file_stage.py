"""Stage the NEW File producer's facade/backend as one canonical dependency.

Foundation File_Utilities algorithms remain separate. Only the caller's owned
target library is written; the platform-io producer is read-only.
"""
from pathlib import Path
import shutil

ROOT = Path(__file__).resolve().parents[1]


def compose_into(library):
    shutil.copytree(ROOT.parent / "platform-io/stdlib/File", library / "File", dirs_exist_ok=True)
    for name in ["file.jai", "native-unix.jai", "native-windows.jai"]:
        shutil.copyfile(ROOT.parent / "platform-io/stdlib/internal/files" / name,
                        library / "internal/files" / name)
    text = library / "internal/platform-io/windows-text.jai"
    text.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(ROOT.parent / "platform-io/stdlib/internal/platform-io/windows-text.jai", text)
