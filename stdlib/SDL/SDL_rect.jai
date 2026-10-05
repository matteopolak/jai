// SDL2 declarations from SDL_rect.h.
SDL_Point :: struct {
    x : s32 ;
    y : s32 ;
}
SDL_Rect :: struct {
    x , y : s32 ;
    w , h : s32 ;
}
SDL_PointInRect :: ( p : * SDL_Point , r : * SDL_Rect ) -> SDL_bool {
    if !p || !r return SDL_FALSE;
    if SDL_RectEmpty(r) == SDL_TRUE return SDL_FALSE;
    horizontal := cast(s64) p.x - cast(s64) r.x;
    vertical := cast(s64) p.y - cast(s64) r.y;
    if horizontal < 0 || vertical < 0 return SDL_FALSE;
    if horizontal >= r.w || vertical >= r.h return SDL_FALSE;
    return SDL_TRUE;
}
SDL_RectEmpty :: ( r : * SDL_Rect ) -> SDL_bool {
    if !r return SDL_TRUE;
    if r.h <= 0 return SDL_TRUE;
    if r.w <= 0 return SDL_TRUE;
    return SDL_FALSE;
}
SDL_RectEquals :: ( a : * SDL_Rect , b : * SDL_Rect ) -> SDL_bool {
    if !a || !b return SDL_FALSE;
    if a.h != b.h || a.w != b.w return SDL_FALSE;
    if a.y != b.y || a.x != b.x return SDL_FALSE;
    return SDL_TRUE;
}
SDL_HasIntersection :: ( A : * SDL_Rect , B : * SDL_Rect ) -> SDL_bool #foreign SDL2 ;
SDL_IntersectRect :: ( A : * SDL_Rect , B : * SDL_Rect , result : * SDL_Rect ) -> SDL_bool #foreign SDL2 ;
SDL_UnionRect :: ( A : * SDL_Rect , B : * SDL_Rect , result : * SDL_Rect ) #foreign SDL2 ;
SDL_EnclosePoints :: ( points : * SDL_Point , count : s32 , clip : * SDL_Rect , result : * SDL_Rect ) -> SDL_bool #foreign SDL2 ;
SDL_IntersectRectAndLine :: ( rect : * SDL_Rect , X1 : * s32 , Y1 : * s32 , X2 : * s32 , Y2 : * s32 ) -> SDL_bool #foreign SDL2 ;
