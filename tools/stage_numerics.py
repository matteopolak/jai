"""Stage only fresh peer libraries and this worker's modules in local artifacts."""
from pathlib import Path
import argparse,hashlib,json,shutil
root=Path(__file__).resolve().parents[1]
parser=argparse.ArgumentParser()
parser.add_argument('--foundation',type=Path,default=root.parent/'stdlib/stdlib')
parser.add_argument('--bindings',type=Path,default=root.parent/'bindings/stdlib')
parser.add_argument('--foundations',type=Path)
parser.add_argument('--window-render',type=Path)
parser.add_argument('--destination',type=Path,default=root/'artifacts/stdlib')
parser.add_argument('--compiler-library',type=Path,help='New compiler-owned stdlib modules, copied read-only without Extensions')
parser.add_argument('--repair-foundation-buffer-alias',action='store_true')
parser.add_argument('--formatter-bootstrap',action='store_true',help='Stage real implementations of missing reviewed Basic tool APIs; never modifies peer sources')
parser.add_argument('--manifest',type=Path,default=root/'artifacts/numerics-staging.json')
args=parser.parse_args()
dest=args.destination.resolve()
if not dest.is_relative_to(root/'artifacts'):
    raise SystemExit('staging writes must remain inside this workspace artifacts directory')
records=[]
def stage(source,include_extensions,owned=None):
    for path in sorted(source.rglob('*')):
        if path.is_symlink(): raise SystemExit(f'refusing source symlink: {path}')
        if not path.is_file(): continue
        relative=path.relative_to(source)
        if not include_extensions and relative.parts[0]=='Extensions': continue
        if owned is not None and not any(relative==Path(prefix) or Path(prefix) in relative.parents for prefix in owned): continue
        target=dest/relative; target.parent.mkdir(parents=True,exist_ok=True)
        shutil.copyfile(path,target)
        records.append(dict(source=str(path),destination=str(relative),sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
dest.mkdir(parents=True,exist_ok=True)
stage(args.foundation.resolve(),True)
if args.bindings.is_dir():
    stage(args.bindings.resolve(),False,['Android','Curl','d3d11','d3d12','d3d_compiler','dxc_compiler','dxgi','freetype','GL','ImGui','iOS','Linux','lz4','macOS','meshoptimizer','Metal','MojoShader','nvidia_aftermath','nvtt','Objective_C','POSIX','rpmalloc','SDL','stb_image','stb_image_resize','stb_image_write','stb_vorbis','telemetry3','Vulkan','Windows','X11','xxHash','internal/bindings'])
if args.compiler_library is not None:
    stage(args.compiler_library.resolve(),False,['Compiler','Jai_Lexer','Code_Visit','Program_Print','internal/compiler-api','internal/jai-lexer','internal/code-visit','internal/program-print'])
if args.foundations is not None:
    stage(args.foundations.resolve(),False,['Basic','String','Hash','File_Utilities','internal/basic','internal/string','internal/hash','internal/files/paths.jai','internal/files/filesystem.jai','internal/files/filesystem-windows.jai','internal/files/visit-info.jai'])
if args.window_render is not None:
    stage(args.window_render.resolve(),False,['Window_Creation','Window_Type','Input','Keymap','Gamepad','Simp','sRGB','Clipboard','internal/window','internal/rendering','internal/input','internal/gamepad','internal/clipboard'])
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
    if 'print :: print_to_builder;' not in source:
        additions.append('print :: print_to_builder;')
    helpers=[]
    for name in ['tprint','exit','get_working_directory']:
        if name+' ::' not in source:
            additions.append(name+' :: Impl.numerics_tool_'+name+';')
            helpers.append(name)
    if additions:
        facade.write_text(source.replace('#scope_file','\n'.join(additions)+'\n#scope_file',1))
        repairs.append('Formatter bootstrap: reviewed Basic aliases '+', '.join(additions))
    if helpers:
        private=dest/'internal/basic/numerics-tool-integration.jai'
        shutil.copyfile(root/'tools/numerics-formatter-basic.jai',private)
        entry=dest/'internal/basic/module.jai'
        load='#load "numerics-tool-integration.jai";'
        text=entry.read_text()
        if load not in text: entry.write_text(text+'\n'+load+'\n')
    facade=dest/'File_Utilities/module.jai'
    source=facade.read_text()
    aliases=[]
    for name in ['is_directory','visit_files']:
        if name+' ::' not in source:
            aliases.append(name+' :: Files.'+name+';')
    if aliases:
        # Both helper declarations must be absent to avoid duplicate overloads
        # after the foundation owner implements one of these APIs.
        if len(aliases)!=2:
            raise SystemExit('partial filesystem tool APIs now available: update staging bootstrap rather than duplicate declarations')
        facade.write_text(source.replace('#scope_file','\n'.join(aliases)+'\n#scope_file',1))
        shutil.copyfile(root/'tools/numerics-formatter-files.jai',dest/'internal/files/numerics-formatter-files.jai')
        entry=dest/'internal/files/filesystem.jai'
        entry.write_text('#load "numerics-formatter-files.jai";\n'+entry.read_text())
        repairs.append('Formatter bootstrap: real scoped POSIX is_directory and visit_files implementation.')
manifest=args.manifest.resolve()
if not manifest.is_relative_to(root/'artifacts'):
    raise SystemExit('staging manifest must remain inside this workspace artifacts directory')
manifest.write_text(json.dumps(dict(files=records,repairs=repairs),indent=2)+'\n')
print(f'Staged {len(records)} fresh source files into {dest}; manifest: {manifest}')
