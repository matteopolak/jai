// Standalone authored-source checks bypass vector storage aliases.
#load "../constants.jai";
#load "../scalar.jai";
#load "../../Float16/conversion.jai";
near :: (actual: float64, expected: float64, tolerance: float64 = 1e-13) -> bool {
    return abs(actual-expected)<=tolerance*abs(expected)+tolerance;
}
numeric_scalar_cases :: () -> bool {
    negative_zero:=float64_from_bits(0x8000000000000000);
    if float64_bits(sqrt(negative_zero))!=0x8000000000000000 return false;
    if float64_bits(sin(negative_zero))!=0x8000000000000000 return false;
    if !isnan(FLOAT64_NAN) || is_finite(FLOAT64_INFINITY) return false;
    if floor(cast(float64) -1.25)!=-2 || ceil(cast(float64) -1.25)!=-1 || round(cast(float64) -2.5)!=-3 return false;
    if floor(FLOAT64_INFINITY)!=FLOAT64_INFINITY || !isnan(floor(FLOAT64_NAN)) return false;
    if sqrt(cast(float64) 4.0)!=2 || !isnan(sqrt(cast(float64) -1.0)) return false;
    if sqrt(float64_from_bits(1))==0 return false;
    if exp(cast(float64) -1000.0)!=0 || !isinf(exp(cast(float64) 1000.0)) return false;
    if !near(log(cast(float64) 2.0),0.6931471805599453) || !near(exp(cast(float64) 1.0),2.718281828459045) return false;
    if !isinf(log(cast(float64) 0.0)) || !isnan(log(cast(float64) -1.0)) return false;
    if !near(sin(cast(float64) 0.5),0.479425538604203) || !near(cos(cast(float64) 0.5),0.8775825618903727) return false;
    if !near(atan(cast(float64) 1.0),PI64*0.25) || !near(atan2(cast(float64) 1.0,-1.0),PI64*0.75) return false;
    if !near(asin(cast(float64) 0.5),PI64/6) || !near(acos(cast(float64) -1.0),PI64) return false;
    if !isnan(asin(cast(float64) 2.0)) || !isnan(sin(FLOAT64_INFINITY)) return false;
    if !near(pow(cast(float64) -2.0,3.0),-8.0) || !isnan(pow(cast(float64) -2.0,0.5)) return false;
    if pow(-FLOAT64_INFINITY,0.5)!=FLOAT64_INFINITY return false;
    if fmod_cycling(cast(float64) -0.5,2.0)!=1.5 || fmod_cycling(cast(float64) 0.5,-2.0)!=-1.5 return false;
    for i: 1..8 {
        x:=cast(float64) i*0.01;
        if !near(exp(log(x)),x) return false;
        if !near(sin(x)*sin(x)+cos(x)*cos(x),1.0) return false;
        if !near(sqrt(x)*sqrt(x),x) return false;
    }
    return true;
}
numeric_half_cases :: () -> bool {
    if cast(u16) float32_to_float16(1.0)!=0x3c00 return false;
    if cast(u16) float32_to_float16(float32_from_bits(0x80000000))!=0x8000 return false;
    if cast(u16) float32_to_float16(65504.0)!=0x7bff return false;
    if cast(u16) float32_to_float16(FLOAT32_INFINITY)!=0x7c00 return false;
    if float16_to_float32(cast(Float16) 1)!=0.000000059604644775390625 return false;
    if cast(u16) float32_to_float16(1.00048828125)!=0x3c00 return false;
    if cast(u16) float32_to_float16(1.00146484375)!=0x3c02 return false;
    return true;
}
numeric_half_range :: (start: int, end: int) -> bool {
    // Every finite half is exactly representable in float32.
    for raw: start..end {
        half:=cast(Float16) raw;
        exponent:=(cast(u16) half >> 10) & 31;
        fraction:=cast(u16) half & 1023;
        back:=float32_to_float16(float16_to_float32(half));
        if exponent!=31 && back!=half return false;
        if exponent==31 && fraction==0 && back!=half return false;
        if exponent==31 && fraction!=0 && !isnan(float16_to_float32(half)) return false;
    }
    return true;
}
#assert #run numeric_scalar_cases();
#assert #run numeric_half_cases();

#assert #run numeric_half_range(0,1023);
#assert #run numeric_half_range(1024,2047);
#assert #run numeric_half_range(2048,3071);
#assert #run numeric_half_range(3072,4095);
#assert #run numeric_half_range(4096,5119);
#assert #run numeric_half_range(5120,6143);
#assert #run numeric_half_range(6144,7167);
#assert #run numeric_half_range(7168,8191);
#assert #run numeric_half_range(8192,9215);
#assert #run numeric_half_range(9216,10239);
#assert #run numeric_half_range(10240,11263);
#assert #run numeric_half_range(11264,12287);
#assert #run numeric_half_range(12288,13311);
#assert #run numeric_half_range(13312,14335);
#assert #run numeric_half_range(14336,15359);
#assert #run numeric_half_range(15360,16383);
#assert #run numeric_half_range(16384,17407);
#assert #run numeric_half_range(17408,18431);
#assert #run numeric_half_range(18432,19455);
#assert #run numeric_half_range(19456,20479);
#assert #run numeric_half_range(20480,21503);
#assert #run numeric_half_range(21504,22527);
#assert #run numeric_half_range(22528,23551);
#assert #run numeric_half_range(23552,24575);
#assert #run numeric_half_range(24576,25599);
#assert #run numeric_half_range(25600,26623);
#assert #run numeric_half_range(26624,27647);
#assert #run numeric_half_range(27648,28671);
#assert #run numeric_half_range(28672,29695);
#assert #run numeric_half_range(29696,30719);
#assert #run numeric_half_range(30720,31743);
#assert #run numeric_half_range(31744,32767);
#assert #run numeric_half_range(32768,33791);
#assert #run numeric_half_range(33792,34815);
#assert #run numeric_half_range(34816,35839);
#assert #run numeric_half_range(35840,36863);
#assert #run numeric_half_range(36864,37887);
#assert #run numeric_half_range(37888,38911);
#assert #run numeric_half_range(38912,39935);
#assert #run numeric_half_range(39936,40959);
#assert #run numeric_half_range(40960,41983);
#assert #run numeric_half_range(41984,43007);
#assert #run numeric_half_range(43008,44031);
#assert #run numeric_half_range(44032,45055);
#assert #run numeric_half_range(45056,46079);
#assert #run numeric_half_range(46080,47103);
#assert #run numeric_half_range(47104,48127);
#assert #run numeric_half_range(48128,49151);
#assert #run numeric_half_range(49152,50175);
#assert #run numeric_half_range(50176,51199);
#assert #run numeric_half_range(51200,52223);
#assert #run numeric_half_range(52224,53247);
#assert #run numeric_half_range(53248,54271);
#assert #run numeric_half_range(54272,55295);
#assert #run numeric_half_range(55296,56319);
#assert #run numeric_half_range(56320,57343);
#assert #run numeric_half_range(57344,58367);
#assert #run numeric_half_range(58368,59391);
#assert #run numeric_half_range(59392,60415);
#assert #run numeric_half_range(60416,61439);
#assert #run numeric_half_range(61440,62463);
#assert #run numeric_half_range(62464,63487);
#assert #run numeric_half_range(63488,64511);
#assert #run numeric_half_range(64512,65535);
