// Authored heap-based implementation gives the maintained entry point O(n log n).
Basic :: #import "Basic";
intro_sort :: (array:[]$T,comparator:$Comparator) {
    _heap_sort(array,comparator);
}
insertion_sort :: (array:[]$T,f:(T,T)->int) { insertion_sort(array,0,array.count,f); }
intro_sort :: (array:[]$T,begin:int,end:int,f:(T,T)->int) {
    _heap_sort(Basic.array_view(array,begin,end-begin),f);
}
insertion_sort :: (array:[]$T,begin:int,end:int,f:(T,T)->int) {
    for i:begin+1..end-1 {
        value:=array[i]; cursor:=i;
        while cursor>begin && f(value,array[cursor-1])<0 { array[cursor]=array[cursor-1]; cursor-=1; }
        array[cursor]=value;
    }
}
#scope_file
_heap_sort :: (array:[]$T,f:$Comparator) {
    if array.count<2 return;
    root:=array.count/2;
    while root>0 { root-=1; _sift(array,root,array.count,f); }
    end:=array.count;
    while end>1 { end-=1; Basic.Swap(array.data,array.data+end); _sift(array,0,end,f); }
}
_sift :: (array:[]$T,root:int,end:int,f:$Comparator) {
    while root*2+1<end {
        child:=root*2+1;
        if child+1<end && f(array[child],array[child+1])<0 child+=1;
        if f(array[root],array[child])>=0 return;
        Basic.Swap(array.data+root,array.data+child);
        root=child;
    }
}
