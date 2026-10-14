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
        data=path.read_bytes()
        target.write_bytes(data)
        records.append(dict(source=str(path),destination=str(relative),sha256=hashlib.sha256(data).hexdigest()))
dest.mkdir(parents=True,exist_ok=True)
stage(args.foundation.resolve(),True)
if args.bindings.is_dir():
    stage(args.bindings.resolve(),False,['Android','Curl','d3d11','d3d12','d3d_compiler','dxc_compiler','dxgi','freetype','GL','ImGui','iOS','Linux','lz4','macOS','meshoptimizer','Metal','MojoShader','nvidia_aftermath','nvtt','Objective_C','POSIX','rpmalloc','SDL','stb_image','stb_image_resize','stb_image_write','stb_vorbis','telemetry3','Vulkan','Windows','X11','xxHash','internal/bindings'])
if args.compiler_library is not None:
    stage(args.compiler_library.resolve(),False,['Compiler','Jai_Lexer','Code_Visit','Program_Print','internal/compiler-api','internal/jai-lexer','internal/code-visit','internal/program-print'])
if args.foundations is not None:
    stage(args.foundations.resolve(),False,['Basic','String','Hash','File_Utilities','internal/basic','internal/basic-interface','internal/string','internal/hash','internal/files/paths.jai','internal/files/filesystem.jai','internal/files/filesystem-windows.jai','internal/files/visit-info.jai','internal/files/windows-text.jai','internal/files/windows-abi.jai'])
if args.window_render is not None:
    stage(args.window_render.resolve(),False,['Window_Creation','Window_Type','Input','Keymap','Gamepad','Simp','sRGB','Clipboard','internal/window','internal/rendering','internal/input','internal/gamepad','internal/clipboard'])
for name in ['Math','Sloppy_Math','Float16','Color_Interpolation','GetRect','GetRect_LeftHanded','internal/numerics']:
    path=dest/name
    if path.exists(): shutil.rmtree(path)
stage(root/'stdlib',False)
repairs=[] # No source repairs or test fixtures enter production staging.
manifest=args.manifest.resolve()
if not manifest.is_relative_to(root/'artifacts'):
    raise SystemExit('staging manifest must remain inside this workspace artifacts directory')
manifest.write_text(json.dumps(dict(files=records,repairs=repairs),indent=2)+'\n')
print(f'Staged {len(records)} fresh source files into {dest}; manifest: {manifest}')
