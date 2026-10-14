#!/usr/bin/env python3
"""Audit a packaged SDL3 runtime, then compile/run its Jai ABI and headless tests.
Use --jaic with a source-built compiler or a packaged compiler. No system SDL fallback.
"""
from __future__ import annotations
import argparse
import ctypes
import hashlib
import json
import os
import re
import shutil
import subprocess
from pathlib import Path
from sdl3_native import ROOT, host

def audit(native,plat):
    native=native.resolve()
    meta=json.loads((native/'sdl3/build.json').read_text())
    assert meta['platform']==plat and meta['version']=='3.4.18'
    for name,digest in meta['artifacts'].items():
        assert hashlib.sha256((native/name).read_bytes()).hexdigest()==digest,name
    filename='SDL3.dll' if plat.startswith('windows') else 'libSDL3.'+('dylib' if plat.startswith('macos') else 'so')
    library=ctypes.CDLL(str(native/filename))
    library.SDL_GetVersion.restype=ctypes.c_int
    assert library.SDL_GetVersion()==3004018
    text=(ROOT/f'stdlib/Extensions/SDL3/{plat}.jai').read_text()+(ROOT/'stdlib/Extensions/SDL3/macros.jai').read_text()
    symbols=[]
    for line in text.splitlines():
        if '#foreign SDL3' not in line: continue
        m=re.search(r'#foreign SDL3 "([^"]+)"',line)
        symbol=m[1] if m else line.split(' :: ')[0]
        getattr(library,symbol) # Raise for every missing export; never silently skip.
        symbols.append(symbol)
    assert (native/'licenses/sdl3/LICENSE.txt').read_bytes()==(ROOT/'stdlib/Extensions/SDL3/LICENSE.txt').read_bytes()
    print(f'audited SDL3 {plat}: {len(symbols)} runtime exports and all artifact hashes')

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--jaic',type=Path)
    p.add_argument('--audit-only',action='store_true')
    p.add_argument('--native',type=Path,required=True)
    p.add_argument('--stdlib',type=Path)
    p.add_argument('--platform',default=host())
    a=p.parse_args(); audit(a.native,a.platform)
    if a.audit_only:return
    if not a.jaic:p.error('--jaic is required unless --audit-only')
    out=ROOT/'artifacts/sdl3/tests'/a.platform;out.mkdir(parents=True,exist_ok=True)
    env=dict(os.environ,JAIC_NATIVE_LIBS=str(a.native.resolve()))
    if a.stdlib:env['JAIC_STDLIB']=str(a.stdlib.resolve())
    compiler=str(a.jaic.resolve())
    exe='.exe' if a.platform.startswith('windows') else ''
    # Run outside the checkout, with only explicit compiler/stdlib/library paths.
    for name in ('layout','headless','callbacks'):
        program=out/(name+exe)
        subprocess.run([compiler,str(ROOT/f'tests/sdl3/{name}.jai'),'-exe',str(program)],env=env,cwd=out,check=True)
        if not program.exists():raise RuntimeError(f'compiler did not emit {program}')
        subprocess.run([str(program)],env=env,cwd=out,check=True)
    print('SDL3 linked ABI, headless and callback tests passed')

if __name__=='__main__':main()
