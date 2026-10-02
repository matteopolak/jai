// Maintained rank buffer contract with an independently authored stable merge.
#import "Basic";
MAX_RADIX_COUNT :: 65536;
RadixSort :: struct {
    ranks: [MAX_RADIX_COUNT]u32;
    count: u32;
}
sort :: (r:*RadixSort,data:*u32,count:u32) { _sort_rank_indices(r,data,count); }
rank :: (r:*RadixSort,index:u32)->u32 { assert(index<r.count); return r.ranks[index]; }
free_resources :: (r:*RadixSort) {
    for i:0..cast(int)r.count-1 r.ranks[i]=0;
    r.count=0;
}
reset :: (radix:*RadixSort) { radix.count=0; }
resize :: (radix:*RadixSort,new_size:u32) {
    assert(new_size<=MAX_RADIX_COUNT);
    radix.count=new_size;
    for i:0..cast(int)new_size-1 radix.ranks[i]=cast(u32)i;
}
operator [] :: (radix:RadixSort,i:int)->u32 { assert(i>=0 && i<radix.count); return radix.ranks[i]; }
sort :: (radix:*RadixSort,input:*u64,count:u32) { _sort_rank_indices(radix,input,count); }
sort :: (radix:*RadixSort,input:*float,count:u32) { _sort_rank_indices(radix,input,count); }
sort :: (radix:*RadixSort,input:[]u32) { sort(radix,input.data,cast(u32)input.count); }
sort :: (radix:*RadixSort,input:[]u64) { sort(radix,input.data,cast(u32)input.count); }
sort :: (radix:*RadixSort,input:[]float) { sort(radix,input.data,cast(u32)input.count); }
reorder :: (input:*[..]$T,radix:RadixSort) {
    assert(input.count==radix.count);
    result:[..]T;
    result.allocator=input.allocator;
    array_resize(*result,input.count,false);
    for i:0..input.count-1 result[i]=input.*[radix.ranks[i]];
    array_reset(input);
    input.*=result;
}
#scope_file
_less_or_equal :: (a:$T,b:T)->bool {
    #if T==float {
        if a!=a return b!=b;
        if b!=b return true;
    }
    return a<=b;
}
_sort_rank_indices :: (r:*RadixSort,data:*$T,count:u32) {
    assert(count<=MAX_RADIX_COUNT && (count==0 || data!=null));
    resize(r,count);
    if count<2 return;
    scratch,base:=NewArray(count,u32,false);
    defer free(base);
    width:=1; n:=cast(int)count;
    while width<n {
        start:=0;
        while start<n {
            left:=start; middle:=min(start+width,n); right:=middle; end:=min(start+2*width,n); out:=start;
            while left<middle || right<end {
                if right>=end || (left<middle && _less_or_equal(data[r.ranks[left]],data[r.ranks[right]])) {
                    scratch[out]=r.ranks[left]; left+=1;
                } else { scratch[out]=r.ranks[right]; right+=1; }
                out+=1;
            }
            start=end;
        }
        for i:0..n-1 r.ranks[i]=scratch[i];
        width*=2;
    }
}
