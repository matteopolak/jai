import sys
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools" / "native_bindings"))
from generate import generate_facade, split_arguments
from spec import parse_spec


class GeneratorTests(unittest.TestCase):
    def test_arguments_handle_nested_function_types(self):
        self.assertEqual(split_arguments('a: s32, cb: #type (x: s32, y: s32) #c_call, b: [2]u32'),
                         ['a: s32', 'cb: #type (x: s32, y: s32) #c_call', 'b: [2]u32'])

    def test_forwarding_preserves_parameter_names_defaults_and_return(self):
        spec = parse_spec('''# d3d11
## Public declaration inventory
- `IFace_Run :: inline (this: *IFace, flags: u32 = 7) -> s32`
- `vtable :: (obj: *IFace) -> *IFace_VTable`
''')
        code, ledger = generate_facade('d3d11', spec)
        self.assertIn('flags: u32 = 7', code)
        self.assertIn('return this.vtable.Run(this, flags);', code)
        self.assertIn('return obj.vtable;', code)
        self.assertEqual([d['status'] for d in ledger], ['forwarded', 'forwarded'])

    def test_implicit_enum_member_is_not_dropped(self):
        spec = parse_spec('''# Example
## Public declaration inventory
- `Tag :: enum u32`
## Public type members
#### `Tag` (enum)
- `ZERO :: 0`
- `ONE`
- `LAST :: ONE`
''')
        code, ledger = generate_facade('Example', spec)
        self.assertIn('Tag :: enum u32 {', code)
        self.assertIn('ONE;', code)
        self.assertEqual(ledger[0]['status'], 'declared')

    def test_unknown_wrapper_remains_explicitly_unresolved(self):
        spec = parse_spec('''# Example
## Public declaration inventory
- `mystery :: (x: s32) -> bool`
''')
        code, ledger = generate_facade('Example', spec)
        self.assertNotIn('mystery ::', code)
        self.assertEqual(ledger[0]['status'], 'unresolved')

    def test_string_span_and_value_reference_forwarding(self):
        spec = parse_spec('''# ImGui
## Public declaration inventory
- `Draw :: (pos: *Vec2, text_begin: *u8, text_end: *u8) #foreign native`
- `Draw :: (pos: Vec2, text: string) #no_context`
''')
        code, ledger = generate_facade('ImGui', spec)
        self.assertIn('Draw(*pos, text.data, text.data + text.count)', code)
        self.assertEqual(ledger[1]['status'], 'implemented')

    def test_independent_top_level_order_preserves_semantic_sequences(self):
        spec = parse_spec('''# Example
## Public declaration inventory
- `zebra :: (value: s32) #foreign native`
- `storage_z: s32 = 5`
- `BETA :: 2`
- `zebra :: (value: u64) #foreign native`
- `storage_a: s32 = storage_z`
- `ALPHA :: 1`
- `alpha :: () #foreign native`
- `Tag :: enum u32`
## Public type members
#### `Tag` (enum)
- `ZED :: 10`
- `AYE`
''')
        code, _ = generate_facade('Example', spec)
        self.assertLess(code.index('Tag ::'), code.index('ALPHA ::'))
        self.assertLess(code.index('ALPHA ::'), code.index('BETA ::'))
        self.assertLess(code.index('storage_z:'), code.index('storage_a:'))
        self.assertLess(code.index('alpha ::'), code.index('zebra ::'))
        self.assertLess(code.index('value: s32'), code.index('value: u64'))
        self.assertLess(code.index('ZED ::'), code.index('AYE;'))

    def test_cpp_methods_on_same_line_are_forwarded_and_accounted(self):
        spec = parse_spec('''# nvtt
## Public declaration inventory
- `Compressor :: struct`
## Public type members
### `Compressor`
```jai
Compressor :: struct {
run :: (this: *Compressor, options: *Options) -> bool #foreign libnvtt; run :: (this: *Compressor, options: Options) -> bool #no_context;
}
```
''')
        code, ledger = generate_facade('nvtt', spec)
        self.assertIn('return run(this, *options);', code)
        self.assertEqual([m['status'] for m in ledger[0]['members']], ['declared', 'implemented'])


if __name__ == '__main__':
    unittest.main()
