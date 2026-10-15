# DXC reflection forwarding and verification limits

`DXC_Reflect` now creates native `IDxcUtils`, supplies compiled bytes through a
correctly sized `DxcBuffer` with binary/ACP encoding, and requests the canonical
D3D12 shader reflection interface. Every HRESULT and returned pointer is
checked. Partial interfaces on failure are released; the utility is always
released; successful reflection retains its independent native reference for
the caller. No blob data or reflected object is fabricated. SDK helpers and the
contextual reflection alias remain private; the return type is canonical D3D12.

Microsoft's complete official native SDK inputs are pinned at v1.8.2505 in
dependencies.json: dxcapi.h, its own WinAdapter.h, and native dxclibrary.cpp.
The latter confirms acceptance of full DXIL containers and binary ACP encoding.
This is native SDK/ABI evidence, not a Jai compatibility oracle. See the
[official native implementation](https://github.com/microsoft/DirectXShaderCompiler/blob/v1.8.2505/tools/clang/tools/dxcompiler/dxclibrary.cpp).

The C++ ABI probe uses the complete unmodified vendor header and supported host
adapter. It asserts buffer size/alignment, every field offset, HRESULT size and
COM identity size. Both macOS CPU compilations are recorded as SDK layout
evidence; **they do not establish Windows native execution**.

`tests/native-bindings/dxc-reflect.jai` requires actual Windows dxcompiler. It
compiles HLSL using the real compiler COM API, obtains the result blob, reflects
its bytes, checks a native scalar query and releases each object. Empty/corrupt
inputs must fail without fabricated objects. Jai buffer size/offset assertions
remain active. Both Windows source targets and native execution are registered.

Current Jai checks stop at the unchanged general D3D12 forward-overlay
diagnostic before validating this body. Windows runtime is unavailable here.
This is authored forwarding plus SDK layout evidence, **not a source-verified
or native-verified completed DXC wrapper**. `DXC_Compile` now has an independently
source-checked SDK route; public/native verification remains required. The
version-string helper remains unresolved. Next: producer forward-overlay semantics,
actual Windows source/strict lint, then the real executable test.
