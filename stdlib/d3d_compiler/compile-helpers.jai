// Independently authored D3DCompiler counted-string/definition/blob adapters.
D3DCompile :: (shader: string, source_name: string, pDefines: [] string, pInclude: *ID3DInclude, entry_point: string, target: string, Flags1: u32, Flags2: u32) -> bytecode: string, errors: string, HRESULT {
    macros := _d3d_macro_array(pDefines);
    if pDefines.count > 0 && macros == null return "", ShaderMemory.copy_string("Unable to allocate shader macro array"), cast(HRESULT) 0x8007000e;
    code: *ID3DBlob;
    diagnostics: *ID3DBlob;
    status := D3DCompile(shader.data, cast(SIZE_T) shader.count,
        ShaderMemory.temp_c_string(source_name), macros, pInclude,
        ShaderMemory.temp_c_string(entry_point), ShaderMemory.temp_c_string(target), Flags1, Flags2, *code, *diagnostics);
    defer _d3d_release(code);
    defer _d3d_release(diagnostics);
    output := _d3d_blob_string(code, false);
    messages := _d3d_blob_string(diagnostics, true);
    if code != null && output.data == null && ID3D10Blob_GetBufferSize(code) > 0 {
        if messages.count > 0 ShaderMemory.free(messages);
        return "", ShaderMemory.copy_string("Unable to copy shader compiler output"), cast(HRESULT) 0x8007000e;
    }
    if diagnostics != null && messages.data == null && ID3D10Blob_GetBufferSize(diagnostics) > 1 {
        if output.count > 0 ShaderMemory.free(output);
        return "", "", cast(HRESULT) 0x8007000e;
    }
    return output, messages, status;
}
D3DCompileFromFile :: (file_name: string, pDefines: [] string, pInclude: *ID3DInclude, entry_point: string, target: string, Flags1: u32, Flags2: u32) -> pCode: *ID3DBlob, pErrorMsgs: *ID3DBlob, HRESULT {
    wide, valid, _ := ShaderUtf8.utf8_to_wide(file_name);
    if !valid || wide == null return null, null, cast(HRESULT) 0x80070057;
    defer ShaderMemory.free(wide);
    macros := _d3d_macro_array(pDefines);
    if pDefines.count > 0 && macros == null return null, null, cast(HRESULT) 0x8007000e;
    code: *ID3DBlob;
    messages: *ID3DBlob;
    status := D3DCompileFromFile(cast(*s16) wide, macros, pInclude,
        ShaderMemory.temp_c_string(entry_point), ShaderMemory.temp_c_string(target), Flags1, Flags2, *code, *messages);
    return code, messages, status;
}

#scope_file
ShaderMemory :: #import "Basic";
ShaderWindows :: #import "Windows";
ShaderUtf8 :: #import "Windows_Utf8";
_d3d_release :: (object: *void) {
    if object == null return;
    unknown := cast(*ShaderWindows.IUnknown) object;
    unknown.vtable.Release(unknown);
}
_d3d_blob_string :: (blob: *ID3DBlob, trim_zero: bool) -> string {
    if blob == null return "";
    count := ID3D10Blob_GetBufferSize(blob);
    ShaderMemory.assert(count <= 0x7fff_ffff_ffff_ffff);
    text: string;
    text.data = cast(*u8) ID3D10Blob_GetBufferPointer(blob);
    text.count = cast(s64) count;
    if trim_zero && text.count > 0 && text[text.count - 1] == 0 text.count -= 1;
    return ShaderMemory.copy_string(text);
}
_d3d_macro_array :: (definitions: [] string) -> *D3D_SHADER_MACRO {
    if definitions.count == 0 return null;
    ShaderMemory.assert(definitions.count >= 0 && definitions.count < 0x3fff_ffff);
    values := cast(*D3D_SHADER_MACRO) ShaderMemory.temporary_alloc((definitions.count + 1) * size_of(D3D_SHADER_MACRO));
    if values == null return null;
    ShaderMemory.memset(values, 0, (definitions.count + 1) * size_of(D3D_SHADER_MACRO));
    for index: 0..definitions.count - 1 {
        text := definitions[index];
        split: s64 = 0;
        while split < text.count && text[split] != #char "=" split += 1;
        name: string;
        name.data = text.data;
        name.count = split;
        ShaderMemory.assert(name.count > 0, "Shader define requires a name");
        value := "1";
        if split < text.count {
            value.data = text.data + split + 1;
            value.count = text.count - split - 1;
        }
        values[index].Name = ShaderMemory.temp_c_string(name);
        values[index].Definition = ShaderMemory.temp_c_string(value);
    }
    return values;
}
