// CPU metadata layouts retain the x86 feature-leaf ABI.
x86_Vendor :: enum u8 { UNKNOWN :: 0; INTEL :: 1; AMD :: 2; }
x86_Feature_Leaf :: enum u16 {
    _01H_EDX :: 0;
    _01H_ECX :: 1;
    _19H_EBX :: 2;
    _01H_EXT_EDX :: 3;
    _01H_EXT_ECX :: 4;
    _08H_EXT_EBX :: 5;
    _07H_00H_EBX :: 6;
    _07H_00H_ECX :: 7;
    _07H_00H_EDX :: 8;
    _07H_01H_EAX :: 9;
    _0DH_01H_EAX :: 10;
    NUMBER :: 11;
}
x86_Feature_Flag :: enum u16 {
    FPU :: 0;
    VME :: 1;
    DE :: 2;
    PSE :: 3;
    TSC :: 4;
    MSR :: 5;
    PAE :: 6;
    MCE :: 7;
    CX8 :: 8;
    APIC :: 9;
    SEP :: 11;
    MTRR :: 12;
    PGE :: 13;
    MCA :: 14;
    CMOV :: 15;
    PAT :: 16;
    PSE_36 :: 17;
    PSN :: 18;
    CLFLUSH :: 19;
    DS :: 21;
    ACPI :: 22;
    MMX :: 23;
    FXSR :: 24;
    SSE :: 25;
    SSE2 :: 26;
    SS :: 27;
    HTT :: 28;
    TM :: 29;
    IA64 :: 30;
    PBE :: 31;
    SSE3 :: 32;
    PCLMULQDQ :: 33;
    DTEST64 :: 34;
    MONITOR :: 35;
    DS_CPL :: 36;
    VMX :: 37;
    SMX :: 38;
    EIST :: 39;
    TM2 :: 40;
    SSSE3 :: 41;
    CNXT_ID :: 42;
    SDBG :: 43;
    FMA :: 44;
    CX16 :: 45;
    XTPR :: 46;
    PDCM :: 47;
    PCID :: 49;
    DCA :: 50;
    SSE4_1 :: 51;
    SSE4_2 :: 52;
    X2APIC :: 53;
    MOVBE :: 54;
    POPCNT :: 55;
    TSC_DEADLINE :: 56;
    AES :: 57;
    XSAVE :: 58;
    OSXSAVE :: 59;
    AVX :: 60;
    F16C :: 61;
    RDRAND :: 62;
    HYPERVISOR :: 63;
    AESKLE :: 64;
    AESKLE_WIDE :: 66;
    KEY_LOCKER_MSR :: 68;
    SYSCALL_SYSRET :: 107;
    MP :: 115;
    NX :: 116;
    MMX_EXT :: 118;
    FXSR_OPT :: 121;
    PDPE1GB :: 122;
    RDTSCP :: 123;
    _64BIT_MODE :: 125;
    _3DNOW_EXT :: 126;
    _3DNOW :: 127;
    LAHF_SAHF :: 128;
    CMP_LEGACY :: 129;
    SVM :: 130;
    EXTAPIC :: 131;
    CR8_LEGACY :: 132;
    ABM :: 133;
    SSE4A :: 134;
    MISALIGNED_SSE :: 135;
    _3DNOW_PREFETCH :: 136;
    OSVW :: 137;
    IBS :: 138;
    XOP :: 139;
    SKINIT :: 140;
    WDT :: 141;
    LWP :: 143;
    FMA4 :: 144;
    TCE :: 145;
    NODE_ID :: 147;
    TBM :: 149;
    TOPOLOGY_EXTENSIONS :: 150;
    PERFCTR_CORE :: 151;
    PERFCTR_NB :: 152;
    DBX :: 154;
    PERFTSC :: 155;
    PCX_L2I :: 156;
    CLZERO :: 160;
    INVLPGB :: 163;
    RDPRU :: 164;
    MCOMMIT :: 168;
    WBNOINVD :: 169;
    FSGSBASE :: 192;
    TSC_ADJUST :: 193;
    SGX :: 194;
    BMI1 :: 195;
    HLE :: 196;
    AVX2 :: 197;
    FDP_EXCPTN_ONLY :: 198;
    SMEP :: 199;
    BMI2 :: 200;
    ENHANCED_REP :: 201;
    INVPCID :: 202;
    RTM :: 203;
    RDT_M :: 204;
    DEP_FPU_CS_DS :: 205;
    MPX :: 206;
    RDT_A :: 207;
    AVX512F :: 208;
    AVX512DQ :: 209;
    RDSEED :: 210;
    ADX :: 211;
    SMAP :: 212;
    AVX512_IFMA :: 213;
    PCOMMIT :: 214;
    CLFLUSHOPT :: 215;
    CLWB :: 216;
    INTEL_PT :: 217;
    AVX512PF :: 218;
    AVX512ER :: 219;
    AVX512CD :: 220;
    SHA :: 221;
    AVX512BW :: 222;
    AVX512VL :: 223;
    PREFETCHWT1 :: 224;
    AVX512_VBMI :: 225;
    UMIP :: 226;
    PKU :: 227;
    OSPKE :: 228;
    WAITPKG :: 229;
    AVX512_VBMI2 :: 230;
    CET_SS :: 231;
    GFNI :: 232;
    VAES :: 233;
    VPCLMULQDQ :: 234;
    AVX512_VNNI :: 235;
    AVX512_BITALG :: 236;
    TME_EN :: 237;
    AVX512_VPOPCNTDQ :: 238;
    FIVE_LEVEL_PAGING :: 240;
    MAWAU_0 :: 241;
    MAWAU_1 :: 242;
    MAWAU_2 :: 243;
    MAWAU_3 :: 244;
    MAWAU_4 :: 245;
    RDPID :: 246;
    KL :: 247;
    CLDEMOTE :: 249;
    MOVDIRI :: 251;
    MOVDIR64B :: 252;
    ENQCMD :: 253;
    SGX_LC :: 254;
    PKS :: 255;
    AVX512_4VNNIW :: 258;
    AVX512_4FMAPS :: 259;
    FSRM :: 260;
    AVX512_VP2INTERSECT :: 264;
    SRBDS_CTRL :: 265;
    MD_CLEAR :: 266;
    TSX_FORCE_ABORT :: 269;
    SERIALIZE :: 270;
    HYBRID :: 271;
    TSXLDTRK :: 272;
    PCONFIG :: 274;
    LBR :: 275;
    CET_IBT :: 276;
    AMX_BF16 :: 278;
    AVX512_FP16 :: 279;
    AMX_TILE :: 280;
    AMX_INT8 :: 281;
    SPEC_CTRL :: 282;
    STIBP :: 283;
    L1D_FLUSH :: 284;
    ARCH_CAPABILITIES :: 285;
    CORE_CAPABILITIES :: 286;
    SSBD :: 287;
    AVX_VNNI :: 292;
    AVX512_BF16 :: 293;
    FZRM :: 298;
    FSRS :: 299;
    FSRCS :: 300;
    HRESET :: 310;
    LAM :: 314;
    XSAVEOPT :: 320;
    XSAVEC :: 321;
    XGETBV_ECX1 :: 322;
    XSAVES_XRSTORS :: 323;
    XFD :: 324;
}
Cpu_X86 :: struct {
    vendor: x86_Vendor;
    feature_leaves: [x86_Feature_Leaf.NUMBER] u32;
}
check_feature :: (leaves: [x86_Feature_Leaf.NUMBER] u32, flag: x86_Feature_Flag) -> bool {
    index:=cast(u16) flag;
    return (leaves[index/32] & (cast(u32) 1 << cast(u32) (index%32))) != 0;
}
enable_feature :: (leaves: *[x86_Feature_Leaf.NUMBER] u32, flag: x86_Feature_Flag) {
    index:=cast(u16) flag;
    leaves.*[index/32] |= cast(u32) 1 << cast(u32) (index%32);
}
disable_feature :: (leaves: *[x86_Feature_Leaf.NUMBER] u32, flag: x86_Feature_Flag) {
    index:=cast(u16) flag;
    leaves.*[index/32] &= ~(cast(u32) 1 << cast(u32) (index%32));
}
Prefetch_Hint :: enum { T0 :: 0; T1 :: 1; T2 :: 2; NTA :: 3; }
get_cpu_info :: () -> Cpu_X86 {
    cpu: Cpu_X86;
    // cpuid with an out-of-range leaf returns junk, so the maximum basic/extended leaves are checked first.
    max_basic_info: u32 = 0;
    max_extended_info: u32 = 0;
    vendor_chunk_0: u32 = 0;
    vendor_chunk_1: u32 = 0;
    vendor_chunk_2: u32 = 0;
    #asm {
        xor.d a: gpr === a, a;
        xor.d c: gpr === c, c;
        cpuid a, b:, c, d:;
        mov.d max_basic_info, a;
        mov.d vendor_chunk_0, b;
        mov.d vendor_chunk_1, d;
        mov.d vendor_chunk_2, c;
        mov.d a, 0x80000000;
        xor.d c, c;
        cpuid a, b, c, d;
        mov.d max_extended_info, a;
    }
    if vendor_chunk_0 == 0x756E6547 && vendor_chunk_1 == 0x49656E69 && vendor_chunk_2 == 0x6C65746E cpu.vendor = .INTEL; // GenuineIntel
    if vendor_chunk_0 == 0x68747541 && vendor_chunk_1 == 0x69746E65 && vendor_chunk_2 == 0x444D4163 cpu.vendor = .AMD;   // AuthenticAMD

    leaf_a, leaf_b, leaf_c, leaf_d: u32;
    if max_basic_info >= 0x01 {
        cpuid_query(0x01, 0, *leaf_a, *leaf_b, *leaf_c, *leaf_d);
        cpu.feature_leaves[x86_Feature_Leaf._01H_EDX] = leaf_d;
        cpu.feature_leaves[x86_Feature_Leaf._01H_ECX] = leaf_c;
    }
    if max_basic_info >= 0x19 {
        cpuid_query(0x19, 0, *leaf_a, *leaf_b, *leaf_c, *leaf_d);
        cpu.feature_leaves[x86_Feature_Leaf._19H_EBX] = leaf_b;
    }
    if max_extended_info >= 0x80000001 {
        cpuid_query(0x80000001, 0, *leaf_a, *leaf_b, *leaf_c, *leaf_d);
        cpu.feature_leaves[x86_Feature_Leaf._01H_EXT_EDX] = leaf_d;
        cpu.feature_leaves[x86_Feature_Leaf._01H_EXT_ECX] = leaf_c;
    }
    if max_extended_info >= 0x80000008 {
        cpuid_query(0x80000008, 0, *leaf_a, *leaf_b, *leaf_c, *leaf_d);
        cpu.feature_leaves[x86_Feature_Leaf._08H_EXT_EBX] = leaf_b;
    }
    if max_basic_info >= 0x07 {
        cpuid_query(0x07, 0, *leaf_a, *leaf_b, *leaf_c, *leaf_d);
        cpu.feature_leaves[x86_Feature_Leaf._07H_00H_EBX] = leaf_b;
        cpu.feature_leaves[x86_Feature_Leaf._07H_00H_ECX] = leaf_c;
        cpu.feature_leaves[x86_Feature_Leaf._07H_00H_EDX] = leaf_d;
        cpuid_query(0x07, 1, *leaf_a, *leaf_b, *leaf_c, *leaf_d);
        cpu.feature_leaves[x86_Feature_Leaf._07H_01H_EAX] = leaf_a;
    }
    if max_basic_info >= 0x0D {
        cpuid_query(0x0D, 1, *leaf_a, *leaf_b, *leaf_c, *leaf_d);
        cpu.feature_leaves[x86_Feature_Leaf._0DH_01H_EAX] = leaf_a;
    }
    return cpu;
}

cpuid_query :: (leaf: u32, subleaf: u32, out_a: *u32, out_b: *u32, out_c: *u32, out_d: *u32) {
    ra, rb, rc, rd: u32 = 0;
    #asm {
        mov.d a: gpr === a, leaf;
        mov.d c: gpr === c, subleaf;
        cpuid a, b:, c, d:;
        mov.d ra, a;
        mov.d rb, b;
        mov.d rc, c;
        mov.d rd, d;
    }
    out_a.* = ra; out_b.* = rb; out_c.* = rc; out_d.* = rd;
}

// Lower-level instruction hooks. jaic lowers #asm to portable IR: prefetch has no observable effect so it is a
// no-op, rdseed falls back to rdrand (jaic has no rdseed), the rest map directly.
prefetch :: (pointer: *void, $hint: Prefetch_Hint) #expand {
    #if hint == .NTA || hint == .T0 || hint == .T1 || hint == .T2 {
    } else {
        #assert false "'hint' argument to prefetch is out of range.";
    }
}

rdtsc :: () -> u64 {
    low: u64 = 0;
    #asm {
        rdtsc high:, low;
        shl.q high, 32;
        or.q low, high;
    }
    return low;
}

rdtscp :: () -> (timestamp: u64, msr: u32) {
    low: u64 = 0;
    msr: u32 = 0;
    #asm {
        rdtscp high:, low, msr;
        shl.q high, 32;
        or.q low, high;
    }
    return low, msr;
}

rdseed :: () -> (success: bool, value: u64) {
    return rdrand();
}

// The CPU sets CF when it delivered a sample; a clear flag means "try again later".
rdrand :: () -> (success: bool, value: u64) {
    sample: u64;
    delivered: bool;
    #asm { rdrand.q sample; setc delivered; }
    return delivered, sample;
}

mfence :: () { #asm { mfence; } }
lfence :: () { #asm { lfence; } }
sfence :: () { #asm { sfence; } }
pause :: () { #asm { pause; } }

X86_Features :: struct { leaves: [x86_Feature_Leaf.NUMBER] u32; }
Machine_Options_X86 :: struct { features: X86_Features; }
get_machine_options_x86 :: (build_options: *$T) -> *Machine_Options_X86 {
    return cast(*Machine_Options_X86) *build_options.machine_options;
}
