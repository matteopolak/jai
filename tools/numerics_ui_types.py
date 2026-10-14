"""Materialize reviewed UI record inventories; never synthesize procedure bodies."""
from pathlib import Path
import re
ROOT=Path(__file__).resolve().parents[1]
for spec,variant in [('getrect.md','right'),('getrect-lefthanded.md','left')]:
    text=(ROOT/'docs/specs/stdlib/modules'/spec).read_text()
    inventory=text.split('## Public type members')[0]
    shapes=text.split('## Public type members')[1].split('## Reachable field-type shapes')[0]
    out=[]
    for match in re.finditer(r'^#### `([^`]+)` \(([^\n]+)\)\n(.*?)(?=^#### |\Z)',shapes,re.M|re.S):
        name,kind,body=match.groups()
        if kind.startswith('enum'):
            inv=re.search(r'^- `'+name+r' :: (enum(?:_flags)?(?: u\d+)?)`',inventory,re.M)
            declaration=inv.group(1) if inv else kind
            fields=re.findall(r'^- `([^`]+)`',body,re.M)
            out.append(name+' :: '+declaration+' { '+'; '.join(fields)+'; }')
            continue
        if kind!='struct': continue
        fields=[]
        for line in body.splitlines():
            m=re.match(r'- `([^`]+)`',line)
            if not m: 
                if 'Anonymous union containing' in line: fields.append('union { initial_value_float32: float32; initial_value_float64: float64; initial_value_int: int; }')
                continue
            f=m.group(1).rstrip(';')
            if f.endswith('Vector3.['): f=f.split('=')[0]+'= .[]'
            fields.append(f+';')
        flag=' #type_info_none' if re.search(r'^- `'+name+r' :: struct #type_info_none`',inventory,re.M) else ''
        out.append(name+' :: struct'+flag+' {\n    '+'\n    '.join(fields)+'\n}')
    path=ROOT/'stdlib/internal/numerics'/('ui_types_'+variant+'.jai')
    path.write_text('\n\n'.join(out)+'\n')
    public='GetRect' if variant=='right' else 'GetRect_LeftHanded'
    p=ROOT/'stdlib'/public; p.mkdir(parents=True,exist_ok=True)
    (p/'module.jai').write_text(f'''#load "../internal/numerics/ui_types_{variant}.jai";
#load "../internal/numerics/ui_context.jai";
#load "../internal/numerics/ui_geometry.jai";
#load "../internal/numerics/ui_core.jai";
#load "../internal/numerics/ui_widgets.jai";
#load "../internal/numerics/ui_text.jai";
#load "../internal/numerics/ui_editor.jai";
#if OS==.WINDOWS {{ Windows :: #import "Windows"; }}
#scope_module
LEFT_HANDED :: {'true' if variant=='left' else 'false'};
#import "Basic";
#import "Math";
#import "Color_Interpolation";
#import "Input";
#import "Window_Type";
#import "Hash_Table";
''')
