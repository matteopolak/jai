// SDL2 declarations from SDL_mouse.h.
SDL_Cursor :: void;
using SDL_SystemCursor :: enum s32 {
    ARROW;
    IBEAM;
    WAIT;
    CROSSHAIR;
    WAITARROW;
    SIZENWSE;
    SIZENESW;
    SIZEWE;
    SIZENS;
    SIZEALL;
    NO;
    HAND;
    SDL_NUM_SYSTEM_CURSORS;
}
SDL_MouseWheelDirection :: enum s32 {
    SDL_MOUSEWHEEL_NORMAL;
    SDL_MOUSEWHEEL_FLIPPED;
}
SDL_GetMouseFocus :: () -> *SDL_Window #foreign SDL2;
SDL_GetMouseState :: (x: *s32, y: *s32) -> u32 #foreign SDL2;
SDL_GetGlobalMouseState :: (x: *s32, y: *s32) -> u32 #foreign SDL2;
SDL_GetRelativeMouseState :: (x: *s32, y: *s32) -> u32 #foreign SDL2;
SDL_WarpMouseInWindow :: (window: *SDL_Window, x: s32, y: s32) #foreign SDL2;
SDL_WarpMouseGlobal :: (x: s32, y: s32) -> s32 #foreign SDL2;
SDL_SetRelativeMouseMode :: (enabled: SDL_bool) -> s32 #foreign SDL2;
SDL_CaptureMouse :: (enabled: SDL_bool) -> s32 #foreign SDL2;
SDL_GetRelativeMouseMode :: () -> SDL_bool #foreign SDL2;
SDL_CreateCursor :: (data: *u8, mask: *u8, w: s32, h: s32, hot_x: s32, hot_y: s32) -> *SDL_Cursor #foreign SDL2;
SDL_CreateColorCursor :: (surface: *SDL_Surface, hot_x: s32, hot_y: s32) -> *SDL_Cursor #foreign SDL2;
SDL_CreateSystemCursor :: (id: SDL_SystemCursor) -> *SDL_Cursor #foreign SDL2;
SDL_SetCursor :: (cursor: *SDL_Cursor) #foreign SDL2;
SDL_GetCursor :: () -> *SDL_Cursor #foreign SDL2;
SDL_GetDefaultCursor :: () -> *SDL_Cursor #foreign SDL2;
SDL_FreeCursor :: (cursor: *SDL_Cursor) #foreign SDL2;
SDL_ShowCursor :: (toggle: s32) -> s32 #foreign SDL2;
SDL_BUTTON :: (x: int) -> int {
    bit_index := x - 1;
    return 1 << bit_index;
}
SDL_BUTTON_LEFT :: 1;
SDL_BUTTON_MIDDLE :: 2;
SDL_BUTTON_RIGHT :: 3;
SDL_BUTTON_X1 :: 4;
SDL_BUTTON_X2 :: 5;
