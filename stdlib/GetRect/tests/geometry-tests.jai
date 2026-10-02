#import "GetRect";
rect_cases :: () -> bool {
    r:=get_rect(10000000000.25,2,100,40);
    if r.x!=10000000000.25 return false;
    left,remaining:=cut_left(r,20,3);
    if left.w!=20 || remaining.x!=r.x+23 || remaining.w!=77 return false;
    top,bottom:=cut_top(r,10,2);
    if top.y!=32 || bottom.h!=28 return false;
    overlap:=intersect(get_rect(0,0,10,10),get_rect(8,3,10,10));
    if overlap.x!=8 || overlap.y!=3 || overlap.w!=2 || overlap.h!=7 return false;
    if !is_inside(0,0,get_rect(0,0,10,10)) || is_inside(10,10,get_rect(0,0,10,10)) return false;
    return true;
}
#assert #run rect_cases();
