// Authored stable bottom-up merging behind the compatible sort entry points.
#import "Basic";
compare_floats :: (a:float,b:float)->s64 { if a<b return -1; if a>b return 1; return 0; }
compare_strings :: (a:string,b:string)->s64 {
    limit:=min(a.count,b.count);
    for i:0..limit-1 {
        if a[i]<b[i] return -1;
        if a[i]>b[i] return 1;
    }
    if a.count<b.count return -1;
    if a.count>b.count return 1;
    return 0;
}
bubble_sort :: (array:[]$T,comparator:$Comparator) {
    remaining:=array.count;
    while remaining>1 {
        last_change:=0;
        for i:1..remaining-1 {
            if comparator(array[i-1],array[i])>0 {
                Swap(array.data+i-1,array.data+i);
                last_change=i;
            }
        }
        remaining=last_change;
    }
}
quick_sort :: (array:[]$T,comparator:$Comparator) {
    if array.count<2 return;
    scratch,base:=NewArray(array.count,T,false);
    defer free(base);
    width:=1;
    while width<array.count {
        start:=0;
        while start<array.count {
            left:=start; middle:=min(start+width,array.count); right:=middle;
            stop:=min(start+2*width,array.count); output:=start;
            while left<middle || right<stop {
                if right>=stop || (left<middle && comparator(array[left],array[right])<=0) {
                    scratch[output]=array[left]; left+=1;
                } else { scratch[output]=array[right]; right+=1; }
                output+=1;
            }
            start=stop;
        }
        for i:0..array.count-1 array[i]=scratch[i];
        width*=2;
    }
}
// Legacy key-selector overload; the selector is evaluated only for comparisons.
quick_sort :: (array:[]$T,f:(T)->$R)->[]T {
    for i:1..array.count-1 {
        value:=array[i]; cursor:=i;
        while cursor>0 && f(value)<f(array[cursor-1]) { array[cursor]=array[cursor-1]; cursor-=1; }
        array[cursor]=value;
    }
    return array;
}
