// Independent declaration normalization; behavior status: docs/stdlib/codec-native-bindings.md.
NVTT_VERSION :: 20100;

Format :: enum s32 {
    RGB           :: 0;
    RGBA          :: 0;

    DXT1          :: 1;
    DXT1a         :: 2;
    DXT3          :: 3;
    DXT5          :: 4;
    DXT5n         :: 5;

    BC1           :: 1;
    BC1a          :: 2;
    BC2           :: 3;
    BC3           :: 4;
    BC3n          :: 5;
    BC4           :: 6;
    BC5           :: 7;

    DXT1n         :: 8;
    CTX1          :: 9;

    BC6           :: 10;
    BC7           :: 11;

    BC3_RGBM      :: 12;

    ETC1          :: 13;
    ETC2_R        :: 14;
    ETC2_RG       :: 15;
    ETC2_RGB      :: 16;
    ETC2_RGBA     :: 17;
    ETC2_RGB_A1   :: 18;

    ETC2_RGBM     :: 19;

    PVR_2BPP_RGB  :: 20;
    PVR_4BPP_RGB  :: 21;
    PVR_2BPP_RGBA :: 22;
    PVR_4BPP_RGBA :: 23;

    Count         :: 24;
}

PixelType :: enum s32 {
    UnsignedNorm  :: 0;
    SignedNorm    :: 1;
    UnsignedInt   :: 2;
    SignedInt     :: 3;
    Float         :: 4;
    UnsignedFloat :: 5;
    SharedExp     :: 6;
}

Quality :: enum s32 {
    Fastest    :: 0;
    Normal     :: 1;
    Production :: 2;
    Highest    :: 3;
}

Decoder :: enum s32 {
    D3D10 :: 0;
    D3D9  :: 1;
    NV5x  :: 2;
}

CompressionOptions :: struct {
    Private :: struct {}
    m: *Private;

    Constructor :: (this: *CompressionOptions) -> void #cpp_method #foreign nvtt "??0CompressionOptions@nvtt@@QEAA@XZ";
    Destructor :: (this: *CompressionOptions) -> void #cpp_method #foreign nvtt "??1CompressionOptions@nvtt@@QEAA@XZ";

    reset :: (this: *CompressionOptions) -> void #cpp_method #foreign nvtt "?reset@CompressionOptions@nvtt@@QEAAXXZ";

    setFormat :: (this: *CompressionOptions, format: Format) -> void #cpp_method #foreign nvtt "?setFormat@CompressionOptions@nvtt@@QEAAXW4Format@2@@Z";
    setQuality :: (this: *CompressionOptions, quality: Quality) -> void #cpp_method #foreign nvtt "?setQuality@CompressionOptions@nvtt@@QEAAXW4Quality@2@@Z";
    setColorWeights :: (this: *CompressionOptions, red: float, green: float, blue: float, alpha: float = 1.0) -> void #cpp_method #foreign nvtt "?setColorWeights@CompressionOptions@nvtt@@QEAAXMMMM@Z";
    setRGBMThreshold :: (this: *CompressionOptions, min_m: float) -> void #cpp_method #foreign nvtt "?setRGBMThreshold@CompressionOptions@nvtt@@QEAAXM@Z";

    setExternalCompressor :: (this: *CompressionOptions, name: *u8) -> void #cpp_method #foreign nvtt "?setExternalCompressor@CompressionOptions@nvtt@@QEAAXPEBD@Z";

    setPixelFormat :: (this: *CompressionOptions, bitcount: u32, rmask: u32, gmask: u32, bmask: u32, amask: u32) -> void #cpp_method #foreign nvtt "?setPixelFormat@CompressionOptions@nvtt@@QEAAXIIIII@Z";
    setPixelFormat :: (this: *CompressionOptions, rsize: u8, gsize: u8, bsize: u8, asize: u8) -> void #cpp_method #foreign nvtt "?setPixelFormat@CompressionOptions@nvtt@@QEAAXEEEE@Z";

    setPixelType :: (this: *CompressionOptions, pixelType: PixelType) -> void #cpp_method #foreign nvtt "?setPixelType@CompressionOptions@nvtt@@QEAAXW4PixelType@2@@Z";

    setPitchAlignment :: (this: *CompressionOptions, pitchAlignment: s32) -> void #cpp_method #foreign nvtt "?setPitchAlignment@CompressionOptions@nvtt@@QEAAXH@Z";

    setQuantization :: (this: *CompressionOptions, colorDithering: bool, alphaDithering: bool, binaryAlpha: bool, alphaThreshold: s32 = 127) -> void #cpp_method #foreign nvtt "?setQuantization@CompressionOptions@nvtt@@QEAAX_N00H@Z";

    setTargetDecoder :: (this: *CompressionOptions, decoder: Decoder) -> void #cpp_method #foreign nvtt "?setTargetDecoder@CompressionOptions@nvtt@@QEAAXW4Decoder@2@@Z";

    format :: (this: *CompressionOptions) -> Format #cpp_method #foreign nvtt "?format@CompressionOptions@nvtt@@QEBA?AW4Format@2@XZ";
    d3d9Format :: (this: *CompressionOptions) -> u32 #cpp_method #foreign nvtt "?d3d9Format@CompressionOptions@nvtt@@QEBAIXZ";
    dxgiFormat :: (this: *CompressionOptions) -> u32 #cpp_method #foreign nvtt "?dxgiFormat@CompressionOptions@nvtt@@QEBAIXZ";
}

WrapMode :: enum s32 {
    Clamp  :: 0;
    Repeat :: 1;
    Mirror :: 2;
}

TextureType :: enum s32 {
    _2D   :: 0;
    Cube  :: 1;
    _3D   :: 2;
    Array :: 3;
}

InputFormat :: enum s32 {
    BGRA_8UB :: 0;
    RGBA_16F :: 1;
    RGBA_32F :: 2;
    R_32F    :: 3;
}

MipmapFilter :: enum s32 {
    Box      :: 0;
    Triangle :: 1;
    Kaiser   :: 2;
}

ResizeFilter :: enum s32 {
    Box      :: 0;
    Triangle :: 1;
    Kaiser   :: 2;
    Mitchell :: 3;
}

RoundMode :: enum s32 {
    None                     :: 0;
    ToNextPowerOfTwo         :: 1;
    ToNearestPowerOfTwo      :: 2;
    ToPreviousPowerOfTwo     :: 3;
    ToNextMultipleOfFour     :: 4;
    ToNearestMultipleOfFour  :: 5;
    ToPreviousMultipleOfFour :: 6;
}

AlphaMode :: enum s32 {
    None          :: 0;
    Transparency  :: 1;
    Premultiplied :: 2;
}

ShapeRestriction :: enum s32 {
    None   :: 0;
    Square :: 1;
}

InputOptions :: struct {
    Private :: struct {}
    m: *Private;

    Constructor :: (this: *InputOptions) -> void #cpp_method #foreign nvtt "??0InputOptions@nvtt@@QEAA@XZ";
    Destructor :: (this: *InputOptions) -> void #cpp_method #foreign nvtt "??1InputOptions@nvtt@@QEAA@XZ";

    reset :: (this: *InputOptions) -> void #cpp_method #foreign nvtt "?reset@InputOptions@nvtt@@QEAAXXZ";

    setTextureLayout :: (this: *InputOptions, type: TextureType, w: s32, h: s32, d: s32 = 1, arraySize: s32 = 1) -> void #cpp_method #foreign nvtt "?setTextureLayout@InputOptions@nvtt@@QEAAXW4TextureType@2@HHHH@Z";
    resetTextureLayout :: (this: *InputOptions) -> void #cpp_method #foreign nvtt "?resetTextureLayout@InputOptions@nvtt@@QEAAXXZ";

    setMipmapData :: (this: *InputOptions, data: *void, w: s32, h: s32, d: s32 = 1, face: s32 = 0, mipmap: s32 = 0) -> bool #cpp_method #foreign nvtt "?setMipmapData@InputOptions@nvtt@@QEAA_NPEBXHHHHH@Z";

    setFormat :: (this: *InputOptions, format: InputFormat) -> void #cpp_method #foreign nvtt "?setFormat@InputOptions@nvtt@@QEAAXW4InputFormat@2@@Z";

    setAlphaMode :: (this: *InputOptions, alphaMode: AlphaMode) -> void #cpp_method #foreign nvtt "?setAlphaMode@InputOptions@nvtt@@QEAAXW4AlphaMode@2@@Z";

    setGamma :: (this: *InputOptions, inputGamma: float, outputGamma: float) -> void #cpp_method #foreign nvtt "?setGamma@InputOptions@nvtt@@QEAAXMM@Z";

    setWrapMode :: (this: *InputOptions, mode: WrapMode) -> void #cpp_method #foreign nvtt "?setWrapMode@InputOptions@nvtt@@QEAAXW4WrapMode@2@@Z";

    setMipmapFilter :: (this: *InputOptions, filter: MipmapFilter) -> void #cpp_method #foreign nvtt "?setMipmapFilter@InputOptions@nvtt@@QEAAXW4MipmapFilter@2@@Z";
    setMipmapGeneration :: (this: *InputOptions, enabled: bool, maxLevel: s32 = -1) -> void #cpp_method #foreign nvtt "?setMipmapGeneration@InputOptions@nvtt@@QEAAX_NH@Z";
    setKaiserParameters :: (this: *InputOptions, width: float, alpha: float, stretch: float) -> void #cpp_method #foreign nvtt "?setKaiserParameters@InputOptions@nvtt@@QEAAXMMM@Z";

    setNormalMap :: (this: *InputOptions, b: bool) -> void #cpp_method #foreign nvtt "?setNormalMap@InputOptions@nvtt@@QEAAX_N@Z";
    setConvertToNormalMap :: (this: *InputOptions, convert: bool) -> void #cpp_method #foreign nvtt "?setConvertToNormalMap@InputOptions@nvtt@@QEAAX_N@Z";
    setHeightEvaluation :: (this: *InputOptions, redScale: float, greenScale: float, blueScale: float, alphaScale: float) -> void #cpp_method #foreign nvtt "?setHeightEvaluation@InputOptions@nvtt@@QEAAXMMMM@Z";
    setNormalFilter :: (this: *InputOptions, sm: float, medium: float, big: float, large: float) -> void #cpp_method #foreign nvtt "?setNormalFilter@InputOptions@nvtt@@QEAAXMMMM@Z";
    setNormalizeMipmaps :: (this: *InputOptions, b: bool) -> void #cpp_method #foreign nvtt "?setNormalizeMipmaps@InputOptions@nvtt@@QEAAX_N@Z";

    setMaxExtents :: (this: *InputOptions, d: s32) -> void #cpp_method #foreign nvtt "?setMaxExtents@InputOptions@nvtt@@QEAAXH@Z";
    setRoundMode :: (this: *InputOptions, mode: RoundMode) -> void #cpp_method #foreign nvtt "?setRoundMode@InputOptions@nvtt@@QEAAXW4RoundMode@2@@Z";
}

OutputHandler :: struct {
    vtable: *OutputHandler_VTable;
}
OutputHandler_VTable :: struct #type_info_none {
    Destructor: (this: *OutputHandler, flags: Msvc_Destructor_Flags) -> void #cpp_method;

    beginImage: (this: *OutputHandler, size: s32, width: s32, height: s32, depth: s32, face: s32, miplevel: s32) -> void #cpp_method;

    writeData: (this: *OutputHandler, data: *void, size: s32) -> bool #cpp_method;

    endImage: (this: *OutputHandler) -> void #cpp_method;
}

OutputHandler_Destructor :: (this: *OutputHandler, flags: Msvc_Destructor_Flags) {
    this.vtable.Destructor(this, flags);
}

OutputHandler_beginImage :: (this: *OutputHandler, size: s32, width: s32, height: s32, depth: s32, face: s32, miplevel: s32) {
    this.vtable.beginImage(this, size, width, height, depth, face, miplevel);
}

OutputHandler_writeData :: (this: *OutputHandler, data: *void, size: s32) -> bool {
    return this.vtable.writeData(this, data, size);
}

OutputHandler_endImage :: (this: *OutputHandler) {
    this.vtable.endImage(this);
}

vtable :: (obj: *OutputHandler) -> *OutputHandler_VTable {
    return obj.vtable;
}

Error :: enum s32 {
    Unknown                 :: 0;
    InvalidInput            :: 1;
    UnsupportedFeature      :: 2;
    CudaError               :: 3;
    FileOpen                :: 4;
    FileWrite               :: 5;
    UnsupportedOutputFormat :: 6;
    Count                   :: 7;
}

ErrorHandler :: struct {
    vtable: *ErrorHandler_VTable;
}
ErrorHandler_VTable :: struct #type_info_none {
    Destructor: (this: *ErrorHandler, flags: Msvc_Destructor_Flags) -> void #cpp_method;

    error: (this: *ErrorHandler, e: Error) -> void #cpp_method;
}

ErrorHandler_Destructor :: (this: *ErrorHandler, flags: Msvc_Destructor_Flags) {
    this.vtable.Destructor(this, flags);
}

ErrorHandler_error :: (this: *ErrorHandler, e: Error) {
    this.vtable.error(this, e);
}

vtable :: (obj: *ErrorHandler) -> *ErrorHandler_VTable {
    return obj.vtable;
}

Container :: enum s32 {
    DDS   :: 0;
    DDS10 :: 1;
    KTX   :: 2;
}

OutputOptions :: struct {
    Private :: struct {}
    m: *Private;

    Constructor :: (this: *OutputOptions) -> void #cpp_method #foreign nvtt "??0OutputOptions@nvtt@@QEAA@XZ";
    Destructor :: (this: *OutputOptions) -> void #cpp_method #foreign nvtt "??1OutputOptions@nvtt@@QEAA@XZ";

    reset :: (this: *OutputOptions) -> void #cpp_method #foreign nvtt "?reset@OutputOptions@nvtt@@QEAAXXZ";

    setFileName :: (this: *OutputOptions, fileName: *u8) -> void #cpp_method #foreign nvtt "?setFileName@OutputOptions@nvtt@@QEAAXPEBD@Z";
    setFileHandle :: (this: *OutputOptions, fp: *void) -> void #cpp_method #foreign nvtt "?setFileHandle@OutputOptions@nvtt@@QEAAXPEAX@Z";

    setOutputHandler :: (this: *OutputOptions, outputHandler: *OutputHandler) -> void #cpp_method #foreign nvtt "?setOutputHandler@OutputOptions@nvtt@@QEAAXPEAUOutputHandler@2@@Z";
    setErrorHandler :: (this: *OutputOptions, errorHandler: *ErrorHandler) -> void #cpp_method #foreign nvtt "?setErrorHandler@OutputOptions@nvtt@@QEAAXPEAUErrorHandler@2@@Z";

    setOutputHeader :: (this: *OutputOptions, outputHeader: bool) -> void #cpp_method #foreign nvtt "?setOutputHeader@OutputOptions@nvtt@@QEAAX_N@Z";
    setContainer :: (this: *OutputOptions, container: Container) -> void #cpp_method #foreign nvtt "?setContainer@OutputOptions@nvtt@@QEAAXW4Container@2@@Z";
    setUserVersion :: (this: *OutputOptions, version: s32) -> void #cpp_method #foreign nvtt "?setUserVersion@OutputOptions@nvtt@@QEAAXH@Z";
    setSrgbFlag :: (this: *OutputOptions, b: bool) -> void #cpp_method #foreign nvtt "?setSrgbFlag@OutputOptions@nvtt@@QEAAX_N@Z";
}

Task :: #type (_context: *void, id: s32) -> void #c_call;

TaskDispatcher :: struct {
    vtable: *TaskDispatcher_VTable;
}
TaskDispatcher_VTable :: struct #type_info_none {
    Destructor: (this: *TaskDispatcher, flags: Msvc_Destructor_Flags) -> void #cpp_method;

    dispatch: (this: *TaskDispatcher, task: Task, _context: *void, count: s32) -> void #cpp_method;
}

TaskDispatcher_Destructor :: (this: *TaskDispatcher, flags: Msvc_Destructor_Flags) {
    this.vtable.Destructor(this, flags);
}

TaskDispatcher_dispatch :: (this: *TaskDispatcher, task: Task, _context: *void, count: s32) {
    this.vtable.dispatch(this, task, _context, count);
}

vtable :: (obj: *TaskDispatcher) -> *TaskDispatcher_VTable {
    return obj.vtable;
}

Compressor :: struct  {
    Private :: struct {}
    m: *Private;

    Constructor :: (this: *Compressor) -> void #cpp_method #foreign nvtt "??0Compressor@nvtt@@QEAA@XZ";
    Destructor :: (this: *Compressor) -> void #cpp_method #foreign nvtt "??1Compressor@nvtt@@QEAA@XZ";

    enableCudaAcceleration :: (this: *Compressor, enable: bool) -> void #cpp_method #foreign nvtt "?enableCudaAcceleration@Compressor@nvtt@@QEAAX_N@Z";
    isCudaAccelerationEnabled :: (this: *Compressor) -> bool #cpp_method #foreign nvtt "?isCudaAccelerationEnabled@Compressor@nvtt@@QEBA_NXZ";
    setTaskDispatcher :: (this: *Compressor, disp: *TaskDispatcher) -> void #cpp_method #foreign nvtt "?setTaskDispatcher@Compressor@nvtt@@QEAAXPEAUTaskDispatcher@2@@Z";

    process :: (this: *Compressor, inputOptions: *InputOptions, compressionOptions: *CompressionOptions, outputOptions: *OutputOptions) -> bool #cpp_method #foreign nvtt "?process@Compressor@nvtt@@QEBA_NAEBUInputOptions@2@AEBUCompressionOptions@2@AEBUOutputOptions@2@@Z";
    process :: (this: *Compressor, inputOptions: InputOptions, compressionOptions: CompressionOptions, outputOptions: OutputOptions) -> bool #no_context {
    return process(this, *inputOptions, *compressionOptions, *outputOptions);
}
    estimateSize :: (this: *Compressor, inputOptions: *InputOptions, compressionOptions: *CompressionOptions) -> s32 #cpp_method #foreign nvtt "?estimateSize@Compressor@nvtt@@QEBAHAEBUInputOptions@2@AEBUCompressionOptions@2@@Z";
    estimateSize :: (this: *Compressor, inputOptions: InputOptions, compressionOptions: CompressionOptions) -> s32 #no_context {
    return estimateSize(this, *inputOptions, *compressionOptions);
}

    outputHeader :: (this: *Compressor, img: *Surface, mipmapCount: s32, compressionOptions: *CompressionOptions, outputOptions: *OutputOptions) -> bool #cpp_method #foreign nvtt "?outputHeader@Compressor@nvtt@@QEBA_NAEBUSurface@2@HAEBUCompressionOptions@2@AEBUOutputOptions@2@@Z";
    outputHeader :: (this: *Compressor, img: Surface, mipmapCount: s32, compressionOptions: CompressionOptions, outputOptions: OutputOptions) -> bool #no_context {
    return outputHeader(this, *img, mipmapCount, *compressionOptions, *outputOptions);
}
    compress :: (this: *Compressor, img: *Surface, face: s32, mipmap: s32, compressionOptions: *CompressionOptions, outputOptions: *OutputOptions) -> bool #cpp_method #foreign nvtt "?compress@Compressor@nvtt@@QEBA_NAEBUSurface@2@HHAEBUCompressionOptions@2@AEBUOutputOptions@2@@Z";
    compress :: (this: *Compressor, img: Surface, face: s32, mipmap: s32, compressionOptions: CompressionOptions, outputOptions: OutputOptions) -> bool #no_context {
    return compress(this, *img, face, mipmap, *compressionOptions, *outputOptions);
}
    estimateSize :: (this: *Compressor, img: *Surface, mipmapCount: s32, compressionOptions: *CompressionOptions) -> s32 #cpp_method #foreign nvtt "?estimateSize@Compressor@nvtt@@QEBAHAEBUSurface@2@HAEBUCompressionOptions@2@@Z";
    estimateSize :: (this: *Compressor, img: Surface, mipmapCount: s32, compressionOptions: CompressionOptions) -> s32 #no_context {
    return estimateSize(this, *img, mipmapCount, *compressionOptions);
}

    outputHeader :: (this: *Compressor, cube: *CubeSurface, mipmapCount: s32, compressionOptions: *CompressionOptions, outputOptions: *OutputOptions) -> bool #cpp_method #foreign nvtt "?outputHeader@Compressor@nvtt@@QEBA_NAEBUCubeSurface@2@HAEBUCompressionOptions@2@AEBUOutputOptions@2@@Z";
    outputHeader :: (this: *Compressor, cube: CubeSurface, mipmapCount: s32, compressionOptions: CompressionOptions, outputOptions: OutputOptions) -> bool #no_context {
    return outputHeader(this, *cube, mipmapCount, *compressionOptions, *outputOptions);
}
    compress :: (this: *Compressor, cube: *CubeSurface, mipmap: s32, compressionOptions: *CompressionOptions, outputOptions: *OutputOptions) -> bool #cpp_method #foreign nvtt "?compress@Compressor@nvtt@@QEBA_NAEBUCubeSurface@2@HAEBUCompressionOptions@2@AEBUOutputOptions@2@@Z";
    compress :: (this: *Compressor, cube: CubeSurface, mipmap: s32, compressionOptions: CompressionOptions, outputOptions: OutputOptions) -> bool #no_context {
    return compress(this, *cube, mipmap, *compressionOptions, *outputOptions);
}
    estimateSize :: (this: *Compressor, cube: *CubeSurface, mipmapCount: s32, compressionOptions: *CompressionOptions) -> s32 #cpp_method #foreign nvtt "?estimateSize@Compressor@nvtt@@QEBAHAEBUCubeSurface@2@HAEBUCompressionOptions@2@@Z";
    estimateSize :: (this: *Compressor, cube: CubeSurface, mipmapCount: s32, compressionOptions: CompressionOptions) -> s32 #no_context {
    return estimateSize(this, *cube, mipmapCount, *compressionOptions);
}

    outputHeader :: (this: *Compressor, type: TextureType, w: s32, h: s32, d: s32, arraySize: s32, mipmapCount: s32, isNormalMap: bool, compressionOptions: *CompressionOptions, outputOptions: *OutputOptions) -> bool #cpp_method #foreign nvtt "?outputHeader@Compressor@nvtt@@QEBA_NW4TextureType@2@HHHHH_NAEBUCompressionOptions@2@AEBUOutputOptions@2@@Z";
    outputHeader :: (this: *Compressor, type: TextureType, w: s32, h: s32, d: s32, arraySize: s32, mipmapCount: s32, isNormalMap: bool, compressionOptions: CompressionOptions, outputOptions: OutputOptions) -> bool #no_context {
    return outputHeader(this, type, w, h, d, arraySize, mipmapCount, isNormalMap, *compressionOptions, *outputOptions);
}
    compress :: (this: *Compressor, w: s32, h: s32, d: s32, face: s32, mipmap: s32, rgba: *float, compressionOptions: *CompressionOptions, outputOptions: *OutputOptions) -> bool #cpp_method #foreign nvtt "?compress@Compressor@nvtt@@QEBA_NHHHHHPEBMAEBUCompressionOptions@2@AEBUOutputOptions@2@@Z";
    compress :: (this: *Compressor, w: s32, h: s32, d: s32, face: s32, mipmap: s32, rgba: *float, compressionOptions: CompressionOptions, outputOptions: OutputOptions) -> bool #no_context {
    return compress(this, w, h, d, face, mipmap, rgba, *compressionOptions, *outputOptions);
}
    estimateSize :: (this: *Compressor, w: s32, h: s32, d: s32, mipmapCount: s32, compressionOptions: *CompressionOptions) -> s32 #cpp_method #foreign nvtt "?estimateSize@Compressor@nvtt@@QEBAHHHHHAEBUCompressionOptions@2@@Z";
    estimateSize :: (this: *Compressor, w: s32, h: s32, d: s32, mipmapCount: s32, compressionOptions: CompressionOptions) -> s32 #no_context {
    return estimateSize(this, w, h, d, mipmapCount, *compressionOptions);
}
}

Context :: Compressor;

NormalTransform :: enum s32 {
    Orthographic  :: 0;
    Stereographic :: 1;
    Paraboloid    :: 2;
    Quartic       :: 3;
}

ToneMapper :: enum s32 {
    Linear    :: 0;
    Reindhart :: 1;
    Halo      :: 2;
    Lightmap  :: 3;
}

WarpFunction :: #type (x: *float, y: *float, d: *float) -> void #c_call;

Surface :: struct #type_info_none {
    Constructor :: (this: *Surface) -> void #cpp_method #foreign nvtt "??0Surface@nvtt@@QEAA@XZ";
    CopyConstructor :: (this: *Surface, img: *Surface) -> void #cpp_method #foreign nvtt "??0Surface@nvtt@@QEAA@AEBU01@@Z";
    CopyConstructor :: (this: *Surface, img: Surface) #no_context {
    CopyConstructor(this, *img);
}
    Destructor :: (this: *Surface) -> void #cpp_method #foreign nvtt "??1Surface@nvtt@@QEAA@XZ";

    setWrapMode :: (this: *Surface, mode: WrapMode) -> void #cpp_method #foreign nvtt "?setWrapMode@Surface@nvtt@@QEAAXW4WrapMode@2@@Z";
    setAlphaMode :: (this: *Surface, alphaMode: AlphaMode) -> void #cpp_method #foreign nvtt "?setAlphaMode@Surface@nvtt@@QEAAXW4AlphaMode@2@@Z";
    setNormalMap :: (this: *Surface, isNormalMap: bool) -> void #cpp_method #foreign nvtt "?setNormalMap@Surface@nvtt@@QEAAX_N@Z";

    isNull :: (this: *Surface) -> bool #cpp_method #foreign nvtt "?isNull@Surface@nvtt@@QEBA_NXZ";
    width :: (this: *Surface) -> s32 #cpp_method #foreign nvtt "?width@Surface@nvtt@@QEBAHXZ";
    height :: (this: *Surface) -> s32 #cpp_method #foreign nvtt "?height@Surface@nvtt@@QEBAHXZ";
    depth :: (this: *Surface) -> s32 #cpp_method #foreign nvtt "?depth@Surface@nvtt@@QEBAHXZ";
    type :: (this: *Surface) -> TextureType #cpp_method #foreign nvtt "?type@Surface@nvtt@@QEBA?AW4TextureType@2@XZ";
    wrapMode :: (this: *Surface) -> WrapMode #cpp_method #foreign nvtt "?wrapMode@Surface@nvtt@@QEBA?AW4WrapMode@2@XZ";
    alphaMode :: (this: *Surface) -> AlphaMode #cpp_method #foreign nvtt "?alphaMode@Surface@nvtt@@QEBA?AW4AlphaMode@2@XZ";
    isNormalMap :: (this: *Surface) -> bool #cpp_method #foreign nvtt "?isNormalMap@Surface@nvtt@@QEBA_NXZ";
    countMipmaps :: (this: *Surface) -> s32 #cpp_method #foreign nvtt "?countMipmaps@Surface@nvtt@@QEBAHXZ";
    countMipmaps :: (this: *Surface, min_size: s32) -> s32 #cpp_method #foreign nvtt "?countMipmaps@Surface@nvtt@@QEBAHH@Z";
    alphaTestCoverage :: (this: *Surface, alphaRef: float = 0.5, alpha_channel: s32 = 3) -> float #cpp_method #foreign nvtt "?alphaTestCoverage@Surface@nvtt@@QEBAMMH@Z";
    average :: (this: *Surface, channel: s32, alpha_channel: s32 = -1, gamma: float = 2.2) -> float #cpp_method #foreign nvtt "?average@Surface@nvtt@@QEBAMHHM@Z";
    data :: (this: *Surface) -> *float #cpp_method #foreign nvtt "?data@Surface@nvtt@@QEBAPEBMXZ";
    channel :: (this: *Surface, i: s32) -> *float #cpp_method #foreign nvtt "?channel@Surface@nvtt@@QEBAPEBMH@Z";
    histogram :: (this: *Surface, channel: s32, rangeMin: float, rangeMax: float, binCount: s32, binPtr: *s32) -> void #cpp_method #foreign nvtt "?histogram@Surface@nvtt@@QEBAXHMMHPEAH@Z";
    range :: (this: *Surface, channel: s32, rangeMin: *float, rangeMax: *float, alpha_channel: s32 = -1, alpha_ref: float = 0.0) -> void #cpp_method #foreign nvtt "?range@Surface@nvtt@@QEBAXHPEAM0HM@Z";

    load :: (this: *Surface, fileName: *u8, hasAlpha: *bool = null) -> bool #cpp_method #foreign nvtt "?load@Surface@nvtt@@QEAA_NPEBDPEA_N@Z";
    save :: (this: *Surface, fileName: *u8, hasAlpha := false, hdr := false) -> bool #cpp_method #foreign nvtt "?save@Surface@nvtt@@QEBA_NPEBD_N1@Z";
    setImage :: (this: *Surface, w: s32, h: s32, d: s32) -> bool #cpp_method #foreign nvtt "?setImage@Surface@nvtt@@QEAA_NHHH@Z";
    setImage :: (this: *Surface, format: InputFormat, w: s32, h: s32, d: s32, data: *void) -> bool #cpp_method #foreign nvtt "?setImage@Surface@nvtt@@QEAA_NW4InputFormat@2@HHHPEBX@Z";
    setImage :: (this: *Surface, format: InputFormat, w: s32, h: s32, d: s32, r: *void, g: *void, b: *void, a: *void) -> bool #cpp_method #foreign nvtt "?setImage@Surface@nvtt@@QEAA_NW4InputFormat@2@HHHPEBX111@Z";
    setImage2D :: (this: *Surface, format: Format, decoder: Decoder, w: s32, h: s32, data: *void) -> bool #cpp_method #foreign nvtt "?setImage2D@Surface@nvtt@@QEAA_NW4Format@2@W4Decoder@2@HHPEBX@Z";

    resize :: (this: *Surface, w: s32, h: s32, d: s32, filter: ResizeFilter) -> void #cpp_method #foreign nvtt "?resize@Surface@nvtt@@QEAAXHHHW4ResizeFilter@2@@Z";
    resize :: (this: *Surface, w: s32, h: s32, d: s32, filter: ResizeFilter, filterWidth: float, params: *float = null) -> void #cpp_method #foreign nvtt "?resize@Surface@nvtt@@QEAAXHHHW4ResizeFilter@2@MPEBM@Z";
    resize :: (this: *Surface, maxExtent: s32, mode: RoundMode, filter: ResizeFilter) -> void #cpp_method #foreign nvtt "?resize@Surface@nvtt@@QEAAXHW4RoundMode@2@W4ResizeFilter@2@@Z";
    resize :: (this: *Surface, maxExtent: s32, mode: RoundMode, filter: ResizeFilter, filterWidth: float, params: *float = null) -> void #cpp_method #foreign nvtt "?resize@Surface@nvtt@@QEAAXHW4RoundMode@2@W4ResizeFilter@2@MPEBM@Z";
    resizeMakeSquare :: (this: *Surface, maxExtent: s32, roundMode: RoundMode, filter: ResizeFilter) -> void #cpp_method #foreign nvtt "?resizeMakeSquare@Surface@nvtt@@QEAAXHW4RoundMode@2@W4ResizeFilter@2@@Z";
    autoResize :: (this: *Surface, errorTolerance: float, mode: RoundMode, filter: ResizeFilter) -> void #cpp_method #foreign nvtt "?autoResize@Surface@nvtt@@QEAAXMW4RoundMode@2@W4ResizeFilter@2@@Z";

    buildNextMipmap :: (this: *Surface, filter: MipmapFilter, min_size: s32 = 1) -> bool #cpp_method #foreign nvtt "?buildNextMipmap@Surface@nvtt@@QEAA_NW4MipmapFilter@2@H@Z";
    buildNextMipmap :: (this: *Surface, filter: MipmapFilter, filterWidth: float, params: *float = null, min_size: s32 = 1) -> bool #cpp_method #foreign nvtt "?buildNextMipmap@Surface@nvtt@@QEAA_NW4MipmapFilter@2@MPEBMH@Z";
    buildNextMipmapSolidColor :: (this: *Surface, color_components: *float) -> bool #cpp_method #foreign nvtt "?buildNextMipmapSolidColor@Surface@nvtt@@QEAA_NQEBM@Z";
    canvasSize :: (this: *Surface, w: s32, h: s32, d: s32) -> void #cpp_method #foreign nvtt "?canvasSize@Surface@nvtt@@QEAAXHHH@Z";

    canMakeNextMipmap :: (this: *Surface, min_size: s32 = 1) -> bool #cpp_method #foreign nvtt "?canMakeNextMipmap@Surface@nvtt@@QEAA_NH@Z";

    toLinear :: (this: *Surface, gamma: float) -> void #cpp_method #foreign nvtt "?toLinear@Surface@nvtt@@QEAAXM@Z";
    toGamma :: (this: *Surface, gamma: float) -> void #cpp_method #foreign nvtt "?toGamma@Surface@nvtt@@QEAAXM@Z";
    toLinear :: (this: *Surface, channel: s32, gamma: float) -> void #cpp_method #foreign nvtt "?toLinear@Surface@nvtt@@QEAAXHM@Z";
    toGamma :: (this: *Surface, channel: s32, gamma: float) -> void #cpp_method #foreign nvtt "?toGamma@Surface@nvtt@@QEAAXHM@Z";
    toSrgb :: (this: *Surface) -> void #cpp_method #foreign nvtt "?toSrgb@Surface@nvtt@@QEAAXXZ";
    toSrgbFast :: (this: *Surface) -> void #cpp_method #foreign nvtt "?toSrgbFast@Surface@nvtt@@QEAAXXZ";
    toLinearFromSrgb :: (this: *Surface) -> void #cpp_method #foreign nvtt "?toLinearFromSrgb@Surface@nvtt@@QEAAXXZ";
    toLinearFromSrgbFast :: (this: *Surface) -> void #cpp_method #foreign nvtt "?toLinearFromSrgbFast@Surface@nvtt@@QEAAXXZ";
    toXenonSrgb :: (this: *Surface) -> void #cpp_method #foreign nvtt "?toXenonSrgb@Surface@nvtt@@QEAAXXZ";
    transform :: (this: *Surface, w0: *[4] float, w1: *[4] float, w2: *[4] float, w3: *[4] float, offset: *[4] float) -> void #cpp_method #foreign nvtt "?transform@Surface@nvtt@@QEAAXQEBM0000@Z";
    swizzle :: (this: *Surface, r: s32, g: s32, b: s32, a: s32) -> void #cpp_method #foreign nvtt "?swizzle@Surface@nvtt@@QEAAXHHHH@Z";
    scaleBias :: (this: *Surface, channel: s32, scale: float, bias: float) -> void #cpp_method #foreign nvtt "?scaleBias@Surface@nvtt@@QEAAXHMM@Z";
    clamp :: (this: *Surface, channel: s32, low: float = 0.0, high: float = 1.0) -> void #cpp_method #foreign nvtt "?clamp@Surface@nvtt@@QEAAXHMM@Z";
    blend :: (this: *Surface, r: float, g: float, b: float, a: float, t: float) -> void #cpp_method #foreign nvtt "?blend@Surface@nvtt@@QEAAXMMMMM@Z";
    premultiplyAlpha :: (this: *Surface) -> void #cpp_method #foreign nvtt "?premultiplyAlpha@Surface@nvtt@@QEAAXXZ";
    toGreyScale :: (this: *Surface, redScale: float, greenScale: float, blueScale: float, alphaScale: float) -> void #cpp_method #foreign nvtt "?toGreyScale@Surface@nvtt@@QEAAXMMMM@Z";
    setBorder :: (this: *Surface, r: float, g: float, b: float, a: float) -> void #cpp_method #foreign nvtt "?setBorder@Surface@nvtt@@QEAAXMMMM@Z";
    fill :: (this: *Surface, r: float, g: float, b: float, a: float) -> void #cpp_method #foreign nvtt "?fill@Surface@nvtt@@QEAAXMMMM@Z";
    scaleAlphaToCoverage :: (this: *Surface, coverage: float, alphaRef: float = 0.5, alpha_channel: s32 = 3) -> void #cpp_method #foreign nvtt "?scaleAlphaToCoverage@Surface@nvtt@@QEAAXMMH@Z";
    toRGBM :: (this: *Surface, range: float = 1.0, threshold: float = 0.25) -> void #cpp_method #foreign nvtt "?toRGBM@Surface@nvtt@@QEAAXMM@Z";
    fromRGBM :: (this: *Surface, range: float = 1.0, threshold: float = 0.25) -> void #cpp_method #foreign nvtt "?fromRGBM@Surface@nvtt@@QEAAXMM@Z";
    toLM :: (this: *Surface, range: float = 1.0, threshold: float = 0.0) -> void #cpp_method #foreign nvtt "?toLM@Surface@nvtt@@QEAAXMM@Z";
    toRGBE :: (this: *Surface, mantissaBits: s32, exponentBits: s32) -> void #cpp_method #foreign nvtt "?toRGBE@Surface@nvtt@@QEAAXHH@Z";
    fromRGBE :: (this: *Surface, mantissaBits: s32, exponentBits: s32) -> void #cpp_method #foreign nvtt "?fromRGBE@Surface@nvtt@@QEAAXHH@Z";
    toYCoCg :: (this: *Surface) -> void #cpp_method #foreign nvtt "?toYCoCg@Surface@nvtt@@QEAAXXZ";
    blockScaleCoCg :: (this: *Surface, bits: s32 = 5, threshold: float = 0.0) -> void #cpp_method #foreign nvtt "?blockScaleCoCg@Surface@nvtt@@QEAAXHM@Z";
    fromYCoCg :: (this: *Surface) -> void #cpp_method #foreign nvtt "?fromYCoCg@Surface@nvtt@@QEAAXXZ";
    toLUVW :: (this: *Surface, range: float = 1.0) -> void #cpp_method #foreign nvtt "?toLUVW@Surface@nvtt@@QEAAXM@Z";
    fromLUVW :: (this: *Surface, range: float = 1.0) -> void #cpp_method #foreign nvtt "?fromLUVW@Surface@nvtt@@QEAAXM@Z";
    abs :: (this: *Surface, channel: s32) -> void #cpp_method #foreign nvtt "?abs@Surface@nvtt@@QEAAXH@Z";
    convolve :: (this: *Surface, channel: s32, kernelSize: s32, kernelData: *float) -> void #cpp_method #foreign nvtt "?convolve@Surface@nvtt@@QEAAXHHPEAM@Z";
    toLogScale :: (this: *Surface, channel: s32, base: float) -> void #cpp_method #foreign nvtt "?toLogScale@Surface@nvtt@@QEAAXHM@Z";
    fromLogScale :: (this: *Surface, channel: s32, base: float) -> void #cpp_method #foreign nvtt "?fromLogScale@Surface@nvtt@@QEAAXHM@Z";
    setAtlasBorder :: (this: *Surface, w: s32, h: s32, r: float, g: float, b: float, a: float) -> void #cpp_method #foreign nvtt "?setAtlasBorder@Surface@nvtt@@QEAAXHHMMMM@Z";

    toneMap :: (this: *Surface, tm: ToneMapper, parameters: *float) -> void #cpp_method #foreign nvtt "?toneMap@Surface@nvtt@@QEAAXW4ToneMapper@2@PEAM@Z";

    binarize :: (this: *Surface, channel: s32, threshold: float, dither: bool) -> void #cpp_method #foreign nvtt "?binarize@Surface@nvtt@@QEAAXHM_N@Z";
    quantize :: (this: *Surface, channel: s32, bits: s32, exactEndPoints: bool, dither: bool) -> void #cpp_method #foreign nvtt "?quantize@Surface@nvtt@@QEAAXHH_N0@Z";

    toNormalMap :: (this: *Surface, sm: float, medium: float, big: float, large: float) -> void #cpp_method #foreign nvtt "?toNormalMap@Surface@nvtt@@QEAAXMMMM@Z";
    normalizeNormalMap :: (this: *Surface) -> void #cpp_method #foreign nvtt "?normalizeNormalMap@Surface@nvtt@@QEAAXXZ";
    transformNormals :: (this: *Surface, xform: NormalTransform) -> void #cpp_method #foreign nvtt "?transformNormals@Surface@nvtt@@QEAAXW4NormalTransform@2@@Z";
    reconstructNormals :: (this: *Surface, xform: NormalTransform) -> void #cpp_method #foreign nvtt "?reconstructNormals@Surface@nvtt@@QEAAXW4NormalTransform@2@@Z";
    toCleanNormalMap :: (this: *Surface) -> void #cpp_method #foreign nvtt "?toCleanNormalMap@Surface@nvtt@@QEAAXXZ";
    packNormals :: (this: *Surface, scale: float = 0.5, bias: float = 0.5) -> void #cpp_method #foreign nvtt "?packNormals@Surface@nvtt@@QEAAXMM@Z";
    expandNormals :: (this: *Surface, scale: float = 2.0, bias: float = -1.0) -> void #cpp_method #foreign nvtt "?expandNormals@Surface@nvtt@@QEAAXMM@Z";
    createToksvigMap :: (this: *Surface, power: float) -> Surface {
        result: Surface;
        native_object_return_1(this, *result, power);
        return result;
    }
    createCleanMap :: (this: *Surface) -> Surface {
        result: Surface;
        native_object_return_2(this, *result);
        return result;
    }

    flipX :: (this: *Surface) -> void #cpp_method #foreign nvtt "?flipX@Surface@nvtt@@QEAAXXZ";
    flipY :: (this: *Surface) -> void #cpp_method #foreign nvtt "?flipY@Surface@nvtt@@QEAAXXZ";
    flipZ :: (this: *Surface) -> void #cpp_method #foreign nvtt "?flipZ@Surface@nvtt@@QEAAXXZ";
    createSubImage :: (this: *Surface, x0: s32, x1: s32, y0: s32, y1: s32, z0: s32, z1: s32) -> Surface {
        result: Surface;
        native_object_return_3(this, *result, x0, x1, y0, y1, z0, z1);
        return result;
    }

    warp :: (this: *Surface, w: s32, h: s32, f: WarpFunction) -> Surface {
        result: Surface;
        native_object_return_4(this, *result, w, h, f);
        return result;
    }
    warp :: (this: *Surface, w: s32, h: s32, d: s32, f: WarpFunction) -> Surface {
        result: Surface;
        native_object_return_5(this, *result, w, h, d, f);
        return result;
    }

    copyChannel :: (this: *Surface, srcImage: *Surface, srcChannel: s32) -> bool #cpp_method #foreign nvtt "?copyChannel@Surface@nvtt@@QEAA_NAEBU12@H@Z";
    copyChannel :: (this: *Surface, srcImage: Surface, srcChannel: s32) -> bool #no_context {
    return copyChannel(this, *srcImage, srcChannel);
}
    copyChannel :: (this: *Surface, srcImage: *Surface, srcChannel: s32, dstChannel: s32) -> bool #cpp_method #foreign nvtt "?copyChannel@Surface@nvtt@@QEAA_NAEBU12@HH@Z";
    copyChannel :: (this: *Surface, srcImage: Surface, srcChannel: s32, dstChannel: s32) -> bool #no_context {
    return copyChannel(this, *srcImage, srcChannel, dstChannel);
}

    addChannel :: (this: *Surface, img: *Surface, srcChannel: s32, dstChannel: s32, scale: float) -> bool #cpp_method #foreign nvtt "?addChannel@Surface@nvtt@@QEAA_NAEBU12@HHM@Z";
    addChannel :: (this: *Surface, img: Surface, srcChannel: s32, dstChannel: s32, scale: float) -> bool #no_context {
    return addChannel(this, *img, srcChannel, dstChannel, scale);
}

    copy :: (this: *Surface, src: *Surface, xsrc: s32, ysrc: s32, zsrc: s32, xsize: s32, ysize: s32, zsize: s32, xdst: s32, ydst: s32, zdst: s32) -> bool #cpp_method #foreign nvtt "?copy@Surface@nvtt@@QEAA_NAEBU12@HHHHHHHHH@Z";
    copy :: (this: *Surface, src: Surface, xsrc: s32, ysrc: s32, zsrc: s32, xsize: s32, ysize: s32, zsize: s32, xdst: s32, ydst: s32, zdst: s32) -> bool #no_context {
    return copy(this, *src, xsrc, ysrc, zsrc, xsize, ysize, zsize, xdst, ydst, zdst);
}

    Private :: struct {}
    m: *Private;
}

operator_assign :: (this: *Surface, img: *Surface) -> void #cpp_method #foreign nvtt "??4Surface@nvtt@@QEAAXAEBU01@@Z";
operator_assign :: (this: *Surface, img: Surface) #no_context {
    operator_assign(this, *img);
}

CubeLayout :: enum s32 {
    VerticalCross     :: 0;
    HorizontalCross   :: 1;
    Column            :: 2;
    Row               :: 3;
    LatitudeLongitude :: 4;
}

EdgeFixup :: enum s32 {
    None    :: 0;
    Stretch :: 1;
    Warp    :: 2;
    Average :: 3;
}

CubeSurface :: struct  {
    Constructor :: (this: *CubeSurface) -> void #cpp_method #foreign nvtt "??0CubeSurface@nvtt@@QEAA@XZ";
    CopyConstructor :: (this: *CubeSurface, img: *CubeSurface) -> void #cpp_method #foreign nvtt "??0CubeSurface@nvtt@@QEAA@AEBU01@@Z";
    CopyConstructor :: (this: *CubeSurface, img: CubeSurface) #no_context {
    CopyConstructor(this, *img);
}
    Destructor :: (this: *CubeSurface) -> void #cpp_method #foreign nvtt "??1CubeSurface@nvtt@@QEAA@XZ";

    isNull :: (this: *CubeSurface) -> bool #cpp_method #foreign nvtt "?isNull@CubeSurface@nvtt@@QEBA_NXZ";
    edgeLength :: (this: *CubeSurface) -> s32 #cpp_method #foreign nvtt "?edgeLength@CubeSurface@nvtt@@QEBAHXZ";
    countMipmaps :: (this: *CubeSurface) -> s32 #cpp_method #foreign nvtt "?countMipmaps@CubeSurface@nvtt@@QEBAHXZ";

    load :: (this: *CubeSurface, fileName: *u8, mipmap: s32) -> bool #cpp_method #foreign nvtt "?load@CubeSurface@nvtt@@QEAA_NPEBDH@Z";
    save :: (this: *CubeSurface, fileName: *u8) -> bool #cpp_method #foreign nvtt "?save@CubeSurface@nvtt@@QEBA_NPEBD@Z";

    face :: (this: *CubeSurface, face: s32) -> *Surface #cpp_method #foreign nvtt "?face@CubeSurface@nvtt@@QEAAAEAUSurface@2@H@Z";
    face_1 :: (this:  *CubeSurface, face: s32) -> *Surface #cpp_method #foreign nvtt "?face@CubeSurface@nvtt@@QEBAAEBUSurface@2@H@Z";

    fold :: (this: *CubeSurface, img: *Surface, layout: CubeLayout) -> void #cpp_method #foreign nvtt "?fold@CubeSurface@nvtt@@QEAAXAEBUSurface@2@W4CubeLayout@2@@Z";
    fold :: (this: *CubeSurface, img: Surface, layout: CubeLayout) #no_context {
    fold(this, *img, layout);
}
    unfold :: (this: *CubeSurface, layout: CubeLayout) -> Surface {
        result: Surface;
        native_object_return_6(this, *result, layout);
        return result;
    }

    average :: (this: *CubeSurface, channel: s32) -> float #cpp_method #foreign nvtt "?average@CubeSurface@nvtt@@QEBAMH@Z";
    range :: (this: *CubeSurface, channel: s32, minimum_ptr: *float, maximum_ptr: *float) -> void #cpp_method #foreign nvtt "?range@CubeSurface@nvtt@@QEBAXHPEAM0@Z";
    clamp :: (this: *CubeSurface, channel: s32, low: float = 0.0, high: float = 1.0) -> void #cpp_method #foreign nvtt "?clamp@CubeSurface@nvtt@@QEAAXHMM@Z";

    irradianceFilter :: (this: *CubeSurface, size: s32, fixupMethod: EdgeFixup) -> CubeSurface {
        result: CubeSurface;
        native_object_return_7(this, *result, size, fixupMethod);
        return result;
    }
    cosinePowerFilter :: (this: *CubeSurface, size: s32, cosinePower: float, fixupMethod: EdgeFixup) -> CubeSurface {
        result: CubeSurface;
        native_object_return_8(this, *result, size, cosinePower, fixupMethod);
        return result;
    }

    fastResample :: (this: *CubeSurface, size: s32, fixupMethod: EdgeFixup) -> CubeSurface {
        result: CubeSurface;
        native_object_return_9(this, *result, size, fixupMethod);
        return result;
    }

    toLinear :: (this: *CubeSurface, gamma: float) -> void #cpp_method #foreign nvtt "?toLinear@CubeSurface@nvtt@@QEAAXM@Z";
    toGamma :: (this: *CubeSurface, gamma: float) -> void #cpp_method #foreign nvtt "?toGamma@CubeSurface@nvtt@@QEAAXM@Z";

    Private :: struct {}
    m: *Private;
}

operator_assign :: (this: *CubeSurface, img: *CubeSurface) -> void #cpp_method #foreign nvtt "??4CubeSurface@nvtt@@QEAAXAEBU01@@Z";
operator_assign :: (this: *CubeSurface, img: CubeSurface) #no_context {
    operator_assign(this, *img);
}

errorString :: (e: Error) -> *u8 #foreign nvtt "?errorString@nvtt@@YAPEBDW4Error@1@@Z";

version :: () -> u32 #foreign nvtt "?version@nvtt@@YAIXZ";

rmsError :: (reference: *Surface, img: *Surface) -> float #foreign nvtt "?rmsError@nvtt@@YAMAEBUSurface@1@0@Z";
rmsError :: (reference: Surface, img: Surface) -> float #no_context {
    return rmsError(*reference, *img);
}
rmsAlphaError :: (reference: *Surface, img: *Surface) -> float #foreign nvtt "?rmsAlphaError@nvtt@@YAMAEBUSurface@1@0@Z";
rmsAlphaError :: (reference: Surface, img: Surface) -> float #no_context {
    return rmsAlphaError(*reference, *img);
}
cieLabError :: (reference: *Surface, img: *Surface) -> float #foreign nvtt "?cieLabError@nvtt@@YAMAEBUSurface@1@0@Z";
cieLabError :: (reference: Surface, img: Surface) -> float #no_context {
    return cieLabError(*reference, *img);
}
angularError :: (reference: *Surface, img: *Surface) -> float #foreign nvtt "?angularError@nvtt@@YAMAEBUSurface@1@0@Z";
angularError :: (reference: Surface, img: Surface) -> float #no_context {
    return angularError(*reference, *img);
}
diff :: (reference: *Surface, img: *Surface, scale: float) -> Surface {
        result: Surface;
        native_object_return_10(*result, reference, img, scale);
        return result;
    }
diff :: (reference: Surface, img: Surface, scale: float) -> Surface #no_context {
    return diff(*reference, *img, scale);
}

rmsToneMappedError :: (reference: *Surface, img: *Surface, exposure: float) -> float #foreign nvtt "?rmsToneMappedError@nvtt@@YAMAEBUSurface@1@0M@Z";
rmsToneMappedError :: (reference: Surface, img: Surface, exposure: float) -> float #no_context {
    return rmsToneMappedError(*reference, *img, exposure);
}

histogram :: (img: *Surface, width: s32, height: s32) -> Surface {
        result: Surface;
        native_object_return_11(*result, img, width, height);
        return result;
    }
histogram :: (img: Surface, width: s32, height: s32) -> Surface #no_context {
    return histogram(*img, width, height);
}
histogram :: (img: *Surface, minRange: float, maxRange: float, width: s32, height: s32) -> Surface {
        result: Surface;
        native_object_return_12(*result, img, minRange, maxRange, width, height);
        return result;
    }
histogram :: (img: Surface, minRange: float, maxRange: float, width: s32, height: s32) -> Surface #no_context {
    return histogram(*img, minRange, maxRange, width, height);
}

#scope_file

nvtt :: #system_library "nvtt";


#scope_file
// Reviewed legacy C++ ABI: explicit return storage precedes this on Itanium; follows this on MSVC.
native_object_return_1 :: (this: *Surface, result: *Surface, power: float) #foreign nvtt "?createToksvigMap@Surface@nvtt@@QEBA?AU12@M@Z";
native_object_return_2 :: (this: *Surface, result: *Surface) #foreign nvtt "?createCleanMap@Surface@nvtt@@QEBA?AU12@XZ";
native_object_return_3 :: (this: *Surface, result: *Surface, x0: s32, x1: s32, y0: s32, y1: s32, z0: s32, z1: s32) #foreign nvtt "?createSubImage@Surface@nvtt@@QEBA?AU12@HHHHHH@Z";
native_object_return_4 :: (this: *Surface, result: *Surface, w: s32, h: s32, f: WarpFunction) #foreign nvtt "?warp@Surface@nvtt@@QEBA?AU12@HHP6AXAEAM00@Z@Z";
native_object_return_5 :: (this: *Surface, result: *Surface, w: s32, h: s32, d: s32, f: WarpFunction) #foreign nvtt "?warp@Surface@nvtt@@QEBA?AU12@HHHP6AXAEAM00@Z@Z";
native_object_return_6 :: (this: *CubeSurface, result: *Surface, layout: CubeLayout) #foreign nvtt "?unfold@CubeSurface@nvtt@@QEBA?AUSurface@2@W4CubeLayout@2@@Z";
native_object_return_7 :: (this: *CubeSurface, result: *CubeSurface, size: s32, fixupMethod: EdgeFixup) #foreign nvtt "?irradianceFilter@CubeSurface@nvtt@@QEBA?AU12@HW4EdgeFixup@2@@Z";
native_object_return_8 :: (this: *CubeSurface, result: *CubeSurface, size: s32, cosinePower: float, fixupMethod: EdgeFixup) #foreign nvtt "?cosinePowerFilter@CubeSurface@nvtt@@QEBA?AU12@HMW4EdgeFixup@2@@Z";
native_object_return_9 :: (this: *CubeSurface, result: *CubeSurface, size: s32, fixupMethod: EdgeFixup) #foreign nvtt "?fastResample@CubeSurface@nvtt@@QEBA?AU12@HW4EdgeFixup@2@@Z";
native_object_return_10 :: (result: *Surface, reference: *Surface, img: *Surface, scale: float) #foreign nvtt "?diff@nvtt@@YA?AUSurface@1@AEBU21@0M@Z";
native_object_return_11 :: (result: *Surface, img: *Surface, width: s32, height: s32) #foreign nvtt "?histogram@nvtt@@YA?AUSurface@1@AEBU21@HH@Z";
native_object_return_12 :: (result: *Surface, img: *Surface, minRange: float, maxRange: float, width: s32, height: s32) #foreign nvtt "?histogram@nvtt@@YA?AUSurface@1@AEBU21@MMHH@Z";
