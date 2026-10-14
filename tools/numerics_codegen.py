"""Normalize generated owned sources with the repository formatter engine."""
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]

def normalize(source):
    formatter = Path(os.environ.get('NUMERICS_JAIFMT', ROOT/'artifacts/numerics-format-driver'))
    if not formatter.is_file():
        raise SystemExit('Build the repository Jai_Format engine driver before regenerating numerics')
    result = subprocess.run([str(formatter), '--stdin'], input=source, text=True,
                            stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=ROOT)
    if result.returncode:
        raise SystemExit(result.stderr or 'repository formatter failed')
    return result.stdout

def write_generated(path, source):
    Path(path).write_text(normalize(source))
