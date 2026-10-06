#load "../../Machine_X64.jai";
feature_leaf_cases :: () -> bool {
    leaves: [x86_Feature_Leaf.NUMBER] u32;
    if check_feature(leaves,.SSE2) return false;
    enable_feature(*leaves,.SSE2);
    enable_feature(*leaves,.AVX2);
    enable_feature(*leaves,.RDSEED);
    if leaves[0]!=((cast(u32) 1) << 26) return false;
    if !check_feature(leaves,.SSE2) || !check_feature(leaves,.AVX2) || !check_feature(leaves,.RDSEED) return false;
    disable_feature(*leaves,.AVX2);
    if check_feature(leaves,.AVX2) || !check_feature(leaves,.RDSEED) return false;
    return true;
}
#assert #run feature_leaf_cases();
