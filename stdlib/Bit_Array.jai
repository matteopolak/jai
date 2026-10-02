// Independently authored bit storage. The maintained words vector owns memory.
#import "Basic";
Bit_Array :: struct {
    words: [..]u64;
    count: int;
}
init_bit_array :: (bits:*Bit_Array,bit_count:int) {
    assert(bit_count>=0);
    array_reset(*bits.words);
    array_resize(*bits.words,(bit_count+63)/64);
    for *word:bits.words word.*=0;
    bits.count=bit_count;
}
bit_index_in_range :: (bits:*Bit_Array,index:int)->bool { return index>=0 && index<bits.count; }
get_bit :: (bits:*Bit_Array,index:int)->bool {
    if !bit_index_in_range(bits,index) return false;
    bit:=cast(u64)1 << (index%64);
    return (bits.words[index/64]&bit)!=0;
}
set_bit :: (bits:*Bit_Array,index:int) {
    assert(bit_index_in_range(bits,index));
    bits.words[index/64]|=cast(u64)1<<(index%64);
}
clear_bit :: (bits:*Bit_Array,index:int) {
    assert(bit_index_in_range(bits,index));
    bits.words[index/64]&=~(cast(u64)1<<(index%64));
}
toggle_bit :: (bits:*Bit_Array,index:int) {
    assert(bit_index_in_range(bits,index));
    bits.words[index/64]^=cast(u64)1<<(index%64);
}
set_bit_to :: (bits:*Bit_Array,index:int,value:bool) {
    if value set_bit(bits,index); else clear_bit(bits,index);
}
deinit :: (bits:*Bit_Array) {
    array_reset(*bits.words);
    bits.count=0;
}
make_bit_array :: (count:int)->Bit_Array #must {
    result:Bit_Array;
    init_bit_array(*result,count);
    return result;
}
operator [] :: (a:Bit_Array,i:int)->bool {
    assert(i>=0 && i<a.count);
    return (a.words[i/64]&(cast(u64)1<<(i%64)))!=0;
}
operator []= :: (a:*Bit_Array,i:int,value:bool) { set_bit_to(a,i,value); }
clear_all_bits :: (array:*Bit_Array) { for *word:array.words word.*=0; }
set_all_bits :: (array:*Bit_Array) {
    for *word:array.words word.*=~cast(u64)0;
    _mask_tail(array);
}
toggle_all_bits :: (array:*Bit_Array) {
    for *word:array.words word.*=~word.*;
    _mask_tail(array);
}
for_expansion :: (array:*Bit_Array,body:Code,flags:For_Flags) #expand {
    #assert(!(flags&.POINTER));
    cursor:=0;
    #if flags&.REVERSE cursor=array.count-1;
    while cursor>=0 && cursor<array.count {
        `it_index:=cursor;
        `it:=get_bit(array,cursor);
        #insert (remove={clear_bit(array,cursor);}) body;
        #if flags&.REVERSE cursor-=1;
        else cursor+=1;
    }
}
for_expansion :: (array:Bit_Array,body:Code,flags:For_Flags) #expand {
    for_expansion(*array,body,flags);
}
only_set :: (array:*Bit_Array,body:Code,flags:For_Flags) #expand {
    only_set_or_unset(array,body,flags,true);
}
only_unset :: (array:*Bit_Array,body:Code,flags:For_Flags) #expand {
    only_set_or_unset(array,body,flags,false);
}
set_bits :: (w:s64,m:s64,b:bool)->s64 { if b return w|m; return w&~m; }
#scope_file
_mask_tail :: (array:*Bit_Array) {
    tail:=array.count%64;
    if tail && array.words.count>0 array.words[array.words.count-1]&=(cast(u64)1<<tail)-1;
}
only_set_or_unset :: (array:*Bit_Array,body:Code,flags:For_Flags,target_value:bool) #expand {
    #assert(!(flags&.POINTER));
    cursor:=0;
    #if flags&.REVERSE cursor=array.count-1;
    while cursor>=0 && cursor<array.count {
        if get_bit(array,cursor)==target_value {
            `it:=target_value;
            `it_index:=cursor;
            #insert (remove={set_bit_to(array,cursor,!target_value);}) body;
        }
        #if flags&.REVERSE cursor-=1;
        else cursor+=1;
    }
}
