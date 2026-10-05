// The maintained OpenJai crc64 contract uses CRC-64/ECMA-182.
CRC64_ECMA_POLY :: 0x42f0_e1eb_a9ea_3693;

crc64 :: (s: string) -> u64 #no_aoc {
    return crc64_update(s, 0);
}

// Explicit compatibility entry for the older supplied module's CRC-64/WE.
crc64_we :: (s: string) -> u64 {
    return ~crc64_update(s, 0xffff_ffff_ffff_ffff);
}

#scope_file
crc64_update :: (s: string, accumulator: u64) -> u64 #no_aoc {
    for byte: s {
        accumulator ^= cast(u64) byte << 56;
        bit: s32 = 0;
        while bit < 8 {
            high_bit := accumulator & 0x8000_0000_0000_0000;
            accumulator <<= 1;
            if high_bit accumulator ^= CRC64_ECMA_POLY;
            bit += 1;
        }
    }
    return accumulator;
}
