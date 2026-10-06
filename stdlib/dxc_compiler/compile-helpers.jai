// Independent DXC utility/compiler/result lifecycle using reviewed dxcapi.h.
#assert OS == .WINDOWS "The retained DXC ABI uses Windows UTF-16 arguments";
DXC_Compile :: (args: Dxc_Shader_Compiler_Args) -> [..] u8 {
    output: [..] u8;
    utils: *IDxcUtils;
    compiler: *IDxcCompiler3;
    result: *IDxcResult;
    includes: *IDxcIncludeHandler;
    status := DxcCreateInstance(CLSID_DxcUtils, IDxcUtils_UID, cast(**void) *utils);
    defer _dxc_release(utils);
    if status < 0 || utils == null {
        DXCMemory.log_error("Unable to create DXC utilities: %", status);
        return output;
    }
    status = DxcCreateInstance(CLSID_DxcCompiler, IDxcCompiler3_UID, cast(**void) *compiler);
    defer _dxc_release(compiler);
    if status < 0 || compiler == null {
        DXCMemory.log_error("Unable to create DXC compiler: %", status);
        return output;
    }
    status = IDxcUtils_CreateDefaultIncludeHandler(utils, *includes);
    defer _dxc_release(includes);
    if status < 0 || includes == null {
        DXCMemory.log_error("Unable to create DXC include handler: %", status);
        return output;
    }
    arguments: [..] *s16;
    defer {
        for argument: arguments DXCMemory.free(argument);
        DXCMemory.array_free(arguments);
    }
    if args.shader_name.count > 0 _dxc_argument(*arguments, args.shader_name);
    DXCMemory.assert(args.shader_model_version.count > 0, "DXC requires a shader model version");
    if args.shader_type != .Library {
        _dxc_argument(*arguments, "-E");
        _dxc_argument(*arguments, args.entry_point);
    }
    prefix := _dxc_stage_prefix(args.shader_type);
    profile := DXCMemory.tprint("%_%", prefix, args.shader_model_version);
    _dxc_argument(*arguments, "-T");
    _dxc_argument(*arguments, profile);
    if args.add_debug_info {
        _dxc_argument(*arguments, "-Zi");
        _dxc_argument(*arguments, "-Qembed_debug");
    }
    if args.warnings_as_error _dxc_argument(*arguments, "-WX");
    if args.skip_optimization _dxc_argument(*arguments, "-Od");
    if args.compile_as_spirv {
        _dxc_argument(*arguments, "-spirv");
        if args.use_spirv_1_4 _dxc_argument(*arguments, "-fspv-target-env=vulkan1.1spirv1.4");
    }
    for definition: args.defines {
        _dxc_argument(*arguments, "-D");
        _dxc_argument(*arguments, definition);
    }
    for argument: args.extra_args _dxc_argument(*arguments, argument);
    DXCMemory.assert(arguments.count <= 0xffff_ffff);
    source: DxcBuffer;
    source.Ptr = args.shader_source.data;
    source.Size = cast(SIZE_T) args.shader_source.count;
    source.Encoding = DXC_CP_UTF8;
    status = IDxcCompiler3_Compile(compiler, *source, arguments.data, cast(u32) arguments.count, includes, *IDxcResult_UID, cast(**void) *result);
    defer _dxc_release(result);
    if status < 0 || result == null {
        DXCMemory.log_error("DXC Compile invocation failed: %", status);
        return output;
    }
    errors: *IDxcBlobEncoding;
    IDxcOperationResult_GetErrorBuffer(cast(*IDxcOperationResult) result, *errors);
    if errors != null {
        defer _dxc_release(errors);
        utf8: *IDxcBlobUtf8;
        conversion := IDxcUtils_GetBlobAsUtf8(utils, cast(*IDxcBlob) errors, *utf8);
        defer _dxc_release(utf8);
        if conversion >= 0 && utf8 != null {
            text: string;
            text.data = IDxcBlobUtf8_GetStringPointer(utf8);
            text.count = cast(s64) IDxcBlobUtf8_GetStringLength(utf8);
            if text.count > 0 DXCMemory.log_error("DXC: %", text);
        } else DXCMemory.log_error("Unable to convert DXC diagnostic text to UTF-8: %", conversion);
    }
    compilation: HRESULT;
    status = IDxcOperationResult_GetStatus(cast(*IDxcOperationResult) result, *compilation);
    if status < 0 || compilation < 0 return output;
    binary: *IDxcBlob;
    status = IDxcOperationResult_GetResult(cast(*IDxcOperationResult) result, *binary);
    defer _dxc_release(binary);
    if status < 0 || binary == null {
        DXCMemory.log_error("Unable to retrieve DXC output: %", status);
        return output;
    }
    size := IDxcBlob_GetBufferSize(binary);
    DXCMemory.assert(size <= 0x7fff_ffff_ffff_ffff);
    DXCMemory.array_resize(*output, cast(s64) size);
    if size > 0 memcpy(output.data, IDxcBlob_GetBufferPointer(binary), cast(s64) size);
    return output;
}
DXC_Reflect :: (dxil: [] u8) -> *ID3D12ShaderReflection, bool {
    utils: *IDxcUtils;
    status := DxcCreateInstance(CLSID_DxcUtils, IDxcUtils_UID, cast(**void) *utils);
    defer _dxc_release(utils);
    if status < 0 || utils == null return null, false;
    source: DxcBuffer;
    source.Ptr = dxil.data;
    source.Size = cast(SIZE_T) dxil.count;
    source.Encoding = DXC_CP_ACP;
    reflected: *ID3D12ShaderReflection;
    identifier := DXCWindows.uid(ID3D12ShaderReflection_UUID);
    status = IDxcUtils_CreateReflection(utils, *source, *identifier, cast(**void) *reflected);
    if status < 0 {
        _dxc_release(reflected);
        return null, false;
    }
    return reflected, reflected != null;
}

#scope_file
DXCMemory :: #import "Basic";
DXCWindows :: #import "Windows";
DXCUtf8 :: #import "Windows_Utf8";
_dxc_release :: (object: *void) {
    if object == null return;
    unknown := cast(*DXCWindows.IUnknown) object;
    unknown.vtable.Release(unknown);
}
_dxc_argument :: (arguments: *[..] *s16, argument: string) {
    if argument.count == 0 {
        empty := cast(*s16) DXCMemory.alloc(2);
        DXCMemory.assert(empty != null);
        empty.* = 0;
        DXCMemory.array_add(arguments, empty);
        return;
    }
    wide, valid, _ := DXCUtf8.utf8_to_wide(argument);
    DXCMemory.assert(valid && wide != null, "DXC argument requires valid UTF-8");
    DXCMemory.array_add(arguments, cast(*s16) wide);
}
_dxc_stage_prefix :: (kind: Shader_Type) -> string {
    if kind == .Vertex return "vs";
    if kind == .Fragment return "ps";
    if kind == .Compute return "cs";
    if kind == .Hull return "hs";
    if kind == .Domain return "ds";
    if kind == .Mesh return "ms";
    if kind == .Amplification return "as";
    DXCMemory.assert(kind == .Library, "Unsupported DXC shader stage");
    return "lib";
}
