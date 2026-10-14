"""Stage only fresh peer libraries and this worker's modules in local artifacts."""
from pathlib import Path
import argparse,hashlib,json,shutil
root=Path(__file__).resolve().parents[1]
parser=argparse.ArgumentParser()
parser.add_argument('--foundation',type=Path,default=root.parent/'stdlib/stdlib')
parser.add_argument('--bindings',type=Path,default=root.parent/'bindings/stdlib')
parser.add_argument('--destination',type=Path,default=root/'artifacts/stdlib')
parser.add_argument('--compiler-library',type=Path,help='New compiler-owned stdlib modules, copied read-only without Extensions')
parser.add_argument('--repair-foundation-buffer-alias',action='store_true')
parser.add_argument('--formatter-bootstrap',action='store_true',help='Stage real implementations of missing reviewed Basic tool APIs; never modifies peer sources')
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
if args.compiler_library is not None: stage(args.compiler_library.resolve(),False)
stage(root/'stdlib',False)
repairs=[]
if args.repair_foundation_buffer_alias:
    path=dest/'Basic/module.jai'
    old=path.read_text(); new=old.replace('Buffer :: Impl.Buffer;\n','')
    if old!=new:
        path.write_text(new)
        repairs.append('Removed invalid standalone Basic.Buffer alias; reviewed Buffer is nested under String_Builder.')
if args.formatter_bootstrap:
    facade=dest/'Basic/module.jai'
    source=facade.read_text()
    additions=[]
    implementations=[]
    if 'print :: print_to_builder;' not in source:
        additions.append('print :: print_to_builder;')
    if 'tprint ::' not in source:
        additions.append('tprint :: Impl.tprint;')
        implementations.append('''tprint :: (format_string: string, args: ..Any) -> string {
    previous := context.allocator;
    context.allocator = temporary_allocator;
    defer context.allocator = previous;
    return sprint(format_string, ..args);
}''')
    if 'exit ::' not in source:
        additions.append('exit :: Impl.exit;')
        implementations.append('exit :: (status: s32) #foreign numerics_tool_libc "exit";\n#scope_file\nnumerics_tool_libc :: #system_library "libc";')
    if additions:
        facade.write_text(source.replace('#scope_file','\n'.join(additions)+'\n#scope_file',1))
        repairs.append('Formatter bootstrap: reviewed Basic aliases '+', '.join(additions))
    if implementations:
        private=dest/'internal/basic/numerics-tool-integration.jai'
        private.write_text('// Staging-only reviewed Basic tool API implementations.\n'+'\n'.join(implementations)+'\n')
        entry=dest/'internal/basic/module.jai'
        load='#load "numerics-tool-integration.jai";'
        text=entry.read_text()
        if load not in text: entry.write_text(text+'\n'+load+'\n')
manifest=root/'artifacts/numerics-staging.json'
manifest.write_text(json.dumps(dict(files=records,repairs=repairs),indent=2)+'\n')
print(f'Staged {len(records)} fresh source files into {dest}; manifest: {manifest}')
