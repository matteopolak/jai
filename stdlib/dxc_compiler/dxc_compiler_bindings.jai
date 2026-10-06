// dxcompiler COM interfaces and constants.
DXC_CP_UTF8 :: 65001;
DXC_CP_UTF16 :: 1200;
DXC_CP_UTF32 :: 12000;
DXC_CP_ACP :: 0;
DXC_CP_WIDE :: DXC_CP_UTF16;
DXC_HASHFLAG_INCLUDES_SOURCE :: 1;
DxcCreateInstanceProc :: #type (rclsid: *IID, riid: *IID, ppv: **void) -> HRESULT #c_call;
DxcCreateInstance2Proc :: #type (pMalloc: *IMalloc, rclsid: *IID, riid: *IID, ppv: **void) -> HRESULT #c_call;
DxcCreateInstance :: (rclsid: *IID, riid: *IID, ppv: **void) -> HRESULT #foreign dxcompiler;
DxcCreateInstance :: (rclsid: IID, riid: IID, ppv: **void) -> HRESULT {
    return DxcCreateInstance(*rclsid, *riid, ppv);
}
DxcCreateInstance2 :: (pMalloc: *IMalloc, rclsid: *IID, riid: *IID, ppv: **void) -> HRESULT #foreign dxcompiler;
DxcCreateInstance2 :: (pMalloc: *IMalloc, rclsid: IID, riid: IID, ppv: **void) -> HRESULT {
    return DxcCreateInstance2(pMalloc, *rclsid, *riid, ppv);
}
DxcShaderHash :: struct {
    Flags: u32;
    HashDigest: [16] u8;
}
IDxcBlob :: struct {
    #as using iunknown: IUnknown;
    #place iunknown;
    idxcblob_vtable: *IDxcBlob_VTable;
}
IDxcBlob_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    GetBufferPointer: (this: *IDxcBlob) -> *void #cpp_method;
    GetBufferSize: (this: *IDxcBlob) -> SIZE_T #cpp_method;
}
IDxcBlob_GetBufferPointer :: (this: *IDxcBlob) -> *void {
    return this.idxcblob_vtable.GetBufferPointer(this);
}
IDxcBlob_GetBufferSize :: (this: *IDxcBlob) -> SIZE_T {
    return this.idxcblob_vtable.GetBufferSize(this);
}
vtable :: (obj: *IDxcBlob) -> *IDxcBlob_VTable {
    return obj.idxcblob_vtable;
}
IDxcBlobEncoding :: struct {
    #as using idxcblob: IDxcBlob;
    #place idxcblob;
    idxcblobencoding_vtable: *IDxcBlobEncoding_VTable;
}
IDxcBlobEncoding_VTable :: struct #type_info_none {
    using idxcblob: IDxcBlob_VTable;
    GetEncoding: (this: *IDxcBlobEncoding, pKnown: *BOOL, pCodePage: *u32) -> HRESULT #cpp_method;
}
IDxcBlobEncoding_GetEncoding :: (this: *IDxcBlobEncoding, pKnown: *BOOL, pCodePage: *u32) -> HRESULT {
    return this.idxcblobencoding_vtable.GetEncoding(this, pKnown, pCodePage);
}
vtable :: (obj: *IDxcBlobEncoding) -> *IDxcBlobEncoding_VTable {
    return obj.idxcblobencoding_vtable;
}
IDxcBlobWide :: struct {
    #as using idxcblobencoding: IDxcBlobEncoding;
    #place idxcblobencoding;
    idxcblobwide_vtable: *IDxcBlobWide_VTable;
}
IDxcBlobWide_VTable :: struct #type_info_none {
    using idxcblobencoding: IDxcBlobEncoding_VTable;
    GetStringPointer: (this: *IDxcBlobWide) -> *s16 #cpp_method;
    GetStringLength: (this: *IDxcBlobWide) -> SIZE_T #cpp_method;
}
IDxcBlobWide_GetStringPointer :: (this: *IDxcBlobWide) -> *s16 {
    return this.idxcblobwide_vtable.GetStringPointer(this);
}
IDxcBlobWide_GetStringLength :: (this: *IDxcBlobWide) -> SIZE_T {
    return this.idxcblobwide_vtable.GetStringLength(this);
}
vtable :: (obj: *IDxcBlobWide) -> *IDxcBlobWide_VTable {
    return obj.idxcblobwide_vtable;
}
IDxcBlobUtf8 :: struct {
    #as using idxcblobencoding: IDxcBlobEncoding;
    #place idxcblobencoding;
    idxcblobutf8_vtable: *IDxcBlobUtf8_VTable;
}
IDxcBlobUtf8_VTable :: struct #type_info_none {
    using idxcblobencoding: IDxcBlobEncoding_VTable;
    GetStringPointer: (this: *IDxcBlobUtf8) -> *u8 #cpp_method;
    GetStringLength: (this: *IDxcBlobUtf8) -> SIZE_T #cpp_method;
}
IDxcBlobUtf8_GetStringPointer :: (this: *IDxcBlobUtf8) -> *u8 {
    return this.idxcblobutf8_vtable.GetStringPointer(this);
}
IDxcBlobUtf8_GetStringLength :: (this: *IDxcBlobUtf8) -> SIZE_T {
    return this.idxcblobutf8_vtable.GetStringLength(this);
}
vtable :: (obj: *IDxcBlobUtf8) -> *IDxcBlobUtf8_VTable {
    return obj.idxcblobutf8_vtable;
}
IDxcBlobUtf16 :: IDxcBlobWide;
IDxcIncludeHandler :: struct {
    #as using iunknown: IUnknown;
    #place iunknown;
    idxcincludehandler_vtable: *IDxcIncludeHandler_VTable;
}
IDxcIncludeHandler_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    LoadSource: (this: *IDxcIncludeHandler, pFilename: *s16, ppIncludeSource: **IDxcBlob) -> HRESULT #cpp_method;
}
IDxcIncludeHandler_LoadSource :: (this: *IDxcIncludeHandler, pFilename: *s16, ppIncludeSource: **IDxcBlob) -> HRESULT {
    return this.idxcincludehandler_vtable.LoadSource(this, pFilename, ppIncludeSource);
}
vtable :: (obj: *IDxcIncludeHandler) -> *IDxcIncludeHandler_VTable {
    return obj.idxcincludehandler_vtable;
}
DxcBuffer :: struct {
    Ptr: *void;
    Size: SIZE_T;
    Encoding: u32;
}
DxcText :: DxcBuffer;
DxcDefine :: struct {
    Name: *s16;
    Value: *s16;
}
IDxcCompilerArgs :: struct {
    #as using iunknown: IUnknown;
    #place iunknown;
    idxccompilerargs_vtable: *IDxcCompilerArgs_VTable;
}
IDxcCompilerArgs_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    GetArguments: (this: *IDxcCompilerArgs) -> **s16 #cpp_method;
    GetCount: (this: *IDxcCompilerArgs) -> u32 #cpp_method;
    AddArguments: (this: *IDxcCompilerArgs, pArguments: **s16, argCount: u32) -> HRESULT #cpp_method;
    AddArgumentsUTF8: (this: *IDxcCompilerArgs, pArguments: **u8, argCount: u32) -> HRESULT #cpp_method;
    AddDefines: (this: *IDxcCompilerArgs, pDefines: *DxcDefine, defineCount: u32) -> HRESULT #cpp_method;
}
IDxcCompilerArgs_GetArguments :: (this: *IDxcCompilerArgs) -> **s16 {
    return this.idxccompilerargs_vtable.GetArguments(this);
}
IDxcCompilerArgs_GetCount :: (this: *IDxcCompilerArgs) -> u32 {
    return this.idxccompilerargs_vtable.GetCount(this);
}
IDxcCompilerArgs_AddArguments :: (this: *IDxcCompilerArgs, pArguments: **s16, argCount: u32) -> HRESULT {
    return this.idxccompilerargs_vtable.AddArguments(this, pArguments, argCount);
}
IDxcCompilerArgs_AddArgumentsUTF8 :: (this: *IDxcCompilerArgs, pArguments: **u8, argCount: u32) -> HRESULT {
    return this.idxccompilerargs_vtable.AddArgumentsUTF8(this, pArguments, argCount);
}
IDxcCompilerArgs_AddDefines :: (this: *IDxcCompilerArgs, pDefines: *DxcDefine, defineCount: u32) -> HRESULT {
    return this.idxccompilerargs_vtable.AddDefines(this, pDefines, defineCount);
}
vtable :: (obj: *IDxcCompilerArgs) -> *IDxcCompilerArgs_VTable {
    return obj.idxccompilerargs_vtable;
}
IDxcLibrary :: struct {
    #as using iunknown: IUnknown;
    #place iunknown;
    idxclibrary_vtable: *IDxcLibrary_VTable;
}
IDxcLibrary_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    SetMalloc: (this: *IDxcLibrary, pMalloc: *IMalloc) -> HRESULT #cpp_method;
    CreateBlobFromBlob: (this: *IDxcLibrary, pBlob: *IDxcBlob, offset: u32, length: u32, ppResult: **IDxcBlob) -> HRESULT #cpp_method;
    CreateBlobFromFile: (this: *IDxcLibrary, pFileName: *s16, codePage: *u32, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    CreateBlobWithEncodingFromPinned: (this: *IDxcLibrary, pText: *void, size: u32, codePage: u32, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    CreateBlobWithEncodingOnHeapCopy: (this: *IDxcLibrary, pText: *void, size: u32, codePage: u32, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    CreateBlobWithEncodingOnMalloc: (this: *IDxcLibrary, pText: *void, pIMalloc: *IMalloc, size: u32, codePage: u32, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    CreateIncludeHandler: (this: *IDxcLibrary, ppResult: **IDxcIncludeHandler) -> HRESULT #cpp_method;
    CreateStreamFromBlobReadOnly: (this: *IDxcLibrary, pBlob: *IDxcBlob, ppStream: **IStream) -> HRESULT #cpp_method;
    GetBlobAsUtf8: (this: *IDxcLibrary, pBlob: *IDxcBlob, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    GetBlobAsWide: (this: *IDxcLibrary, pBlob: *IDxcBlob, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
}
IDxcLibrary_SetMalloc :: (this: *IDxcLibrary, pMalloc: *IMalloc) -> HRESULT {
    return this.idxclibrary_vtable.SetMalloc(this, pMalloc);
}
IDxcLibrary_CreateBlobFromBlob :: (this: *IDxcLibrary, pBlob: *IDxcBlob, offset: u32, length: u32, ppResult: **IDxcBlob) -> HRESULT {
    return this.idxclibrary_vtable.CreateBlobFromBlob(this, pBlob, offset, length, ppResult);
}
IDxcLibrary_CreateBlobFromFile :: (this: *IDxcLibrary, pFileName: *s16, codePage: *u32, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT {
    return this.idxclibrary_vtable.CreateBlobFromFile(this, pFileName, codePage, pBlobEncoding);
}
IDxcLibrary_CreateBlobWithEncodingFromPinned :: (this: *IDxcLibrary, pText: *void, size: u32, codePage: u32, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT {
    return this.idxclibrary_vtable.CreateBlobWithEncodingFromPinned(this, pText, size, codePage, pBlobEncoding);
}
IDxcLibrary_CreateBlobWithEncodingOnHeapCopy :: (this: *IDxcLibrary, pText: *void, size: u32, codePage: u32, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT {
    return this.idxclibrary_vtable.CreateBlobWithEncodingOnHeapCopy(this, pText, size, codePage, pBlobEncoding);
}
IDxcLibrary_CreateBlobWithEncodingOnMalloc :: (this: *IDxcLibrary, pText: *void, pIMalloc: *IMalloc, size: u32, codePage: u32, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT {
    return this.idxclibrary_vtable.CreateBlobWithEncodingOnMalloc(this, pText, pIMalloc, size, codePage, pBlobEncoding);
}
IDxcLibrary_CreateIncludeHandler :: (this: *IDxcLibrary, ppResult: **IDxcIncludeHandler) -> HRESULT {
    return this.idxclibrary_vtable.CreateIncludeHandler(this, ppResult);
}
IDxcLibrary_CreateStreamFromBlobReadOnly :: (this: *IDxcLibrary, pBlob: *IDxcBlob, ppStream: **IStream) -> HRESULT {
    return this.idxclibrary_vtable.CreateStreamFromBlobReadOnly(this, pBlob, ppStream);
}
IDxcLibrary_GetBlobAsUtf8 :: (this: *IDxcLibrary, pBlob: *IDxcBlob, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT {
    return this.idxclibrary_vtable.GetBlobAsUtf8(this, pBlob, pBlobEncoding);
}
IDxcLibrary_GetBlobAsWide :: (this: *IDxcLibrary, pBlob: *IDxcBlob, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT {
    return this.idxclibrary_vtable.GetBlobAsWide(this, pBlob, pBlobEncoding);
}
vtable :: (obj: *IDxcLibrary) -> *IDxcLibrary_VTable {
    return obj.idxclibrary_vtable;
}
IDxcOperationResult :: struct {
    #as using iunknown: IUnknown;
    #place iunknown;
    idxcoperationresult_vtable: *IDxcOperationResult_VTable;
}
IDxcOperationResult_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    GetStatus: (this: *IDxcOperationResult, pStatus: *HRESULT) -> HRESULT #cpp_method;
    GetResult: (this: *IDxcOperationResult, ppResult: **IDxcBlob) -> HRESULT #cpp_method;
    GetErrorBuffer: (this: *IDxcOperationResult, ppErrors: **IDxcBlobEncoding) -> HRESULT #cpp_method;
}
IDxcOperationResult_GetStatus :: (this: *IDxcOperationResult, pStatus: *HRESULT) -> HRESULT {
    return this.idxcoperationresult_vtable.GetStatus(this, pStatus);
}
IDxcOperationResult_GetResult :: (this: *IDxcOperationResult, ppResult: **IDxcBlob) -> HRESULT {
    return this.idxcoperationresult_vtable.GetResult(this, ppResult);
}
IDxcOperationResult_GetErrorBuffer :: (this: *IDxcOperationResult, ppErrors: **IDxcBlobEncoding) -> HRESULT {
    return this.idxcoperationresult_vtable.GetErrorBuffer(this, ppErrors);
}
vtable :: (obj: *IDxcOperationResult) -> *IDxcOperationResult_VTable {
    return obj.idxcoperationresult_vtable;
}
IDxcCompiler :: struct {
    #as using iunknown: IUnknown;
    #place iunknown;
    idxccompiler_vtable: *IDxcCompiler_VTable;
}
IDxcCompiler_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    Compile: (this: *IDxcCompiler, pSource: *IDxcBlob, pSourceName: *s16, pEntryPoint: *s16, pTargetProfile: *s16, pArguments: **s16, argCount: u32, pDefines: *DxcDefine, defineCount: u32, pIncludeHandler: *IDxcIncludeHandler, ppResult: **IDxcOperationResult) -> HRESULT #cpp_method;
    Preprocess: (this: *IDxcCompiler, pSource: *IDxcBlob, pSourceName: *s16, pArguments: **s16, argCount: u32, pDefines: *DxcDefine, defineCount: u32, pIncludeHandler: *IDxcIncludeHandler, ppResult: **IDxcOperationResult) -> HRESULT #cpp_method;
    Disassemble: (this: *IDxcCompiler, pSource: *IDxcBlob, ppDisassembly: **IDxcBlobEncoding) -> HRESULT #cpp_method;
}
IDxcCompiler_Compile :: (this: *IDxcCompiler, pSource: *IDxcBlob, pSourceName: *s16, pEntryPoint: *s16, pTargetProfile: *s16, pArguments: **s16, argCount: u32, pDefines: *DxcDefine, defineCount: u32, pIncludeHandler: *IDxcIncludeHandler, ppResult: **IDxcOperationResult) -> HRESULT {
    return this.idxccompiler_vtable.Compile(this, pSource, pSourceName, pEntryPoint, pTargetProfile, pArguments, argCount, pDefines, defineCount, pIncludeHandler, ppResult);
}
IDxcCompiler_Preprocess :: (this: *IDxcCompiler, pSource: *IDxcBlob, pSourceName: *s16, pArguments: **s16, argCount: u32, pDefines: *DxcDefine, defineCount: u32, pIncludeHandler: *IDxcIncludeHandler, ppResult: **IDxcOperationResult) -> HRESULT {
    return this.idxccompiler_vtable.Preprocess(this, pSource, pSourceName, pArguments, argCount, pDefines, defineCount, pIncludeHandler, ppResult);
}
IDxcCompiler_Disassemble :: (this: *IDxcCompiler, pSource: *IDxcBlob, ppDisassembly: **IDxcBlobEncoding) -> HRESULT {
    return this.idxccompiler_vtable.Disassemble(this, pSource, ppDisassembly);
}
vtable :: (obj: *IDxcCompiler) -> *IDxcCompiler_VTable {
    return obj.idxccompiler_vtable;
}
IDxcCompiler2 :: struct {
    #as using idxccompiler: IDxcCompiler;
    #place idxccompiler;
    idxccompiler2_vtable: *IDxcCompiler2_VTable;
}
IDxcCompiler2_VTable :: struct #type_info_none {
    using idxccompiler: IDxcCompiler_VTable;
    CompileWithDebug: (this: *IDxcCompiler2, pSource: *IDxcBlob, pSourceName: *s16, pEntryPoint: *s16, pTargetProfile: *s16, pArguments: **s16, argCount: u32, pDefines: *DxcDefine, defineCount: u32, pIncludeHandler: *IDxcIncludeHandler, ppResult: **IDxcOperationResult, ppDebugBlobName: **s16, ppDebugBlob: **IDxcBlob) -> HRESULT #cpp_method;
}
IDxcCompiler2_CompileWithDebug :: (this: *IDxcCompiler2, pSource: *IDxcBlob, pSourceName: *s16, pEntryPoint: *s16, pTargetProfile: *s16, pArguments: **s16, argCount: u32, pDefines: *DxcDefine, defineCount: u32, pIncludeHandler: *IDxcIncludeHandler, ppResult: **IDxcOperationResult, ppDebugBlobName: **s16, ppDebugBlob: **IDxcBlob) -> HRESULT {
    return this.idxccompiler2_vtable.CompileWithDebug(this, pSource, pSourceName, pEntryPoint, pTargetProfile, pArguments, argCount, pDefines, defineCount, pIncludeHandler, ppResult, ppDebugBlobName, ppDebugBlob);
}
vtable :: (obj: *IDxcCompiler2) -> *IDxcCompiler2_VTable {
    return obj.idxccompiler2_vtable;
}
IDxcLinker :: struct {
    #as using iunknown: IUnknown;
    #place iunknown;
    idxclinker_vtable: *IDxcLinker_VTable;
}
IDxcLinker_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    RegisterLibrary: (this: *IDxcLinker, pLibName: *s16, pLib: *IDxcBlob) -> HRESULT #cpp_method;
    Link: (this: *IDxcLinker, pEntryName: *s16, pTargetProfile: *s16, pLibNames: **s16, libCount: u32, pArguments: **s16, argCount: u32, ppResult: **IDxcOperationResult) -> HRESULT #cpp_method;
}
IDxcLinker_RegisterLibrary :: (this: *IDxcLinker, pLibName: *s16, pLib: *IDxcBlob) -> HRESULT {
    return this.idxclinker_vtable.RegisterLibrary(this, pLibName, pLib);
}
IDxcLinker_Link :: (this: *IDxcLinker, pEntryName: *s16, pTargetProfile: *s16, pLibNames: **s16, libCount: u32, pArguments: **s16, argCount: u32, ppResult: **IDxcOperationResult) -> HRESULT {
    return this.idxclinker_vtable.Link(this, pEntryName, pTargetProfile, pLibNames, libCount, pArguments, argCount, ppResult);
}
vtable :: (obj: *IDxcLinker) -> *IDxcLinker_VTable {
    return obj.idxclinker_vtable;
}
IDxcUtils :: struct {
    #as using iunknown: IUnknown;
    #place iunknown;
    idxcutils_vtable: *IDxcUtils_VTable;
}
IDxcUtils_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    CreateBlobFromBlob: (this: *IDxcUtils, pBlob: *IDxcBlob, offset: u32, length: u32, ppResult: **IDxcBlob) -> HRESULT #cpp_method;
    CreateBlobFromPinned: (this: *IDxcUtils, pData: *void, size: u32, codePage: u32, ppBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    MoveToBlob: (this: *IDxcUtils, pData: *void, pIMalloc: *IMalloc, size: u32, codePage: u32, ppBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    CreateBlob: (this: *IDxcUtils, pData: *void, size: u32, codePage: u32, ppBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    LoadFile: (this: *IDxcUtils, pFileName: *s16, pCodePage: *u32, ppBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    CreateReadOnlyStreamFromBlob: (this: *IDxcUtils, pBlob: *IDxcBlob, ppStream: **IStream) -> HRESULT #cpp_method;
    CreateDefaultIncludeHandler: (this: *IDxcUtils, ppResult: **IDxcIncludeHandler) -> HRESULT #cpp_method;
    GetBlobAsUtf8: (this: *IDxcUtils, pBlob: *IDxcBlob, ppBlobEncoding: **IDxcBlobUtf8) -> HRESULT #cpp_method;
    GetBlobAsWide: (this: *IDxcUtils, pBlob: *IDxcBlob, ppBlobEncoding: **IDxcBlobWide) -> HRESULT #cpp_method;
    GetDxilContainerPart: (this: *IDxcUtils, pShader: *DxcBuffer, DxcPart: u32, ppPartData: **void, pPartSizeInBytes: *u32) -> HRESULT #cpp_method;
    CreateReflection: (this: *IDxcUtils, pData: *DxcBuffer, iid: *IID, ppvReflection: **void) -> HRESULT #cpp_method;
    BuildArguments: (this: *IDxcUtils, pSourceName: *s16, pEntryPoint: *s16, pTargetProfile: *s16, pArguments: **s16, argCount: u32, pDefines: *DxcDefine, defineCount: u32, ppArgs: **IDxcCompilerArgs) -> HRESULT #cpp_method;
    GetPDBContents: (this: *IDxcUtils, pPDBBlob: *IDxcBlob, ppHash: **IDxcBlob, ppContainer: **IDxcBlob) -> HRESULT #cpp_method;
}
IDxcUtils_CreateBlobFromBlob :: (this: *IDxcUtils, pBlob: *IDxcBlob, offset: u32, length: u32, ppResult: **IDxcBlob) -> HRESULT {
    return this.idxcutils_vtable.CreateBlobFromBlob(this, pBlob, offset, length, ppResult);
}
IDxcUtils_CreateBlobFromPinned :: (this: *IDxcUtils, pData: *void, size: u32, codePage: u32, ppBlobEncoding: **IDxcBlobEncoding) -> HRESULT {
    return this.idxcutils_vtable.CreateBlobFromPinned(this, pData, size, codePage, ppBlobEncoding);
}
IDxcUtils_MoveToBlob :: (this: *IDxcUtils, pData: *void, pIMalloc: *IMalloc, size: u32, codePage: u32, ppBlobEncoding: **IDxcBlobEncoding) -> HRESULT {
    return this.idxcutils_vtable.MoveToBlob(this, pData, pIMalloc, size, codePage, ppBlobEncoding);
}
IDxcUtils_CreateBlob :: (this: *IDxcUtils, pData: *void, size: u32, codePage: u32, ppBlobEncoding: **IDxcBlobEncoding) -> HRESULT {
    return this.idxcutils_vtable.CreateBlob(this, pData, size, codePage, ppBlobEncoding);
}
IDxcUtils_LoadFile :: (this: *IDxcUtils, pFileName: *s16, pCodePage: *u32, ppBlobEncoding: **IDxcBlobEncoding) -> HRESULT {
    return this.idxcutils_vtable.LoadFile(this, pFileName, pCodePage, ppBlobEncoding);
}
IDxcUtils_CreateReadOnlyStreamFromBlob :: (this: *IDxcUtils, pBlob: *IDxcBlob, ppStream: **IStream) -> HRESULT {
    return this.idxcutils_vtable.CreateReadOnlyStreamFromBlob(this, pBlob, ppStream);
}
IDxcUtils_CreateDefaultIncludeHandler :: (this: *IDxcUtils, ppResult: **IDxcIncludeHandler) -> HRESULT {
    return this.idxcutils_vtable.CreateDefaultIncludeHandler(this, ppResult);
}
IDxcUtils_GetBlobAsUtf8 :: (this: *IDxcUtils, pBlob: *IDxcBlob, ppBlobEncoding: **IDxcBlobUtf8) -> HRESULT {
    return this.idxcutils_vtable.GetBlobAsUtf8(this, pBlob, ppBlobEncoding);
}
IDxcUtils_GetBlobAsWide :: (this: *IDxcUtils, pBlob: *IDxcBlob, ppBlobEncoding: **IDxcBlobWide) -> HRESULT {
    return this.idxcutils_vtable.GetBlobAsWide(this, pBlob, ppBlobEncoding);
}
IDxcUtils_GetDxilContainerPart :: (this: *IDxcUtils, pShader: *DxcBuffer, DxcPart: u32, ppPartData: **void, pPartSizeInBytes: *u32) -> HRESULT {
    return this.idxcutils_vtable.GetDxilContainerPart(this, pShader, DxcPart, ppPartData, pPartSizeInBytes);
}
IDxcUtils_CreateReflection :: (this: *IDxcUtils, pData: *DxcBuffer, iid: *IID, ppvReflection: **void) -> HRESULT {
    return this.idxcutils_vtable.CreateReflection(this, pData, iid, ppvReflection);
}
IDxcUtils_BuildArguments :: (this: *IDxcUtils, pSourceName: *s16, pEntryPoint: *s16, pTargetProfile: *s16, pArguments: **s16, argCount: u32, pDefines: *DxcDefine, defineCount: u32, ppArgs: **IDxcCompilerArgs) -> HRESULT {
    return this.idxcutils_vtable.BuildArguments(this, pSourceName, pEntryPoint, pTargetProfile, pArguments, argCount, pDefines, defineCount, ppArgs);
}
IDxcUtils_GetPDBContents :: (this: *IDxcUtils, pPDBBlob: *IDxcBlob, ppHash: **IDxcBlob, ppContainer: **IDxcBlob) -> HRESULT {
    return this.idxcutils_vtable.GetPDBContents(this, pPDBBlob, ppHash, ppContainer);
}
vtable :: (obj: *IDxcUtils) -> *IDxcUtils_VTable {
    return obj.idxcutils_vtable;
}
DXC_OUT_KIND :: enum s32 {
    NONE :: 0;
    OBJECT :: 1;
    ERRORS :: 2;
    PDB :: 3;
    SHADER_HASH :: 4;
    DISASSEMBLY :: 5;
    HLSL :: 6;
    TEXT :: 7;
    REFLECTION :: 8;
    ROOT_SIGNATURE :: 9;
    EXTRA_OUTPUTS :: 10;
    REMARKS :: 11;
    TIME_REPORT :: 12;
    TIME_TRACE :: 13;
    LAST :: 13;
    NUM_ENUMS :: 14;
    FORCE_DWORD :: -1;
    DXC_OUT_NONE :: NONE;
    DXC_OUT_OBJECT :: OBJECT;
    DXC_OUT_ERRORS :: ERRORS;
    DXC_OUT_PDB :: PDB;
    DXC_OUT_SHADER_HASH :: SHADER_HASH;
    DXC_OUT_DISASSEMBLY :: DISASSEMBLY;
    DXC_OUT_HLSL :: HLSL;
    DXC_OUT_TEXT :: TEXT;
    DXC_OUT_REFLECTION :: REFLECTION;
    DXC_OUT_ROOT_SIGNATURE :: ROOT_SIGNATURE;
    DXC_OUT_EXTRA_OUTPUTS :: EXTRA_OUTPUTS;
    DXC_OUT_REMARKS :: REMARKS;
    DXC_OUT_TIME_REPORT :: TIME_REPORT;
    DXC_OUT_TIME_TRACE :: TIME_TRACE;
    DXC_OUT_LAST :: LAST;
    DXC_OUT_NUM_ENUMS :: NUM_ENUMS;
    DXC_OUT_FORCE_DWORD :: FORCE_DWORD;
}
IDxcResult :: struct {
    #as using idxcoperationresult: IDxcOperationResult;
    #place idxcoperationresult;
    idxcresult_vtable: *IDxcResult_VTable;
}
IDxcResult_VTable :: struct #type_info_none {
    using idxcoperationresult: IDxcOperationResult_VTable;
    HasOutput: (this: *IDxcResult, dxcOutKind: DXC_OUT_KIND) -> BOOL #cpp_method;
    GetOutput: (this: *IDxcResult, dxcOutKind: DXC_OUT_KIND, iid: *IID, ppvObject: **void, ppOutputName: **IDxcBlobWide) -> HRESULT #cpp_method;
    GetNumOutputs: (this: *IDxcResult) -> u32 #cpp_method;
    GetOutputByIndex: (this: *IDxcResult, Index: u32) -> DXC_OUT_KIND #cpp_method;
    PrimaryOutput: (this: *IDxcResult) -> DXC_OUT_KIND #cpp_method;
}
IDxcResult_HasOutput :: (this: *IDxcResult, dxcOutKind: DXC_OUT_KIND) -> BOOL {
    return this.idxcresult_vtable.HasOutput(this, dxcOutKind);
}
IDxcResult_GetOutput :: (this: *IDxcResult, dxcOutKind: DXC_OUT_KIND, iid: *IID, ppvObject: **void, ppOutputName: **IDxcBlobWide) -> HRESULT {
    return this.idxcresult_vtable.GetOutput(this, dxcOutKind, iid, ppvObject, ppOutputName);
}
IDxcResult_GetNumOutputs :: (this: *IDxcResult) -> u32 {
    return this.idxcresult_vtable.GetNumOutputs(this);
}
IDxcResult_GetOutputByIndex :: (this: *IDxcResult, Index: u32) -> DXC_OUT_KIND {
    return this.idxcresult_vtable.GetOutputByIndex(this, Index);
}
IDxcResult_PrimaryOutput :: (this: *IDxcResult) -> DXC_OUT_KIND {
    return this.idxcresult_vtable.PrimaryOutput(this);
}
vtable :: (obj: *IDxcResult) -> *IDxcResult_VTable {
    return obj.idxcresult_vtable;
}
IDxcExtraOutputs :: struct {
    #as using iunknown: IUnknown;
    #place iunknown;
    idxcextraoutputs_vtable: *IDxcExtraOutputs_VTable;
}
IDxcExtraOutputs_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    GetOutputCount: (this: *IDxcExtraOutputs) -> u32 #cpp_method;
    GetOutput: (this: *IDxcExtraOutputs, uIndex: u32, iid: *IID, ppvObject: **void, ppOutputType: **IDxcBlobWide, ppOutputName: **IDxcBlobWide) -> HRESULT #cpp_method;
}
IDxcExtraOutputs_GetOutputCount :: (this: *IDxcExtraOutputs) -> u32 {
    return this.idxcextraoutputs_vtable.GetOutputCount(this);
}
IDxcExtraOutputs_GetOutput :: (this: *IDxcExtraOutputs, uIndex: u32, iid: *IID, ppvObject: **void, ppOutputType: **IDxcBlobWide, ppOutputName: **IDxcBlobWide) -> HRESULT {
    return this.idxcextraoutputs_vtable.GetOutput(this, uIndex, iid, ppvObject, ppOutputType, ppOutputName);
}
vtable :: (obj: *IDxcExtraOutputs) -> *IDxcExtraOutputs_VTable {
    return obj.idxcextraoutputs_vtable;
}
IDxcCompiler3 :: struct {
    #as using iunknown: IUnknown;
    #place iunknown;
    idxccompiler3_vtable: *IDxcCompiler3_VTable;
}
IDxcCompiler3_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    Compile: (this: *IDxcCompiler3, pSource: *DxcBuffer, pArguments: **s16, argCount: u32, pIncludeHandler: *IDxcIncludeHandler, riid: *IID, ppResult: **void) -> HRESULT #cpp_method;
    Disassemble: (this: *IDxcCompiler3, pObject: *DxcBuffer, riid: *IID, ppResult: **void) -> HRESULT #cpp_method;
}
IDxcCompiler3_Compile :: (this: *IDxcCompiler3, pSource: *DxcBuffer, pArguments: **s16, argCount: u32, pIncludeHandler: *IDxcIncludeHandler, riid: *IID, ppResult: **void) -> HRESULT {
    return this.idxccompiler3_vtable.Compile(this, pSource, pArguments, argCount, pIncludeHandler, riid, ppResult);
}
IDxcCompiler3_Disassemble :: (this: *IDxcCompiler3, pObject: *DxcBuffer, riid: *IID, ppResult: **void) -> HRESULT {
    return this.idxccompiler3_vtable.Disassemble(this, pObject, riid, ppResult);
}
vtable :: (obj: *IDxcCompiler3) -> *IDxcCompiler3_VTable {
    return obj.idxccompiler3_vtable;
}
DxcValidatorFlags_Default: u32 : 0;
DxcValidatorFlags_InPlaceEdit: u32 : 1;
DxcValidatorFlags_RootSignatureOnly: u32 : 2;
DxcValidatorFlags_ModuleOnly: u32 : 4;
DxcValidatorFlags_ValidMask: u32 : 7;
IDxcValidator :: struct {
    #as using iunknown: IUnknown;
    #place iunknown;
    idxcvalidator_vtable: *IDxcValidator_VTable;
}
IDxcValidator_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    Validate: (this: *IDxcValidator, pShader: *IDxcBlob, Flags: u32, ppResult: **IDxcOperationResult) -> HRESULT #cpp_method;
}
IDxcValidator_Validate :: (this: *IDxcValidator, pShader: *IDxcBlob, Flags: u32, ppResult: **IDxcOperationResult) -> HRESULT {
    return this.idxcvalidator_vtable.Validate(this, pShader, Flags, ppResult);
}
vtable :: (obj: *IDxcValidator) -> *IDxcValidator_VTable {
    return obj.idxcvalidator_vtable;
}
IDxcValidator2 :: struct {
    #as using idxcvalidator: IDxcValidator;
    #place idxcvalidator;
    idxcvalidator2_vtable: *IDxcValidator2_VTable;
}
IDxcValidator2_VTable :: struct #type_info_none {
    using idxcvalidator: IDxcValidator_VTable;
    ValidateWithDebug: (this: *IDxcValidator2, pShader: *IDxcBlob, Flags: u32, pOptDebugBitcode: *DxcBuffer, ppResult: **IDxcOperationResult) -> HRESULT #cpp_method;
}
IDxcValidator2_ValidateWithDebug :: (this: *IDxcValidator2, pShader: *IDxcBlob, Flags: u32, pOptDebugBitcode: *DxcBuffer, ppResult: **IDxcOperationResult) -> HRESULT {
    return this.idxcvalidator2_vtable.ValidateWithDebug(this, pShader, Flags, pOptDebugBitcode, ppResult);
}
vtable :: (obj: *IDxcValidator2) -> *IDxcValidator2_VTable {
    return obj.idxcvalidator2_vtable;
}
IDxcContainerBuilder :: struct {
    #as using iunknown: IUnknown;
    #place iunknown;
    idxccontainerbuilder_vtable: *IDxcContainerBuilder_VTable;
}
IDxcContainerBuilder_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    Load: (this: *IDxcContainerBuilder, pDxilContainerHeader: *IDxcBlob) -> HRESULT #cpp_method;
    AddPart: (this: *IDxcContainerBuilder, fourCC: u32, pSource: *IDxcBlob) -> HRESULT #cpp_method;
    RemovePart: (this: *IDxcContainerBuilder, fourCC: u32) -> HRESULT #cpp_method;
    SerializeContainer: (this: *IDxcContainerBuilder, ppResult: **IDxcOperationResult) -> HRESULT #cpp_method;
}
IDxcContainerBuilder_Load :: (this: *IDxcContainerBuilder, pDxilContainerHeader: *IDxcBlob) -> HRESULT {
    return this.idxccontainerbuilder_vtable.Load(this, pDxilContainerHeader);
}
IDxcContainerBuilder_AddPart :: (this: *IDxcContainerBuilder, fourCC: u32, pSource: *IDxcBlob) -> HRESULT {
    return this.idxccontainerbuilder_vtable.AddPart(this, fourCC, pSource);
}
IDxcContainerBuilder_RemovePart :: (this: *IDxcContainerBuilder, fourCC: u32) -> HRESULT {
    return this.idxccontainerbuilder_vtable.RemovePart(this, fourCC);
}
IDxcContainerBuilder_SerializeContainer :: (this: *IDxcContainerBuilder, ppResult: **IDxcOperationResult) -> HRESULT {
    return this.idxccontainerbuilder_vtable.SerializeContainer(this, ppResult);
}
vtable :: (obj: *IDxcContainerBuilder) -> *IDxcContainerBuilder_VTable {
    return obj.idxccontainerbuilder_vtable;
}
IDxcAssembler :: struct {
    #as using iunknown: IUnknown;
    #place iunknown;
    idxcassembler_vtable: *IDxcAssembler_VTable;
}
IDxcAssembler_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    AssembleToContainer: (this: *IDxcAssembler, pShader: *IDxcBlob, ppResult: **IDxcOperationResult) -> HRESULT #cpp_method;
}
IDxcAssembler_AssembleToContainer :: (this: *IDxcAssembler, pShader: *IDxcBlob, ppResult: **IDxcOperationResult) -> HRESULT {
    return this.idxcassembler_vtable.AssembleToContainer(this, pShader, ppResult);
}
vtable :: (obj: *IDxcAssembler) -> *IDxcAssembler_VTable {
    return obj.idxcassembler_vtable;
}
IDxcContainerReflection :: struct {
    #as using iunknown: IUnknown;
    #place iunknown;
    idxccontainerreflection_vtable: *IDxcContainerReflection_VTable;
}
IDxcContainerReflection_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    Load: (this: *IDxcContainerReflection, pContainer: *IDxcBlob) -> HRESULT #cpp_method;
    GetPartCount: (this: *IDxcContainerReflection, pResult: *u32) -> HRESULT #cpp_method;
    GetPartKind: (this: *IDxcContainerReflection, idx: u32, pResult: *u32) -> HRESULT #cpp_method;
    GetPartContent: (this: *IDxcContainerReflection, idx: u32, ppResult: **IDxcBlob) -> HRESULT #cpp_method;
    FindFirstPartKind: (this: *IDxcContainerReflection, kind: u32, pResult: *u32) -> HRESULT #cpp_method;
    GetPartReflection: (this: *IDxcContainerReflection, idx: u32, iid: *IID, ppvObject: **void) -> HRESULT #cpp_method;
}
IDxcContainerReflection_Load :: (this: *IDxcContainerReflection, pContainer: *IDxcBlob) -> HRESULT {
    return this.idxccontainerreflection_vtable.Load(this, pContainer);
}
IDxcContainerReflection_GetPartCount :: (this: *IDxcContainerReflection, pResult: *u32) -> HRESULT {
    return this.idxccontainerreflection_vtable.GetPartCount(this, pResult);
}
IDxcContainerReflection_GetPartKind :: (this: *IDxcContainerReflection, idx: u32, pResult: *u32) -> HRESULT {
    return this.idxccontainerreflection_vtable.GetPartKind(this, idx, pResult);
}
IDxcContainerReflection_GetPartContent :: (this: *IDxcContainerReflection, idx: u32, ppResult: **IDxcBlob) -> HRESULT {
    return this.idxccontainerreflection_vtable.GetPartContent(this, idx, ppResult);
}
IDxcContainerReflection_FindFirstPartKind :: (this: *IDxcContainerReflection, kind: u32, pResult: *u32) -> HRESULT {
    return this.idxccontainerreflection_vtable.FindFirstPartKind(this, kind, pResult);
}
IDxcContainerReflection_GetPartReflection :: (this: *IDxcContainerReflection, idx: u32, iid: *IID, ppvObject: **void) -> HRESULT {
    return this.idxccontainerreflection_vtable.GetPartReflection(this, idx, iid, ppvObject);
}
vtable :: (obj: *IDxcContainerReflection) -> *IDxcContainerReflection_VTable {
    return obj.idxccontainerreflection_vtable;
}
IDxcOptimizerPass :: struct {
    #as using iunknown: IUnknown;
    #place iunknown;
    idxcoptimizerpass_vtable: *IDxcOptimizerPass_VTable;
}
IDxcOptimizerPass_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    GetOptionName: (this: *IDxcOptimizerPass, ppResult: **s16) -> HRESULT #cpp_method;
    GetDescription: (this: *IDxcOptimizerPass, ppResult: **s16) -> HRESULT #cpp_method;
    GetOptionArgCount: (this: *IDxcOptimizerPass, pCount: *u32) -> HRESULT #cpp_method;
    GetOptionArgName: (this: *IDxcOptimizerPass, argIndex: u32, ppResult: **s16) -> HRESULT #cpp_method;
    GetOptionArgDescription: (this: *IDxcOptimizerPass, argIndex: u32, ppResult: **s16) -> HRESULT #cpp_method;
}
IDxcOptimizerPass_GetOptionName :: (this: *IDxcOptimizerPass, ppResult: **s16) -> HRESULT {
    return this.idxcoptimizerpass_vtable.GetOptionName(this, ppResult);
}
IDxcOptimizerPass_GetDescription :: (this: *IDxcOptimizerPass, ppResult: **s16) -> HRESULT {
    return this.idxcoptimizerpass_vtable.GetDescription(this, ppResult);
}
IDxcOptimizerPass_GetOptionArgCount :: (this: *IDxcOptimizerPass, pCount: *u32) -> HRESULT {
    return this.idxcoptimizerpass_vtable.GetOptionArgCount(this, pCount);
}
IDxcOptimizerPass_GetOptionArgName :: (this: *IDxcOptimizerPass, argIndex: u32, ppResult: **s16) -> HRESULT {
    return this.idxcoptimizerpass_vtable.GetOptionArgName(this, argIndex, ppResult);
}
IDxcOptimizerPass_GetOptionArgDescription :: (this: *IDxcOptimizerPass, argIndex: u32, ppResult: **s16) -> HRESULT {
    return this.idxcoptimizerpass_vtable.GetOptionArgDescription(this, argIndex, ppResult);
}
vtable :: (obj: *IDxcOptimizerPass) -> *IDxcOptimizerPass_VTable {
    return obj.idxcoptimizerpass_vtable;
}
IDxcOptimizer :: struct {
    #as using iunknown: IUnknown;
    #place iunknown;
    idxcoptimizer_vtable: *IDxcOptimizer_VTable;
}
IDxcOptimizer_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    GetAvailablePassCount: (this: *IDxcOptimizer, pCount: *u32) -> HRESULT #cpp_method;
    GetAvailablePass: (this: *IDxcOptimizer, index: u32, ppResult: **IDxcOptimizerPass) -> HRESULT #cpp_method;
    RunOptimizer: (this: *IDxcOptimizer, pBlob: *IDxcBlob, ppOptions: **s16, optionCount: u32, pOutputModule: **IDxcBlob, ppOutputText: **IDxcBlobEncoding) -> HRESULT #cpp_method;
}
IDxcOptimizer_GetAvailablePassCount :: (this: *IDxcOptimizer, pCount: *u32) -> HRESULT {
    return this.idxcoptimizer_vtable.GetAvailablePassCount(this, pCount);
}
IDxcOptimizer_GetAvailablePass :: (this: *IDxcOptimizer, index: u32, ppResult: **IDxcOptimizerPass) -> HRESULT {
    return this.idxcoptimizer_vtable.GetAvailablePass(this, index, ppResult);
}
IDxcOptimizer_RunOptimizer :: (this: *IDxcOptimizer, pBlob: *IDxcBlob, ppOptions: **s16, optionCount: u32, pOutputModule: **IDxcBlob, ppOutputText: **IDxcBlobEncoding) -> HRESULT {
    return this.idxcoptimizer_vtable.RunOptimizer(this, pBlob, ppOptions, optionCount, pOutputModule, ppOutputText);
}
vtable :: (obj: *IDxcOptimizer) -> *IDxcOptimizer_VTable {
    return obj.idxcoptimizer_vtable;
}
DxcVersionInfoFlags_None: u32 : 0;
DxcVersionInfoFlags_Debug: u32 : 1;
DxcVersionInfoFlags_Internal: u32 : 2;
IDxcVersionInfo :: struct {
    #as using iunknown: IUnknown;
    #place iunknown;
    idxcversioninfo_vtable: *IDxcVersionInfo_VTable;
}
IDxcVersionInfo_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    GetVersion: (this: *IDxcVersionInfo, pMajor: *u32, pMinor: *u32) -> HRESULT #cpp_method;
    GetFlags: (this: *IDxcVersionInfo, pFlags: *u32) -> HRESULT #cpp_method;
}
IDxcVersionInfo_GetVersion :: (this: *IDxcVersionInfo, pMajor: *u32, pMinor: *u32) -> HRESULT {
    return this.idxcversioninfo_vtable.GetVersion(this, pMajor, pMinor);
}
IDxcVersionInfo_GetFlags :: (this: *IDxcVersionInfo, pFlags: *u32) -> HRESULT {
    return this.idxcversioninfo_vtable.GetFlags(this, pFlags);
}
vtable :: (obj: *IDxcVersionInfo) -> *IDxcVersionInfo_VTable {
    return obj.idxcversioninfo_vtable;
}
IDxcVersionInfo2 :: struct {
    #as using idxcversioninfo: IDxcVersionInfo;
    #place idxcversioninfo;
    idxcversioninfo2_vtable: *IDxcVersionInfo2_VTable;
}
IDxcVersionInfo2_VTable :: struct #type_info_none {
    using idxcversioninfo: IDxcVersionInfo_VTable;
    GetCommitInfo: (this: *IDxcVersionInfo2, pCommitCount: *u32, pCommitHash: **u8) -> HRESULT #cpp_method;
}
IDxcVersionInfo2_GetCommitInfo :: (this: *IDxcVersionInfo2, pCommitCount: *u32, pCommitHash: **u8) -> HRESULT {
    return this.idxcversioninfo2_vtable.GetCommitInfo(this, pCommitCount, pCommitHash);
}
vtable :: (obj: *IDxcVersionInfo2) -> *IDxcVersionInfo2_VTable {
    return obj.idxcversioninfo2_vtable;
}
IDxcVersionInfo3 :: struct {
    #as using iunknown: IUnknown;
    #place iunknown;
    idxcversioninfo3_vtable: *IDxcVersionInfo3_VTable;
}
IDxcVersionInfo3_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    GetCustomVersionString: (this: *IDxcVersionInfo3, pVersionString: **u8) -> HRESULT #cpp_method;
}
IDxcVersionInfo3_GetCustomVersionString :: (this: *IDxcVersionInfo3, pVersionString: **u8) -> HRESULT {
    return this.idxcversioninfo3_vtable.GetCustomVersionString(this, pVersionString);
}
vtable :: (obj: *IDxcVersionInfo3) -> *IDxcVersionInfo3_VTable {
    return obj.idxcversioninfo3_vtable;
}
DxcArgPair :: struct {
    pName: *s16;
    pValue: *s16;
}
IDxcPdbUtils :: struct {
    #as using iunknown: IUnknown;
    #place iunknown;
    idxcpdbutils_vtable: *IDxcPdbUtils_VTable;
}
IDxcPdbUtils_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    Load: (this: *IDxcPdbUtils, pPdbOrDxil: *IDxcBlob) -> HRESULT #cpp_method;
    GetSourceCount: (this: *IDxcPdbUtils, pCount: *u32) -> HRESULT #cpp_method;
    GetSource: (this: *IDxcPdbUtils, uIndex: u32, ppResult: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    GetSourceName: (this: *IDxcPdbUtils, uIndex: u32, pResult: *BSTR) -> HRESULT #cpp_method;
    GetFlagCount: (this: *IDxcPdbUtils, pCount: *u32) -> HRESULT #cpp_method;
    GetFlag: (this: *IDxcPdbUtils, uIndex: u32, pResult: *BSTR) -> HRESULT #cpp_method;
    GetArgCount: (this: *IDxcPdbUtils, pCount: *u32) -> HRESULT #cpp_method;
    GetArg: (this: *IDxcPdbUtils, uIndex: u32, pResult: *BSTR) -> HRESULT #cpp_method;
    GetArgPairCount: (this: *IDxcPdbUtils, pCount: *u32) -> HRESULT #cpp_method;
    GetArgPair: (this: *IDxcPdbUtils, uIndex: u32, pName: *BSTR, pValue: *BSTR) -> HRESULT #cpp_method;
    GetDefineCount: (this: *IDxcPdbUtils, pCount: *u32) -> HRESULT #cpp_method;
    GetDefine: (this: *IDxcPdbUtils, uIndex: u32, pResult: *BSTR) -> HRESULT #cpp_method;
    GetTargetProfile: (this: *IDxcPdbUtils, pResult: *BSTR) -> HRESULT #cpp_method;
    GetEntryPoint: (this: *IDxcPdbUtils, pResult: *BSTR) -> HRESULT #cpp_method;
    GetMainFileName: (this: *IDxcPdbUtils, pResult: *BSTR) -> HRESULT #cpp_method;
    GetHash: (this: *IDxcPdbUtils, ppResult: **IDxcBlob) -> HRESULT #cpp_method;
    GetName: (this: *IDxcPdbUtils, pResult: *BSTR) -> HRESULT #cpp_method;
    IsFullPDB: (this: *IDxcPdbUtils) -> BOOL #cpp_method;
    GetFullPDB: (this: *IDxcPdbUtils, ppFullPDB: **IDxcBlob) -> HRESULT #cpp_method;
    GetVersionInfo: (this: *IDxcPdbUtils, ppVersionInfo: **IDxcVersionInfo) -> HRESULT #cpp_method;
    SetCompiler: (this: *IDxcPdbUtils, pCompiler: *IDxcCompiler3) -> HRESULT #cpp_method;
    CompileForFullPDB: (this: *IDxcPdbUtils, ppResult: **IDxcResult) -> HRESULT #cpp_method;
    OverrideArgs: (this: *IDxcPdbUtils, pArgPairs: *DxcArgPair, uNumArgPairs: u32) -> HRESULT #cpp_method;
    OverrideRootSignature: (this: *IDxcPdbUtils, pRootSignature: *s16) -> HRESULT #cpp_method;
}
IDxcPdbUtils_Load :: (this: *IDxcPdbUtils, pPdbOrDxil: *IDxcBlob) -> HRESULT {
    return this.idxcpdbutils_vtable.Load(this, pPdbOrDxil);
}
IDxcPdbUtils_GetSourceCount :: (this: *IDxcPdbUtils, pCount: *u32) -> HRESULT {
    return this.idxcpdbutils_vtable.GetSourceCount(this, pCount);
}
IDxcPdbUtils_GetSource :: (this: *IDxcPdbUtils, uIndex: u32, ppResult: **IDxcBlobEncoding) -> HRESULT {
    return this.idxcpdbutils_vtable.GetSource(this, uIndex, ppResult);
}
IDxcPdbUtils_GetSourceName :: (this: *IDxcPdbUtils, uIndex: u32, pResult: *BSTR) -> HRESULT {
    return this.idxcpdbutils_vtable.GetSourceName(this, uIndex, pResult);
}
IDxcPdbUtils_GetFlagCount :: (this: *IDxcPdbUtils, pCount: *u32) -> HRESULT {
    return this.idxcpdbutils_vtable.GetFlagCount(this, pCount);
}
IDxcPdbUtils_GetFlag :: (this: *IDxcPdbUtils, uIndex: u32, pResult: *BSTR) -> HRESULT {
    return this.idxcpdbutils_vtable.GetFlag(this, uIndex, pResult);
}
IDxcPdbUtils_GetArgCount :: (this: *IDxcPdbUtils, pCount: *u32) -> HRESULT {
    return this.idxcpdbutils_vtable.GetArgCount(this, pCount);
}
IDxcPdbUtils_GetArg :: (this: *IDxcPdbUtils, uIndex: u32, pResult: *BSTR) -> HRESULT {
    return this.idxcpdbutils_vtable.GetArg(this, uIndex, pResult);
}
IDxcPdbUtils_GetArgPairCount :: (this: *IDxcPdbUtils, pCount: *u32) -> HRESULT {
    return this.idxcpdbutils_vtable.GetArgPairCount(this, pCount);
}
IDxcPdbUtils_GetArgPair :: (this: *IDxcPdbUtils, uIndex: u32, pName: *BSTR, pValue: *BSTR) -> HRESULT {
    return this.idxcpdbutils_vtable.GetArgPair(this, uIndex, pName, pValue);
}
IDxcPdbUtils_GetDefineCount :: (this: *IDxcPdbUtils, pCount: *u32) -> HRESULT {
    return this.idxcpdbutils_vtable.GetDefineCount(this, pCount);
}
IDxcPdbUtils_GetDefine :: (this: *IDxcPdbUtils, uIndex: u32, pResult: *BSTR) -> HRESULT {
    return this.idxcpdbutils_vtable.GetDefine(this, uIndex, pResult);
}
IDxcPdbUtils_GetTargetProfile :: (this: *IDxcPdbUtils, pResult: *BSTR) -> HRESULT {
    return this.idxcpdbutils_vtable.GetTargetProfile(this, pResult);
}
IDxcPdbUtils_GetEntryPoint :: (this: *IDxcPdbUtils, pResult: *BSTR) -> HRESULT {
    return this.idxcpdbutils_vtable.GetEntryPoint(this, pResult);
}
IDxcPdbUtils_GetMainFileName :: (this: *IDxcPdbUtils, pResult: *BSTR) -> HRESULT {
    return this.idxcpdbutils_vtable.GetMainFileName(this, pResult);
}
IDxcPdbUtils_GetHash :: (this: *IDxcPdbUtils, ppResult: **IDxcBlob) -> HRESULT {
    return this.idxcpdbutils_vtable.GetHash(this, ppResult);
}
IDxcPdbUtils_GetName :: (this: *IDxcPdbUtils, pResult: *BSTR) -> HRESULT {
    return this.idxcpdbutils_vtable.GetName(this, pResult);
}
IDxcPdbUtils_IsFullPDB :: (this: *IDxcPdbUtils) -> BOOL {
    return this.idxcpdbutils_vtable.IsFullPDB(this);
}
IDxcPdbUtils_GetFullPDB :: (this: *IDxcPdbUtils, ppFullPDB: **IDxcBlob) -> HRESULT {
    return this.idxcpdbutils_vtable.GetFullPDB(this, ppFullPDB);
}
IDxcPdbUtils_GetVersionInfo :: (this: *IDxcPdbUtils, ppVersionInfo: **IDxcVersionInfo) -> HRESULT {
    return this.idxcpdbutils_vtable.GetVersionInfo(this, ppVersionInfo);
}
IDxcPdbUtils_SetCompiler :: (this: *IDxcPdbUtils, pCompiler: *IDxcCompiler3) -> HRESULT {
    return this.idxcpdbutils_vtable.SetCompiler(this, pCompiler);
}
IDxcPdbUtils_CompileForFullPDB :: (this: *IDxcPdbUtils, ppResult: **IDxcResult) -> HRESULT {
    return this.idxcpdbutils_vtable.CompileForFullPDB(this, ppResult);
}
IDxcPdbUtils_OverrideArgs :: (this: *IDxcPdbUtils, pArgPairs: *DxcArgPair, uNumArgPairs: u32) -> HRESULT {
    return this.idxcpdbutils_vtable.OverrideArgs(this, pArgPairs, uNumArgPairs);
}
IDxcPdbUtils_OverrideRootSignature :: (this: *IDxcPdbUtils, pRootSignature: *s16) -> HRESULT {
    return this.idxcpdbutils_vtable.OverrideRootSignature(this, pRootSignature);
}
vtable :: (obj: *IDxcPdbUtils) -> *IDxcPdbUtils_VTable {
    return obj.idxcpdbutils_vtable;
}
IDxcPdbUtils2 :: struct {
    #as using iunknown: IUnknown;
    #place iunknown;
    idxcpdbutils2_vtable: *IDxcPdbUtils2_VTable;
}
IDxcPdbUtils2_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    Load: (this: *IDxcPdbUtils2, pPdbOrDxil: *IDxcBlob) -> HRESULT #cpp_method;
    GetSourceCount: (this: *IDxcPdbUtils2, pCount: *u32) -> HRESULT #cpp_method;
    GetSource: (this: *IDxcPdbUtils2, uIndex: u32, ppResult: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    GetSourceName: (this: *IDxcPdbUtils2, uIndex: u32, ppResult: **IDxcBlobWide) -> HRESULT #cpp_method;
    GetLibraryPDBCount: (this: *IDxcPdbUtils2, pCount: *u32) -> HRESULT #cpp_method;
    GetLibraryPDB: (this: *IDxcPdbUtils2, uIndex: u32, ppOutPdbUtils: **IDxcPdbUtils2, ppLibraryName: **IDxcBlobWide) -> HRESULT #cpp_method;
    GetFlagCount: (this: *IDxcPdbUtils2, pCount: *u32) -> HRESULT #cpp_method;
    GetFlag: (this: *IDxcPdbUtils2, uIndex: u32, ppResult: **IDxcBlobWide) -> HRESULT #cpp_method;
    GetArgCount: (this: *IDxcPdbUtils2, pCount: *u32) -> HRESULT #cpp_method;
    GetArg: (this: *IDxcPdbUtils2, uIndex: u32, ppResult: **IDxcBlobWide) -> HRESULT #cpp_method;
    GetArgPairCount: (this: *IDxcPdbUtils2, pCount: *u32) -> HRESULT #cpp_method;
    GetArgPair: (this: *IDxcPdbUtils2, uIndex: u32, ppName: **IDxcBlobWide, ppValue: **IDxcBlobWide) -> HRESULT #cpp_method;
    GetDefineCount: (this: *IDxcPdbUtils2, pCount: *u32) -> HRESULT #cpp_method;
    GetDefine: (this: *IDxcPdbUtils2, uIndex: u32, ppResult: **IDxcBlobWide) -> HRESULT #cpp_method;
    GetTargetProfile: (this: *IDxcPdbUtils2, ppResult: **IDxcBlobWide) -> HRESULT #cpp_method;
    GetEntryPoint: (this: *IDxcPdbUtils2, ppResult: **IDxcBlobWide) -> HRESULT #cpp_method;
    GetMainFileName: (this: *IDxcPdbUtils2, ppResult: **IDxcBlobWide) -> HRESULT #cpp_method;
    GetHash: (this: *IDxcPdbUtils2, ppResult: **IDxcBlob) -> HRESULT #cpp_method;
    GetName: (this: *IDxcPdbUtils2, ppResult: **IDxcBlobWide) -> HRESULT #cpp_method;
    GetVersionInfo: (this: *IDxcPdbUtils2, ppVersionInfo: **IDxcVersionInfo) -> HRESULT #cpp_method;
    GetCustomToolchainID: (this: *IDxcPdbUtils2, pID: *u32) -> HRESULT #cpp_method;
    GetCustomToolchainData: (this: *IDxcPdbUtils2, ppBlob: **IDxcBlob) -> HRESULT #cpp_method;
    GetWholeDxil: (this: *IDxcPdbUtils2, ppResult: **IDxcBlob) -> HRESULT #cpp_method;
    IsFullPDB: (this: *IDxcPdbUtils2) -> BOOL #cpp_method;
    IsPDBRef: (this: *IDxcPdbUtils2) -> BOOL #cpp_method;
}
IDxcPdbUtils2_Load :: (this: *IDxcPdbUtils2, pPdbOrDxil: *IDxcBlob) -> HRESULT {
    return this.idxcpdbutils2_vtable.Load(this, pPdbOrDxil);
}
IDxcPdbUtils2_GetSourceCount :: (this: *IDxcPdbUtils2, pCount: *u32) -> HRESULT {
    return this.idxcpdbutils2_vtable.GetSourceCount(this, pCount);
}
IDxcPdbUtils2_GetSource :: (this: *IDxcPdbUtils2, uIndex: u32, ppResult: **IDxcBlobEncoding) -> HRESULT {
    return this.idxcpdbutils2_vtable.GetSource(this, uIndex, ppResult);
}
IDxcPdbUtils2_GetSourceName :: (this: *IDxcPdbUtils2, uIndex: u32, ppResult: **IDxcBlobWide) -> HRESULT {
    return this.idxcpdbutils2_vtable.GetSourceName(this, uIndex, ppResult);
}
IDxcPdbUtils2_GetLibraryPDBCount :: (this: *IDxcPdbUtils2, pCount: *u32) -> HRESULT {
    return this.idxcpdbutils2_vtable.GetLibraryPDBCount(this, pCount);
}
IDxcPdbUtils2_GetLibraryPDB :: (this: *IDxcPdbUtils2, uIndex: u32, ppOutPdbUtils: **IDxcPdbUtils2, ppLibraryName: **IDxcBlobWide) -> HRESULT {
    return this.idxcpdbutils2_vtable.GetLibraryPDB(this, uIndex, ppOutPdbUtils, ppLibraryName);
}
IDxcPdbUtils2_GetFlagCount :: (this: *IDxcPdbUtils2, pCount: *u32) -> HRESULT {
    return this.idxcpdbutils2_vtable.GetFlagCount(this, pCount);
}
IDxcPdbUtils2_GetFlag :: (this: *IDxcPdbUtils2, uIndex: u32, ppResult: **IDxcBlobWide) -> HRESULT {
    return this.idxcpdbutils2_vtable.GetFlag(this, uIndex, ppResult);
}
IDxcPdbUtils2_GetArgCount :: (this: *IDxcPdbUtils2, pCount: *u32) -> HRESULT {
    return this.idxcpdbutils2_vtable.GetArgCount(this, pCount);
}
IDxcPdbUtils2_GetArg :: (this: *IDxcPdbUtils2, uIndex: u32, ppResult: **IDxcBlobWide) -> HRESULT {
    return this.idxcpdbutils2_vtable.GetArg(this, uIndex, ppResult);
}
IDxcPdbUtils2_GetArgPairCount :: (this: *IDxcPdbUtils2, pCount: *u32) -> HRESULT {
    return this.idxcpdbutils2_vtable.GetArgPairCount(this, pCount);
}
IDxcPdbUtils2_GetArgPair :: (this: *IDxcPdbUtils2, uIndex: u32, ppName: **IDxcBlobWide, ppValue: **IDxcBlobWide) -> HRESULT {
    return this.idxcpdbutils2_vtable.GetArgPair(this, uIndex, ppName, ppValue);
}
IDxcPdbUtils2_GetDefineCount :: (this: *IDxcPdbUtils2, pCount: *u32) -> HRESULT {
    return this.idxcpdbutils2_vtable.GetDefineCount(this, pCount);
}
IDxcPdbUtils2_GetDefine :: (this: *IDxcPdbUtils2, uIndex: u32, ppResult: **IDxcBlobWide) -> HRESULT {
    return this.idxcpdbutils2_vtable.GetDefine(this, uIndex, ppResult);
}
IDxcPdbUtils2_GetTargetProfile :: (this: *IDxcPdbUtils2, ppResult: **IDxcBlobWide) -> HRESULT {
    return this.idxcpdbutils2_vtable.GetTargetProfile(this, ppResult);
}
IDxcPdbUtils2_GetEntryPoint :: (this: *IDxcPdbUtils2, ppResult: **IDxcBlobWide) -> HRESULT {
    return this.idxcpdbutils2_vtable.GetEntryPoint(this, ppResult);
}
IDxcPdbUtils2_GetMainFileName :: (this: *IDxcPdbUtils2, ppResult: **IDxcBlobWide) -> HRESULT {
    return this.idxcpdbutils2_vtable.GetMainFileName(this, ppResult);
}
IDxcPdbUtils2_GetHash :: (this: *IDxcPdbUtils2, ppResult: **IDxcBlob) -> HRESULT {
    return this.idxcpdbutils2_vtable.GetHash(this, ppResult);
}
IDxcPdbUtils2_GetName :: (this: *IDxcPdbUtils2, ppResult: **IDxcBlobWide) -> HRESULT {
    return this.idxcpdbutils2_vtable.GetName(this, ppResult);
}
IDxcPdbUtils2_GetVersionInfo :: (this: *IDxcPdbUtils2, ppVersionInfo: **IDxcVersionInfo) -> HRESULT {
    return this.idxcpdbutils2_vtable.GetVersionInfo(this, ppVersionInfo);
}
IDxcPdbUtils2_GetCustomToolchainID :: (this: *IDxcPdbUtils2, pID: *u32) -> HRESULT {
    return this.idxcpdbutils2_vtable.GetCustomToolchainID(this, pID);
}
IDxcPdbUtils2_GetCustomToolchainData :: (this: *IDxcPdbUtils2, ppBlob: **IDxcBlob) -> HRESULT {
    return this.idxcpdbutils2_vtable.GetCustomToolchainData(this, ppBlob);
}
IDxcPdbUtils2_GetWholeDxil :: (this: *IDxcPdbUtils2, ppResult: **IDxcBlob) -> HRESULT {
    return this.idxcpdbutils2_vtable.GetWholeDxil(this, ppResult);
}
IDxcPdbUtils2_IsFullPDB :: (this: *IDxcPdbUtils2) -> BOOL {
    return this.idxcpdbutils2_vtable.IsFullPDB(this);
}
IDxcPdbUtils2_IsPDBRef :: (this: *IDxcPdbUtils2) -> BOOL {
    return this.idxcpdbutils2_vtable.IsPDBRef(this);
}
vtable :: (obj: *IDxcPdbUtils2) -> *IDxcPdbUtils2_VTable {
    return obj.idxcpdbutils2_vtable;
}
#scope_file
#import "Basic";
dxcompiler :: #system_library "dxcompiler";
