// Pure production layout math for the historical upward-positive UI.
#scope_module
right_divider_rects :: (r:Rect,horizontal:bool,fraction:float,thickness:float)->Rect,Rect,Rect {
    dimension:=ifx horizontal then r.w else r.h; thickness=right_float_clamp(thickness,0.0,right_float_max(dimension,0.0)); fraction=right_float_clamp(fraction,0.0,1.0);
    first:=r; divider:=r; second:=r;
    if horizontal {
        first.w=right_float_max(r.w-thickness,0.0)*fraction; divider.x=r.x+first.w; divider.w=thickness;
        second.x=divider.x+divider.w; second.w=right_float_max(r.x+r.w-second.x,0.0);
    } else {
        first.h=right_float_max(r.h-thickness,0.0)*fraction; first.y=r.y+r.h-first.h;
        divider.h=thickness; divider.y=first.y-thickness; second.h=right_float_max(divider.y-r.y,0.0);
    }
    return first,divider,second;
}
right_scroll_nib :: (bar:Rect,vertical:bool,viewport:float,content:float,scroll:float,minimum:float)->Rect {
    track:=right_float_max(ifx vertical then bar.h else bar.w,0.0); breadth:=right_float_max(ifx vertical then bar.w else bar.h,0.0);
    size:=right_float_min(track,right_float_max(breadth*minimum,ifx content>0 then track*viewport/content else track));
    extent:=right_float_max(content-viewport,0.0); fraction:=ifx extent>0 then right_float_clamp(scroll/extent,0.0,1.0) else 0.0;
    result:=bar;
    if vertical { result.h=size; result.y=bar.y+(track-size)*(1-fraction); }
    else { result.w=size; result.x=bar.x+(track-size)*fraction; }
    return result;
}
right_scroll_fraction :: (bar:Rect,vertical:bool,nib_size:float,position:float)->float {
    travel:=right_float_max((ifx vertical then bar.h else bar.w)-nib_size,0.0); if travel<=0 return 0;
    along:=ifx vertical then bar.y+bar.h-position-nib_size/2 else position-bar.x-nib_size/2;
    return right_float_clamp(along/travel,0.0,1.0);
}
right_subwindow_rects :: (full:Rect,title_height:float,mx:float,my:float)->Rect,Rect {
    title:=full; title.h=right_float_clamp(title_height,0.0,right_float_max(full.h,0.0)); title.y=full.y+full.h-title.h;
    content:=Rect.{full.x+mx,full.y+my,right_float_max(full.w-2*mx,0.0),right_float_max(full.h-title.h-2*my,0.0)};
    return title,content;
}
right_resize_edges :: (r:Rect,delta:Vector2,west:bool,east:bool,north:bool,south:bool,min_width:float,min_height:float)->Rect {
    left:=r.x; right:=r.x+r.w; bottom:=r.y; top:=r.y+r.h;
    if west left=right_float_min(left+delta.x,right-min_width); if east right=right_float_max(right+delta.x,left+min_width);
    if south bottom=right_float_min(bottom+delta.y,top-min_height); if north top=right_float_max(top+delta.y,bottom+min_height);
    return .{left,bottom,right_float_max(right-left,0.0),right_float_max(top-bottom,0.0)};
}
right_content_bottom :: (full:Rect,new_y:float,margin:float,title_height:float)->Rect {
    top:=full.y+full.h; bottom:=right_float_min(new_y-margin,top-title_height);
    return .{full.x,bottom,full.w,right_float_max(top-bottom,0.0)};
}
right_flow_line_y :: (content:Rect,offset:float,stride:float,index:int)->float { return content.y+content.h+offset-cast(float)(index+1)*stride; }
right_flow_line_index :: (content:Rect,offset:float,stride:float,y:float,count:int)->int {
    if count<=0||stride<=0 return 0;
    return right_int_clamp(cast(int)floor((content.y+content.h+offset-y)/stride),0,count-1);
}
right_sv_point :: (r:Rect,normalized:Vector2,warp:bool)->Vector2 {
    if warp { radius:=right_float_min(r.w,r.h)/2; return xy(r.x+r.w/2+normalized.x*radius,r.y+r.h/2-normalized.y*radius); }
    return xy(r.x+(normalized.x+1)*r.w/2,r.y+(1-normalized.y)*r.h/2);
}
right_sv_normalized :: (r:Rect,point:Vector2,warp:bool)->Vector2 {
    if warp { radius:=right_float_min(r.w,r.h)/2; if radius<=0 return .{}; return xy(point.x-r.x-r.w/2,r.y+r.h/2-point.y)/radius; }
    return xy((point.x-r.x)*2/right_float_max(r.w,1.0)-1,1-(point.y-r.y)*2/right_float_max(r.h,1.0));
}

// Concrete scalar domains keep nested production layout operations unambiguous.
right_float_min :: (a:float,b:float)->float { if a<b return a; return b; }
right_float_max :: (a:float,b:float)->float { if a>b return a; return b; }
right_float_clamp :: (value:float,low:float,high:float)->float { if value<low return low; if value>high return high; return value; }
right_int_clamp :: (value:int,low:int,high:int)->int { if value<low return low; if value>high return high; return value; }
