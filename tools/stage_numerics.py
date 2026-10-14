"""Stage only fresh peer libraries and this worker's modules in local artifacts."""
from pathlib import Path
import argparse,hashlib,json,shutil
root=Path(__file__).resolve().parents[1]
parser=argparse.ArgumentParser()
parser.add_argument('--foundation',type=Path,default=root.parent/'stdlib/stdlib')
parser.add_argument('--bindings',type=Path,default=root.parent/'bindings/stdlib')
parser.add_argument('--destination',type=Path,default=root/'artifacts/stdlib')
parser.add_argument('--repair-foundation-buffer-alias',action='store_true')
args=parser.parse_args()
dest=args.destination.resolve()
if not dest.is_relative_to(root/'artifacts'):
    raise SystemExit('staging writes must remain inside this workspace artifacts directory')
records=[]
def stage(source,include_extensions):
    for path in sorted(source.rglob('*')):
        if path.is_symlink(): raise SystemExit(f'refusing source symlink: {path}')
        if not path.is_file(): continue
        relative=path.relative_to(source)
        if not include_extensions and relative.parts[0]=='Extensions': continue
        target=dest/relative; target.parent.mkdir(parents=True,exist_ok=True)
        shutil.copyfile(path,target)
        records.append(dict(source=str(path),destination=str(relative),sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
dest.mkdir(parents=True,exist_ok=True)
stage(args.foundation.resolve(),True)
if args.bindings.is_dir(): stage(args.bindings.resolve(),False)
stage(root/'stdlib',False)
repairs=[]
if args.repair_foundation_buffer_alias:
    path=dest/'Basic/module.jai'
    old=path.read_text(); new=old.replace('Buffer :: Impl.Buffer;\n','')
    if old!=new:
        path.write_text(new)
        repairs.append('Removed invalid standalone Basic.Buffer alias; reviewed Buffer is nested under String_Builder.')
manifest=root/'artifacts/numerics-staging.json'
manifest.write_text(json.dumps(dict(files=records,repairs=repairs),indent=2)+'\n')
print(f'Staged {len(records)} fresh source files into {dest}; manifest: {manifest}')
