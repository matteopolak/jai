// Shared exact binary conversion bodies.
Float16 :: #type,isa u16;
float32_to_float16 :: float_to_half_fast3;
float16_to_float32 :: half_to_float_fast4;
float_to_half_fast3 :: (_f: float32) -> Float16 {
    bits:=float32_bits(_f);
    sign:=cast(u16) ((bits >> 16) & 0x8000);
    exponent:=cast(s32) ((bits >> 23) & 255);
    fraction:=bits & 0x7fffff;
    if exponent==255 {
        if fraction==0 return cast(Float16) (sign | 0x7c00);
        payload:=(cast(u16) (fraction >> 13)) | 0x0200;
        return cast(Float16) (sign | 0x7c00 | payload);
    }
    half_exponent:=exponent-112;
    if half_exponent>=31 return cast(Float16) (sign | 0x7c00);
    if half_exponent<=0 {
        if half_exponent < -10 return cast(Float16) sign;
        significand:=fraction | 0x800000;
        shift:=14-half_exponent;
        retained:=significand >> cast(u32) shift;
        discarded:=significand & (((cast(u32) 1) << cast(u32) shift)-1);
        halfway:=(cast(u32) 1) << cast(u32) (shift-1);
        if discarded>halfway || (discarded==halfway && (retained&1)!=0) retained+=1;
        return cast(Float16) (sign | cast(u16) retained);
    }
    retained:=fraction >> 13;
    discarded:=fraction & 8191;
    if discarded>4096 || (discarded==4096 && (retained&1)!=0) {
        retained+=1;
        if retained==1024 { retained=0; half_exponent+=1; }
    }
    return cast(Float16) (sign | (cast(u16) (half_exponent << 10)) | cast(u16) retained);
}
half_to_float_fast4 :: (h: Float16) -> float32 { return half_to_float(cast(u16) h); }
