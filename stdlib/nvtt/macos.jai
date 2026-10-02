// Independent declaration normalization; behavior status: docs/stdlib/codec-native-bindings.md.
NVTT_VERSION :: 20100;

Format :: enum u32 {
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

PixelType :: enum u32 {
    UnsignedNorm  :: 0;
    SignedNorm    :: 1;
    UnsignedInt   :: 2;
    SignedInt     :: 3;
    Float         :: 4;
    UnsignedFloat :: 5;
    SharedExp     :: 6;
}

Quality :: enum u32 {
    Fastest    :: 0;
    Normal     :: 1;
    Production :: 2;
    Highest    :: 3;
}

Decoder :: enum u32 {
    D3D10 :: 0;
    D3D9  :: 1;
    NV5x  :: 2;
}

CompressionOptions :: struct {
    Private :: struct {}
    m: *Private;

    Constructor :: (this: *CompressionOptions) -> void #cpp_method #foreign libnvtt "_ZN4nvtt18CompressionOptionsC1Ev";
    Destructor_Base :: (this: *CompressionOptions) -> void #cpp_method #foreign libnvtt "_ZN4nvtt18CompressionOptionsD2Ev";
    Destructor :: (this: *CompressionOptions) -> void #cpp_method #foreign libnvtt "_ZN4nvtt18CompressionOptionsD1Ev";

    reset :: (this: *CompressionOptions) -> void #cpp_method #foreign libnvtt "_ZN4nvtt18CompressionOptions5resetEv";

    setFormat :: (this: *CompressionOptions, format: Format) -> void #cpp_method #foreign libnvtt "_ZN4nvtt18CompressionOptions9setFormatENS_6FormatE";
    setQuality :: (this: *CompressionOptions, quality: Quality) -> void #cpp_method #foreign libnvtt "_ZN4nvtt18CompressionOptions10setQualityENS_7QualityE";
    setColorWeights :: (this: *CompressionOptions, red: float, green: float, blue: float, alpha: float = 1.0) -> void #cpp_method #foreign libnvtt "_ZN4nvtt18CompressionOptions15setColorWeightsEffff";
    setRGBMThreshold :: (this: *CompressionOptions, min_m: float) -> void #cpp_method #foreign libnvtt "_ZN4nvtt18CompressionOptions16setRGBMThresholdEf";

    setExternalCompressor :: (this: *CompressionOptions, name: *u8) -> void #cpp_method #foreign libnvtt "_ZN4nvtt18CompressionOptions21setExternalCompressorEPKc";

    setPixelFormat :: (this: *CompressionOptions, bitcount: u32, rmask: u32, gmask: u32, bmask: u32, amask: u32) -> void #cpp_method #foreign libnvtt "_ZN4nvtt18CompressionOptions14setPixelFormatEjjjjj";
    setPixelFormat :: (this: *CompressionOptions, rsize: u8, gsize: u8, bsize: u8, asize: u8) -> void #cpp_method #foreign libnvtt "_ZN4nvtt18CompressionOptions14setPixelFormatEhhhh";

    setPixelType :: (this: *CompressionOptions, pixelType: PixelType) -> void #cpp_method #foreign libnvtt "_ZN4nvtt18CompressionOptions12setPixelTypeENS_9PixelTypeE";

    setPitchAlignment :: (this: *CompressionOptions, pitchAlignment: s32) -> void #cpp_method #foreign libnvtt "_ZN4nvtt18CompressionOptions17setPitchAlignmentEi";

    setQuantization :: (this: *CompressionOptions, colorDithering: bool, alphaDithering: bool, binaryAlpha: bool, alphaThreshold: s32 = 127) -> void #cpp_method #foreign libnvtt "_ZN4nvtt18CompressionOptions15setQuantizationEbbbi";

    setTargetDecoder :: (this: *CompressionOptions, decoder: Decoder) -> void #cpp_method #foreign libnvtt "_ZN4nvtt18CompressionOptions16setTargetDecoderENS_7DecoderE";

    format :: (this: *CompressionOptions) -> Format #cpp_method #foreign libnvtt "_ZNK4nvtt18CompressionOptions6formatEv";
    d3d9Format :: (this: *CompressionOptions) -> u32 #cpp_method #foreign libnvtt "_ZNK4nvtt18CompressionOptions10d3d9FormatEv";
    dxgiFormat :: (this: *CompressionOptions) -> u32 #cpp_method #foreign libnvtt "_ZNK4nvtt18CompressionOptions10dxgiFormatEv";
}

WrapMode :: enum u32 {
    Clamp  :: 0;
    Repeat :: 1;
    Mirror :: 2;
}

TextureType :: enum u32 {
    _2D   :: 0;
    Cube  :: 1;
    _3D   :: 2;
    Array :: 3;
}

InputFormat :: enum u32 {
    BGRA_8UB :: 0;
    RGBA_16F :: 1;
    RGBA_32F :: 2;
    R_32F    :: 3;
}

MipmapFilter :: enum u32 {
    Box      :: 0;
    Triangle :: 1;
    Kaiser   :: 2;
}

ResizeFilter :: enum u32 {
    Box      :: 0;
    Triangle :: 1;
    Kaiser   :: 2;
    Mitchell :: 3;
}

RoundMode :: enum u32 {
    None                     :: 0;
    ToNextPowerOfTwo         :: 1;
    ToNearestPowerOfTwo      :: 2;
    ToPreviousPowerOfTwo     :: 3;
    ToNextMultipleOfFour     :: 4;
    ToNearestMultipleOfFour  :: 5;
    ToPreviousMultipleOfFour :: 6;
}

AlphaMode :: enum u32 {
    None          :: 0;
    Transparency  :: 1;
    Premultiplied :: 2;
}

ShapeRestriction :: enum u32 {
    None   :: 0;
    Square :: 1;
}

InputOptions :: struct {
    Private :: struct {}
    m: *Private;

    Constructor :: (this: *InputOptions) -> void #cpp_method #foreign libnvtt "_ZN4nvtt12InputOptionsC1Ev";
    Destructor_Base :: (this: *InputOptions) -> void #cpp_method #foreign libnvtt "_ZN4nvtt12InputOptionsD2Ev";
    Destructor :: (this: *InputOptions) -> void #cpp_method #foreign libnvtt "_ZN4nvtt12InputOptionsD1Ev";

    reset :: (this: *InputOptions) -> void #cpp_method #foreign libnvtt "_ZN4nvtt12InputOptions5resetEv";

    setTextureLayout :: (this: *InputOptions, type: TextureType, w: s32, h: s32, d: s32 = 1, arraySize: s32 = 1) -> void #cpp_method #foreign libnvtt "_ZN4nvtt12InputOptions16setTextureLayoutENS_11TextureTypeEiiii";
    resetTextureLayout :: (this: *InputOptions) -> void #cpp_method #foreign libnvtt "_ZN4nvtt12InputOptions18resetTextureLayoutEv";

    setMipmapData :: (this: *InputOptions, data: *void, w: s32, h: s32, d: s32 = 1, face: s32 = 0, mipmap: s32 = 0) -> bool #cpp_method #foreign libnvtt "_ZN4nvtt12InputOptions13setMipmapDataEPKviiiii";

    setFormat :: (this: *InputOptions, format: InputFormat) -> void #cpp_method #foreign libnvtt "_ZN4nvtt12InputOptions9setFormatENS_11InputFormatE";

    setAlphaMode :: (this: *InputOptions, alphaMode: AlphaMode) -> void #cpp_method #foreign libnvtt "_ZN4nvtt12InputOptions12setAlphaModeENS_9AlphaModeE";

    setGamma :: (this: *InputOptions, inputGamma: float, outputGamma: float) -> void #cpp_method #foreign libnvtt "_ZN4nvtt12InputOptions8setGammaEff";

    setWrapMode :: (this: *InputOptions, mode: WrapMode) -> void #cpp_method #foreign libnvtt "_ZN4nvtt12InputOptions11setWrapModeENS_8WrapModeE";

    setMipmapFilter :: (this: *InputOptions, filter: MipmapFilter) -> void #cpp_method #foreign libnvtt "_ZN4nvtt12InputOptions15setMipmapFilterENS_12MipmapFilterE";
    setMipmapGeneration :: (this: *InputOptions, enabled: bool, maxLevel: s32 = -1) -> void #cpp_method #foreign libnvtt "_ZN4nvtt12InputOptions19setMipmapGenerationEbi";
    setKaiserParameters :: (this: *InputOptions, width: float, alpha: float, stretch: float) -> void #cpp_method #foreign libnvtt "_ZN4nvtt12InputOptions19setKaiserParametersEfff";

    setNormalMap :: (this: *InputOptions, b: bool) -> void #cpp_method #foreign libnvtt "_ZN4nvtt12InputOptions12setNormalMapEb";
    setConvertToNormalMap :: (this: *InputOptions, convert: bool) -> void #cpp_method #foreign libnvtt "_ZN4nvtt12InputOptions21setConvertToNormalMapEb";
    setHeightEvaluation :: (this: *InputOptions, redScale: float, greenScale: float, blueScale: float, alphaScale: float) -> void #cpp_method #foreign libnvtt "_ZN4nvtt12InputOptions19setHeightEvaluationEffff";
    setNormalFilter :: (this: *InputOptions, sm: float, medium: float, big: float, large: float) -> void #cpp_method #foreign libnvtt "_ZN4nvtt12InputOptions15setNormalFilterEffff";
    setNormalizeMipmaps :: (this: *InputOptions, b: bool) -> void #cpp_method #foreign libnvtt "_ZN4nvtt12InputOptions19setNormalizeMipmapsEb";

    setMaxExtents :: (this: *InputOptions, d: s32) -> void #cpp_method #foreign libnvtt "_ZN4nvtt12InputOptions13setMaxExtentsEi";
    setRoundMode :: (this: *InputOptions, mode: RoundMode) -> void #cpp_method #foreign libnvtt "_ZN4nvtt12InputOptions12setRoundModeENS_9RoundModeE";
}

OutputHandler :: struct {
    vtable: *OutputHandler_VTable;
    Destructor_Base :: (this: *OutputHandler) -> void #cpp_method #foreign __UnknownLib "_ZN4nvtt13OutputHandlerD2Ev";
}
OutputHandler_VTable :: struct #type_info_none {
    Destructor: (this: *OutputHandler) -> void #cpp_method;
    Destructor_Deleting: (this: *OutputHandler) -> void #cpp_method;

    beginImage: (this: *OutputHandler, size: s32, width: s32, height: s32, depth: s32, face: s32, miplevel: s32) -> void #cpp_method;

    writeData: (this: *OutputHandler, data: *void, size: s32) -> bool #cpp_method;

    endImage: (this: *OutputHandler) -> void #cpp_method;
}

OutputHandler_Destructor :: (this: *OutputHandler) #foreign codec_adapter "jai_stdlib_nvtt_macos_OutputHandler_Destructor_1";
OutputHandler_Destructor_Deleting :: (this: *OutputHandler) #foreign codec_adapter "jai_stdlib_nvtt_macos_OutputHandler_Destructor_Deleting_1";

OutputHandler_beginImage :: (this: *OutputHandler, size: s32, width: s32, height: s32, depth: s32, face: s32, miplevel: s32) #foreign codec_adapter "jai_stdlib_nvtt_macos_OutputHandler_beginImage_1";

OutputHandler_writeData :: (this: *OutputHandler, data: *void, size: s32) -> bool #foreign codec_adapter "jai_stdlib_nvtt_macos_OutputHandler_writeData_1";

OutputHandler_endImage :: (this: *OutputHandler) #foreign codec_adapter "jai_stdlib_nvtt_macos_OutputHandler_endImage_1";

vtable :: (obj: *OutputHandler) -> *OutputHandler_VTable #foreign codec_adapter "jai_stdlib_nvtt_macos_vtable_1";

Error :: enum u32 {
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
    Destructor_Base :: (this: *ErrorHandler) -> void #cpp_method #foreign __UnknownLib "_ZN4nvtt12ErrorHandlerD2Ev";
}
ErrorHandler_VTable :: struct #type_info_none {
    Destructor: (this: *ErrorHandler) -> void #cpp_method;
    Destructor_Deleting: (this: *ErrorHandler) -> void #cpp_method;

    error: (this: *ErrorHandler, e: Error) -> void #cpp_method;
}

ErrorHandler_Destructor :: (this: *ErrorHandler) #foreign codec_adapter "jai_stdlib_nvtt_macos_ErrorHandler_Destructor_1";
ErrorHandler_Destructor_Deleting :: (this: *ErrorHandler) #foreign codec_adapter "jai_stdlib_nvtt_macos_ErrorHandler_Destructor_Deleting_1";

ErrorHandler_error :: (this: *ErrorHandler, e: Error) #foreign codec_adapter "jai_stdlib_nvtt_macos_ErrorHandler_error_1";

vtable :: (obj: *ErrorHandler) -> *ErrorHandler_VTable #foreign codec_adapter "jai_stdlib_nvtt_macos_vtable_2";

Container :: enum u32 {
    DDS   :: 0;
    DDS10 :: 1;
    KTX   :: 2;
}

OutputOptions :: struct {
    Private :: struct {}
    m: *Private;

    Constructor :: (this: *OutputOptions) -> void #cpp_method #foreign libnvtt "_ZN4nvtt13OutputOptionsC1Ev";
    Destructor_Base :: (this: *OutputOptions) -> void #cpp_method #foreign libnvtt "_ZN4nvtt13OutputOptionsD2Ev";
    Destructor :: (this: *OutputOptions) -> void #cpp_method #foreign libnvtt "_ZN4nvtt13OutputOptionsD1Ev";

    reset :: (this: *OutputOptions) -> void #cpp_method #foreign libnvtt "_ZN4nvtt13OutputOptions5resetEv";

    setFileName :: (this: *OutputOptions, fileName: *u8) -> void #cpp_method #foreign libnvtt "_ZN4nvtt13OutputOptions11setFileNameEPKc";
    setFileHandle :: (this: *OutputOptions, fp: *void) -> void #cpp_method #foreign libnvtt "_ZN4nvtt13OutputOptions13setFileHandleEPv";

    setOutputHandler :: (this: *OutputOptions, outputHandler: *OutputHandler) -> void #cpp_method #foreign libnvtt "_ZN4nvtt13OutputOptions16setOutputHandlerEPNS_13OutputHandlerE";
    setErrorHandler :: (this: *OutputOptions, errorHandler: *ErrorHandler) -> void #cpp_method #foreign libnvtt "_ZN4nvtt13OutputOptions15setErrorHandlerEPNS_12ErrorHandlerE";

    setOutputHeader :: (this: *OutputOptions, outputHeader: bool) -> void #cpp_method #foreign libnvtt "_ZN4nvtt13OutputOptions15setOutputHeaderEb";
    setContainer :: (this: *OutputOptions, container: Container) -> void #cpp_method #foreign libnvtt "_ZN4nvtt13OutputOptions12setContainerENS_9ContainerE";
    setUserVersion :: (this: *OutputOptions, version: s32) -> void #cpp_method #foreign libnvtt "_ZN4nvtt13OutputOptions14setUserVersionEi";
    setSrgbFlag :: (this: *OutputOptions, b: bool) -> void #cpp_method #foreign libnvtt "_ZN4nvtt13OutputOptions11setSrgbFlagEb";
}

Task :: #type (_context: *void, id: s32) -> void #c_call;

TaskDispatcher :: struct {
    vtable: *TaskDispatcher_VTable;
    Destructor_Base :: (this: *TaskDispatcher) -> void #cpp_method #foreign __UnknownLib "_ZN4nvtt14TaskDispatcherD2Ev";
}
TaskDispatcher_VTable :: struct #type_info_none {
    Destructor: (this: *TaskDispatcher) -> void #cpp_method;
    Destructor_Deleting: (this: *TaskDispatcher) -> void #cpp_method;

    dispatch: (this: *TaskDispatcher, task: Task, _context: *void, count: s32) -> void #cpp_method;
}

TaskDispatcher_Destructor :: (this: *TaskDispatcher) #foreign codec_adapter "jai_stdlib_nvtt_macos_TaskDispatcher_Destructor_1";
TaskDispatcher_Destructor_Deleting :: (this: *TaskDispatcher) #foreign codec_adapter "jai_stdlib_nvtt_macos_TaskDispatcher_Destructor_Deleting_1";

TaskDispatcher_dispatch :: (this: *TaskDispatcher, task: Task, _context: *void, count: s32) #foreign codec_adapter "jai_stdlib_nvtt_macos_TaskDispatcher_dispatch_1";

vtable :: (obj: *TaskDispatcher) -> *TaskDispatcher_VTable #foreign codec_adapter "jai_stdlib_nvtt_macos_vtable_3";

Compressor :: struct  {
    Private :: struct {}
    m: *Private;

    Constructor :: (this: *Compressor) -> void #cpp_method #foreign libnvtt "_ZN4nvtt10CompressorC1Ev";
    Destructor_Base :: (this: *Compressor) -> void #cpp_method #foreign libnvtt "_ZN4nvtt10CompressorD2Ev";
    Destructor :: (this: *Compressor) -> void #cpp_method #foreign libnvtt "_ZN4nvtt10CompressorD1Ev";

    enableCudaAcceleration :: (this: *Compressor, enable: bool) -> void #cpp_method #foreign libnvtt "_ZN4nvtt10Compressor22enableCudaAccelerationEb";
    isCudaAccelerationEnabled :: (this: *Compressor) -> bool #cpp_method #foreign libnvtt "_ZNK4nvtt10Compressor25isCudaAccelerationEnabledEv";
    setTaskDispatcher :: (this: *Compressor, disp: *TaskDispatcher) -> void #cpp_method #foreign libnvtt "_ZN4nvtt10Compressor17setTaskDispatcherEPNS_14TaskDispatcherE";

    process :: (this: *Compressor, inputOptions: *InputOptions, compressionOptions: *CompressionOptions, outputOptions: *OutputOptions) -> bool #cpp_method #foreign libnvtt "_ZNK4nvtt10Compressor7processERKNS_12InputOptionsERKNS_18CompressionOptionsERKNS_13OutputOptionsE";
    process :: (this: *Compressor, inputOptions: InputOptions, compressionOptions: CompressionOptions, outputOptions: OutputOptions) -> bool #no_context {
    return process(this, *inputOptions, *compressionOptions, *outputOptions);
}
    estimateSize :: (this: *Compressor, inputOptions: *InputOptions, compressionOptions: *CompressionOptions) -> s32 #cpp_method #foreign libnvtt "_ZNK4nvtt10Compressor12estimateSizeERKNS_12InputOptionsERKNS_18CompressionOptionsE";
    estimateSize :: (this: *Compressor, inputOptions: InputOptions, compressionOptions: CompressionOptions) -> s32 #no_context {
    return estimateSize(this, *inputOptions, *compressionOptions);
}

    outputHeader :: (this: *Compressor, img: *Surface, mipmapCount: s32, compressionOptions: *CompressionOptions, outputOptions: *OutputOptions) -> bool #cpp_method #foreign libnvtt "_ZNK4nvtt10Compressor12outputHeaderERKNS_7SurfaceEiRKNS_18CompressionOptionsERKNS_13OutputOptionsE";
    outputHeader :: (this: *Compressor, img: Surface, mipmapCount: s32, compressionOptions: CompressionOptions, outputOptions: OutputOptions) -> bool #no_context {
    return outputHeader(this, *img, mipmapCount, *compressionOptions, *outputOptions);
}
    compress :: (this: *Compressor, img: *Surface, face: s32, mipmap: s32, compressionOptions: *CompressionOptions, outputOptions: *OutputOptions) -> bool #cpp_method #foreign libnvtt "_ZNK4nvtt10Compressor8compressERKNS_7SurfaceEiiRKNS_18CompressionOptionsERKNS_13OutputOptionsE";
    compress :: (this: *Compressor, img: Surface, face: s32, mipmap: s32, compressionOptions: CompressionOptions, outputOptions: OutputOptions) -> bool #no_context {
    return compress(this, *img, face, mipmap, *compressionOptions, *outputOptions);
}
    estimateSize :: (this: *Compressor, img: *Surface, mipmapCount: s32, compressionOptions: *CompressionOptions) -> s32 #cpp_method #foreign libnvtt "_ZNK4nvtt10Compressor12estimateSizeERKNS_7SurfaceEiRKNS_18CompressionOptionsE";
    estimateSize :: (this: *Compressor, img: Surface, mipmapCount: s32, compressionOptions: CompressionOptions) -> s32 #no_context {
    return estimateSize(this, *img, mipmapCount, *compressionOptions);
}

    outputHeader :: (this: *Compressor, cube: *CubeSurface, mipmapCount: s32, compressionOptions: *CompressionOptions, outputOptions: *OutputOptions) -> bool #cpp_method #foreign libnvtt "_ZNK4nvtt10Compressor12outputHeaderERKNS_11CubeSurfaceEiRKNS_18CompressionOptionsERKNS_13OutputOptionsE";
    outputHeader :: (this: *Compressor, cube: CubeSurface, mipmapCount: s32, compressionOptions: CompressionOptions, outputOptions: OutputOptions) -> bool #no_context {
    return outputHeader(this, *cube, mipmapCount, *compressionOptions, *outputOptions);
}
    compress :: (this: *Compressor, cube: *CubeSurface, mipmap: s32, compressionOptions: *CompressionOptions, outputOptions: *OutputOptions) -> bool #cpp_method #foreign libnvtt "_ZNK4nvtt10Compressor8compressERKNS_11CubeSurfaceEiRKNS_18CompressionOptionsERKNS_13OutputOptionsE";
    compress :: (this: *Compressor, cube: CubeSurface, mipmap: s32, compressionOptions: CompressionOptions, outputOptions: OutputOptions) -> bool #no_context {
    return compress(this, *cube, mipmap, *compressionOptions, *outputOptions);
}
    estimateSize :: (this: *Compressor, cube: *CubeSurface, mipmapCount: s32, compressionOptions: *CompressionOptions) -> s32 #cpp_method #foreign libnvtt "_ZNK4nvtt10Compressor12estimateSizeERKNS_11CubeSurfaceEiRKNS_18CompressionOptionsE";
    estimateSize :: (this: *Compressor, cube: CubeSurface, mipmapCount: s32, compressionOptions: CompressionOptions) -> s32 #no_context {
    return estimateSize(this, *cube, mipmapCount, *compressionOptions);
}

    outputHeader :: (this: *Compressor, type: TextureType, w: s32, h: s32, d: s32, arraySize: s32, mipmapCount: s32, isNormalMap: bool, compressionOptions: *CompressionOptions, outputOptions: *OutputOptions) -> bool #cpp_method #foreign libnvtt "_ZNK4nvtt10Compressor12outputHeaderENS_11TextureTypeEiiiiibRKNS_18CompressionOptionsERKNS_13OutputOptionsE";
    outputHeader :: (this: *Compressor, type: TextureType, w: s32, h: s32, d: s32, arraySize: s32, mipmapCount: s32, isNormalMap: bool, compressionOptions: CompressionOptions, outputOptions: OutputOptions) -> bool #no_context {
    return outputHeader(this, type, w, h, d, arraySize, mipmapCount, isNormalMap, *compressionOptions, *outputOptions);
}
    compress :: (this: *Compressor, w: s32, h: s32, d: s32, face: s32, mipmap: s32, rgba: *float, compressionOptions: *CompressionOptions, outputOptions: *OutputOptions) -> bool #cpp_method #foreign libnvtt "_ZNK4nvtt10Compressor8compressEiiiiiPKfRKNS_18CompressionOptionsERKNS_13OutputOptionsE";
    compress :: (this: *Compressor, w: s32, h: s32, d: s32, face: s32, mipmap: s32, rgba: *float, compressionOptions: CompressionOptions, outputOptions: OutputOptions) -> bool #no_context {
    return compress(this, w, h, d, face, mipmap, rgba, *compressionOptions, *outputOptions);
}
    estimateSize :: (this: *Compressor, w: s32, h: s32, d: s32, mipmapCount: s32, compressionOptions: *CompressionOptions) -> s32 #cpp_method #foreign libnvtt "_ZNK4nvtt10Compressor12estimateSizeEiiiiRKNS_18CompressionOptionsE";
    estimateSize :: (this: *Compressor, w: s32, h: s32, d: s32, mipmapCount: s32, compressionOptions: CompressionOptions) -> s32 #no_context {
    return estimateSize(this, w, h, d, mipmapCount, *compressionOptions);
}
}

Context :: Compressor;

NormalTransform :: enum u32 {
    Orthographic  :: 0;
    Stereographic :: 1;
    Paraboloid    :: 2;
    Quartic       :: 3;
}

ToneMapper :: enum u32 {
    Linear    :: 0;
    Reindhart :: 1;
    Halo      :: 2;
    Lightmap  :: 3;
}

WarpFunction :: #type (x: *float, y: *float, d: *float) -> void #c_call;

Surface :: struct #type_info_none {
    Constructor :: (this: *Surface) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7SurfaceC1Ev";
    CopyConstructor :: (this: *Surface, img: *Surface) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7SurfaceC1ERKS0_";
    CopyConstructor :: (this: *Surface, img: Surface) #no_context {
    CopyConstructor(this, *img);
}
    Destructor_Base :: (this: *Surface) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7SurfaceD2Ev";
    Destructor :: (this: *Surface) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7SurfaceD1Ev";

    setWrapMode :: (this: *Surface, mode: WrapMode) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface11setWrapModeENS_8WrapModeE";
    setAlphaMode :: (this: *Surface, alphaMode: AlphaMode) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface12setAlphaModeENS_9AlphaModeE";
    setNormalMap :: (this: *Surface, isNormalMap: bool) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface12setNormalMapEb";

    isNull :: (this: *Surface) -> bool #cpp_method #foreign libnvtt "_ZNK4nvtt7Surface6isNullEv";
    width :: (this: *Surface) -> s32 #cpp_method #foreign libnvtt "_ZNK4nvtt7Surface5widthEv";
    height :: (this: *Surface) -> s32 #cpp_method #foreign libnvtt "_ZNK4nvtt7Surface6heightEv";
    depth :: (this: *Surface) -> s32 #cpp_method #foreign libnvtt "_ZNK4nvtt7Surface5depthEv";
    type :: (this: *Surface) -> TextureType #cpp_method #foreign libnvtt "_ZNK4nvtt7Surface4typeEv";
    wrapMode :: (this: *Surface) -> WrapMode #cpp_method #foreign libnvtt "_ZNK4nvtt7Surface8wrapModeEv";
    alphaMode :: (this: *Surface) -> AlphaMode #cpp_method #foreign libnvtt "_ZNK4nvtt7Surface9alphaModeEv";
    isNormalMap :: (this: *Surface) -> bool #cpp_method #foreign libnvtt "_ZNK4nvtt7Surface11isNormalMapEv";
    countMipmaps :: (this: *Surface) -> s32 #cpp_method #foreign libnvtt "_ZNK4nvtt7Surface12countMipmapsEv";
    countMipmaps :: (this: *Surface, min_size: s32) -> s32 #cpp_method #foreign libnvtt "_ZNK4nvtt7Surface12countMipmapsEi";
    alphaTestCoverage :: (this: *Surface, alphaRef: float = 0.5, alpha_channel: s32 = 3) -> float #cpp_method #foreign libnvtt "_ZNK4nvtt7Surface17alphaTestCoverageEfi";
    average :: (this: *Surface, channel: s32, alpha_channel: s32 = -1, gamma: float = 2.2) -> float #cpp_method #foreign libnvtt "_ZNK4nvtt7Surface7averageEiif";
    data :: (this: *Surface) -> *float #cpp_method #foreign libnvtt "_ZNK4nvtt7Surface4dataEv";
    channel :: (this: *Surface, i: s32) -> *float #cpp_method #foreign libnvtt "_ZNK4nvtt7Surface7channelEi";
    histogram :: (this: *Surface, channel: s32, rangeMin: float, rangeMax: float, binCount: s32, binPtr: *s32) -> void #cpp_method #foreign libnvtt "_ZNK4nvtt7Surface9histogramEiffiPi";
    range :: (this: *Surface, channel: s32, rangeMin: *float, rangeMax: *float, alpha_channel: s32 = -1, alpha_ref: float = 0.0) -> void #cpp_method #foreign libnvtt "_ZNK4nvtt7Surface5rangeEiPfS1_if";

    load :: (this: *Surface, fileName: *u8, hasAlpha: *bool = null) -> bool #cpp_method #foreign libnvtt "_ZN4nvtt7Surface4loadEPKcPb";
    save :: (this: *Surface, fileName: *u8, hasAlpha := false, hdr := false) -> bool #cpp_method #foreign libnvtt "_ZNK4nvtt7Surface4saveEPKcbb";
    setImage :: (this: *Surface, w: s32, h: s32, d: s32) -> bool #cpp_method #foreign libnvtt "_ZN4nvtt7Surface8setImageEiii";
    setImage :: (this: *Surface, format: InputFormat, w: s32, h: s32, d: s32, data: *void) -> bool #cpp_method #foreign libnvtt "_ZN4nvtt7Surface8setImageENS_11InputFormatEiiiPKv";
    setImage :: (this: *Surface, format: InputFormat, w: s32, h: s32, d: s32, r: *void, g: *void, b: *void, a: *void) -> bool #cpp_method #foreign libnvtt "_ZN4nvtt7Surface8setImageENS_11InputFormatEiiiPKvS3_S3_S3_";
    setImage2D :: (this: *Surface, format: Format, decoder: Decoder, w: s32, h: s32, data: *void) -> bool #cpp_method #foreign libnvtt "_ZN4nvtt7Surface10setImage2DENS_6FormatENS_7DecoderEiiPKv";

    resize :: (this: *Surface, w: s32, h: s32, d: s32, filter: ResizeFilter) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface6resizeEiiiNS_12ResizeFilterE";
    resize :: (this: *Surface, w: s32, h: s32, d: s32, filter: ResizeFilter, filterWidth: float, params: *float = null) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface6resizeEiiiNS_12ResizeFilterEfPKf";
    resize :: (this: *Surface, maxExtent: s32, mode: RoundMode, filter: ResizeFilter) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface6resizeEiNS_9RoundModeENS_12ResizeFilterE";
    resize :: (this: *Surface, maxExtent: s32, mode: RoundMode, filter: ResizeFilter, filterWidth: float, params: *float = null) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface6resizeEiNS_9RoundModeENS_12ResizeFilterEfPKf";
    resizeMakeSquare :: (this: *Surface, maxExtent: s32, roundMode: RoundMode, filter: ResizeFilter) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface16resizeMakeSquareEiNS_9RoundModeENS_12ResizeFilterE";
    autoResize :: (this: *Surface, errorTolerance: float, mode: RoundMode, filter: ResizeFilter) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface10autoResizeEfNS_9RoundModeENS_12ResizeFilterE";

    buildNextMipmap :: (this: *Surface, filter: MipmapFilter, min_size: s32 = 1) -> bool #cpp_method #foreign libnvtt "_ZN4nvtt7Surface15buildNextMipmapENS_12MipmapFilterEi";
    buildNextMipmap :: (this: *Surface, filter: MipmapFilter, filterWidth: float, params: *float = null, min_size: s32 = 1) -> bool #cpp_method #foreign libnvtt "_ZN4nvtt7Surface15buildNextMipmapENS_12MipmapFilterEfPKfi";
    buildNextMipmapSolidColor :: (this: *Surface, color_components: *float) -> bool #cpp_method #foreign libnvtt "_ZN4nvtt7Surface25buildNextMipmapSolidColorEPKf";
    canvasSize :: (this: *Surface, w: s32, h: s32, d: s32) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface10canvasSizeEiii";

    canMakeNextMipmap :: (this: *Surface, min_size: s32 = 1) -> bool #cpp_method #foreign libnvtt "_ZN4nvtt7Surface17canMakeNextMipmapEi";

    toLinear :: (this: *Surface, gamma: float) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface8toLinearEf";
    toGamma :: (this: *Surface, gamma: float) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface7toGammaEf";
    toLinear :: (this: *Surface, channel: s32, gamma: float) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface8toLinearEif";
    toGamma :: (this: *Surface, channel: s32, gamma: float) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface7toGammaEif";
    toSrgb :: (this: *Surface) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface6toSrgbEv";
    toSrgbFast :: (this: *Surface) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface10toSrgbFastEv";
    toLinearFromSrgb :: (this: *Surface) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface16toLinearFromSrgbEv";
    toLinearFromSrgbFast :: (this: *Surface) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface20toLinearFromSrgbFastEv";
    toXenonSrgb :: (this: *Surface) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface11toXenonSrgbEv";
    transform :: (this: *Surface, w0: *[4] float, w1: *[4] float, w2: *[4] float, w3: *[4] float, offset: *[4] float) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface9transformEPKfS2_S2_S2_S2_";
    swizzle :: (this: *Surface, r: s32, g: s32, b: s32, a: s32) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface7swizzleEiiii";
    scaleBias :: (this: *Surface, channel: s32, scale: float, bias: float) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface9scaleBiasEiff";
    clamp :: (this: *Surface, channel: s32, low: float = 0.0, high: float = 1.0) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface5clampEiff";
    blend :: (this: *Surface, r: float, g: float, b: float, a: float, t: float) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface5blendEfffff";
    premultiplyAlpha :: (this: *Surface) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface16premultiplyAlphaEv";
    toGreyScale :: (this: *Surface, redScale: float, greenScale: float, blueScale: float, alphaScale: float) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface11toGreyScaleEffff";
    setBorder :: (this: *Surface, r: float, g: float, b: float, a: float) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface9setBorderEffff";
    fill :: (this: *Surface, r: float, g: float, b: float, a: float) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface4fillEffff";
    scaleAlphaToCoverage :: (this: *Surface, coverage: float, alphaRef: float = 0.5, alpha_channel: s32 = 3) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface20scaleAlphaToCoverageEffi";
    toRGBM :: (this: *Surface, range: float = 1.0, threshold: float = 0.25) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface6toRGBMEff";
    fromRGBM :: (this: *Surface, range: float = 1.0, threshold: float = 0.25) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface8fromRGBMEff";
    toLM :: (this: *Surface, range: float = 1.0, threshold: float = 0.0) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface4toLMEff";
    toRGBE :: (this: *Surface, mantissaBits: s32, exponentBits: s32) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface6toRGBEEii";
    fromRGBE :: (this: *Surface, mantissaBits: s32, exponentBits: s32) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface8fromRGBEEii";
    toYCoCg :: (this: *Surface) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface7toYCoCgEv";
    blockScaleCoCg :: (this: *Surface, bits: s32 = 5, threshold: float = 0.0) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface14blockScaleCoCgEif";
    fromYCoCg :: (this: *Surface) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface9fromYCoCgEv";
    toLUVW :: (this: *Surface, range: float = 1.0) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface6toLUVWEf";
    fromLUVW :: (this: *Surface, range: float = 1.0) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface8fromLUVWEf";
    abs :: (this: *Surface, channel: s32) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface3absEi";
    convolve :: (this: *Surface, channel: s32, kernelSize: s32, kernelData: *float) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface8convolveEiiPf";
    toLogScale :: (this: *Surface, channel: s32, base: float) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface10toLogScaleEif";
    fromLogScale :: (this: *Surface, channel: s32, base: float) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface12fromLogScaleEif";
    setAtlasBorder :: (this: *Surface, w: s32, h: s32, r: float, g: float, b: float, a: float) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface14setAtlasBorderEiiffff";

    toneMap :: (this: *Surface, tm: ToneMapper, parameters: *float) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface7toneMapENS_10ToneMapperEPf";

    binarize :: (this: *Surface, channel: s32, threshold: float, dither: bool) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface8binarizeEifb";
    quantize :: (this: *Surface, channel: s32, bits: s32, exactEndPoints: bool, dither: bool) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface8quantizeEiibb";

    toNormalMap :: (this: *Surface, sm: float, medium: float, big: float, large: float) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface11toNormalMapEffff";
    normalizeNormalMap :: (this: *Surface) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface18normalizeNormalMapEv";
    transformNormals :: (this: *Surface, xform: NormalTransform) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface16transformNormalsENS_15NormalTransformE";
    reconstructNormals :: (this: *Surface, xform: NormalTransform) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface18reconstructNormalsENS_15NormalTransformE";
    toCleanNormalMap :: (this: *Surface) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface16toCleanNormalMapEv";
    packNormals :: (this: *Surface, scale: float = 0.5, bias: float = 0.5) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface11packNormalsEff";
    expandNormals :: (this: *Surface, scale: float = 2.0, bias: float = -1.0) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface13expandNormalsEff";
    createToksvigMap :: (this: *Surface, power: float) -> Surface #cpp_method /* unsupported non-POD C++ return metadata */ #foreign libnvtt "_ZNK4nvtt7Surface16createToksvigMapEf";
    createCleanMap :: (this: *Surface) -> Surface #cpp_method /* unsupported non-POD C++ return metadata */ #foreign libnvtt "_ZNK4nvtt7Surface14createCleanMapEv";

    flipX :: (this: *Surface) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface5flipXEv";
    flipY :: (this: *Surface) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface5flipYEv";
    flipZ :: (this: *Surface) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface5flipZEv";
    createSubImage :: (this: *Surface, x0: s32, x1: s32, y0: s32, y1: s32, z0: s32, z1: s32) -> Surface #cpp_method /* unsupported non-POD C++ return metadata */ #foreign libnvtt "_ZNK4nvtt7Surface14createSubImageEiiiiii";

    warp :: (this: *Surface, w: s32, h: s32, f: WarpFunction) -> Surface #cpp_method /* unsupported non-POD C++ return metadata */ #foreign libnvtt "_ZNK4nvtt7Surface4warpEiiPFvRfS1_S1_E";
    warp :: (this: *Surface, w: s32, h: s32, d: s32, f: WarpFunction) -> Surface #cpp_method /* unsupported non-POD C++ return metadata */ #foreign libnvtt "_ZNK4nvtt7Surface4warpEiiiPFvRfS1_S1_E";

    copyChannel :: (this: *Surface, srcImage: *Surface, srcChannel: s32) -> bool #cpp_method #foreign libnvtt "_ZN4nvtt7Surface11copyChannelERKS0_i";
    copyChannel :: (this: *Surface, srcImage: Surface, srcChannel: s32) -> bool #no_context {
    return copyChannel(this, *srcImage, srcChannel);
}
    copyChannel :: (this: *Surface, srcImage: *Surface, srcChannel: s32, dstChannel: s32) -> bool #cpp_method #foreign libnvtt "_ZN4nvtt7Surface11copyChannelERKS0_ii";
    copyChannel :: (this: *Surface, srcImage: Surface, srcChannel: s32, dstChannel: s32) -> bool #no_context {
    return copyChannel(this, *srcImage, srcChannel, dstChannel);
}

    addChannel :: (this: *Surface, img: *Surface, srcChannel: s32, dstChannel: s32, scale: float) -> bool #cpp_method #foreign libnvtt "_ZN4nvtt7Surface10addChannelERKS0_iif";
    addChannel :: (this: *Surface, img: Surface, srcChannel: s32, dstChannel: s32, scale: float) -> bool #no_context {
    return addChannel(this, *img, srcChannel, dstChannel, scale);
}

    copy :: (this: *Surface, src: *Surface, xsrc: s32, ysrc: s32, zsrc: s32, xsize: s32, ysize: s32, zsize: s32, xdst: s32, ydst: s32, zdst: s32) -> bool #cpp_method #foreign libnvtt "_ZN4nvtt7Surface4copyERKS0_iiiiiiiii";
    copy :: (this: *Surface, src: Surface, xsrc: s32, ysrc: s32, zsrc: s32, xsize: s32, ysize: s32, zsize: s32, xdst: s32, ydst: s32, zdst: s32) -> bool #no_context {
    return copy(this, *src, xsrc, ysrc, zsrc, xsize, ysize, zsize, xdst, ydst, zdst);
}

    detach :: (this: *Surface) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7Surface6detachEv";

    Private :: struct {}
    m: *Private;
}

operator_assign :: (this: *Surface, img: *Surface) -> void #cpp_method #foreign libnvtt "_ZN4nvtt7SurfaceaSERKS0_";
operator_assign :: (this: *Surface, img: Surface) #no_context {
    operator_assign(this, *img);
}

CubeLayout :: enum u32 {
    VerticalCross     :: 0;
    HorizontalCross   :: 1;
    Column            :: 2;
    Row               :: 3;
    LatitudeLongitude :: 4;
}

EdgeFixup :: enum u32 {
    None    :: 0;
    Stretch :: 1;
    Warp    :: 2;
    Average :: 3;
}

CubeSurface :: struct  {
    Constructor :: (this: *CubeSurface) -> void #cpp_method #foreign libnvtt "_ZN4nvtt11CubeSurfaceC1Ev";
    CopyConstructor :: (this: *CubeSurface, img: *CubeSurface) -> void #cpp_method #foreign libnvtt "_ZN4nvtt11CubeSurfaceC1ERKS0_";
    CopyConstructor :: (this: *CubeSurface, img: CubeSurface) #no_context {
    CopyConstructor(this, *img);
}
    Destructor_Base :: (this: *CubeSurface) -> void #cpp_method #foreign libnvtt "_ZN4nvtt11CubeSurfaceD2Ev";
    Destructor :: (this: *CubeSurface) -> void #cpp_method #foreign libnvtt "_ZN4nvtt11CubeSurfaceD1Ev";

    isNull :: (this: *CubeSurface) -> bool #cpp_method #foreign libnvtt "_ZNK4nvtt11CubeSurface6isNullEv";
    edgeLength :: (this: *CubeSurface) -> s32 #cpp_method #foreign libnvtt "_ZNK4nvtt11CubeSurface10edgeLengthEv";
    countMipmaps :: (this: *CubeSurface) -> s32 #cpp_method #foreign libnvtt "_ZNK4nvtt11CubeSurface12countMipmapsEv";

    load :: (this: *CubeSurface, fileName: *u8, mipmap: s32) -> bool #cpp_method #foreign libnvtt "_ZN4nvtt11CubeSurface4loadEPKci";
    save :: (this: *CubeSurface, fileName: *u8) -> bool #cpp_method #foreign libnvtt "_ZNK4nvtt11CubeSurface4saveEPKc";

    face :: (this: *CubeSurface, face: s32) -> *Surface #cpp_method #foreign libnvtt "_ZN4nvtt11CubeSurface4faceEi";
    face_1 :: (this:  *CubeSurface, face: s32) -> *Surface #cpp_method #foreign libnvtt "_ZNK4nvtt11CubeSurface4faceEi";

    fold :: (this: *CubeSurface, img: *Surface, layout: CubeLayout) -> void #cpp_method #foreign libnvtt "_ZN4nvtt11CubeSurface4foldERKNS_7SurfaceENS_10CubeLayoutE";
    fold :: (this: *CubeSurface, img: Surface, layout: CubeLayout) #no_context {
    fold(this, *img, layout);
}
    unfold :: (this: *CubeSurface, layout: CubeLayout) -> Surface #cpp_method /* unsupported non-POD C++ return metadata */ #foreign libnvtt "_ZNK4nvtt11CubeSurface6unfoldENS_10CubeLayoutE";

    average :: (this: *CubeSurface, channel: s32) -> float #cpp_method #foreign libnvtt "_ZNK4nvtt11CubeSurface7averageEi";
    range :: (this: *CubeSurface, channel: s32, minimum_ptr: *float, maximum_ptr: *float) -> void #cpp_method #foreign libnvtt "_ZNK4nvtt11CubeSurface5rangeEiPfS1_";
    clamp :: (this: *CubeSurface, channel: s32, low: float = 0.0, high: float = 1.0) -> void #cpp_method #foreign libnvtt "_ZN4nvtt11CubeSurface5clampEiff";

    irradianceFilter :: (this: *CubeSurface, size: s32, fixupMethod: EdgeFixup) -> CubeSurface #cpp_method /* unsupported non-POD C++ return metadata */ #foreign libnvtt "_ZNK4nvtt11CubeSurface16irradianceFilterEiNS_9EdgeFixupE";
    cosinePowerFilter :: (this: *CubeSurface, size: s32, cosinePower: float, fixupMethod: EdgeFixup) -> CubeSurface #cpp_method /* unsupported non-POD C++ return metadata */ #foreign libnvtt "_ZNK4nvtt11CubeSurface17cosinePowerFilterEifNS_9EdgeFixupE";

    fastResample :: (this: *CubeSurface, size: s32, fixupMethod: EdgeFixup) -> CubeSurface #cpp_method /* unsupported non-POD C++ return metadata */ #foreign libnvtt "_ZNK4nvtt11CubeSurface12fastResampleEiNS_9EdgeFixupE";

    toLinear :: (this: *CubeSurface, gamma: float) -> void #cpp_method #foreign libnvtt "_ZN4nvtt11CubeSurface8toLinearEf";
    toGamma :: (this: *CubeSurface, gamma: float) -> void #cpp_method #foreign libnvtt "_ZN4nvtt11CubeSurface7toGammaEf";

    detach :: (this: *CubeSurface) -> void #cpp_method #foreign libnvtt "_ZN4nvtt11CubeSurface6detachEv";

    Private :: struct {}
    m: *Private;
}

operator_assign :: (this: *CubeSurface, img: *CubeSurface) -> void #cpp_method #foreign libnvtt "_ZN4nvtt11CubeSurfaceaSERKS0_";
operator_assign :: (this: *CubeSurface, img: CubeSurface) #no_context {
    operator_assign(this, *img);
}

errorString :: (e: Error) -> *u8 #foreign libnvtt "_ZN4nvtt11errorStringENS_5ErrorE";

version :: () -> u32 #foreign libnvtt "_ZN4nvtt7versionEv";

rmsError :: (reference: *Surface, img: *Surface) -> float #foreign libnvtt "_ZN4nvtt8rmsErrorERKNS_7SurfaceES2_";
rmsError :: (reference: Surface, img: Surface) -> float #no_context {
    return rmsError(*reference, *img);
}
rmsAlphaError :: (reference: *Surface, img: *Surface) -> float #foreign libnvtt "_ZN4nvtt13rmsAlphaErrorERKNS_7SurfaceES2_";
rmsAlphaError :: (reference: Surface, img: Surface) -> float #no_context {
    return rmsAlphaError(*reference, *img);
}
cieLabError :: (reference: *Surface, img: *Surface) -> float #foreign libnvtt "_ZN4nvtt11cieLabErrorERKNS_7SurfaceES2_";
cieLabError :: (reference: Surface, img: Surface) -> float #no_context {
    return cieLabError(*reference, *img);
}
angularError :: (reference: *Surface, img: *Surface) -> float #foreign libnvtt "_ZN4nvtt12angularErrorERKNS_7SurfaceES2_";
angularError :: (reference: Surface, img: Surface) -> float #no_context {
    return angularError(*reference, *img);
}
diff :: (reference: *Surface, img: *Surface, scale: float) -> Surface /* unsupported non-POD C++ return metadata */ #foreign libnvtt "_ZN4nvtt4diffERKNS_7SurfaceES2_f";
diff :: (reference: Surface, img: Surface, scale: float) -> Surface #no_context {
    return diff(*reference, *img, scale);
}

rmsToneMappedError :: (reference: *Surface, img: *Surface, exposure: float) -> float #foreign libnvtt "_ZN4nvtt18rmsToneMappedErrorERKNS_7SurfaceES2_f";
rmsToneMappedError :: (reference: Surface, img: Surface, exposure: float) -> float #no_context {
    return rmsToneMappedError(*reference, *img, exposure);
}

histogram :: (img: *Surface, width: s32, height: s32) -> Surface /* unsupported non-POD C++ return metadata */ #foreign libnvtt "_ZN4nvtt9histogramERKNS_7SurfaceEii";
histogram :: (img: Surface, width: s32, height: s32) -> Surface #no_context {
    return histogram(*img, width, height);
}
histogram :: (img: *Surface, minRange: float, maxRange: float, width: s32, height: s32) -> Surface /* unsupported non-POD C++ return metadata */ #foreign libnvtt "_ZN4nvtt9histogramERKNS_7SurfaceEffii";
histogram :: (img: Surface, minRange: float, maxRange: float, width: s32, height: s32) -> Surface #no_context {
    return histogram(*img, minRange, maxRange, width, height);
}

#scope_file

libnvtt :: #system_library "jai_nvtt_legacy_adapter";

#scope_file
codec_adapter :: #system_library "jai_nvtt_legacy_adapter";
