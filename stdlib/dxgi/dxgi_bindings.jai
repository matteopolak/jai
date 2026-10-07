// DXGI types, constants and COM interfaces.
DXGI_STANDARD_MULTISAMPLE_QUALITY_PATTERN :: 0xffffffff;
DXGI_CENTER_MULTISAMPLE_QUALITY_PATTERN :: 0xfffffffe;
DXGI_FORMAT_DEFINED :: 1;
_FACDXGI :: 0x87a;

DXGI_CPU_ACCESS :: enum {
    NONE :: 0;
    DYNAMIC :: 1;
    READ_WRITE :: 2;
    SCRATCH :: 3;
    FIELD :: 15;
    DXGI_CPU_ACCESS_NONE :: NONE;
    DXGI_CPU_ACCESS_DYNAMIC :: DYNAMIC;
    DXGI_CPU_ACCESS_READ_WRITE :: READ_WRITE;
    DXGI_CPU_ACCESS_SCRATCH :: SCRATCH;
    DXGI_CPU_ACCESS_FIELD :: FIELD;
}

DXGI_USAGE :: enum_flags u32 {
    SHADER_INPUT :: 0x00000010;
    RENDER_TARGET_OUTPUT :: 0x00000020;
    BACK_BUFFER :: 0x00000040;
    SHARED :: 0x00000080;
    READ_ONLY :: 0x00000100;
    DISCARD_ON_PRESENT :: 0x00000200;
    UNORDERED_ACCESS :: 0x00000400;
    DXGI_USAGE_SHADER_INPUT :: SHADER_INPUT;
    DXGI_USAGE_RENDER_TARGET_OUTPUT :: RENDER_TARGET_OUTPUT;
    DXGI_USAGE_BACK_BUFFER :: BACK_BUFFER;
    DXGI_USAGE_SHARED :: SHARED;
    DXGI_USAGE_READ_ONLY :: READ_ONLY;
    DXGI_USAGE_DISCARD_ON_PRESENT :: DISCARD_ON_PRESENT;
    DXGI_USAGE_UNORDERED_ACCESS :: UNORDERED_ACCESS;
}

DXGI_RESOURCE_PRIORITY :: enum {
    MINIMUM :: 0x28000000;
    LOW :: 0x50000000;
    NORMAL :: 0x78000000;
    HIGH :: 0xa0000000;
    MAXIMUM :: 0xc8000000;
    DXGI_RESOURCE_PRIORITY_MINIMUM :: MINIMUM;
    DXGI_RESOURCE_PRIORITY_LOW :: LOW;
    DXGI_RESOURCE_PRIORITY_NORMAL :: NORMAL;
    DXGI_RESOURCE_PRIORITY_HIGH :: HIGH;
    DXGI_RESOURCE_PRIORITY_MAXIMUM :: MAXIMUM;
}

DXGI_MAP :: enum_flags {
    READ :: 1;
    WRITE :: 2;
    DISCARD :: 4;
    DXGI_MAP_READ :: READ;
    DXGI_MAP_WRITE :: WRITE;
    DXGI_MAP_DISCARD :: DISCARD;
}

DXGI_ENUM_MODES :: enum_flags {
    INTERLACED :: 1;
    SCALING :: 2;
    STEREO :: 4;
    DISABLED_STEREO :: 8;
    DXGI_ENUM_MODES_INTERLACED :: INTERLACED;
    DXGI_ENUM_MODES_SCALING :: SCALING;
    DXGI_ENUM_MODES_STEREO :: STEREO;
    DXGI_ENUM_MODES_DISABLED_STEREO :: DISABLED_STEREO;
}

DXGI_MAX_SWAP_CHAIN_BUFFERS :: 16;

DXGI_PRESENT :: enum_flags {
    TEST :: 0x00000001;
    DO_NOT_SEQUENCE :: 0x00000002;
    RESTART :: 0x00000004;
    DO_NOT_WAIT :: 0x00000008;
    STEREO_PREFER_RIGHT :: 0x00000010;
    STEREO_TEMPORARY_MONO :: 0x00000020;
    RESTRICT_TO_OUTPUT :: 0x00000040;
    USE_DURATION :: 0x00000100;
    ALLOW_TEARING :: 0x00000200;
    DXGI_PRESENT_TEST :: TEST;
    DXGI_PRESENT_DO_NOT_SEQUENCE :: DO_NOT_SEQUENCE;
    DXGI_PRESENT_RESTART :: RESTART;
    DXGI_PRESENT_DO_NOT_WAIT :: DO_NOT_WAIT;
    DXGI_PRESENT_STEREO_PREFER_RIGHT :: STEREO_PREFER_RIGHT;
    DXGI_PRESENT_STEREO_TEMPORARY_MONO :: STEREO_TEMPORARY_MONO;
    DXGI_PRESENT_RESTRICT_TO_OUTPUT :: RESTRICT_TO_OUTPUT;
    DXGI_PRESENT_USE_DURATION :: USE_DURATION;
    DXGI_PRESENT_ALLOW_TEARING :: ALLOW_TEARING;
}

DXGI_MWA :: enum_flags {
    NO_WINDOW_CHANGES :: 1 << 0;
    NO_ALT_ENTER :: 1 << 1;
    NO_PRINT_SCREEN :: 1 << 2;
    VALID :: 0x7;
    DXGI_MWA_NO_WINDOW_CHANGES :: NO_WINDOW_CHANGES;
    DXGI_MWA_NO_ALT_ENTER :: NO_ALT_ENTER;
    DXGI_MWA_NO_PRINT_SCREEN :: NO_PRINT_SCREEN;
    DXGI_MWA_VALID :: VALID;
}

DXGI_SHARED_RESOURCE_READ :: 0x80000000;
DXGI_SHARED_RESOURCE_WRITE :: 1;
DXGI_CREATE_FACTORY_DEBUG :: 0x1;

DXGI_RATIONAL :: struct {
    Numerator: u32;
    Denominator: u32;
}

DXGI_SAMPLE_DESC :: struct {
    Count: u32;
    Quality: u32;
}

DXGI_COLOR_SPACE_TYPE :: enum s32 {
    RGB_FULL_G22_NONE_P709 :: 0;
    RGB_FULL_G10_NONE_P709 :: 1;
    RGB_STUDIO_G22_NONE_P709 :: 2;
    RGB_STUDIO_G22_NONE_P2020 :: 3;
    RESERVED :: 4;
    YCBCR_FULL_G22_NONE_P709_X601 :: 5;
    YCBCR_STUDIO_G22_LEFT_P601 :: 6;
    YCBCR_FULL_G22_LEFT_P601 :: 7;
    YCBCR_STUDIO_G22_LEFT_P709 :: 8;
    YCBCR_FULL_G22_LEFT_P709 :: 9;
    YCBCR_STUDIO_G22_LEFT_P2020 :: 10;
    YCBCR_FULL_G22_LEFT_P2020 :: 11;
    RGB_FULL_G2084_NONE_P2020 :: 12;
    YCBCR_STUDIO_G2084_LEFT_P2020 :: 13;
    RGB_STUDIO_G2084_NONE_P2020 :: 14;
    YCBCR_STUDIO_G22_TOPLEFT_P2020 :: 15;
    YCBCR_STUDIO_G2084_TOPLEFT_P2020 :: 16;
    RGB_FULL_G22_NONE_P2020 :: 17;
    YCBCR_STUDIO_GHLG_TOPLEFT_P2020 :: 18;
    YCBCR_FULL_GHLG_TOPLEFT_P2020 :: 19;
    RGB_STUDIO_G24_NONE_P709 :: 20;
    RGB_STUDIO_G24_NONE_P2020 :: 21;
    YCBCR_STUDIO_G24_LEFT_P709 :: 22;
    YCBCR_STUDIO_G24_LEFT_P2020 :: 23;
    YCBCR_STUDIO_G24_TOPLEFT_P2020 :: 24;
    CUSTOM :: -1;
    DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P709 :: RGB_FULL_G22_NONE_P709;
    DXGI_COLOR_SPACE_RGB_FULL_G10_NONE_P709 :: RGB_FULL_G10_NONE_P709;
    DXGI_COLOR_SPACE_RGB_STUDIO_G22_NONE_P709 :: RGB_STUDIO_G22_NONE_P709;
    DXGI_COLOR_SPACE_RGB_STUDIO_G22_NONE_P2020 :: RGB_STUDIO_G22_NONE_P2020;
    DXGI_COLOR_SPACE_RESERVED :: RESERVED;
    DXGI_COLOR_SPACE_YCBCR_FULL_G22_NONE_P709_X601 :: YCBCR_FULL_G22_NONE_P709_X601;
    DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P601 :: YCBCR_STUDIO_G22_LEFT_P601;
    DXGI_COLOR_SPACE_YCBCR_FULL_G22_LEFT_P601 :: YCBCR_FULL_G22_LEFT_P601;
    DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P709 :: YCBCR_STUDIO_G22_LEFT_P709;
    DXGI_COLOR_SPACE_YCBCR_FULL_G22_LEFT_P709 :: YCBCR_FULL_G22_LEFT_P709;
    DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P2020 :: YCBCR_STUDIO_G22_LEFT_P2020;
    DXGI_COLOR_SPACE_YCBCR_FULL_G22_LEFT_P2020 :: YCBCR_FULL_G22_LEFT_P2020;
    DXGI_COLOR_SPACE_RGB_FULL_G2084_NONE_P2020 :: RGB_FULL_G2084_NONE_P2020;
    DXGI_COLOR_SPACE_YCBCR_STUDIO_G2084_LEFT_P2020 :: YCBCR_STUDIO_G2084_LEFT_P2020;
    DXGI_COLOR_SPACE_RGB_STUDIO_G2084_NONE_P2020 :: RGB_STUDIO_G2084_NONE_P2020;
    DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_TOPLEFT_P2020 :: YCBCR_STUDIO_G22_TOPLEFT_P2020;
    DXGI_COLOR_SPACE_YCBCR_STUDIO_G2084_TOPLEFT_P2020 :: YCBCR_STUDIO_G2084_TOPLEFT_P2020;
    DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P2020 :: RGB_FULL_G22_NONE_P2020;
    DXGI_COLOR_SPACE_YCBCR_STUDIO_GHLG_TOPLEFT_P2020 :: YCBCR_STUDIO_GHLG_TOPLEFT_P2020;
    DXGI_COLOR_SPACE_YCBCR_FULL_GHLG_TOPLEFT_P2020 :: YCBCR_FULL_GHLG_TOPLEFT_P2020;
    DXGI_COLOR_SPACE_RGB_STUDIO_G24_NONE_P709 :: RGB_STUDIO_G24_NONE_P709;
    DXGI_COLOR_SPACE_RGB_STUDIO_G24_NONE_P2020 :: RGB_STUDIO_G24_NONE_P2020;
    DXGI_COLOR_SPACE_YCBCR_STUDIO_G24_LEFT_P709 :: YCBCR_STUDIO_G24_LEFT_P709;
    DXGI_COLOR_SPACE_YCBCR_STUDIO_G24_LEFT_P2020 :: YCBCR_STUDIO_G24_LEFT_P2020;
    DXGI_COLOR_SPACE_YCBCR_STUDIO_G24_TOPLEFT_P2020 :: YCBCR_STUDIO_G24_TOPLEFT_P2020;
    DXGI_COLOR_SPACE_CUSTOM :: CUSTOM;
}

DXGI_FORMAT :: enum s32 {
    UNKNOWN :: 0;
    R32G32B32A32_TYPELESS :: 1;
    R32G32B32A32_FLOAT :: 2;
    R32G32B32A32_UINT :: 3;
    R32G32B32A32_SINT :: 4;
    R32G32B32_TYPELESS :: 5;
    R32G32B32_FLOAT :: 6;
    R32G32B32_UINT :: 7;
    R32G32B32_SINT :: 8;
    R16G16B16A16_TYPELESS :: 9;
    R16G16B16A16_FLOAT :: 10;
    R16G16B16A16_UNORM :: 11;
    R16G16B16A16_UINT :: 12;
    R16G16B16A16_SNORM :: 13;
    R16G16B16A16_SINT :: 14;
    R32G32_TYPELESS :: 15;
    R32G32_FLOAT :: 16;
    R32G32_UINT :: 17;
    R32G32_SINT :: 18;
    R32G8X24_TYPELESS :: 19;
    D32_FLOAT_S8X24_UINT :: 20;
    R32_FLOAT_X8X24_TYPELESS :: 21;
    X32_TYPELESS_G8X24_UINT :: 22;
    R10G10B10A2_TYPELESS :: 23;
    R10G10B10A2_UNORM :: 24;
    R10G10B10A2_UINT :: 25;
    R11G11B10_FLOAT :: 26;
    R8G8B8A8_TYPELESS :: 27;
    R8G8B8A8_UNORM :: 28;
    R8G8B8A8_UNORM_SRGB :: 29;
    R8G8B8A8_UINT :: 30;
    R8G8B8A8_SNORM :: 31;
    R8G8B8A8_SINT :: 32;
    R16G16_TYPELESS :: 33;
    R16G16_FLOAT :: 34;
    R16G16_UNORM :: 35;
    R16G16_UINT :: 36;
    R16G16_SNORM :: 37;
    R16G16_SINT :: 38;
    R32_TYPELESS :: 39;
    D32_FLOAT :: 40;
    R32_FLOAT :: 41;
    R32_UINT :: 42;
    R32_SINT :: 43;
    R24G8_TYPELESS :: 44;
    D24_UNORM_S8_UINT :: 45;
    R24_UNORM_X8_TYPELESS :: 46;
    X24_TYPELESS_G8_UINT :: 47;
    R8G8_TYPELESS :: 48;
    R8G8_UNORM :: 49;
    R8G8_UINT :: 50;
    R8G8_SNORM :: 51;
    R8G8_SINT :: 52;
    R16_TYPELESS :: 53;
    R16_FLOAT :: 54;
    D16_UNORM :: 55;
    R16_UNORM :: 56;
    R16_UINT :: 57;
    R16_SNORM :: 58;
    R16_SINT :: 59;
    R8_TYPELESS :: 60;
    R8_UNORM :: 61;
    R8_UINT :: 62;
    R8_SNORM :: 63;
    R8_SINT :: 64;
    A8_UNORM :: 65;
    R1_UNORM :: 66;
    R9G9B9E5_SHAREDEXP :: 67;
    R8G8_B8G8_UNORM :: 68;
    G8R8_G8B8_UNORM :: 69;
    BC1_TYPELESS :: 70;
    BC1_UNORM :: 71;
    BC1_UNORM_SRGB :: 72;
    BC2_TYPELESS :: 73;
    BC2_UNORM :: 74;
    BC2_UNORM_SRGB :: 75;
    BC3_TYPELESS :: 76;
    BC3_UNORM :: 77;
    BC3_UNORM_SRGB :: 78;
    BC4_TYPELESS :: 79;
    BC4_UNORM :: 80;
    BC4_SNORM :: 81;
    BC5_TYPELESS :: 82;
    BC5_UNORM :: 83;
    BC5_SNORM :: 84;
    B5G6R5_UNORM :: 85;
    B5G5R5A1_UNORM :: 86;
    B8G8R8A8_UNORM :: 87;
    B8G8R8X8_UNORM :: 88;
    R10G10B10_XR_BIAS_A2_UNORM :: 89;
    B8G8R8A8_TYPELESS :: 90;
    B8G8R8A8_UNORM_SRGB :: 91;
    B8G8R8X8_TYPELESS :: 92;
    B8G8R8X8_UNORM_SRGB :: 93;
    BC6H_TYPELESS :: 94;
    BC6H_UF16 :: 95;
    BC6H_SF16 :: 96;
    BC7_TYPELESS :: 97;
    BC7_UNORM :: 98;
    BC7_UNORM_SRGB :: 99;
    AYUV :: 100;
    Y410 :: 101;
    Y416 :: 102;
    NV12 :: 103;
    P010 :: 104;
    P016 :: 105;
    _420_OPAQUE :: 106;
    YUY2 :: 107;
    Y210 :: 108;
    Y216 :: 109;
    NV11 :: 110;
    AI44 :: 111;
    IA44 :: 112;
    P8 :: 113;
    A8P8 :: 114;
    B4G4R4A4_UNORM :: 115;
    P208 :: 130;
    V208 :: 131;
    V408 :: 132;
    SAMPLER_FEEDBACK_MIN_MIP_OPAQUE :: 189;
    SAMPLER_FEEDBACK_MIP_REGION_USED_OPAQUE :: 190;
    FORCE_UINT :: -1;
    DXGI_FORMAT_UNKNOWN :: UNKNOWN;
    DXGI_FORMAT_R32G32B32A32_TYPELESS :: R32G32B32A32_TYPELESS;
    DXGI_FORMAT_R32G32B32A32_FLOAT :: R32G32B32A32_FLOAT;
    DXGI_FORMAT_R32G32B32A32_UINT :: R32G32B32A32_UINT;
    DXGI_FORMAT_R32G32B32A32_SINT :: R32G32B32A32_SINT;
    DXGI_FORMAT_R32G32B32_TYPELESS :: R32G32B32_TYPELESS;
    DXGI_FORMAT_R32G32B32_FLOAT :: R32G32B32_FLOAT;
    DXGI_FORMAT_R32G32B32_UINT :: R32G32B32_UINT;
    DXGI_FORMAT_R32G32B32_SINT :: R32G32B32_SINT;
    DXGI_FORMAT_R16G16B16A16_TYPELESS :: R16G16B16A16_TYPELESS;
    DXGI_FORMAT_R16G16B16A16_FLOAT :: R16G16B16A16_FLOAT;
    DXGI_FORMAT_R16G16B16A16_UNORM :: R16G16B16A16_UNORM;
    DXGI_FORMAT_R16G16B16A16_UINT :: R16G16B16A16_UINT;
    DXGI_FORMAT_R16G16B16A16_SNORM :: R16G16B16A16_SNORM;
    DXGI_FORMAT_R16G16B16A16_SINT :: R16G16B16A16_SINT;
    DXGI_FORMAT_R32G32_TYPELESS :: R32G32_TYPELESS;
    DXGI_FORMAT_R32G32_FLOAT :: R32G32_FLOAT;
    DXGI_FORMAT_R32G32_UINT :: R32G32_UINT;
    DXGI_FORMAT_R32G32_SINT :: R32G32_SINT;
    DXGI_FORMAT_R32G8X24_TYPELESS :: R32G8X24_TYPELESS;
    DXGI_FORMAT_D32_FLOAT_S8X24_UINT :: D32_FLOAT_S8X24_UINT;
    DXGI_FORMAT_R32_FLOAT_X8X24_TYPELESS :: R32_FLOAT_X8X24_TYPELESS;
    DXGI_FORMAT_X32_TYPELESS_G8X24_UINT :: X32_TYPELESS_G8X24_UINT;
    DXGI_FORMAT_R10G10B10A2_TYPELESS :: R10G10B10A2_TYPELESS;
    DXGI_FORMAT_R10G10B10A2_UNORM :: R10G10B10A2_UNORM;
    DXGI_FORMAT_R10G10B10A2_UINT :: R10G10B10A2_UINT;
    DXGI_FORMAT_R11G11B10_FLOAT :: R11G11B10_FLOAT;
    DXGI_FORMAT_R8G8B8A8_TYPELESS :: R8G8B8A8_TYPELESS;
    DXGI_FORMAT_R8G8B8A8_UNORM :: R8G8B8A8_UNORM;
    DXGI_FORMAT_R8G8B8A8_UNORM_SRGB :: R8G8B8A8_UNORM_SRGB;
    DXGI_FORMAT_R8G8B8A8_UINT :: R8G8B8A8_UINT;
    DXGI_FORMAT_R8G8B8A8_SNORM :: R8G8B8A8_SNORM;
    DXGI_FORMAT_R8G8B8A8_SINT :: R8G8B8A8_SINT;
    DXGI_FORMAT_R16G16_TYPELESS :: R16G16_TYPELESS;
    DXGI_FORMAT_R16G16_FLOAT :: R16G16_FLOAT;
    DXGI_FORMAT_R16G16_UNORM :: R16G16_UNORM;
    DXGI_FORMAT_R16G16_UINT :: R16G16_UINT;
    DXGI_FORMAT_R16G16_SNORM :: R16G16_SNORM;
    DXGI_FORMAT_R16G16_SINT :: R16G16_SINT;
    DXGI_FORMAT_R32_TYPELESS :: R32_TYPELESS;
    DXGI_FORMAT_D32_FLOAT :: D32_FLOAT;
    DXGI_FORMAT_R32_FLOAT :: R32_FLOAT;
    DXGI_FORMAT_R32_UINT :: R32_UINT;
    DXGI_FORMAT_R32_SINT :: R32_SINT;
    DXGI_FORMAT_R24G8_TYPELESS :: R24G8_TYPELESS;
    DXGI_FORMAT_D24_UNORM_S8_UINT :: D24_UNORM_S8_UINT;
    DXGI_FORMAT_R24_UNORM_X8_TYPELESS :: R24_UNORM_X8_TYPELESS;
    DXGI_FORMAT_X24_TYPELESS_G8_UINT :: X24_TYPELESS_G8_UINT;
    DXGI_FORMAT_R8G8_TYPELESS :: R8G8_TYPELESS;
    DXGI_FORMAT_R8G8_UNORM :: R8G8_UNORM;
    DXGI_FORMAT_R8G8_UINT :: R8G8_UINT;
    DXGI_FORMAT_R8G8_SNORM :: R8G8_SNORM;
    DXGI_FORMAT_R8G8_SINT :: R8G8_SINT;
    DXGI_FORMAT_R16_TYPELESS :: R16_TYPELESS;
    DXGI_FORMAT_R16_FLOAT :: R16_FLOAT;
    DXGI_FORMAT_D16_UNORM :: D16_UNORM;
    DXGI_FORMAT_R16_UNORM :: R16_UNORM;
    DXGI_FORMAT_R16_UINT :: R16_UINT;
    DXGI_FORMAT_R16_SNORM :: R16_SNORM;
    DXGI_FORMAT_R16_SINT :: R16_SINT;
    DXGI_FORMAT_R8_TYPELESS :: R8_TYPELESS;
    DXGI_FORMAT_R8_UNORM :: R8_UNORM;
    DXGI_FORMAT_R8_UINT :: R8_UINT;
    DXGI_FORMAT_R8_SNORM :: R8_SNORM;
    DXGI_FORMAT_R8_SINT :: R8_SINT;
    DXGI_FORMAT_A8_UNORM :: A8_UNORM;
    DXGI_FORMAT_R1_UNORM :: R1_UNORM;
    DXGI_FORMAT_R9G9B9E5_SHAREDEXP :: R9G9B9E5_SHAREDEXP;
    DXGI_FORMAT_R8G8_B8G8_UNORM :: R8G8_B8G8_UNORM;
    DXGI_FORMAT_G8R8_G8B8_UNORM :: G8R8_G8B8_UNORM;
    DXGI_FORMAT_BC1_TYPELESS :: BC1_TYPELESS;
    DXGI_FORMAT_BC1_UNORM :: BC1_UNORM;
    DXGI_FORMAT_BC1_UNORM_SRGB :: BC1_UNORM_SRGB;
    DXGI_FORMAT_BC2_TYPELESS :: BC2_TYPELESS;
    DXGI_FORMAT_BC2_UNORM :: BC2_UNORM;
    DXGI_FORMAT_BC2_UNORM_SRGB :: BC2_UNORM_SRGB;
    DXGI_FORMAT_BC3_TYPELESS :: BC3_TYPELESS;
    DXGI_FORMAT_BC3_UNORM :: BC3_UNORM;
    DXGI_FORMAT_BC3_UNORM_SRGB :: BC3_UNORM_SRGB;
    DXGI_FORMAT_BC4_TYPELESS :: BC4_TYPELESS;
    DXGI_FORMAT_BC4_UNORM :: BC4_UNORM;
    DXGI_FORMAT_BC4_SNORM :: BC4_SNORM;
    DXGI_FORMAT_BC5_TYPELESS :: BC5_TYPELESS;
    DXGI_FORMAT_BC5_UNORM :: BC5_UNORM;
    DXGI_FORMAT_BC5_SNORM :: BC5_SNORM;
    DXGI_FORMAT_B5G6R5_UNORM :: B5G6R5_UNORM;
    DXGI_FORMAT_B5G5R5A1_UNORM :: B5G5R5A1_UNORM;
    DXGI_FORMAT_B8G8R8A8_UNORM :: B8G8R8A8_UNORM;
    DXGI_FORMAT_B8G8R8X8_UNORM :: B8G8R8X8_UNORM;
    DXGI_FORMAT_R10G10B10_XR_BIAS_A2_UNORM :: R10G10B10_XR_BIAS_A2_UNORM;
    DXGI_FORMAT_B8G8R8A8_TYPELESS :: B8G8R8A8_TYPELESS;
    DXGI_FORMAT_B8G8R8A8_UNORM_SRGB :: B8G8R8A8_UNORM_SRGB;
    DXGI_FORMAT_B8G8R8X8_TYPELESS :: B8G8R8X8_TYPELESS;
    DXGI_FORMAT_B8G8R8X8_UNORM_SRGB :: B8G8R8X8_UNORM_SRGB;
    DXGI_FORMAT_BC6H_TYPELESS :: BC6H_TYPELESS;
    DXGI_FORMAT_BC6H_UF16 :: BC6H_UF16;
    DXGI_FORMAT_BC6H_SF16 :: BC6H_SF16;
    DXGI_FORMAT_BC7_TYPELESS :: BC7_TYPELESS;
    DXGI_FORMAT_BC7_UNORM :: BC7_UNORM;
    DXGI_FORMAT_BC7_UNORM_SRGB :: BC7_UNORM_SRGB;
    DXGI_FORMAT_AYUV :: AYUV;
    DXGI_FORMAT_Y410 :: Y410;
    DXGI_FORMAT_Y416 :: Y416;
    DXGI_FORMAT_NV12 :: NV12;
    DXGI_FORMAT_P010 :: P010;
    DXGI_FORMAT_P016 :: P016;
    DXGI_FORMAT_420_OPAQUE :: _420_OPAQUE;
    DXGI_FORMAT_YUY2 :: YUY2;
    DXGI_FORMAT_Y210 :: Y210;
    DXGI_FORMAT_Y216 :: Y216;
    DXGI_FORMAT_NV11 :: NV11;
    DXGI_FORMAT_AI44 :: AI44;
    DXGI_FORMAT_IA44 :: IA44;
    DXGI_FORMAT_P8 :: P8;
    DXGI_FORMAT_A8P8 :: A8P8;
    DXGI_FORMAT_B4G4R4A4_UNORM :: B4G4R4A4_UNORM;
    DXGI_FORMAT_P208 :: P208;
    DXGI_FORMAT_V208 :: V208;
    DXGI_FORMAT_V408 :: V408;
    DXGI_FORMAT_SAMPLER_FEEDBACK_MIN_MIP_OPAQUE :: SAMPLER_FEEDBACK_MIN_MIP_OPAQUE;
    DXGI_FORMAT_SAMPLER_FEEDBACK_MIP_REGION_USED_OPAQUE :: SAMPLER_FEEDBACK_MIP_REGION_USED_OPAQUE;
    DXGI_FORMAT_FORCE_UINT :: FORCE_UINT;
}

DXGI_RGB :: struct {
    Red: float;
    Green: float;
    Blue: float;
}

D3DCOLORVALUE :: struct {
    r: float;
    g: float;
    b: float;
    a: float;
}

DXGI_RGBA :: D3DCOLORVALUE;

DXGI_GAMMA_CONTROL :: struct {
    Scale: DXGI_RGB;
    Offset: DXGI_RGB;
    GammaCurve: [1025] DXGI_RGB;
}

DXGI_GAMMA_CONTROL_CAPABILITIES :: struct {
    ScaleAndOffsetSupported: BOOL;
    MaxConvertedValue: float;
    MinConvertedValue: float;
    NumGammaControlPoints: u32;
    ControlPointPositions: [1025] float;
}

DXGI_MODE_SCANLINE_ORDER :: enum s32 {
    UNSPECIFIED :: 0;
    PROGRESSIVE :: 1;
    UPPER_FIELD_FIRST :: 2;
    LOWER_FIELD_FIRST :: 3;
    DXGI_MODE_SCANLINE_ORDER_UNSPECIFIED :: UNSPECIFIED;
    DXGI_MODE_SCANLINE_ORDER_PROGRESSIVE :: PROGRESSIVE;
    DXGI_MODE_SCANLINE_ORDER_UPPER_FIELD_FIRST :: UPPER_FIELD_FIRST;
    DXGI_MODE_SCANLINE_ORDER_LOWER_FIELD_FIRST :: LOWER_FIELD_FIRST;
}

DXGI_MODE_SCALING :: enum s32 {
    UNSPECIFIED :: 0;
    CENTERED :: 1;
    STRETCHED :: 2;
    DXGI_MODE_SCALING_UNSPECIFIED :: UNSPECIFIED;
    DXGI_MODE_SCALING_CENTERED :: CENTERED;
    DXGI_MODE_SCALING_STRETCHED :: STRETCHED;
}

DXGI_MODE_ROTATION :: enum s32 {
    UNSPECIFIED :: 0;
    IDENTITY :: 1;
    ROTATE90 :: 2;
    ROTATE180 :: 3;
    ROTATE270 :: 4;
    DXGI_MODE_ROTATION_UNSPECIFIED :: UNSPECIFIED;
    DXGI_MODE_ROTATION_IDENTITY :: IDENTITY;
    DXGI_MODE_ROTATION_ROTATE90 :: ROTATE90;
    DXGI_MODE_ROTATION_ROTATE180 :: ROTATE180;
    DXGI_MODE_ROTATION_ROTATE270 :: ROTATE270;
}

DXGI_MODE_DESC :: struct {
    Width: u32;
    Height: u32;
    RefreshRate: DXGI_RATIONAL;
    Format: DXGI_FORMAT;
    ScanlineOrdering: DXGI_MODE_SCANLINE_ORDER;
    Scaling: DXGI_MODE_SCALING;
}

DXGI_JPEG_DC_HUFFMAN_TABLE :: struct {
    CodeCounts: [12] u8;
    CodeValues: [12] u8;
}

DXGI_JPEG_AC_HUFFMAN_TABLE :: struct {
    CodeCounts: [16] u8;
    CodeValues: [162] u8;
}

DXGI_JPEG_QUANTIZATION_TABLE :: struct {
    Elements: [64] u8;
}

DXGI_FRAME_STATISTICS :: struct {
    PresentCount: u32;
    PresentRefreshCount: u32;
    SyncRefreshCount: u32;
    SyncQPCTime: LARGE_INTEGER;
    SyncGPUTime: LARGE_INTEGER;
}

DXGI_MAPPED_RECT :: struct {
    Pitch: s32;
    pBits: *u8;
}

DXGI_ADAPTER_DESC :: struct {
    Description: [128] s16;
    VendorId: u32;
    DeviceId: u32;
    SubSysId: u32;
    Revision: u32;
    DedicatedVideoMemory: SIZE_T;
    DedicatedSystemMemory: SIZE_T;
    SharedSystemMemory: SIZE_T;
    AdapterLuid: LUID;
}

DXGI_OUTPUT_DESC :: struct {
    DeviceName: [32] s16;
    DesktopCoordinates: RECT;
    AttachedToDesktop: BOOL;
    Rotation: DXGI_MODE_ROTATION;
    Monitor: HMONITOR;
}

DXGI_SHARED_RESOURCE :: struct {
    Handle: HANDLE;
}

DXGI_RESIDENCY :: enum s32 {
    FULLY_RESIDENT :: 1;
    RESIDENT_IN_SHARED_MEMORY :: 2;
    EVICTED_TO_DISK :: 3;
    DXGI_RESIDENCY_FULLY_RESIDENT :: FULLY_RESIDENT;
    DXGI_RESIDENCY_RESIDENT_IN_SHARED_MEMORY :: RESIDENT_IN_SHARED_MEMORY;
    DXGI_RESIDENCY_EVICTED_TO_DISK :: EVICTED_TO_DISK;
}

DXGI_SURFACE_DESC :: struct {
    Width: u32;
    Height: u32;
    Format: DXGI_FORMAT;
    SampleDesc: DXGI_SAMPLE_DESC;
}

DXGI_SWAP_EFFECT :: enum s32 {
    DISCARD :: 0;
    SEQUENTIAL :: 1;
    FLIP_SEQUENTIAL :: 3;
    FLIP_DISCARD :: 4;
    DXGI_SWAP_EFFECT_DISCARD :: DISCARD;
    DXGI_SWAP_EFFECT_SEQUENTIAL :: SEQUENTIAL;
    DXGI_SWAP_EFFECT_FLIP_SEQUENTIAL :: FLIP_SEQUENTIAL;
    DXGI_SWAP_EFFECT_FLIP_DISCARD :: FLIP_DISCARD;
}

DXGI_SWAP_CHAIN_FLAG :: enum_flags u32 {
    NONPREROTATED :: 0x1;
    ALLOW_MODE_SWITCH :: 0x2;
    GDI_COMPATIBLE :: 0x4;
    RESTRICTED_CONTENT :: 0x8;
    RESTRICT_SHARED_RESOURCE_DRIVER :: 0x10;
    DISPLAY_ONLY :: 0x20;
    FRAME_LATENCY_WAITABLE_OBJECT :: 0x40;
    FOREGROUND_LAYER :: 0x80;
    FULLSCREEN_VIDEO :: 0x100;
    YUV_VIDEO :: 0x200;
    HW_PROTECTED :: 0x400;
    ALLOW_TEARING :: 0x800;
    RESTRICTED_TO_ALL_HOLOGRAPHIC_DISPLAYS :: 0x1000;
    DXGI_SWAP_CHAIN_FLAG_NONPREROTATED :: NONPREROTATED;
    DXGI_SWAP_CHAIN_FLAG_ALLOW_MODE_SWITCH :: ALLOW_MODE_SWITCH;
    DXGI_SWAP_CHAIN_FLAG_GDI_COMPATIBLE :: GDI_COMPATIBLE;
    DXGI_SWAP_CHAIN_FLAG_RESTRICTED_CONTENT :: RESTRICTED_CONTENT;
    DXGI_SWAP_CHAIN_FLAG_RESTRICT_SHARED_RESOURCE_DRIVER :: RESTRICT_SHARED_RESOURCE_DRIVER;
    DXGI_SWAP_CHAIN_FLAG_DISPLAY_ONLY :: DISPLAY_ONLY;
    DXGI_SWAP_CHAIN_FLAG_FRAME_LATENCY_WAITABLE_OBJECT :: FRAME_LATENCY_WAITABLE_OBJECT;
    DXGI_SWAP_CHAIN_FLAG_FOREGROUND_LAYER :: FOREGROUND_LAYER;
    DXGI_SWAP_CHAIN_FLAG_FULLSCREEN_VIDEO :: FULLSCREEN_VIDEO;
    DXGI_SWAP_CHAIN_FLAG_YUV_VIDEO :: YUV_VIDEO;
    DXGI_SWAP_CHAIN_FLAG_HW_PROTECTED :: HW_PROTECTED;
    DXGI_SWAP_CHAIN_FLAG_ALLOW_TEARING :: ALLOW_TEARING;
    DXGI_SWAP_CHAIN_FLAG_RESTRICTED_TO_ALL_HOLOGRAPHIC_DISPLAYS :: RESTRICTED_TO_ALL_HOLOGRAPHIC_DISPLAYS;
}

DXGI_SWAP_CHAIN_DESC :: struct {
    BufferDesc: DXGI_MODE_DESC;
    SampleDesc: DXGI_SAMPLE_DESC;
    BufferUsage: DXGI_USAGE;
    BufferCount: u32;
    OutputWindow: HWND;
    Windowed: BOOL;
    SwapEffect: DXGI_SWAP_EFFECT;
    Flags: u32;
}

IDXGIObject_UUID :: "aec22fb8-76f3-4639-9be0-28eb43a67a2e";

IDXGIObject :: struct {
    #as using iunknown: IUnknown;
    #place iunknown;
    idxgiobject_vtable: *IDXGIObject_VTable;
}

IDXGIObject_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    SetPrivateData: (this: *IDXGIObject, Name: *GUID, DataSize: u32, pData: *void) -> HRESULT #cpp_method;
    SetPrivateDataInterface: (this: *IDXGIObject, Name: *GUID, pUnknown: *IUnknown) -> HRESULT #cpp_method;
    GetPrivateData: (this: *IDXGIObject, Name: *GUID, pDataSize: *u32, pData: *void) -> HRESULT #cpp_method;
    GetParent: (this: *IDXGIObject, riid: *IID, ppParent: **void) -> HRESULT #cpp_method;
}

IDXGIObject_SetPrivateData :: (this: *IDXGIObject, Name: *GUID, DataSize: u32, pData: *void) -> HRESULT {
    return this.idxgiobject_vtable.SetPrivateData(this, Name, DataSize, pData);
}

IDXGIObject_SetPrivateDataInterface :: (this: *IDXGIObject, Name: *GUID, pUnknown: *IUnknown) -> HRESULT {
    return this.idxgiobject_vtable.SetPrivateDataInterface(this, Name, pUnknown);
}

IDXGIObject_GetPrivateData :: (this: *IDXGIObject, Name: *GUID, pDataSize: *u32, pData: *void) -> HRESULT {
    return this.idxgiobject_vtable.GetPrivateData(this, Name, pDataSize, pData);
}

IDXGIObject_GetParent :: (this: *IDXGIObject, riid: *IID, ppParent: **void) -> HRESULT {
    return this.idxgiobject_vtable.GetParent(this, riid, ppParent);
}

vtable :: (obj: *IDXGIObject) -> *IDXGIObject_VTable {
    return obj.idxgiobject_vtable;
}

IDXGIDeviceSubObject_UUID :: "3d3e0379-f9de-4d58-bb6c-18d62992f1a6";

IDXGIDeviceSubObject :: struct {
    #as using idxgiobject: IDXGIObject;
    #place idxgiobject;
    idxgidevicesubobject_vtable: *IDXGIDeviceSubObject_VTable;
}

IDXGIDeviceSubObject_VTable :: struct #type_info_none {
    using idxgiobject: IDXGIObject_VTable;
    GetDevice: (this: *IDXGIDeviceSubObject, riid: *IID, ppDevice: **void) -> HRESULT #cpp_method;
}

IDXGIDeviceSubObject_GetDevice :: (this: *IDXGIDeviceSubObject, riid: *IID, ppDevice: **void) -> HRESULT {
    return this.idxgidevicesubobject_vtable.GetDevice(this, riid, ppDevice);
}

vtable :: (obj: *IDXGIDeviceSubObject) -> *IDXGIDeviceSubObject_VTable {
    return obj.idxgidevicesubobject_vtable;
}

IDXGIResource_UUID :: "035f3ab4-482e-4e50-b41f-8a7f8bd8960b";

IDXGIResource :: struct {
    #as using idxgidevicesubobject: IDXGIDeviceSubObject;
    #place idxgidevicesubobject;
    idxgiresource_vtable: *IDXGIResource_VTable;
}

IDXGIResource_VTable :: struct #type_info_none {
    using idxgidevicesubobject: IDXGIDeviceSubObject_VTable;
    GetSharedHandle: (this: *IDXGIResource, pSharedHandle: *HANDLE) -> HRESULT #cpp_method;
    GetUsage: (this: *IDXGIResource, pUsage: *DXGI_USAGE) -> HRESULT #cpp_method;
    SetEvictionPriority: (this: *IDXGIResource, EvictionPriority: u32) -> HRESULT #cpp_method;
    GetEvictionPriority: (this: *IDXGIResource, pEvictionPriority: *u32) -> HRESULT #cpp_method;
}

IDXGIResource_GetSharedHandle :: (this: *IDXGIResource, pSharedHandle: *HANDLE) -> HRESULT {
    return this.idxgiresource_vtable.GetSharedHandle(this, pSharedHandle);
}

IDXGIResource_GetUsage :: (this: *IDXGIResource, pUsage: *DXGI_USAGE) -> HRESULT {
    return this.idxgiresource_vtable.GetUsage(this, pUsage);
}

IDXGIResource_SetEvictionPriority :: (this: *IDXGIResource, EvictionPriority: u32) -> HRESULT {
    return this.idxgiresource_vtable.SetEvictionPriority(this, EvictionPriority);
}

IDXGIResource_GetEvictionPriority :: (this: *IDXGIResource, pEvictionPriority: *u32) -> HRESULT {
    return this.idxgiresource_vtable.GetEvictionPriority(this, pEvictionPriority);
}

vtable :: (obj: *IDXGIResource) -> *IDXGIResource_VTable {
    return obj.idxgiresource_vtable;
}

IDXGIKeyedMutex_UUID :: "9d8e1289-d7b3-465f-8126-250e349af85d";

IDXGIKeyedMutex :: struct {
    #as using idxgidevicesubobject: IDXGIDeviceSubObject;
    #place idxgidevicesubobject;
    idxgikeyedmutex_vtable: *IDXGIKeyedMutex_VTable;
}

IDXGIKeyedMutex_VTable :: struct #type_info_none {
    using idxgidevicesubobject: IDXGIDeviceSubObject_VTable;
    AcquireSync: (this: *IDXGIKeyedMutex, Key: u64, dwMilliseconds: u32) -> HRESULT #cpp_method;
    ReleaseSync: (this: *IDXGIKeyedMutex, Key: u64) -> HRESULT #cpp_method;
}

IDXGIKeyedMutex_AcquireSync :: (this: *IDXGIKeyedMutex, Key: u64, dwMilliseconds: u32) -> HRESULT {
    return this.idxgikeyedmutex_vtable.AcquireSync(this, Key, dwMilliseconds);
}

IDXGIKeyedMutex_ReleaseSync :: (this: *IDXGIKeyedMutex, Key: u64) -> HRESULT {
    return this.idxgikeyedmutex_vtable.ReleaseSync(this, Key);
}

vtable :: (obj: *IDXGIKeyedMutex) -> *IDXGIKeyedMutex_VTable {
    return obj.idxgikeyedmutex_vtable;
}

IDXGISurface_UUID :: "cafcb56c-6ac3-4889-bf47-9e23bbd260ec";

IDXGISurface :: struct {
    #as using idxgidevicesubobject: IDXGIDeviceSubObject;
    #place idxgidevicesubobject;
    idxgisurface_vtable: *IDXGISurface_VTable;
}

IDXGISurface_VTable :: struct #type_info_none {
    using idxgidevicesubobject: IDXGIDeviceSubObject_VTable;
    GetDesc: (this: *IDXGISurface, pDesc: *DXGI_SURFACE_DESC) -> HRESULT #cpp_method;
    Map: (this: *IDXGISurface, pLockedRect: *DXGI_MAPPED_RECT, MapFlags: u32) -> HRESULT #cpp_method;
    Unmap: (this: *IDXGISurface) -> HRESULT #cpp_method;
}

IDXGISurface_GetDesc :: (this: *IDXGISurface, pDesc: *DXGI_SURFACE_DESC) -> HRESULT {
    return this.idxgisurface_vtable.GetDesc(this, pDesc);
}

IDXGISurface_Map :: (this: *IDXGISurface, pLockedRect: *DXGI_MAPPED_RECT, MapFlags: u32) -> HRESULT {
    return this.idxgisurface_vtable.Map(this, pLockedRect, MapFlags);
}

IDXGISurface_Unmap :: (this: *IDXGISurface) -> HRESULT {
    return this.idxgisurface_vtable.Unmap(this);
}

vtable :: (obj: *IDXGISurface) -> *IDXGISurface_VTable {
    return obj.idxgisurface_vtable;
}

IDXGISurface1_UUID :: "4AE63092-6327-4c1b-80AE-BFE12EA32B86";

IDXGISurface1 :: struct {
    #as using idxgisurface: IDXGISurface;
    #place idxgisurface;
    idxgisurface1_vtable: *IDXGISurface1_VTable;
}

IDXGISurface1_VTable :: struct #type_info_none {
    using idxgisurface: IDXGISurface_VTable;
    GetDC: (this: *IDXGISurface1, Discard: BOOL, phdc: *HDC) -> HRESULT #cpp_method;
    ReleaseDC: (this: *IDXGISurface1, pDirtyRect: *RECT) -> HRESULT #cpp_method;
}

IDXGISurface1_GetDC :: (this: *IDXGISurface1, Discard: BOOL, phdc: *HDC) -> HRESULT {
    return this.idxgisurface1_vtable.GetDC(this, Discard, phdc);
}

IDXGISurface1_ReleaseDC :: (this: *IDXGISurface1, pDirtyRect: *RECT) -> HRESULT {
    return this.idxgisurface1_vtable.ReleaseDC(this, pDirtyRect);
}

vtable :: (obj: *IDXGISurface1) -> *IDXGISurface1_VTable {
    return obj.idxgisurface1_vtable;
}

IDXGIAdapter_UUID :: "2411e7e1-12ac-4ccf-bd14-9798e8534dc0";

IDXGIAdapter :: struct {
    #as using idxgiobject: IDXGIObject;
    #place idxgiobject;
    idxgiadapter_vtable: *IDXGIAdapter_VTable;
}

IDXGIAdapter_VTable :: struct #type_info_none {
    using idxgiobject: IDXGIObject_VTable;
    EnumOutputs: (this: *IDXGIAdapter, Output: u32, ppOutput: **IDXGIOutput) -> HRESULT #cpp_method;
    GetDesc: (this: *IDXGIAdapter, pDesc: *DXGI_ADAPTER_DESC) -> HRESULT #cpp_method;
    CheckInterfaceSupport: (this: *IDXGIAdapter, InterfaceName: *GUID, pUMDVersion: *LARGE_INTEGER) -> HRESULT #cpp_method;
}

IDXGIAdapter_EnumOutputs :: (this: *IDXGIAdapter, Output: u32, ppOutput: **IDXGIOutput) -> HRESULT {
    return this.idxgiadapter_vtable.EnumOutputs(this, Output, ppOutput);
}

IDXGIAdapter_GetDesc :: (this: *IDXGIAdapter, pDesc: *DXGI_ADAPTER_DESC) -> HRESULT {
    return this.idxgiadapter_vtable.GetDesc(this, pDesc);
}

IDXGIAdapter_CheckInterfaceSupport :: (this: *IDXGIAdapter, InterfaceName: *GUID, pUMDVersion: *LARGE_INTEGER) -> HRESULT {
    return this.idxgiadapter_vtable.CheckInterfaceSupport(this, InterfaceName, pUMDVersion);
}

vtable :: (obj: *IDXGIAdapter) -> *IDXGIAdapter_VTable {
    return obj.idxgiadapter_vtable;
}

IDXGIOutput_UUID :: "ae02eedb-c735-4690-8d52-5a8dc20213aa";

IDXGIOutput :: struct {
    #as using idxgiobject: IDXGIObject;
    #place idxgiobject;
    idxgioutput_vtable: *IDXGIOutput_VTable;
}

IDXGIOutput_VTable :: struct #type_info_none {
    using idxgiobject: IDXGIObject_VTable;
    GetDesc: (this: *IDXGIOutput, pDesc: *DXGI_OUTPUT_DESC) -> HRESULT #cpp_method;
    GetDisplayModeList: (this: *IDXGIOutput, EnumFormat: DXGI_FORMAT, Flags: u32, pNumModes: *u32, pDesc: *DXGI_MODE_DESC) -> HRESULT #cpp_method;
    FindClosestMatchingMode: (this: *IDXGIOutput, pModeToMatch: *DXGI_MODE_DESC, pClosestMatch: *DXGI_MODE_DESC, pConcernedDevice: *IUnknown) -> HRESULT #cpp_method;
    WaitForVBlank: (this: *IDXGIOutput) -> HRESULT #cpp_method;
    TakeOwnership: (this: *IDXGIOutput, pDevice: *IUnknown, Exclusive: BOOL) -> HRESULT #cpp_method;
    ReleaseOwnership: (this: *IDXGIOutput) -> void #cpp_method;
    GetGammaControlCapabilities: (this: *IDXGIOutput, pGammaCaps: *DXGI_GAMMA_CONTROL_CAPABILITIES) -> HRESULT #cpp_method;
    SetGammaControl: (this: *IDXGIOutput, pArray: *DXGI_GAMMA_CONTROL) -> HRESULT #cpp_method;
    GetGammaControl: (this: *IDXGIOutput, pArray: *DXGI_GAMMA_CONTROL) -> HRESULT #cpp_method;
    SetDisplaySurface: (this: *IDXGIOutput, pScanoutSurface: *IDXGISurface) -> HRESULT #cpp_method;
    GetDisplaySurfaceData: (this: *IDXGIOutput, pDestination: *IDXGISurface) -> HRESULT #cpp_method;
    GetFrameStatistics: (this: *IDXGIOutput, pStats: *DXGI_FRAME_STATISTICS) -> HRESULT #cpp_method;
}

IDXGIOutput_GetDesc :: (this: *IDXGIOutput, pDesc: *DXGI_OUTPUT_DESC) -> HRESULT {
    return this.idxgioutput_vtable.GetDesc(this, pDesc);
}

IDXGIOutput_GetDisplayModeList :: (this: *IDXGIOutput, EnumFormat: DXGI_FORMAT, Flags: u32, pNumModes: *u32, pDesc: *DXGI_MODE_DESC) -> HRESULT {
    return this.idxgioutput_vtable.GetDisplayModeList(this, EnumFormat, Flags, pNumModes, pDesc);
}

IDXGIOutput_FindClosestMatchingMode :: (this: *IDXGIOutput, pModeToMatch: *DXGI_MODE_DESC, pClosestMatch: *DXGI_MODE_DESC, pConcernedDevice: *IUnknown) -> HRESULT {
    return this.idxgioutput_vtable.FindClosestMatchingMode(this, pModeToMatch, pClosestMatch, pConcernedDevice);
}

IDXGIOutput_WaitForVBlank :: (this: *IDXGIOutput) -> HRESULT {
    return this.idxgioutput_vtable.WaitForVBlank(this);
}

IDXGIOutput_TakeOwnership :: (this: *IDXGIOutput, pDevice: *IUnknown, Exclusive: BOOL) -> HRESULT {
    return this.idxgioutput_vtable.TakeOwnership(this, pDevice, Exclusive);
}

IDXGIOutput_ReleaseOwnership :: (this: *IDXGIOutput) {
    this.idxgioutput_vtable.ReleaseOwnership(this);
}

IDXGIOutput_GetGammaControlCapabilities :: (this: *IDXGIOutput, pGammaCaps: *DXGI_GAMMA_CONTROL_CAPABILITIES) -> HRESULT {
    return this.idxgioutput_vtable.GetGammaControlCapabilities(this, pGammaCaps);
}

IDXGIOutput_SetGammaControl :: (this: *IDXGIOutput, pArray: *DXGI_GAMMA_CONTROL) -> HRESULT {
    return this.idxgioutput_vtable.SetGammaControl(this, pArray);
}

IDXGIOutput_GetGammaControl :: (this: *IDXGIOutput, pArray: *DXGI_GAMMA_CONTROL) -> HRESULT {
    return this.idxgioutput_vtable.GetGammaControl(this, pArray);
}

IDXGIOutput_SetDisplaySurface :: (this: *IDXGIOutput, pScanoutSurface: *IDXGISurface) -> HRESULT {
    return this.idxgioutput_vtable.SetDisplaySurface(this, pScanoutSurface);
}

IDXGIOutput_GetDisplaySurfaceData :: (this: *IDXGIOutput, pDestination: *IDXGISurface) -> HRESULT {
    return this.idxgioutput_vtable.GetDisplaySurfaceData(this, pDestination);
}

IDXGIOutput_GetFrameStatistics :: (this: *IDXGIOutput, pStats: *DXGI_FRAME_STATISTICS) -> HRESULT {
    return this.idxgioutput_vtable.GetFrameStatistics(this, pStats);
}

vtable :: (obj: *IDXGIOutput) -> *IDXGIOutput_VTable {
    return obj.idxgioutput_vtable;
}

IDXGISwapChain_UUID :: "310d36a0-d2e7-4c0a-aa04-6a9d23b8886a";

IDXGISwapChain :: struct {
    #as using idxgidevicesubobject: IDXGIDeviceSubObject;
    #place idxgidevicesubobject;
    idxgiswapchain_vtable: *IDXGISwapChain_VTable;
}

IDXGISwapChain_VTable :: struct #type_info_none {
    using idxgidevicesubobject: IDXGIDeviceSubObject_VTable;
    Present: (this: *IDXGISwapChain, SyncInterval: u32, Flags: u32) -> HRESULT #cpp_method;
    GetBuffer: (this: *IDXGISwapChain, Buffer: u32, riid: *IID, ppSurface: **void) -> HRESULT #cpp_method;
    SetFullscreenState: (this: *IDXGISwapChain, Fullscreen: BOOL, pTarget: *IDXGIOutput) -> HRESULT #cpp_method;
    GetFullscreenState: (this: *IDXGISwapChain, pFullscreen: *BOOL, ppTarget: **IDXGIOutput) -> HRESULT #cpp_method;
    GetDesc: (this: *IDXGISwapChain, pDesc: *DXGI_SWAP_CHAIN_DESC) -> HRESULT #cpp_method;
    ResizeBuffers: (this: *IDXGISwapChain, BufferCount: u32, Width: u32, Height: u32, NewFormat: DXGI_FORMAT, SwapChainFlags: u32) -> HRESULT #cpp_method;
    ResizeTarget: (this: *IDXGISwapChain, pNewTargetParameters: *DXGI_MODE_DESC) -> HRESULT #cpp_method;
    GetContainingOutput: (this: *IDXGISwapChain, ppOutput: **IDXGIOutput) -> HRESULT #cpp_method;
    GetFrameStatistics: (this: *IDXGISwapChain, pStats: *DXGI_FRAME_STATISTICS) -> HRESULT #cpp_method;
    GetLastPresentCount: (this: *IDXGISwapChain, pLastPresentCount: *u32) -> HRESULT #cpp_method;
}

IDXGISwapChain_Present :: (this: *IDXGISwapChain, SyncInterval: u32, Flags: u32) -> HRESULT {
    return this.idxgiswapchain_vtable.Present(this, SyncInterval, Flags);
}

IDXGISwapChain_GetBuffer :: (this: *IDXGISwapChain, Buffer: u32, riid: *IID, ppSurface: **void) -> HRESULT {
    return this.idxgiswapchain_vtable.GetBuffer(this, Buffer, riid, ppSurface);
}

IDXGISwapChain_SetFullscreenState :: (this: *IDXGISwapChain, Fullscreen: BOOL, pTarget: *IDXGIOutput) -> HRESULT {
    return this.idxgiswapchain_vtable.SetFullscreenState(this, Fullscreen, pTarget);
}

IDXGISwapChain_GetFullscreenState :: (this: *IDXGISwapChain, pFullscreen: *BOOL, ppTarget: **IDXGIOutput) -> HRESULT {
    return this.idxgiswapchain_vtable.GetFullscreenState(this, pFullscreen, ppTarget);
}

IDXGISwapChain_GetDesc :: (this: *IDXGISwapChain, pDesc: *DXGI_SWAP_CHAIN_DESC) -> HRESULT {
    return this.idxgiswapchain_vtable.GetDesc(this, pDesc);
}

IDXGISwapChain_ResizeBuffers :: (this: *IDXGISwapChain, BufferCount: u32, Width: u32, Height: u32, NewFormat: DXGI_FORMAT, SwapChainFlags: u32) -> HRESULT {
    return this.idxgiswapchain_vtable.ResizeBuffers(this, BufferCount, Width, Height, NewFormat, SwapChainFlags);
}

IDXGISwapChain_ResizeTarget :: (this: *IDXGISwapChain, pNewTargetParameters: *DXGI_MODE_DESC) -> HRESULT {
    return this.idxgiswapchain_vtable.ResizeTarget(this, pNewTargetParameters);
}

IDXGISwapChain_GetContainingOutput :: (this: *IDXGISwapChain, ppOutput: **IDXGIOutput) -> HRESULT {
    return this.idxgiswapchain_vtable.GetContainingOutput(this, ppOutput);
}

IDXGISwapChain_GetFrameStatistics :: (this: *IDXGISwapChain, pStats: *DXGI_FRAME_STATISTICS) -> HRESULT {
    return this.idxgiswapchain_vtable.GetFrameStatistics(this, pStats);
}

IDXGISwapChain_GetLastPresentCount :: (this: *IDXGISwapChain, pLastPresentCount: *u32) -> HRESULT {
    return this.idxgiswapchain_vtable.GetLastPresentCount(this, pLastPresentCount);
}

vtable :: (obj: *IDXGISwapChain) -> *IDXGISwapChain_VTable {
    return obj.idxgiswapchain_vtable;
}

IDXGIFactory_UUID :: "7b7166ec-21c7-44ae-b21a-c9ae321ae369";

IDXGIFactory :: struct {
    #as using idxgiobject: IDXGIObject;
    #place idxgiobject;
    idxgifactory_vtable: *IDXGIFactory_VTable;
}

IDXGIFactory_VTable :: struct #type_info_none {
    using idxgiobject: IDXGIObject_VTable;
    EnumAdapters: (this: *IDXGIFactory, Adapter: u32, ppAdapter: **IDXGIAdapter) -> HRESULT #cpp_method;
    MakeWindowAssociation: (this: *IDXGIFactory, WindowHandle: HWND, Flags: u32) -> HRESULT #cpp_method;
    GetWindowAssociation: (this: *IDXGIFactory, pWindowHandle: *HWND) -> HRESULT #cpp_method;
    CreateSwapChain: (this: *IDXGIFactory, pDevice: *IUnknown, pDesc: *DXGI_SWAP_CHAIN_DESC, ppSwapChain: **IDXGISwapChain) -> HRESULT #cpp_method;
    CreateSoftwareAdapter: (this: *IDXGIFactory, Module: HMODULE, ppAdapter: **IDXGIAdapter) -> HRESULT #cpp_method;
}

IDXGIFactory_EnumAdapters :: (this: *IDXGIFactory, Adapter: u32, ppAdapter: **IDXGIAdapter) -> HRESULT {
    return this.idxgifactory_vtable.EnumAdapters(this, Adapter, ppAdapter);
}

IDXGIFactory_MakeWindowAssociation :: (this: *IDXGIFactory, WindowHandle: HWND, Flags: u32) -> HRESULT {
    return this.idxgifactory_vtable.MakeWindowAssociation(this, WindowHandle, Flags);
}

IDXGIFactory_GetWindowAssociation :: (this: *IDXGIFactory, pWindowHandle: *HWND) -> HRESULT {
    return this.idxgifactory_vtable.GetWindowAssociation(this, pWindowHandle);
}

IDXGIFactory_CreateSwapChain :: (this: *IDXGIFactory, pDevice: *IUnknown, pDesc: *DXGI_SWAP_CHAIN_DESC, ppSwapChain: **IDXGISwapChain) -> HRESULT {
    return this.idxgifactory_vtable.CreateSwapChain(this, pDevice, pDesc, ppSwapChain);
}

IDXGIFactory_CreateSoftwareAdapter :: (this: *IDXGIFactory, Module: HMODULE, ppAdapter: **IDXGIAdapter) -> HRESULT {
    return this.idxgifactory_vtable.CreateSoftwareAdapter(this, Module, ppAdapter);
}

vtable :: (obj: *IDXGIFactory) -> *IDXGIFactory_VTable {
    return obj.idxgifactory_vtable;
}

CreateDXGIFactory :: (riid: *IID, ppFactory: **void) -> HRESULT #foreign dxgi;

CreateDXGIFactory :: (riid: IID, ppFactory: **void) -> HRESULT {
    return CreateDXGIFactory(*riid, ppFactory);
}

CreateDXGIFactory1 :: (riid: *IID, ppFactory: **void) -> HRESULT #foreign dxgi;

CreateDXGIFactory1 :: (riid: IID, ppFactory: **void) -> HRESULT {
    return CreateDXGIFactory1(*riid, ppFactory);
}

IDXGIDevice_UUID :: "54ec77fa-1377-44e6-8c32-88fd5f44c84c";

IDXGIDevice :: struct {
    #as using idxgiobject: IDXGIObject;
    #place idxgiobject;
    idxgidevice_vtable: *IDXGIDevice_VTable;
}

IDXGIDevice_VTable :: struct #type_info_none {
    using idxgiobject: IDXGIObject_VTable;
    GetAdapter: (this: *IDXGIDevice, pAdapter: **IDXGIAdapter) -> HRESULT #cpp_method;
    CreateSurface: (this: *IDXGIDevice, pDesc: *DXGI_SURFACE_DESC, NumSurfaces: u32, Usage: DXGI_USAGE, pSharedResource: *DXGI_SHARED_RESOURCE, ppSurface: **IDXGISurface) -> HRESULT #cpp_method;
    QueryResourceResidency: (this: *IDXGIDevice, ppResources: **IUnknown, pResidencyStatus: *DXGI_RESIDENCY, NumResources: u32) -> HRESULT #cpp_method;
    SetGPUThreadPriority: (this: *IDXGIDevice, Priority: s32) -> HRESULT #cpp_method;
    GetGPUThreadPriority: (this: *IDXGIDevice, pPriority: *s32) -> HRESULT #cpp_method;
}

IDXGIDevice_GetAdapter :: (this: *IDXGIDevice, pAdapter: **IDXGIAdapter) -> HRESULT {
    return this.idxgidevice_vtable.GetAdapter(this, pAdapter);
}

IDXGIDevice_CreateSurface :: (this: *IDXGIDevice, pDesc: *DXGI_SURFACE_DESC, NumSurfaces: u32, Usage: DXGI_USAGE, pSharedResource: *DXGI_SHARED_RESOURCE, ppSurface: **IDXGISurface) -> HRESULT {
    return this.idxgidevice_vtable.CreateSurface(this, pDesc, NumSurfaces, Usage, pSharedResource, ppSurface);
}

IDXGIDevice_QueryResourceResidency :: (this: *IDXGIDevice, ppResources: **IUnknown, pResidencyStatus: *DXGI_RESIDENCY, NumResources: u32) -> HRESULT {
    return this.idxgidevice_vtable.QueryResourceResidency(this, ppResources, pResidencyStatus, NumResources);
}

IDXGIDevice_SetGPUThreadPriority :: (this: *IDXGIDevice, Priority: s32) -> HRESULT {
    return this.idxgidevice_vtable.SetGPUThreadPriority(this, Priority);
}

IDXGIDevice_GetGPUThreadPriority :: (this: *IDXGIDevice, pPriority: *s32) -> HRESULT {
    return this.idxgidevice_vtable.GetGPUThreadPriority(this, pPriority);
}

vtable :: (obj: *IDXGIDevice) -> *IDXGIDevice_VTable {
    return obj.idxgidevice_vtable;
}

DXGI_ADAPTER_FLAG :: enum_flags u32 {
    NONE :: 0x0;
    REMOTE :: 0x1;
    SOFTWARE :: 0x2;
    FORCE_DWORD :: 0xffffffff;
    DXGI_ADAPTER_FLAG_NONE :: NONE;
    DXGI_ADAPTER_FLAG_REMOTE :: REMOTE;
    DXGI_ADAPTER_FLAG_SOFTWARE :: SOFTWARE;
    DXGI_ADAPTER_FLAG_FORCE_DWORD :: FORCE_DWORD;
}

DXGI_ADAPTER_DESC1 :: struct {
    Description: [128] s16;
    VendorId: u32;
    DeviceId: u32;
    SubSysId: u32;
    Revision: u32;
    DedicatedVideoMemory: SIZE_T;
    DedicatedSystemMemory: SIZE_T;
    SharedSystemMemory: SIZE_T;
    AdapterLuid: LUID;
    Flags: u32;
}

DXGI_DISPLAY_COLOR_SPACE :: struct {
    PrimaryCoordinates: [8][2] float;
    WhitePoints: [16][2] float;
}

IDXGIFactory1_UUID :: "770aae78-f26f-4dba-a829-253c83d1b387";

IDXGIFactory1 :: struct {
    #as using idxgifactory: IDXGIFactory;
    #place idxgifactory;
    idxgifactory1_vtable: *IDXGIFactory1_VTable;
}

IDXGIFactory1_VTable :: struct #type_info_none {
    using idxgifactory: IDXGIFactory_VTable;
    EnumAdapters1: (this: *IDXGIFactory1, Adapter: u32, ppAdapter: **IDXGIAdapter1) -> HRESULT #cpp_method;
    IsCurrent: (this: *IDXGIFactory1) -> BOOL #cpp_method;
}

IDXGIFactory1_EnumAdapters1 :: (this: *IDXGIFactory1, Adapter: u32, ppAdapter: **IDXGIAdapter1) -> HRESULT {
    return this.idxgifactory1_vtable.EnumAdapters1(this, Adapter, ppAdapter);
}

IDXGIFactory1_IsCurrent :: (this: *IDXGIFactory1) -> BOOL {
    return this.idxgifactory1_vtable.IsCurrent(this);
}

vtable :: (obj: *IDXGIFactory1) -> *IDXGIFactory1_VTable {
    return obj.idxgifactory1_vtable;
}

IDXGIAdapter1_UUID :: "29038f61-3839-4626-91fd-086879011a05";

IDXGIAdapter1 :: struct {
    #as using idxgiadapter: IDXGIAdapter;
    #place idxgiadapter;
    idxgiadapter1_vtable: *IDXGIAdapter1_VTable;
}

IDXGIAdapter1_VTable :: struct #type_info_none {
    using idxgiadapter: IDXGIAdapter_VTable;
    GetDesc1: (this: *IDXGIAdapter1, pDesc: *DXGI_ADAPTER_DESC1) -> HRESULT #cpp_method;
}

IDXGIAdapter1_GetDesc1 :: (this: *IDXGIAdapter1, pDesc: *DXGI_ADAPTER_DESC1) -> HRESULT {
    return this.idxgiadapter1_vtable.GetDesc1(this, pDesc);
}

vtable :: (obj: *IDXGIAdapter1) -> *IDXGIAdapter1_VTable {
    return obj.idxgiadapter1_vtable;
}

IDXGIDevice1_UUID :: "77db970f-6276-48ba-ba28-070143b4392c";

IDXGIDevice1 :: struct {
    #as using idxgidevice: IDXGIDevice;
    #place idxgidevice;
    idxgidevice1_vtable: *IDXGIDevice1_VTable;
}

IDXGIDevice1_VTable :: struct #type_info_none {
    using idxgidevice: IDXGIDevice_VTable;
    SetMaximumFrameLatency: (this: *IDXGIDevice1, MaxLatency: u32) -> HRESULT #cpp_method;
    GetMaximumFrameLatency: (this: *IDXGIDevice1, pMaxLatency: *u32) -> HRESULT #cpp_method;
}

IDXGIDevice1_SetMaximumFrameLatency :: (this: *IDXGIDevice1, MaxLatency: u32) -> HRESULT {
    return this.idxgidevice1_vtable.SetMaximumFrameLatency(this, MaxLatency);
}

IDXGIDevice1_GetMaximumFrameLatency :: (this: *IDXGIDevice1, pMaxLatency: *u32) -> HRESULT {
    return this.idxgidevice1_vtable.GetMaximumFrameLatency(this, pMaxLatency);
}

vtable :: (obj: *IDXGIDevice1) -> *IDXGIDevice1_VTable {
    return obj.idxgidevice1_vtable;
}

IDXGIDisplayControl_UUID :: "ea9dbf1a-c88e-4486-854a-98aa0138f30c";

IDXGIDisplayControl :: struct {
    #as using iunknown: IUnknown;
    #place iunknown;
    idxgidisplaycontrol_vtable: *IDXGIDisplayControl_VTable;
}

IDXGIDisplayControl_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    IsStereoEnabled: (this: *IDXGIDisplayControl) -> BOOL #cpp_method;
    SetStereoEnabled: (this: *IDXGIDisplayControl, enabled: BOOL) -> void #cpp_method;
}

IDXGIDisplayControl_IsStereoEnabled :: (this: *IDXGIDisplayControl) -> BOOL {
    return this.idxgidisplaycontrol_vtable.IsStereoEnabled(this);
}

IDXGIDisplayControl_SetStereoEnabled :: (this: *IDXGIDisplayControl, enabled: BOOL) {
    this.idxgidisplaycontrol_vtable.SetStereoEnabled(this, enabled);
}

vtable :: (obj: *IDXGIDisplayControl) -> *IDXGIDisplayControl_VTable {
    return obj.idxgidisplaycontrol_vtable;
}

DXGI_OUTDUPL_MOVE_RECT :: struct {
    SourcePoint: POINT;
    DestinationRect: RECT;
}

DXGI_OUTDUPL_DESC :: struct {
    ModeDesc: DXGI_MODE_DESC;
    Rotation: DXGI_MODE_ROTATION;
    DesktopImageInSystemMemory: BOOL;
}

DXGI_OUTDUPL_POINTER_POSITION :: struct {
    Position: POINT;
    Visible: BOOL;
}

DXGI_OUTDUPL_POINTER_SHAPE_TYPE :: enum s32 {
    MONOCHROME :: 1;
    COLOR :: 2;
    MASKED_COLOR :: 4;
    DXGI_OUTDUPL_POINTER_SHAPE_TYPE_MONOCHROME :: MONOCHROME;
    DXGI_OUTDUPL_POINTER_SHAPE_TYPE_COLOR :: COLOR;
    DXGI_OUTDUPL_POINTER_SHAPE_TYPE_MASKED_COLOR :: MASKED_COLOR;
}

DXGI_OUTDUPL_POINTER_SHAPE_INFO :: struct {
    Type: u32;
    Width: u32;
    Height: u32;
    Pitch: u32;
    HotSpot: POINT;
}

DXGI_OUTDUPL_FRAME_INFO :: struct {
    LastPresentTime: LARGE_INTEGER;
    LastMouseUpdateTime: LARGE_INTEGER;
    AccumulatedFrames: u32;
    RectsCoalesced: BOOL;
    ProtectedContentMaskedOut: BOOL;
    PointerPosition: DXGI_OUTDUPL_POINTER_POSITION;
    TotalMetadataBufferSize: u32;
    PointerShapeBufferSize: u32;
}

IDXGIOutputDuplication_UUID :: "191cfac3-a341-470d-b26e-a864f428319c";

IDXGIOutputDuplication :: struct {
    #as using idxgiobject: IDXGIObject;
    #place idxgiobject;
    idxgioutputduplication_vtable: *IDXGIOutputDuplication_VTable;
}

IDXGIOutputDuplication_VTable :: struct #type_info_none {
    using idxgiobject: IDXGIObject_VTable;
    GetDesc: (this: *IDXGIOutputDuplication, pDesc: *DXGI_OUTDUPL_DESC) -> void #cpp_method;
    AcquireNextFrame: (this: *IDXGIOutputDuplication, TimeoutInMilliseconds: u32, pFrameInfo: *DXGI_OUTDUPL_FRAME_INFO, ppDesktopResource: **IDXGIResource) -> HRESULT #cpp_method;
    GetFrameDirtyRects: (this: *IDXGIOutputDuplication, DirtyRectsBufferSize: u32, pDirtyRectsBuffer: *RECT, pDirtyRectsBufferSizeRequired: *u32) -> HRESULT #cpp_method;
    GetFrameMoveRects: (this: *IDXGIOutputDuplication, MoveRectsBufferSize: u32, pMoveRectBuffer: *DXGI_OUTDUPL_MOVE_RECT, pMoveRectsBufferSizeRequired: *u32) -> HRESULT #cpp_method;
    GetFramePointerShape: (this: *IDXGIOutputDuplication, PointerShapeBufferSize: u32, pPointerShapeBuffer: *void, pPointerShapeBufferSizeRequired: *u32, pPointerShapeInfo: *DXGI_OUTDUPL_POINTER_SHAPE_INFO) -> HRESULT #cpp_method;
    MapDesktopSurface: (this: *IDXGIOutputDuplication, pLockedRect: *DXGI_MAPPED_RECT) -> HRESULT #cpp_method;
    UnMapDesktopSurface: (this: *IDXGIOutputDuplication) -> HRESULT #cpp_method;
    ReleaseFrame: (this: *IDXGIOutputDuplication) -> HRESULT #cpp_method;
}

IDXGIOutputDuplication_GetDesc :: (this: *IDXGIOutputDuplication, pDesc: *DXGI_OUTDUPL_DESC) {
    this.idxgioutputduplication_vtable.GetDesc(this, pDesc);
}

IDXGIOutputDuplication_AcquireNextFrame :: (this: *IDXGIOutputDuplication, TimeoutInMilliseconds: u32, pFrameInfo: *DXGI_OUTDUPL_FRAME_INFO, ppDesktopResource: **IDXGIResource) -> HRESULT {
    return this.idxgioutputduplication_vtable.AcquireNextFrame(this, TimeoutInMilliseconds, pFrameInfo, ppDesktopResource);
}

IDXGIOutputDuplication_GetFrameDirtyRects :: (this: *IDXGIOutputDuplication, DirtyRectsBufferSize: u32, pDirtyRectsBuffer: *RECT, pDirtyRectsBufferSizeRequired: *u32) -> HRESULT {
    return this.idxgioutputduplication_vtable.GetFrameDirtyRects(this, DirtyRectsBufferSize, pDirtyRectsBuffer, pDirtyRectsBufferSizeRequired);
}

IDXGIOutputDuplication_GetFrameMoveRects :: (this: *IDXGIOutputDuplication, MoveRectsBufferSize: u32, pMoveRectBuffer: *DXGI_OUTDUPL_MOVE_RECT, pMoveRectsBufferSizeRequired: *u32) -> HRESULT {
    return this.idxgioutputduplication_vtable.GetFrameMoveRects(this, MoveRectsBufferSize, pMoveRectBuffer, pMoveRectsBufferSizeRequired);
}

IDXGIOutputDuplication_GetFramePointerShape :: (this: *IDXGIOutputDuplication, PointerShapeBufferSize: u32, pPointerShapeBuffer: *void, pPointerShapeBufferSizeRequired: *u32, pPointerShapeInfo: *DXGI_OUTDUPL_POINTER_SHAPE_INFO) -> HRESULT {
    return this.idxgioutputduplication_vtable.GetFramePointerShape(this, PointerShapeBufferSize, pPointerShapeBuffer, pPointerShapeBufferSizeRequired, pPointerShapeInfo);
}

IDXGIOutputDuplication_MapDesktopSurface :: (this: *IDXGIOutputDuplication, pLockedRect: *DXGI_MAPPED_RECT) -> HRESULT {
    return this.idxgioutputduplication_vtable.MapDesktopSurface(this, pLockedRect);
}

IDXGIOutputDuplication_UnMapDesktopSurface :: (this: *IDXGIOutputDuplication) -> HRESULT {
    return this.idxgioutputduplication_vtable.UnMapDesktopSurface(this);
}

IDXGIOutputDuplication_ReleaseFrame :: (this: *IDXGIOutputDuplication) -> HRESULT {
    return this.idxgioutputduplication_vtable.ReleaseFrame(this);
}

vtable :: (obj: *IDXGIOutputDuplication) -> *IDXGIOutputDuplication_VTable {
    return obj.idxgioutputduplication_vtable;
}

DXGI_ALPHA_MODE :: enum s32 {
    UNSPECIFIED :: 0;
    PREMULTIPLIED :: 1;
    STRAIGHT :: 2;
    IGNORE :: 3;
    FORCE_DWORD :: -1;
    DXGI_ALPHA_MODE_UNSPECIFIED :: UNSPECIFIED;
    DXGI_ALPHA_MODE_PREMULTIPLIED :: PREMULTIPLIED;
    DXGI_ALPHA_MODE_STRAIGHT :: STRAIGHT;
    DXGI_ALPHA_MODE_IGNORE :: IGNORE;
    DXGI_ALPHA_MODE_FORCE_DWORD :: FORCE_DWORD;
}

IDXGISurface2_UUID :: "aba496dd-b617-4cb8-a866-bc44d7eb1fa2";

IDXGISurface2 :: struct {
    #as using idxgisurface1: IDXGISurface1;
    #place idxgisurface1;
    idxgisurface2_vtable: *IDXGISurface2_VTable;
}

IDXGISurface2_VTable :: struct #type_info_none {
    using idxgisurface1: IDXGISurface1_VTable;
    GetResource: (this: *IDXGISurface2, riid: *IID, ppParentResource: **void, pSubresourceIndex: *u32) -> HRESULT #cpp_method;
}

IDXGISurface2_GetResource :: (this: *IDXGISurface2, riid: *IID, ppParentResource: **void, pSubresourceIndex: *u32) -> HRESULT {
    return this.idxgisurface2_vtable.GetResource(this, riid, ppParentResource, pSubresourceIndex);
}

vtable :: (obj: *IDXGISurface2) -> *IDXGISurface2_VTable {
    return obj.idxgisurface2_vtable;
}

IDXGIResource1_UUID :: "30961379-4609-4a41-998e-54fe567ee0c1";

IDXGIResource1 :: struct {
    #as using idxgiresource: IDXGIResource;
    #place idxgiresource;
    idxgiresource1_vtable: *IDXGIResource1_VTable;
}

IDXGIResource1_VTable :: struct #type_info_none {
    using idxgiresource: IDXGIResource_VTable;
    CreateSubresourceSurface: (this: *IDXGIResource1, index: u32, ppSurface: **IDXGISurface2) -> HRESULT #cpp_method;
    CreateSharedHandle: (this: *IDXGIResource1, pAttributes: *SECURITY_ATTRIBUTES, dwAccess: u32, lpName: *s16, pHandle: *HANDLE) -> HRESULT #cpp_method;
}

IDXGIResource1_CreateSubresourceSurface :: (this: *IDXGIResource1, index: u32, ppSurface: **IDXGISurface2) -> HRESULT {
    return this.idxgiresource1_vtable.CreateSubresourceSurface(this, index, ppSurface);
}

IDXGIResource1_CreateSharedHandle :: (this: *IDXGIResource1, pAttributes: *SECURITY_ATTRIBUTES, dwAccess: u32, lpName: *s16, pHandle: *HANDLE) -> HRESULT {
    return this.idxgiresource1_vtable.CreateSharedHandle(this, pAttributes, dwAccess, lpName, pHandle);
}

vtable :: (obj: *IDXGIResource1) -> *IDXGIResource1_VTable {
    return obj.idxgiresource1_vtable;
}

DXGI_OFFER_RESOURCE_PRIORITY :: enum s32 {
    LOW :: 1;
    NORMAL :: 2;
    HIGH :: 3;
    DXGI_OFFER_RESOURCE_PRIORITY_LOW :: LOW;
    DXGI_OFFER_RESOURCE_PRIORITY_NORMAL :: NORMAL;
    DXGI_OFFER_RESOURCE_PRIORITY_HIGH :: HIGH;
}

IDXGIDevice2_UUID :: "05008617-fbfd-4051-a790-144884b4f6a9";

IDXGIDevice2 :: struct {
    #as using idxgidevice1: IDXGIDevice1;
    #place idxgidevice1;
    idxgidevice2_vtable: *IDXGIDevice2_VTable;
}

IDXGIDevice2_VTable :: struct #type_info_none {
    using idxgidevice1: IDXGIDevice1_VTable;
    OfferResources: (this: *IDXGIDevice2, NumResources: u32, ppResources: **IDXGIResource, Priority: DXGI_OFFER_RESOURCE_PRIORITY) -> HRESULT #cpp_method;
    ReclaimResources: (this: *IDXGIDevice2, NumResources: u32, ppResources: **IDXGIResource, pDiscarded: *BOOL) -> HRESULT #cpp_method;
    EnqueueSetEvent: (this: *IDXGIDevice2, hEvent: HANDLE) -> HRESULT #cpp_method;
}

IDXGIDevice2_OfferResources :: (this: *IDXGIDevice2, NumResources: u32, ppResources: **IDXGIResource, Priority: DXGI_OFFER_RESOURCE_PRIORITY) -> HRESULT {
    return this.idxgidevice2_vtable.OfferResources(this, NumResources, ppResources, Priority);
}

IDXGIDevice2_ReclaimResources :: (this: *IDXGIDevice2, NumResources: u32, ppResources: **IDXGIResource, pDiscarded: *BOOL) -> HRESULT {
    return this.idxgidevice2_vtable.ReclaimResources(this, NumResources, ppResources, pDiscarded);
}

IDXGIDevice2_EnqueueSetEvent :: (this: *IDXGIDevice2, hEvent: HANDLE) -> HRESULT {
    return this.idxgidevice2_vtable.EnqueueSetEvent(this, hEvent);
}

vtable :: (obj: *IDXGIDevice2) -> *IDXGIDevice2_VTable {
    return obj.idxgidevice2_vtable;
}

DXGI_MODE_DESC1 :: struct {
    Width: u32;
    Height: u32;
    RefreshRate: DXGI_RATIONAL;
    Format: DXGI_FORMAT;
    ScanlineOrdering: DXGI_MODE_SCANLINE_ORDER;
    Scaling: DXGI_MODE_SCALING;
    Stereo: BOOL;
}

DXGI_SCALING :: enum s32 {
    STRETCH :: 0;
    NONE :: 1;
    ASPECT_RATIO_STRETCH :: 2;
    DXGI_SCALING_STRETCH :: STRETCH;
    DXGI_SCALING_NONE :: NONE;
    DXGI_SCALING_ASPECT_RATIO_STRETCH :: ASPECT_RATIO_STRETCH;
}

DXGI_SWAP_CHAIN_DESC1 :: struct {
    Width: u32;
    Height: u32;
    Format: DXGI_FORMAT;
    Stereo: BOOL;
    SampleDesc: DXGI_SAMPLE_DESC;
    BufferUsage: DXGI_USAGE;
    BufferCount: u32;
    Scaling: DXGI_SCALING;
    SwapEffect: DXGI_SWAP_EFFECT;
    AlphaMode: DXGI_ALPHA_MODE;
    Flags: u32;
}

DXGI_SWAP_CHAIN_FULLSCREEN_DESC :: struct {
    RefreshRate: DXGI_RATIONAL;
    ScanlineOrdering: DXGI_MODE_SCANLINE_ORDER;
    Scaling: DXGI_MODE_SCALING;
    Windowed: BOOL;
}

DXGI_PRESENT_PARAMETERS :: struct {
    DirtyRectsCount: u32;
    pDirtyRects: *RECT;
    pScrollRect: *RECT;
    pScrollOffset: *POINT;
}

IDXGISwapChain1_UUID :: "790a45f7-0d42-4876-983a-0a55cfe6f4aa";

IDXGISwapChain1 :: struct {
    #as using idxgiswapchain: IDXGISwapChain;
    #place idxgiswapchain;
    idxgiswapchain1_vtable: *IDXGISwapChain1_VTable;
}

IDXGISwapChain1_VTable :: struct #type_info_none {
    using idxgiswapchain: IDXGISwapChain_VTable;
    GetDesc1: (this: *IDXGISwapChain1, pDesc: *DXGI_SWAP_CHAIN_DESC1) -> HRESULT #cpp_method;
    GetFullscreenDesc: (this: *IDXGISwapChain1, pDesc: *DXGI_SWAP_CHAIN_FULLSCREEN_DESC) -> HRESULT #cpp_method;
    GetHwnd: (this: *IDXGISwapChain1, pHwnd: *HWND) -> HRESULT #cpp_method;
    GetCoreWindow: (this: *IDXGISwapChain1, refiid: *IID, ppUnk: **void) -> HRESULT #cpp_method;
    Present1: (this: *IDXGISwapChain1, SyncInterval: u32, PresentFlags: u32, pPresentParameters: *DXGI_PRESENT_PARAMETERS) -> HRESULT #cpp_method;
    IsTemporaryMonoSupported: (this: *IDXGISwapChain1) -> BOOL #cpp_method;
    GetRestrictToOutput: (this: *IDXGISwapChain1, ppRestrictToOutput: **IDXGIOutput) -> HRESULT #cpp_method;
    SetBackgroundColor: (this: *IDXGISwapChain1, pColor: *DXGI_RGBA) -> HRESULT #cpp_method;
    GetBackgroundColor: (this: *IDXGISwapChain1, pColor: *DXGI_RGBA) -> HRESULT #cpp_method;
    SetRotation: (this: *IDXGISwapChain1, Rotation: DXGI_MODE_ROTATION) -> HRESULT #cpp_method;
    GetRotation: (this: *IDXGISwapChain1, pRotation: *DXGI_MODE_ROTATION) -> HRESULT #cpp_method;
}

IDXGISwapChain1_GetDesc1 :: (this: *IDXGISwapChain1, pDesc: *DXGI_SWAP_CHAIN_DESC1) -> HRESULT {
    return this.idxgiswapchain1_vtable.GetDesc1(this, pDesc);
}

IDXGISwapChain1_GetFullscreenDesc :: (this: *IDXGISwapChain1, pDesc: *DXGI_SWAP_CHAIN_FULLSCREEN_DESC) -> HRESULT {
    return this.idxgiswapchain1_vtable.GetFullscreenDesc(this, pDesc);
}

IDXGISwapChain1_GetHwnd :: (this: *IDXGISwapChain1, pHwnd: *HWND) -> HRESULT {
    return this.idxgiswapchain1_vtable.GetHwnd(this, pHwnd);
}

IDXGISwapChain1_GetCoreWindow :: (this: *IDXGISwapChain1, refiid: *IID, ppUnk: **void) -> HRESULT {
    return this.idxgiswapchain1_vtable.GetCoreWindow(this, refiid, ppUnk);
}

IDXGISwapChain1_Present1 :: (this: *IDXGISwapChain1, SyncInterval: u32, PresentFlags: u32, pPresentParameters: *DXGI_PRESENT_PARAMETERS) -> HRESULT {
    return this.idxgiswapchain1_vtable.Present1(this, SyncInterval, PresentFlags, pPresentParameters);
}

IDXGISwapChain1_IsTemporaryMonoSupported :: (this: *IDXGISwapChain1) -> BOOL {
    return this.idxgiswapchain1_vtable.IsTemporaryMonoSupported(this);
}

IDXGISwapChain1_GetRestrictToOutput :: (this: *IDXGISwapChain1, ppRestrictToOutput: **IDXGIOutput) -> HRESULT {
    return this.idxgiswapchain1_vtable.GetRestrictToOutput(this, ppRestrictToOutput);
}

IDXGISwapChain1_SetBackgroundColor :: (this: *IDXGISwapChain1, pColor: *DXGI_RGBA) -> HRESULT {
    return this.idxgiswapchain1_vtable.SetBackgroundColor(this, pColor);
}

IDXGISwapChain1_GetBackgroundColor :: (this: *IDXGISwapChain1, pColor: *DXGI_RGBA) -> HRESULT {
    return this.idxgiswapchain1_vtable.GetBackgroundColor(this, pColor);
}

IDXGISwapChain1_SetRotation :: (this: *IDXGISwapChain1, Rotation: DXGI_MODE_ROTATION) -> HRESULT {
    return this.idxgiswapchain1_vtable.SetRotation(this, Rotation);
}

IDXGISwapChain1_GetRotation :: (this: *IDXGISwapChain1, pRotation: *DXGI_MODE_ROTATION) -> HRESULT {
    return this.idxgiswapchain1_vtable.GetRotation(this, pRotation);
}

vtable :: (obj: *IDXGISwapChain1) -> *IDXGISwapChain1_VTable {
    return obj.idxgiswapchain1_vtable;
}

IDXGIFactory2_UUID :: "50c83a1c-e072-4c48-87b0-3630fa36a6d0";

IDXGIFactory2 :: struct {
    #as using idxgifactory1: IDXGIFactory1;
    #place idxgifactory1;
    idxgifactory2_vtable: *IDXGIFactory2_VTable;
}

IDXGIFactory2_VTable :: struct #type_info_none {
    using idxgifactory1: IDXGIFactory1_VTable;
    IsWindowedStereoEnabled: (this: *IDXGIFactory2) -> BOOL #cpp_method;
    CreateSwapChainForHwnd: (this: *IDXGIFactory2, pDevice: *IUnknown, hWnd: HWND, pDesc: *DXGI_SWAP_CHAIN_DESC1, pFullscreenDesc: *DXGI_SWAP_CHAIN_FULLSCREEN_DESC, pRestrictToOutput: *IDXGIOutput, ppSwapChain: **IDXGISwapChain1) -> HRESULT #cpp_method;
    CreateSwapChainForCoreWindow: (this: *IDXGIFactory2, pDevice: *IUnknown, pWindow: *IUnknown, pDesc: *DXGI_SWAP_CHAIN_DESC1, pRestrictToOutput: *IDXGIOutput, ppSwapChain: **IDXGISwapChain1) -> HRESULT #cpp_method;
    GetSharedResourceAdapterLuid: (this: *IDXGIFactory2, hResource: HANDLE, pLuid: *LUID) -> HRESULT #cpp_method;
    RegisterStereoStatusWindow: (this: *IDXGIFactory2, WindowHandle: HWND, wMsg: u32, pdwCookie: *u32) -> HRESULT #cpp_method;
    RegisterStereoStatusEvent: (this: *IDXGIFactory2, hEvent: HANDLE, pdwCookie: *u32) -> HRESULT #cpp_method;
    UnregisterStereoStatus: (this: *IDXGIFactory2, dwCookie: u32) -> void #cpp_method;
    RegisterOcclusionStatusWindow: (this: *IDXGIFactory2, WindowHandle: HWND, wMsg: u32, pdwCookie: *u32) -> HRESULT #cpp_method;
    RegisterOcclusionStatusEvent: (this: *IDXGIFactory2, hEvent: HANDLE, pdwCookie: *u32) -> HRESULT #cpp_method;
    UnregisterOcclusionStatus: (this: *IDXGIFactory2, dwCookie: u32) -> void #cpp_method;
    CreateSwapChainForComposition: (this: *IDXGIFactory2, pDevice: *IUnknown, pDesc: *DXGI_SWAP_CHAIN_DESC1, pRestrictToOutput: *IDXGIOutput, ppSwapChain: **IDXGISwapChain1) -> HRESULT #cpp_method;
}

IDXGIFactory2_IsWindowedStereoEnabled :: (this: *IDXGIFactory2) -> BOOL {
    return this.idxgifactory2_vtable.IsWindowedStereoEnabled(this);
}

IDXGIFactory2_CreateSwapChainForHwnd :: (this: *IDXGIFactory2, pDevice: *IUnknown, hWnd: HWND, pDesc: *DXGI_SWAP_CHAIN_DESC1, pFullscreenDesc: *DXGI_SWAP_CHAIN_FULLSCREEN_DESC, pRestrictToOutput: *IDXGIOutput, ppSwapChain: **IDXGISwapChain1) -> HRESULT {
    return this.idxgifactory2_vtable.CreateSwapChainForHwnd(this, pDevice, hWnd, pDesc, pFullscreenDesc, pRestrictToOutput, ppSwapChain);
}

IDXGIFactory2_CreateSwapChainForCoreWindow :: (this: *IDXGIFactory2, pDevice: *IUnknown, pWindow: *IUnknown, pDesc: *DXGI_SWAP_CHAIN_DESC1, pRestrictToOutput: *IDXGIOutput, ppSwapChain: **IDXGISwapChain1) -> HRESULT {
    return this.idxgifactory2_vtable.CreateSwapChainForCoreWindow(this, pDevice, pWindow, pDesc, pRestrictToOutput, ppSwapChain);
}

IDXGIFactory2_GetSharedResourceAdapterLuid :: (this: *IDXGIFactory2, hResource: HANDLE, pLuid: *LUID) -> HRESULT {
    return this.idxgifactory2_vtable.GetSharedResourceAdapterLuid(this, hResource, pLuid);
}

IDXGIFactory2_RegisterStereoStatusWindow :: (this: *IDXGIFactory2, WindowHandle: HWND, wMsg: u32, pdwCookie: *u32) -> HRESULT {
    return this.idxgifactory2_vtable.RegisterStereoStatusWindow(this, WindowHandle, wMsg, pdwCookie);
}

IDXGIFactory2_RegisterStereoStatusEvent :: (this: *IDXGIFactory2, hEvent: HANDLE, pdwCookie: *u32) -> HRESULT {
    return this.idxgifactory2_vtable.RegisterStereoStatusEvent(this, hEvent, pdwCookie);
}

IDXGIFactory2_UnregisterStereoStatus :: (this: *IDXGIFactory2, dwCookie: u32) {
    this.idxgifactory2_vtable.UnregisterStereoStatus(this, dwCookie);
}

IDXGIFactory2_RegisterOcclusionStatusWindow :: (this: *IDXGIFactory2, WindowHandle: HWND, wMsg: u32, pdwCookie: *u32) -> HRESULT {
    return this.idxgifactory2_vtable.RegisterOcclusionStatusWindow(this, WindowHandle, wMsg, pdwCookie);
}

IDXGIFactory2_RegisterOcclusionStatusEvent :: (this: *IDXGIFactory2, hEvent: HANDLE, pdwCookie: *u32) -> HRESULT {
    return this.idxgifactory2_vtable.RegisterOcclusionStatusEvent(this, hEvent, pdwCookie);
}

IDXGIFactory2_UnregisterOcclusionStatus :: (this: *IDXGIFactory2, dwCookie: u32) {
    this.idxgifactory2_vtable.UnregisterOcclusionStatus(this, dwCookie);
}

IDXGIFactory2_CreateSwapChainForComposition :: (this: *IDXGIFactory2, pDevice: *IUnknown, pDesc: *DXGI_SWAP_CHAIN_DESC1, pRestrictToOutput: *IDXGIOutput, ppSwapChain: **IDXGISwapChain1) -> HRESULT {
    return this.idxgifactory2_vtable.CreateSwapChainForComposition(this, pDevice, pDesc, pRestrictToOutput, ppSwapChain);
}

vtable :: (obj: *IDXGIFactory2) -> *IDXGIFactory2_VTable {
    return obj.idxgifactory2_vtable;
}

DXGI_GRAPHICS_PREEMPTION_GRANULARITY :: enum s32 {
    DMA_BUFFER_BOUNDARY :: 0;
    PRIMITIVE_BOUNDARY :: 1;
    TRIANGLE_BOUNDARY :: 2;
    PIXEL_BOUNDARY :: 3;
    INSTRUCTION_BOUNDARY :: 4;
    DXGI_GRAPHICS_PREEMPTION_DMA_BUFFER_BOUNDARY :: DMA_BUFFER_BOUNDARY;
    DXGI_GRAPHICS_PREEMPTION_PRIMITIVE_BOUNDARY :: PRIMITIVE_BOUNDARY;
    DXGI_GRAPHICS_PREEMPTION_TRIANGLE_BOUNDARY :: TRIANGLE_BOUNDARY;
    DXGI_GRAPHICS_PREEMPTION_PIXEL_BOUNDARY :: PIXEL_BOUNDARY;
    DXGI_GRAPHICS_PREEMPTION_INSTRUCTION_BOUNDARY :: INSTRUCTION_BOUNDARY;
}

DXGI_COMPUTE_PREEMPTION_GRANULARITY :: enum s32 {
    DMA_BUFFER_BOUNDARY :: 0;
    DISPATCH_BOUNDARY :: 1;
    THREAD_GROUP_BOUNDARY :: 2;
    THREAD_BOUNDARY :: 3;
    INSTRUCTION_BOUNDARY :: 4;
    DXGI_COMPUTE_PREEMPTION_DMA_BUFFER_BOUNDARY :: DMA_BUFFER_BOUNDARY;
    DXGI_COMPUTE_PREEMPTION_DISPATCH_BOUNDARY :: DISPATCH_BOUNDARY;
    DXGI_COMPUTE_PREEMPTION_THREAD_GROUP_BOUNDARY :: THREAD_GROUP_BOUNDARY;
    DXGI_COMPUTE_PREEMPTION_THREAD_BOUNDARY :: THREAD_BOUNDARY;
    DXGI_COMPUTE_PREEMPTION_INSTRUCTION_BOUNDARY :: INSTRUCTION_BOUNDARY;
}

DXGI_ADAPTER_DESC2 :: struct {
    Description: [128] s16;
    VendorId: u32;
    DeviceId: u32;
    SubSysId: u32;
    Revision: u32;
    DedicatedVideoMemory: SIZE_T;
    DedicatedSystemMemory: SIZE_T;
    SharedSystemMemory: SIZE_T;
    AdapterLuid: LUID;
    Flags: u32;
    GraphicsPreemptionGranularity: DXGI_GRAPHICS_PREEMPTION_GRANULARITY;
    ComputePreemptionGranularity: DXGI_COMPUTE_PREEMPTION_GRANULARITY;
}

IDXGIAdapter2_UUID :: "0AA1AE0A-FA0E-4B84-8644-E05FF8E5ACB5";

IDXGIAdapter2 :: struct {
    #as using idxgiadapter1: IDXGIAdapter1;
    #place idxgiadapter1;
    idxgiadapter2_vtable: *IDXGIAdapter2_VTable;
}

IDXGIAdapter2_VTable :: struct #type_info_none {
    using idxgiadapter1: IDXGIAdapter1_VTable;
    GetDesc2: (this: *IDXGIAdapter2, pDesc: *DXGI_ADAPTER_DESC2) -> HRESULT #cpp_method;
}

IDXGIAdapter2_GetDesc2 :: (this: *IDXGIAdapter2, pDesc: *DXGI_ADAPTER_DESC2) -> HRESULT {
    return this.idxgiadapter2_vtable.GetDesc2(this, pDesc);
}

vtable :: (obj: *IDXGIAdapter2) -> *IDXGIAdapter2_VTable {
    return obj.idxgiadapter2_vtable;
}

IDXGIOutput1_UUID :: "00cddea8-939b-4b83-a340-a685226666cc";

IDXGIOutput1 :: struct {
    #as using idxgioutput: IDXGIOutput;
    #place idxgioutput;
    idxgioutput1_vtable: *IDXGIOutput1_VTable;
}

IDXGIOutput1_VTable :: struct #type_info_none {
    using idxgioutput: IDXGIOutput_VTable;
    GetDisplayModeList1: (this: *IDXGIOutput1, EnumFormat: DXGI_FORMAT, Flags: u32, pNumModes: *u32, pDesc: *DXGI_MODE_DESC1) -> HRESULT #cpp_method;
    FindClosestMatchingMode1: (this: *IDXGIOutput1, pModeToMatch: *DXGI_MODE_DESC1, pClosestMatch: *DXGI_MODE_DESC1, pConcernedDevice: *IUnknown) -> HRESULT #cpp_method;
    GetDisplaySurfaceData1: (this: *IDXGIOutput1, pDestination: *IDXGIResource) -> HRESULT #cpp_method;
    DuplicateOutput: (this: *IDXGIOutput1, pDevice: *IUnknown, ppOutputDuplication: **IDXGIOutputDuplication) -> HRESULT #cpp_method;
}

IDXGIOutput1_GetDisplayModeList1 :: (this: *IDXGIOutput1, EnumFormat: DXGI_FORMAT, Flags: u32, pNumModes: *u32, pDesc: *DXGI_MODE_DESC1) -> HRESULT {
    return this.idxgioutput1_vtable.GetDisplayModeList1(this, EnumFormat, Flags, pNumModes, pDesc);
}

IDXGIOutput1_FindClosestMatchingMode1 :: (this: *IDXGIOutput1, pModeToMatch: *DXGI_MODE_DESC1, pClosestMatch: *DXGI_MODE_DESC1, pConcernedDevice: *IUnknown) -> HRESULT {
    return this.idxgioutput1_vtable.FindClosestMatchingMode1(this, pModeToMatch, pClosestMatch, pConcernedDevice);
}

IDXGIOutput1_GetDisplaySurfaceData1 :: (this: *IDXGIOutput1, pDestination: *IDXGIResource) -> HRESULT {
    return this.idxgioutput1_vtable.GetDisplaySurfaceData1(this, pDestination);
}

IDXGIOutput1_DuplicateOutput :: (this: *IDXGIOutput1, pDevice: *IUnknown, ppOutputDuplication: **IDXGIOutputDuplication) -> HRESULT {
    return this.idxgioutput1_vtable.DuplicateOutput(this, pDevice, ppOutputDuplication);
}

vtable :: (obj: *IDXGIOutput1) -> *IDXGIOutput1_VTable {
    return obj.idxgioutput1_vtable;
}

CreateDXGIFactory2 :: (Flags: u32, riid: *IID, ppFactory: **void) -> HRESULT #foreign dxgi;

CreateDXGIFactory2 :: (Flags: u32, riid: IID, ppFactory: **void) -> HRESULT {
    return CreateDXGIFactory2(Flags, *riid, ppFactory);
}

DXGIGetDebugInterface1 :: (Flags: u32, riid: *IID, pDebug: **void) -> HRESULT #foreign dxgi;

DXGIGetDebugInterface1 :: (Flags: u32, riid: IID, pDebug: **void) -> HRESULT {
    return DXGIGetDebugInterface1(Flags, *riid, pDebug);
}

IDXGIDevice3_UUID :: "6007896c-3244-4afd-bf18-a6d3beda5023";

IDXGIDevice3 :: struct {
    #as using idxgidevice2: IDXGIDevice2;
    #place idxgidevice2;
    idxgidevice3_vtable: *IDXGIDevice3_VTable;
}

IDXGIDevice3_VTable :: struct #type_info_none {
    using idxgidevice2: IDXGIDevice2_VTable;
    Trim: (this: *IDXGIDevice3) -> void #cpp_method;
}

IDXGIDevice3_Trim :: (this: *IDXGIDevice3) {
    this.idxgidevice3_vtable.Trim(this);
}

vtable :: (obj: *IDXGIDevice3) -> *IDXGIDevice3_VTable {
    return obj.idxgidevice3_vtable;
}

DXGI_MATRIX_3X2_F :: struct {
    _11: float;
    _12: float;
    _21: float;
    _22: float;
    _31: float;
    _32: float;
}

IDXGISwapChain2_UUID :: "a8be2ac4-199f-4946-b331-79599fb98de7";

IDXGISwapChain2 :: struct {
    #as using idxgiswapchain1: IDXGISwapChain1;
    #place idxgiswapchain1;
    idxgiswapchain2_vtable: *IDXGISwapChain2_VTable;
}

IDXGISwapChain2_VTable :: struct #type_info_none {
    using idxgiswapchain1: IDXGISwapChain1_VTable;
    SetSourceSize: (this: *IDXGISwapChain2, Width: u32, Height: u32) -> HRESULT #cpp_method;
    GetSourceSize: (this: *IDXGISwapChain2, pWidth: *u32, pHeight: *u32) -> HRESULT #cpp_method;
    SetMaximumFrameLatency: (this: *IDXGISwapChain2, MaxLatency: u32) -> HRESULT #cpp_method;
    GetMaximumFrameLatency: (this: *IDXGISwapChain2, pMaxLatency: *u32) -> HRESULT #cpp_method;
    GetFrameLatencyWaitableObject: (this: *IDXGISwapChain2) -> HANDLE #cpp_method;
    SetMatrixTransform: (this: *IDXGISwapChain2, pMatrix: *DXGI_MATRIX_3X2_F) -> HRESULT #cpp_method;
    GetMatrixTransform: (this: *IDXGISwapChain2, pMatrix: *DXGI_MATRIX_3X2_F) -> HRESULT #cpp_method;
}

IDXGISwapChain2_SetSourceSize :: (this: *IDXGISwapChain2, Width: u32, Height: u32) -> HRESULT {
    return this.idxgiswapchain2_vtable.SetSourceSize(this, Width, Height);
}

IDXGISwapChain2_GetSourceSize :: (this: *IDXGISwapChain2, pWidth: *u32, pHeight: *u32) -> HRESULT {
    return this.idxgiswapchain2_vtable.GetSourceSize(this, pWidth, pHeight);
}

IDXGISwapChain2_SetMaximumFrameLatency :: (this: *IDXGISwapChain2, MaxLatency: u32) -> HRESULT {
    return this.idxgiswapchain2_vtable.SetMaximumFrameLatency(this, MaxLatency);
}

IDXGISwapChain2_GetMaximumFrameLatency :: (this: *IDXGISwapChain2, pMaxLatency: *u32) -> HRESULT {
    return this.idxgiswapchain2_vtable.GetMaximumFrameLatency(this, pMaxLatency);
}

IDXGISwapChain2_GetFrameLatencyWaitableObject :: (this: *IDXGISwapChain2) -> HANDLE {
    return this.idxgiswapchain2_vtable.GetFrameLatencyWaitableObject(this);
}

IDXGISwapChain2_SetMatrixTransform :: (this: *IDXGISwapChain2, pMatrix: *DXGI_MATRIX_3X2_F) -> HRESULT {
    return this.idxgiswapchain2_vtable.SetMatrixTransform(this, pMatrix);
}

IDXGISwapChain2_GetMatrixTransform :: (this: *IDXGISwapChain2, pMatrix: *DXGI_MATRIX_3X2_F) -> HRESULT {
    return this.idxgiswapchain2_vtable.GetMatrixTransform(this, pMatrix);
}

vtable :: (obj: *IDXGISwapChain2) -> *IDXGISwapChain2_VTable {
    return obj.idxgiswapchain2_vtable;
}

IDXGIOutput2_UUID :: "595e39d1-2724-4663-99b1-da969de28364";

IDXGIOutput2 :: struct {
    #as using idxgioutput1: IDXGIOutput1;
    #place idxgioutput1;
    idxgioutput2_vtable: *IDXGIOutput2_VTable;
}

IDXGIOutput2_VTable :: struct #type_info_none {
    using idxgioutput1: IDXGIOutput1_VTable;
    SupportsOverlays: (this: *IDXGIOutput2) -> BOOL #cpp_method;
}

IDXGIOutput2_SupportsOverlays :: (this: *IDXGIOutput2) -> BOOL {
    return this.idxgioutput2_vtable.SupportsOverlays(this);
}

vtable :: (obj: *IDXGIOutput2) -> *IDXGIOutput2_VTable {
    return obj.idxgioutput2_vtable;
}

IDXGIFactory3_UUID :: "25483823-cd46-4c7d-86ca-47aa95b837bd";

IDXGIFactory3 :: struct {
    #as using idxgifactory2: IDXGIFactory2;
    #place idxgifactory2;
    idxgifactory3_vtable: *IDXGIFactory3_VTable;
}

IDXGIFactory3_VTable :: struct #type_info_none {
    using idxgifactory2: IDXGIFactory2_VTable;
    GetCreationFlags: (this: *IDXGIFactory3) -> u32 #cpp_method;
}

IDXGIFactory3_GetCreationFlags :: (this: *IDXGIFactory3) -> u32 {
    return this.idxgifactory3_vtable.GetCreationFlags(this);
}

vtable :: (obj: *IDXGIFactory3) -> *IDXGIFactory3_VTable {
    return obj.idxgifactory3_vtable;
}

DXGI_DECODE_SWAP_CHAIN_DESC :: struct {
    Flags: u32;
}

DXGI_MULTIPLANE_OVERLAY_YCbCr_FLAGS :: enum_flags u32 {
    NOMINAL_RANGE :: 0x1;
    BT709 :: 0x2;
    xvYCC :: 0x4;
    DXGI_MULTIPLANE_OVERLAY_YCbCr_FLAG_NOMINAL_RANGE :: NOMINAL_RANGE;
    DXGI_MULTIPLANE_OVERLAY_YCbCr_FLAG_BT709 :: BT709;
    DXGI_MULTIPLANE_OVERLAY_YCbCr_FLAG_xvYCC :: xvYCC;
}

IDXGIDecodeSwapChain_UUID :: "2633066b-4514-4c7a-8fd8-12ea98059d18";

IDXGIDecodeSwapChain :: struct {
    #as using iunknown: IUnknown;
    #place iunknown;
    idxgidecodeswapchain_vtable: *IDXGIDecodeSwapChain_VTable;
}

IDXGIDecodeSwapChain_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    PresentBuffer: (this: *IDXGIDecodeSwapChain, BufferToPresent: u32, SyncInterval: u32, Flags: u32) -> HRESULT #cpp_method;
    SetSourceRect: (this: *IDXGIDecodeSwapChain, pRect: *RECT) -> HRESULT #cpp_method;
    SetTargetRect: (this: *IDXGIDecodeSwapChain, pRect: *RECT) -> HRESULT #cpp_method;
    SetDestSize: (this: *IDXGIDecodeSwapChain, Width: u32, Height: u32) -> HRESULT #cpp_method;
    GetSourceRect: (this: *IDXGIDecodeSwapChain, pRect: *RECT) -> HRESULT #cpp_method;
    GetTargetRect: (this: *IDXGIDecodeSwapChain, pRect: *RECT) -> HRESULT #cpp_method;
    GetDestSize: (this: *IDXGIDecodeSwapChain, pWidth: *u32, pHeight: *u32) -> HRESULT #cpp_method;
    SetColorSpace: (this: *IDXGIDecodeSwapChain, ColorSpace: DXGI_MULTIPLANE_OVERLAY_YCbCr_FLAGS) -> HRESULT #cpp_method;
    GetColorSpace: (this: *IDXGIDecodeSwapChain) -> DXGI_MULTIPLANE_OVERLAY_YCbCr_FLAGS #cpp_method;
}

IDXGIDecodeSwapChain_PresentBuffer :: (this: *IDXGIDecodeSwapChain, BufferToPresent: u32, SyncInterval: u32, Flags: u32) -> HRESULT {
    return this.idxgidecodeswapchain_vtable.PresentBuffer(this, BufferToPresent, SyncInterval, Flags);
}

IDXGIDecodeSwapChain_SetSourceRect :: (this: *IDXGIDecodeSwapChain, pRect: *RECT) -> HRESULT {
    return this.idxgidecodeswapchain_vtable.SetSourceRect(this, pRect);
}

IDXGIDecodeSwapChain_SetTargetRect :: (this: *IDXGIDecodeSwapChain, pRect: *RECT) -> HRESULT {
    return this.idxgidecodeswapchain_vtable.SetTargetRect(this, pRect);
}

IDXGIDecodeSwapChain_SetDestSize :: (this: *IDXGIDecodeSwapChain, Width: u32, Height: u32) -> HRESULT {
    return this.idxgidecodeswapchain_vtable.SetDestSize(this, Width, Height);
}

IDXGIDecodeSwapChain_GetSourceRect :: (this: *IDXGIDecodeSwapChain, pRect: *RECT) -> HRESULT {
    return this.idxgidecodeswapchain_vtable.GetSourceRect(this, pRect);
}

IDXGIDecodeSwapChain_GetTargetRect :: (this: *IDXGIDecodeSwapChain, pRect: *RECT) -> HRESULT {
    return this.idxgidecodeswapchain_vtable.GetTargetRect(this, pRect);
}

IDXGIDecodeSwapChain_GetDestSize :: (this: *IDXGIDecodeSwapChain, pWidth: *u32, pHeight: *u32) -> HRESULT {
    return this.idxgidecodeswapchain_vtable.GetDestSize(this, pWidth, pHeight);
}

IDXGIDecodeSwapChain_SetColorSpace :: (this: *IDXGIDecodeSwapChain, ColorSpace: DXGI_MULTIPLANE_OVERLAY_YCbCr_FLAGS) -> HRESULT {
    return this.idxgidecodeswapchain_vtable.SetColorSpace(this, ColorSpace);
}

IDXGIDecodeSwapChain_GetColorSpace :: (this: *IDXGIDecodeSwapChain) -> DXGI_MULTIPLANE_OVERLAY_YCbCr_FLAGS {
    return this.idxgidecodeswapchain_vtable.GetColorSpace(this);
}

vtable :: (obj: *IDXGIDecodeSwapChain) -> *IDXGIDecodeSwapChain_VTable {
    return obj.idxgidecodeswapchain_vtable;
}

IDXGIFactoryMedia_UUID :: "41e7d1f2-a591-4f7b-a2e5-fa9c843e1c12";

IDXGIFactoryMedia :: struct {
    #as using iunknown: IUnknown;
    #place iunknown;
    idxgifactorymedia_vtable: *IDXGIFactoryMedia_VTable;
}

IDXGIFactoryMedia_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    CreateSwapChainForCompositionSurfaceHandle: (this: *IDXGIFactoryMedia, pDevice: *IUnknown, hSurface: HANDLE, pDesc: *DXGI_SWAP_CHAIN_DESC1, pRestrictToOutput: *IDXGIOutput, ppSwapChain: **IDXGISwapChain1) -> HRESULT #cpp_method;
    CreateDecodeSwapChainForCompositionSurfaceHandle: (this: *IDXGIFactoryMedia, pDevice: *IUnknown, hSurface: HANDLE, pDesc: *DXGI_DECODE_SWAP_CHAIN_DESC, pYuvDecodeBuffers: *IDXGIResource, pRestrictToOutput: *IDXGIOutput, ppSwapChain: **IDXGIDecodeSwapChain) -> HRESULT #cpp_method;
}

IDXGIFactoryMedia_CreateSwapChainForCompositionSurfaceHandle :: (this: *IDXGIFactoryMedia, pDevice: *IUnknown, hSurface: HANDLE, pDesc: *DXGI_SWAP_CHAIN_DESC1, pRestrictToOutput: *IDXGIOutput, ppSwapChain: **IDXGISwapChain1) -> HRESULT {
    return this.idxgifactorymedia_vtable.CreateSwapChainForCompositionSurfaceHandle(this, pDevice, hSurface, pDesc, pRestrictToOutput, ppSwapChain);
}

IDXGIFactoryMedia_CreateDecodeSwapChainForCompositionSurfaceHandle :: (this: *IDXGIFactoryMedia, pDevice: *IUnknown, hSurface: HANDLE, pDesc: *DXGI_DECODE_SWAP_CHAIN_DESC, pYuvDecodeBuffers: *IDXGIResource, pRestrictToOutput: *IDXGIOutput, ppSwapChain: **IDXGIDecodeSwapChain) -> HRESULT {
    return this.idxgifactorymedia_vtable.CreateDecodeSwapChainForCompositionSurfaceHandle(this, pDevice, hSurface, pDesc, pYuvDecodeBuffers, pRestrictToOutput, ppSwapChain);
}

vtable :: (obj: *IDXGIFactoryMedia) -> *IDXGIFactoryMedia_VTable {
    return obj.idxgifactorymedia_vtable;
}

DXGI_FRAME_PRESENTATION_MODE :: enum s32 {
    COMPOSED :: 0;
    OVERLAY :: 1;
    NONE :: 2;
    COMPOSITION_FAILURE :: 3;
    DXGI_FRAME_PRESENTATION_MODE_COMPOSED :: COMPOSED;
    DXGI_FRAME_PRESENTATION_MODE_OVERLAY :: OVERLAY;
    DXGI_FRAME_PRESENTATION_MODE_NONE :: NONE;
    DXGI_FRAME_PRESENTATION_MODE_COMPOSITION_FAILURE :: COMPOSITION_FAILURE;
}

DXGI_FRAME_STATISTICS_MEDIA :: struct {
    PresentCount: u32;
    PresentRefreshCount: u32;
    SyncRefreshCount: u32;
    SyncQPCTime: LARGE_INTEGER;
    SyncGPUTime: LARGE_INTEGER;
    CompositionMode: DXGI_FRAME_PRESENTATION_MODE;
    ApprovedPresentDuration: u32;
}

IDXGISwapChainMedia_UUID :: "dd95b90b-f05f-4f6a-bd65-25bfb264bd84";

IDXGISwapChainMedia :: struct {
    #as using iunknown: IUnknown;
    #place iunknown;
    idxgiswapchainmedia_vtable: *IDXGISwapChainMedia_VTable;
}

IDXGISwapChainMedia_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    GetFrameStatisticsMedia: (this: *IDXGISwapChainMedia, pStats: *DXGI_FRAME_STATISTICS_MEDIA) -> HRESULT #cpp_method;
    SetPresentDuration: (this: *IDXGISwapChainMedia, Duration: u32) -> HRESULT #cpp_method;
    CheckPresentDurationSupport: (this: *IDXGISwapChainMedia, DesiredPresentDuration: u32, pClosestSmallerPresentDuration: *u32, pClosestLargerPresentDuration: *u32) -> HRESULT #cpp_method;
}

IDXGISwapChainMedia_GetFrameStatisticsMedia :: (this: *IDXGISwapChainMedia, pStats: *DXGI_FRAME_STATISTICS_MEDIA) -> HRESULT {
    return this.idxgiswapchainmedia_vtable.GetFrameStatisticsMedia(this, pStats);
}

IDXGISwapChainMedia_SetPresentDuration :: (this: *IDXGISwapChainMedia, Duration: u32) -> HRESULT {
    return this.idxgiswapchainmedia_vtable.SetPresentDuration(this, Duration);
}

IDXGISwapChainMedia_CheckPresentDurationSupport :: (this: *IDXGISwapChainMedia, DesiredPresentDuration: u32, pClosestSmallerPresentDuration: *u32, pClosestLargerPresentDuration: *u32) -> HRESULT {
    return this.idxgiswapchainmedia_vtable.CheckPresentDurationSupport(this, DesiredPresentDuration, pClosestSmallerPresentDuration, pClosestLargerPresentDuration);
}

vtable :: (obj: *IDXGISwapChainMedia) -> *IDXGISwapChainMedia_VTable {
    return obj.idxgiswapchainmedia_vtable;
}

DXGI_OVERLAY_SUPPORT_FLAG :: enum_flags u32 {
    DIRECT :: 0x1;
    SCALING :: 0x2;
    DXGI_OVERLAY_SUPPORT_FLAG_DIRECT :: DIRECT;
    DXGI_OVERLAY_SUPPORT_FLAG_SCALING :: SCALING;
}

IDXGIOutput3_UUID :: "8a6bb301-7e7e-41F4-a8e0-5b32f7f99b18";

IDXGIOutput3 :: struct {
    #as using idxgioutput2: IDXGIOutput2;
    #place idxgioutput2;
    idxgioutput3_vtable: *IDXGIOutput3_VTable;
}

IDXGIOutput3_VTable :: struct #type_info_none {
    using idxgioutput2: IDXGIOutput2_VTable;
    CheckOverlaySupport: (this: *IDXGIOutput3, EnumFormat: DXGI_FORMAT, pConcernedDevice: *IUnknown, pFlags: *u32) -> HRESULT #cpp_method;
}

IDXGIOutput3_CheckOverlaySupport :: (this: *IDXGIOutput3, EnumFormat: DXGI_FORMAT, pConcernedDevice: *IUnknown, pFlags: *u32) -> HRESULT {
    return this.idxgioutput3_vtable.CheckOverlaySupport(this, EnumFormat, pConcernedDevice, pFlags);
}

vtable :: (obj: *IDXGIOutput3) -> *IDXGIOutput3_VTable {
    return obj.idxgioutput3_vtable;
}

DXGI_SWAP_CHAIN_COLOR_SPACE_SUPPORT_FLAG :: enum_flags u32 {
    PRESENT :: 0x1;
    OVERLAY_PRESENT :: 0x2;
    DXGI_SWAP_CHAIN_COLOR_SPACE_SUPPORT_FLAG_PRESENT :: PRESENT;
    DXGI_SWAP_CHAIN_COLOR_SPACE_SUPPORT_FLAG_OVERLAY_PRESENT :: OVERLAY_PRESENT;
}

IDXGISwapChain3_UUID :: "94d99bdb-f1f8-4ab0-b236-7da0170edab1";

IDXGISwapChain3 :: struct {
    #as using idxgiswapchain2: IDXGISwapChain2;
    #place idxgiswapchain2;
    idxgiswapchain3_vtable: *IDXGISwapChain3_VTable;
}

IDXGISwapChain3_VTable :: struct #type_info_none {
    using idxgiswapchain2: IDXGISwapChain2_VTable;
    GetCurrentBackBufferIndex: (this: *IDXGISwapChain3) -> u32 #cpp_method;
    CheckColorSpaceSupport: (this: *IDXGISwapChain3, ColorSpace: DXGI_COLOR_SPACE_TYPE, pColorSpaceSupport: *u32) -> HRESULT #cpp_method;
    SetColorSpace1: (this: *IDXGISwapChain3, ColorSpace: DXGI_COLOR_SPACE_TYPE) -> HRESULT #cpp_method;
    ResizeBuffers1: (this: *IDXGISwapChain3, BufferCount: u32, Width: u32, Height: u32, Format: DXGI_FORMAT, SwapChainFlags: u32, pCreationNodeMask: *u32, ppPresentQueue: **IUnknown) -> HRESULT #cpp_method;
}

IDXGISwapChain3_GetCurrentBackBufferIndex :: (this: *IDXGISwapChain3) -> u32 {
    return this.idxgiswapchain3_vtable.GetCurrentBackBufferIndex(this);
}

IDXGISwapChain3_CheckColorSpaceSupport :: (this: *IDXGISwapChain3, ColorSpace: DXGI_COLOR_SPACE_TYPE, pColorSpaceSupport: *u32) -> HRESULT {
    return this.idxgiswapchain3_vtable.CheckColorSpaceSupport(this, ColorSpace, pColorSpaceSupport);
}

IDXGISwapChain3_SetColorSpace1 :: (this: *IDXGISwapChain3, ColorSpace: DXGI_COLOR_SPACE_TYPE) -> HRESULT {
    return this.idxgiswapchain3_vtable.SetColorSpace1(this, ColorSpace);
}

IDXGISwapChain3_ResizeBuffers1 :: (this: *IDXGISwapChain3, BufferCount: u32, Width: u32, Height: u32, Format: DXGI_FORMAT, SwapChainFlags: u32, pCreationNodeMask: *u32, ppPresentQueue: **IUnknown) -> HRESULT {
    return this.idxgiswapchain3_vtable.ResizeBuffers1(this, BufferCount, Width, Height, Format, SwapChainFlags, pCreationNodeMask, ppPresentQueue);
}

vtable :: (obj: *IDXGISwapChain3) -> *IDXGISwapChain3_VTable {
    return obj.idxgiswapchain3_vtable;
}

DXGI_OVERLAY_COLOR_SPACE_SUPPORT_FLAG :: enum_flags u32 {
    PRESENT :: 0x1;
    DXGI_OVERLAY_COLOR_SPACE_SUPPORT_FLAG_PRESENT :: PRESENT;
}

IDXGIOutput4_UUID :: "dc7dca35-2196-414d-9F53-617884032a60";

IDXGIOutput4 :: struct {
    #as using idxgioutput3: IDXGIOutput3;
    #place idxgioutput3;
    idxgioutput4_vtable: *IDXGIOutput4_VTable;
}

IDXGIOutput4_VTable :: struct #type_info_none {
    using idxgioutput3: IDXGIOutput3_VTable;
    CheckOverlayColorSpaceSupport: (this: *IDXGIOutput4, Format: DXGI_FORMAT, ColorSpace: DXGI_COLOR_SPACE_TYPE, pConcernedDevice: *IUnknown, pFlags: *u32) -> HRESULT #cpp_method;
}

IDXGIOutput4_CheckOverlayColorSpaceSupport :: (this: *IDXGIOutput4, Format: DXGI_FORMAT, ColorSpace: DXGI_COLOR_SPACE_TYPE, pConcernedDevice: *IUnknown, pFlags: *u32) -> HRESULT {
    return this.idxgioutput4_vtable.CheckOverlayColorSpaceSupport(this, Format, ColorSpace, pConcernedDevice, pFlags);
}

vtable :: (obj: *IDXGIOutput4) -> *IDXGIOutput4_VTable {
    return obj.idxgioutput4_vtable;
}

IDXGIFactory4_UUID :: "1bc6ea02-ef36-464f-bf0c-21ca39e5168a";

IDXGIFactory4 :: struct {
    #as using idxgifactory3: IDXGIFactory3;
    #place idxgifactory3;
    idxgifactory4_vtable: *IDXGIFactory4_VTable;
}

IDXGIFactory4_VTable :: struct #type_info_none {
    using idxgifactory3: IDXGIFactory3_VTable;
    EnumAdapterByLuid: (this: *IDXGIFactory4, AdapterLuid: LUID, riid: *IID, ppvAdapter: **void) -> HRESULT #cpp_method;
    EnumWarpAdapter: (this: *IDXGIFactory4, riid: *IID, ppvAdapter: **void) -> HRESULT #cpp_method;
}

IDXGIFactory4_EnumAdapterByLuid :: (this: *IDXGIFactory4, AdapterLuid: LUID, riid: *IID, ppvAdapter: **void) -> HRESULT {
    return this.idxgifactory4_vtable.EnumAdapterByLuid(this, AdapterLuid, riid, ppvAdapter);
}

IDXGIFactory4_EnumWarpAdapter :: (this: *IDXGIFactory4, riid: *IID, ppvAdapter: **void) -> HRESULT {
    return this.idxgifactory4_vtable.EnumWarpAdapter(this, riid, ppvAdapter);
}

vtable :: (obj: *IDXGIFactory4) -> *IDXGIFactory4_VTable {
    return obj.idxgifactory4_vtable;
}

DXGI_MEMORY_SEGMENT_GROUP :: enum s32 {
    LOCAL :: 0;
    NON_LOCAL :: 1;
    DXGI_MEMORY_SEGMENT_GROUP_LOCAL :: LOCAL;
    DXGI_MEMORY_SEGMENT_GROUP_NON_LOCAL :: NON_LOCAL;
}

DXGI_QUERY_VIDEO_MEMORY_INFO :: struct {
    Budget: u64;
    CurrentUsage: u64;
    AvailableForReservation: u64;
    CurrentReservation: u64;
}

IDXGIAdapter3_UUID :: "645967A4-1392-4310-A798-8053CE3E93FD";

IDXGIAdapter3 :: struct {
    #as using idxgiadapter2: IDXGIAdapter2;
    #place idxgiadapter2;
    idxgiadapter3_vtable: *IDXGIAdapter3_VTable;
}

IDXGIAdapter3_VTable :: struct #type_info_none {
    using idxgiadapter2: IDXGIAdapter2_VTable;
    RegisterHardwareContentProtectionTeardownStatusEvent: (this: *IDXGIAdapter3, hEvent: HANDLE, pdwCookie: *u32) -> HRESULT #cpp_method;
    UnregisterHardwareContentProtectionTeardownStatus: (this: *IDXGIAdapter3, dwCookie: u32) -> void #cpp_method;
    QueryVideoMemoryInfo: (this: *IDXGIAdapter3, NodeIndex: u32, MemorySegmentGroup: DXGI_MEMORY_SEGMENT_GROUP, pVideoMemoryInfo: *DXGI_QUERY_VIDEO_MEMORY_INFO) -> HRESULT #cpp_method;
    SetVideoMemoryReservation: (this: *IDXGIAdapter3, NodeIndex: u32, MemorySegmentGroup: DXGI_MEMORY_SEGMENT_GROUP, Reservation: u64) -> HRESULT #cpp_method;
    RegisterVideoMemoryBudgetChangeNotificationEvent: (this: *IDXGIAdapter3, hEvent: HANDLE, pdwCookie: *u32) -> HRESULT #cpp_method;
    UnregisterVideoMemoryBudgetChangeNotification: (this: *IDXGIAdapter3, dwCookie: u32) -> void #cpp_method;
}

IDXGIAdapter3_RegisterHardwareContentProtectionTeardownStatusEvent :: (this: *IDXGIAdapter3, hEvent: HANDLE, pdwCookie: *u32) -> HRESULT {
    return this.idxgiadapter3_vtable.RegisterHardwareContentProtectionTeardownStatusEvent(this, hEvent, pdwCookie);
}

IDXGIAdapter3_UnregisterHardwareContentProtectionTeardownStatus :: (this: *IDXGIAdapter3, dwCookie: u32) {
    this.idxgiadapter3_vtable.UnregisterHardwareContentProtectionTeardownStatus(this, dwCookie);
}

IDXGIAdapter3_QueryVideoMemoryInfo :: (this: *IDXGIAdapter3, NodeIndex: u32, MemorySegmentGroup: DXGI_MEMORY_SEGMENT_GROUP, pVideoMemoryInfo: *DXGI_QUERY_VIDEO_MEMORY_INFO) -> HRESULT {
    return this.idxgiadapter3_vtable.QueryVideoMemoryInfo(this, NodeIndex, MemorySegmentGroup, pVideoMemoryInfo);
}

IDXGIAdapter3_SetVideoMemoryReservation :: (this: *IDXGIAdapter3, NodeIndex: u32, MemorySegmentGroup: DXGI_MEMORY_SEGMENT_GROUP, Reservation: u64) -> HRESULT {
    return this.idxgiadapter3_vtable.SetVideoMemoryReservation(this, NodeIndex, MemorySegmentGroup, Reservation);
}

IDXGIAdapter3_RegisterVideoMemoryBudgetChangeNotificationEvent :: (this: *IDXGIAdapter3, hEvent: HANDLE, pdwCookie: *u32) -> HRESULT {
    return this.idxgiadapter3_vtable.RegisterVideoMemoryBudgetChangeNotificationEvent(this, hEvent, pdwCookie);
}

IDXGIAdapter3_UnregisterVideoMemoryBudgetChangeNotification :: (this: *IDXGIAdapter3, dwCookie: u32) {
    this.idxgiadapter3_vtable.UnregisterVideoMemoryBudgetChangeNotification(this, dwCookie);
}

vtable :: (obj: *IDXGIAdapter3) -> *IDXGIAdapter3_VTable {
    return obj.idxgiadapter3_vtable;
}

DXGI_OUTDUPL_FLAG :: enum_flags u32 {
    DXGI_OUTDUPL_COMPOSITED_UI_CAPTURE_ONLY :: 0x1;
}

IDXGIOutput5_UUID :: "80A07424-AB52-42EB-833C-0C42FD282D98";

IDXGIOutput5 :: struct {
    #as using idxgioutput4: IDXGIOutput4;
    #place idxgioutput4;
    idxgioutput5_vtable: *IDXGIOutput5_VTable;
}

IDXGIOutput5_VTable :: struct #type_info_none {
    using idxgioutput4: IDXGIOutput4_VTable;
    DuplicateOutput1: (this: *IDXGIOutput5, pDevice: *IUnknown, Flags: u32, SupportedFormatsCount: u32, pSupportedFormats: *DXGI_FORMAT, ppOutputDuplication: **IDXGIOutputDuplication) -> HRESULT #cpp_method;
}

IDXGIOutput5_DuplicateOutput1 :: (this: *IDXGIOutput5, pDevice: *IUnknown, Flags: u32, SupportedFormatsCount: u32, pSupportedFormats: *DXGI_FORMAT, ppOutputDuplication: **IDXGIOutputDuplication) -> HRESULT {
    return this.idxgioutput5_vtable.DuplicateOutput1(this, pDevice, Flags, SupportedFormatsCount, pSupportedFormats, ppOutputDuplication);
}

vtable :: (obj: *IDXGIOutput5) -> *IDXGIOutput5_VTable {
    return obj.idxgioutput5_vtable;
}

DXGI_HDR_METADATA_TYPE :: enum s32 {
    NONE :: 0;
    HDR10 :: 1;
    HDR10PLUS :: 2;
    DXGI_HDR_METADATA_TYPE_NONE :: NONE;
    DXGI_HDR_METADATA_TYPE_HDR10 :: HDR10;
    DXGI_HDR_METADATA_TYPE_HDR10PLUS :: HDR10PLUS;
}

DXGI_HDR_METADATA_HDR10 :: struct {
    RedPrimary: [2] u16;
    GreenPrimary: [2] u16;
    BluePrimary: [2] u16;
    WhitePoint: [2] u16;
    MaxMasteringLuminance: u32;
    MinMasteringLuminance: u32;
    MaxContentLightLevel: u16;
    MaxFrameAverageLightLevel: u16;
}

DXGI_HDR_METADATA_HDR10PLUS :: struct {
    Data: [72] u8;
}

IDXGISwapChain4_UUID :: "3D585D5A-BD4A-489E-B1F4-3DBCB6452FFB";

IDXGISwapChain4 :: struct {
    #as using idxgiswapchain3: IDXGISwapChain3;
    #place idxgiswapchain3;
    idxgiswapchain4_vtable: *IDXGISwapChain4_VTable;
}

IDXGISwapChain4_VTable :: struct #type_info_none {
    using idxgiswapchain3: IDXGISwapChain3_VTable;
    SetHDRMetaData: (this: *IDXGISwapChain4, Type: DXGI_HDR_METADATA_TYPE, Size: u32, pMetaData: *void) -> HRESULT #cpp_method;
}

IDXGISwapChain4_SetHDRMetaData :: (this: *IDXGISwapChain4, Type: DXGI_HDR_METADATA_TYPE, Size: u32, pMetaData: *void) -> HRESULT {
    return this.idxgiswapchain4_vtable.SetHDRMetaData(this, Type, Size, pMetaData);
}

vtable :: (obj: *IDXGISwapChain4) -> *IDXGISwapChain4_VTable {
    return obj.idxgiswapchain4_vtable;
}

DXGI_OFFER_RESOURCE_FLAGS :: enum_flags u32 {
    DXGI_OFFER_RESOURCE_FLAG_ALLOW_DECOMMIT :: 0x1;
}

DXGI_RECLAIM_RESOURCE_RESULTS :: enum s32 {
    OK :: 0;
    DISCARDED :: 1;
    NOT_COMMITTED :: 2;
    DXGI_RECLAIM_RESOURCE_RESULT_OK :: OK;
    DXGI_RECLAIM_RESOURCE_RESULT_DISCARDED :: DISCARDED;
    DXGI_RECLAIM_RESOURCE_RESULT_NOT_COMMITTED :: NOT_COMMITTED;
}

IDXGIDevice4_UUID :: "95B4F95F-D8DA-4CA4-9EE6-3B76D5968A10";

IDXGIDevice4 :: struct {
    #as using idxgidevice3: IDXGIDevice3;
    #place idxgidevice3;
    idxgidevice4_vtable: *IDXGIDevice4_VTable;
}

IDXGIDevice4_VTable :: struct #type_info_none {
    using idxgidevice3: IDXGIDevice3_VTable;
    OfferResources1: (this: *IDXGIDevice4, NumResources: u32, ppResources: **IDXGIResource, Priority: DXGI_OFFER_RESOURCE_PRIORITY, Flags: u32) -> HRESULT #cpp_method;
    ReclaimResources1: (this: *IDXGIDevice4, NumResources: u32, ppResources: **IDXGIResource, pResults: *DXGI_RECLAIM_RESOURCE_RESULTS) -> HRESULT #cpp_method;
}

IDXGIDevice4_OfferResources1 :: (this: *IDXGIDevice4, NumResources: u32, ppResources: **IDXGIResource, Priority: DXGI_OFFER_RESOURCE_PRIORITY, Flags: u32) -> HRESULT {
    return this.idxgidevice4_vtable.OfferResources1(this, NumResources, ppResources, Priority, Flags);
}

IDXGIDevice4_ReclaimResources1 :: (this: *IDXGIDevice4, NumResources: u32, ppResources: **IDXGIResource, pResults: *DXGI_RECLAIM_RESOURCE_RESULTS) -> HRESULT {
    return this.idxgidevice4_vtable.ReclaimResources1(this, NumResources, ppResources, pResults);
}

vtable :: (obj: *IDXGIDevice4) -> *IDXGIDevice4_VTable {
    return obj.idxgidevice4_vtable;
}

DXGI_FEATURE :: enum s32 {
    PRESENT_ALLOW_TEARING :: 0;
    DXGI_FEATURE_PRESENT_ALLOW_TEARING :: PRESENT_ALLOW_TEARING;
}

IDXGIFactory5_UUID :: "7632e1f5-ee65-4dca-87fd-84cd75f8838d";

IDXGIFactory5 :: struct {
    #as using idxgifactory4: IDXGIFactory4;
    #place idxgifactory4;
    idxgifactory5_vtable: *IDXGIFactory5_VTable;
}

IDXGIFactory5_VTable :: struct #type_info_none {
    using idxgifactory4: IDXGIFactory4_VTable;
    CheckFeatureSupport: (this: *IDXGIFactory5, Feature: DXGI_FEATURE, pFeatureSupportData: *void, FeatureSupportDataSize: u32) -> HRESULT #cpp_method;
}

IDXGIFactory5_CheckFeatureSupport :: (this: *IDXGIFactory5, Feature: DXGI_FEATURE, pFeatureSupportData: *void, FeatureSupportDataSize: u32) -> HRESULT {
    return this.idxgifactory5_vtable.CheckFeatureSupport(this, Feature, pFeatureSupportData, FeatureSupportDataSize);
}

vtable :: (obj: *IDXGIFactory5) -> *IDXGIFactory5_VTable {
    return obj.idxgifactory5_vtable;
}

#scope_file
dxgi :: #system_library "dxgi";
