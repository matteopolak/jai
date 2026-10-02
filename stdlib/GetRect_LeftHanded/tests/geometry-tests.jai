#import "GetRect_LeftHanded";
rect_cases :: () -> bool {
    r:=get_rect(1,2,100,40);
    top,remaining:=cut_top(r,10,2);
    if top.y!=2 || remaining.y!=14 || remaining.h!=28 return false;
    bottom,remainder:=cut_bottom(r,10,2);
    if bottom.y!=32 || remainder.y!=2 || remainder.h!=28 return false;
    return true;
}
#assert #run rect_cases();
